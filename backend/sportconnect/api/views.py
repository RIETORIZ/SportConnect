# api/views.py
from rest_framework import viewsets, status, generics
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.authtoken.models import Token
from django.contrib.auth.hashers import check_password
from django.contrib.auth.hashers import make_password
from django.db.models import Q
from django.shortcuts import get_object_or_404
from django.utils import timezone
from django.http import JsonResponse
from django.contrib.auth.models import User
from django.contrib.auth.models import Group
from django.db.models import Max, Avg
import hashlib

from api.models import (
    Users, Sports, Players, Coaches, Renters, Teams, TeamMember,
    SportsFields, Matches, TrainingSessions, ReservationTables, FieldBookings, DirectMessages
)
from .serializers import (
    UserSerializer, RegisterSerializer, LoginSerializer, PlayerSerializer, CoachSerializer, 
    RenterSerializer, SportsSerializer, TeamSerializer, TeamMemberSerializer, SportsFieldSerializer,
    MatchSerializer, TrainingSessionSerializer, ReservationSerializer, FieldBookingSerializer,
    DirectMessageSerializer, ConversationSerializer
)
from api.utils import recommend_fields, recommend_coaches, find_matches_for_player, build_user_map, team_matchmaking, profile_team


def ping(request):
    return JsonResponse({"status": "ok"})

# Authentication Views
class RegisterView(generics.GenericAPIView):
    serializer_class = RegisterSerializer
    permission_classes = [AllowAny]
    
    def post(self, request):
        try:
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            
            # Get the highest existing user_id to avoid sequence issues
            max_id = Users.objects.all().aggregate(Max('user_id'))['user_id__max'] or 0
            
            # Create the user with explicit user_id
            user_data = {
                'user_id': max_id + 1,
                'username': serializer.validated_data['username'],
                'email': serializer.validated_data['email'],
                'password_hash': make_password(serializer.validated_data['password']),
                'phone_number': serializer.validated_data.get('phone_number', ''),
                'region': serializer.validated_data.get('region', ''),
                'age': serializer.validated_data.get('age'),
                'gender': serializer.validated_data.get('gender', ''),
            }
            
            # Create user with proper error handling
            try:
                user = Users.objects.create(**user_data)
            except IntegrityError as e:
                return Response(
                    {'detail': f'Registration failed: This username or email already exists.'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            # Create the role-specific profile
            try:
                role = serializer.validated_data['role']
                if role == 'player':
                    Players.objects.create(
                        user_id=user,
                        age=user.age,
                        gender=user.gender,
                        preferred_sports=serializer.validated_data.get('preferred_sports', ''),
                        experience_level=serializer.validated_data.get('experience_level', ''),
                    )
                elif role == 'coach':
                    Coaches.objects.create(
                        user_id=user,
                        specialization=serializer.validated_data.get('specialization', ''),
                        years_of_experience=serializer.validated_data.get('years_of_experience', 0),
                        certifications=serializer.validated_data.get('certifications', ''),
                        gender=user.gender,
                    )
                elif role == 'renter':
                    Renters.objects.create(
                        user_id=user,
                        business_name=serializer.validated_data.get('business_name', ''),
                        contact_info=serializer.validated_data.get('contact_info', ''),
                        gender=user.gender,
                    )
                else:
                    return Response(
                        {'detail': f'Invalid role: {role}. Must be player, coach, or renter.'},
                        status=status.HTTP_400_BAD_REQUEST
                    )
            except Exception as e:
                # If profile creation fails, delete the user to avoid orphaned records
                user.delete()
                return Response(
                    {'detail': f'Failed to create user profile: {str(e)}'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            # Create auth token with error handling
            try:
                token, _ = Token.objects.get_or_create(user=user)
                token_key = token.key
            except Exception as e:
                # If token creation fails, continue without a token
                print(f"Token creation failed: {e}")
                token_key = None
            
            # Return success response
            response_data = {
                'user_id': user.user_id,
                'email': user.email,
                'username': user.username,
                'user_type': role.capitalize(),
            }
            if token_key:
                response_data['token'] = token_key
                
            return Response(response_data, status=status.HTTP_201_CREATED)
            
        except ValueError as e:
            # Handle ValueError specifically
            return Response({'detail': f'Validation error: {str(e)}'}, status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            # Catch-all for any other exceptions
            return Response({'detail': f'Registration failed: {str(e)}'}, status=status.HTTP_400_BAD_REQUEST)
    

class LoginView(generics.GenericAPIView):
    serializer_class = LoginSerializer
    permission_classes = [AllowAny]
    
    def post(self, request):
        # Print debug information
        print(f"Login request data: {request.data}")
        
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        # Find the user
        try:
            user = Users.objects.get(email=serializer.validated_data['email'])
            print(f"Found user: {user.email} (ID: {user.user_id})")
        except Users.DoesNotExist:
            print(f"User not found with email: {serializer.validated_data['email']}")
            return Response({'detail': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)
        
        # Check password
        if not check_password(serializer.validated_data['password'], user.password_hash):
            print(f"Password check failed for user: {user.email}")
            return Response({'detail': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)
        
        # Determine user role
        user_type = 'User'
        if hasattr(user, 'players'):
            user_type = 'Player'
        elif hasattr(user, 'coaches'):
            user_type = 'Coach'
        elif hasattr(user, 'renters'):
            user_type = 'Renter'
        
        print(f"User type: {user_type}")
        
        username = hashlib.md5(user.email.encode()).hexdigest()[:30]
        
        try:
            # Try to get an existing Django User
            django_user = User.objects.get(username=username)
            print(f"Found existing Django User: {django_user.username}")
        except User.DoesNotExist:
            # Create a new Django User if none exists
            print(f"Creating new Django User with username: {username}")
            django_user = User.objects.create_user(
                username=username,
                email=user.email,
                password=None  # We don't need a password as we use the custom Users model for auth
            )
            django_user.is_active = True
            django_user.save()
            
            # Optionally create a group for the user type if you use Django's permission system
            group_name = user_type
            group, _ = Group.objects.get_or_create(name=group_name)
            django_user.groups.add(group)
        
        # Now create token with Django's User model
        try:
            token, created = Token.objects.get_or_create(user=django_user)
            if created:
                print(f"Created new token for user: {user.email}")
            else:
                print(f"Using existing token for user: {user.email}")
        except Exception as e:
            print(f"Error creating token: {e}")
            # If there's an error, try to delete any existing token and create a new one
            Token.objects.filter(user=django_user).delete()
            token = Token.objects.create(user=django_user)
            print(f"Created new token after error recovery")
        
        return Response({
            'token': token.key,
            'user_id': user.user_id,
            'email': user.email,
            'username': user.username,
            'user_type': user_type,
        }, status=status.HTTP_200_OK)
    

class LogoutView(APIView):
    permission_classes = [IsAuthenticated]
    
    def post(self, request):
        # Delete the user's token
        request.user.auth_token.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

class UserProfileView(APIView):
    permission_classes = [IsAuthenticated]
    
    def get(self, request):
        user = request.user
        data = UserSerializer(user).data
        
        # Add role-specific data
        if hasattr(user, 'players'):
            data['role'] = 'Player'
            data['profile'] = PlayerSerializer(user.players).data
        elif hasattr(user, 'coaches'):
            data['role'] = 'Coach'
            data['profile'] = CoachSerializer(user.coaches).data
        elif hasattr(user, 'renters'):
            data['role'] = 'Renter'
            data['profile'] = RenterSerializer(user.renters).data
        
        return Response(data)
    
    def patch(self, request):
        user = request.user
        user_serializer = UserSerializer(user, data=request.data, partial=True)
        user_serializer.is_valid(raise_exception=True)
        user_serializer.save()
        
        # Update role-specific profile if data provided
        if 'profile' in request.data:
            profile_data = request.data['profile']
            
            if hasattr(user, 'players'):
                profile = user.players
                serializer = PlayerSerializer(profile, data=profile_data, partial=True)
            elif hasattr(user, 'coaches'):
                profile = user.coaches
                serializer = CoachSerializer(profile, data=profile_data, partial=True)
            elif hasattr(user, 'renters'):
                profile = user.renters
                serializer = RenterSerializer(profile, data=profile_data, partial=True)
            else:
                return Response({'detail': 'No profile found'}, status=status.HTTP_400_BAD_REQUEST)
                
            serializer.is_valid(raise_exception=True)
            serializer.save()
        
        return Response(UserSerializer(user).data)

# Recommendation Views
class RecommendedFieldsView(APIView):
    permission_classes = [IsAuthenticated]
    
    def get(self, request):
        user = request.user
        
        # Check if user is a player
        if not hasattr(user, 'players'):
            return Response({'detail': 'Only players can get field recommendations'}, 
                            status=status.HTTP_403_FORBIDDEN)
                            
        # Get recommended fields using the utility function
        recommended_fields = recommend_fields(user)
        serializer = SportsFieldSerializer(recommended_fields, many=True)
        
        return Response(serializer.data)

class RecommendedCoachesView(APIView):
    permission_classes = [IsAuthenticated]
    
    def get(self, request):
        user = request.user
        
        # Check if user is a player
        if not hasattr(user, 'players'):
            return Response({'detail': 'Only players can get coach recommendations'}, 
                            status=status.HTTP_403_FORBIDDEN)
                            
        # Get recommended coaches using the utility function
        player = user.players
        recommended_coaches = recommend_coaches(player)
        serializer = CoachSerializer(recommended_coaches, many=True)
        
        return Response(serializer.data)

class MatchingPlayersView(APIView):
    permission_classes = [IsAuthenticated]
    
    def get(self, request):
        user = request.user
        
        # Check if user is a player
        if not hasattr(user, 'players'):
            return Response({'detail': 'Only players can get matching players'}, 
                            status=status.HTTP_403_FORBIDDEN)
        
        # Build the user map and find matches for the player
        user_map = build_user_map()
        matching_players = find_matches_for_player(
            user.players, 
            Players.objects.all(), 
            user_map
        )
        
        serializer = PlayerSerializer(matching_players, many=True)
        return Response(serializer.data)

# ViewSets for CRUD operations
class UserViewSet(viewsets.ModelViewSet):
    queryset = Users.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated]

class PlayerViewSet(viewsets.ModelViewSet):
    queryset = Players.objects.all()
    serializer_class = PlayerSerializer
    permission_classes = [IsAuthenticated]

class CoachViewSet(viewsets.ModelViewSet):
    queryset = Coaches.objects.all()
    serializer_class = CoachSerializer
    permission_classes = [IsAuthenticated]

class RenterViewSet(viewsets.ModelViewSet):
    queryset = Renters.objects.all()
    serializer_class = RenterSerializer
    permission_classes = [IsAuthenticated]

class TeamViewSet(viewsets.ModelViewSet):
    queryset = Teams.objects.all()
    serializer_class = TeamSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        user = self.request.user
        
        # Return teams based on user role
        if hasattr(user, 'players'):
            player_id = user.players.user_id_id
            # Find teams where this player is a member
            return Teams.objects.filter(player_id__contains=[player_id])
        elif hasattr(user, 'coaches'):
            coach_id = user.coaches.user_id_id
            # Find teams where this coach is assigned
            return Teams.objects.filter(coach_id=coach_id)
        
        # For other users, return all teams (or you could restrict further)
        return Teams.objects.all()

class TeamMemberViewSet(viewsets.ModelViewSet):
    queryset = TeamMember.objects.all()
    serializer_class = TeamMemberSerializer
    permission_classes = [IsAuthenticated]

class SportsFieldViewSet(viewsets.ModelViewSet):
    queryset = SportsFields.objects.all()
    serializer_class = SportsFieldSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        user = self.request.user
        
        # For renters, only show their own fields
        if hasattr(user, 'renters'):
            return SportsFields.objects.filter(renter_id=user.renters)
        
        # For other users, show all fields
        return SportsFields.objects.all()
    
    def perform_create(self, serializer):
        print(f"User: {self.request.user}")
        
        # Get the maximum field_id using aggregate
        from django.db.models import Max
        max_id = SportsFields.objects.all().aggregate(Max('field_id'))['field_id__max'] or 0
        next_id = max_id + 1
        print(f"Using next field_id: {next_id}")
        
        # Check if user is a string (which is happening in your case)
        if isinstance(self.request.user, str):
            # Log for debugging
            print(f"User is a string: {self.request.user}")
            
            try:
                # First, try to get a Django User with this username
                django_user = User.objects.get(username=self.request.user)
                
                # Then try to find the corresponding Users model instance
                # by email (assuming emails match)
                from api.models import Users
                custom_user = Users.objects.get(email=django_user.email)
                
                # Finally, get the renter associated with this user
                renter = Renters.objects.get(user_id=custom_user)
                
                # Save with the found renter and the new ID
                serializer.save(field_id=next_id, renter_id=renter)
                return
                
            except Exception as e:
                print(f"Error finding user/renter: {e}")
                # Save with new ID but without a renter
                serializer.save(field_id=next_id, renter_id=None)
                return
        
        # Existing logic for when user is a proper model instance
        try:
            # If user is a proper Users instance
            if isinstance(self.request.user, Users):
                renter = Renters.objects.get(user_id=self.request.user)
                serializer.save(field_id=next_id, renter_id=renter)
            else:
                # Save with new ID but without a renter
                serializer.save(field_id=next_id, renter_id=None)
        except Exception as e:
            print(f"Error in perform_create: {e}")
            # Save with new ID but without a renter
            serializer.save(field_id=next_id, renter_id=None)

class MatchViewSet(viewsets.ModelViewSet):
    queryset = Matches.objects.all()
    serializer_class = MatchSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        user = self.request.user
        
        # Return matches based on user role
        if hasattr(user, 'players'):
            player_id = user.players.user_id_id
            # Find matches where this player's team is involved
            player_teams = Teams.objects.filter(player_id__contains=[player_id])
            return Matches.objects.filter(
                Q(team1_id__in=player_teams) | Q(team2_id__in=player_teams)
            )
        elif hasattr(user, 'coaches'):
            coach_id = user.coaches.user_id_id
            # Find matches where this coach's team is involved
            coach_teams = Teams.objects.filter(coach_id=coach_id)
            return Matches.objects.filter(
                Q(team1_id__in=coach_teams) | Q(team2_id__in=coach_teams)
            )
        elif hasattr(user, 'renters'):
            # Find matches in the renter's fields
            renter_fields = SportsFields.objects.filter(renter_id=user.renters)
            return Matches.objects.filter(field_id__in=renter_fields)
        
        # For other users, return all matches
        return Matches.objects.all()

class TrainingSessionViewSet(viewsets.ModelViewSet):
    queryset = TrainingSessions.objects.all()
    serializer_class = TrainingSessionSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        user = self.request.user
        
        # Return training sessions based on user role
        if hasattr(user, 'players'):
            player_id = user.players.user_id_id
            # Find training sessions for teams this player is in
            player_teams = Teams.objects.filter(player_id__contains=[player_id])
            return TrainingSessions.objects.filter(team_id__in=player_teams)
        elif hasattr(user, 'coaches'):
            coach_id = user.coaches
            # Find training sessions led by this coach
            return TrainingSessions.objects.filter(coach_id=coach_id)
        elif hasattr(user, 'renters'):
            # Find training sessions in the renter's fields
            renter_fields = SportsFields.objects.filter(renter_id=user.renters)
            return TrainingSessions.objects.filter(field_id__in=renter_fields)
        
        # For other users, return all training sessions
        return TrainingSessions.objects.all()

class ReservationViewSet(viewsets.ModelViewSet):
    queryset = ReservationTables.objects.all()
    serializer_class = ReservationSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        user = self.request.user
        
        # For renters, show reservations for their fields
        if hasattr(user, 'renters'):
            renter_fields = SportsFields.objects.filter(renter_id=user.renters)
            return ReservationTables.objects.filter(field_id__in=renter_fields)
        
        # For others, show only their own reservations
        return ReservationTables.objects.filter(user_id=user)

class FieldBookingViewSet(viewsets.ModelViewSet):
    queryset = FieldBookings.objects.all()
    serializer_class = FieldBookingSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        user = self.request.user
        
        # For renters, show bookings for their fields
        if hasattr(user, 'renters'):
            renter_fields = SportsFields.objects.filter(renter_id=user.renters)
            return FieldBookings.objects.filter(field_id__in=renter_fields)
        
        # For others, show only their own bookings
        return FieldBookings.objects.filter(user_id=user)
    
    def perform_create(self, serializer):
        # Set the user automatically to the current user
        serializer.save(user_id=self.request.user)

class DirectMessageViewSet(viewsets.ModelViewSet):
    queryset = DirectMessages.objects.all()
    serializer_class = DirectMessageSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        user = self.request.user
        
        # Show only messages sent or received by the current user
        return DirectMessages.objects.filter(
            Q(sender_id=user) | Q(receiver_id=user)
        ).order_by('-sent_at')
    
    def perform_create(self, serializer):
        # Set the sender automatically to the current user
        serializer.save(sender_id=self.request.user)
    
    def list(self, request):
        # For listing, we want to show conversations rather than individual messages
        user = request.user
        
        # Get distinct users who have communicated with the current user
        sender_ids = DirectMessages.objects.filter(receiver_id=user).values_list('sender_id', flat=True).distinct()
        receiver_ids = DirectMessages.objects.filter(sender_id=user).values_list('receiver_id', flat=True).distinct()
        
        # Combine and remove duplicates
        user_ids = set(list(sender_ids) + list(receiver_ids))
        
        # Get the latest message for each conversation
        conversations = []
        for other_user_id in user_ids:
            other_user = Users.objects.get(user_id=other_user_id)
            
            # Get the latest message in this conversation
            latest_message = DirectMessages.objects.filter(
                (Q(sender_id=user) & Q(receiver_id=other_user)) | 
                (Q(sender_id=other_user) & Q(receiver_id=user))
            ).order_by('-sent_at').first()
            
            conversations.append({
                'user_id': other_user.user_id,
                'user_name': other_user.username,
                'last_message': latest_message.message_text if latest_message else None,
                'last_message_time': latest_message.sent_at if latest_message else None,
                'user_image_url': None,  # Could be added if you have user profile images
            })
        
        serializer = ConversationSerializer(conversations, many=True)
        return Response(serializer.data)

# Custom action views
class JoinTeamView(APIView):
    permission_classes = [IsAuthenticated]
    
    def post(self, request, pk):
        user = request.user
        
        # Check if user is a player
        if not hasattr(user, 'players'):
            return Response({'detail': 'Only players can join teams'}, 
                            status=status.HTTP_403_FORBIDDEN)
        
        # Get the team
        team = get_object_or_404(Teams, pk=pk)
        
        # Check if player is already in the team
        player_id = user.players.user_id_id
        if player_id in team.player_id:
            return Response({'detail': 'You are already a member of this team'}, 
                            status=status.HTTP_400_BAD_REQUEST)
        
        # Add the player to the team
        team.player_id.append(player_id)
        team.save()
        
        # Create team member record
        TeamMember.objects.create(
            team_id=team,
            user_id=user.players,
            joined_at=timezone.now().date()
        )
        
        return Response({'detail': 'Successfully joined the team'})

class InviteToTrainingView(APIView):
    permission_classes = [IsAuthenticated]
    
    def post(self, request, pk):
        user = request.user
        player_id = request.data.get('player_id')
        
        # Check if user is a coach
        if not hasattr(user, 'coaches'):
            return Response({'detail': 'Only coaches can invite players to training'}, 
                            status=status.HTTP_403_FORBIDDEN)
        
        # Get the training session
        training = get_object_or_404(TrainingSessions, pk=pk)
        
        # Verify the coach owns this training session
        if training.coach_id.user_id_id != user.user_id:
            return Response({'detail': 'You can only invite players to your own training sessions'}, 
                            status=status.HTTP_403_FORBIDDEN)
        
        # Get the player
        try:
            player = get_object_or_404(Players, user_id=player_id)
            
            # Check if the player is already in the team for this training
            team = training.team_id
            if player.user_id_id not in team.player_id:
                # Add the player to the team first
                team.player_id.append(player.user_id_id)
                team.save()
                
                # Create team member record if not exists
                TeamMember.objects.get_or_create(
                    team_id=team,
                    user_id=player,
                    defaults={'joined_at': timezone.now().date()}
                )
            
            # Create a direct message to inform the player
            DirectMessages.objects.create(
                sender_id=user,
                receiver_id=player.user_id,
                message_text=f"You've been invited to a training session on {training.training_date} at {training.training_time} with team {team.team_name}.",
            )
            
            return Response({'detail': 'Player successfully invited to training'})
            
        except Players.DoesNotExist:
            return Response({'detail': 'Player not found'}, status=status.HTTP_404_NOT_FOUND)
        
class UserSettingsView(APIView):
    """
    API view for getting and updating user settings
    """
    permission_classes = [IsAuthenticated]
    
    def get(self, request):
        """
        Get user settings
        """
        user = request.user
        
        # Get user profile data
        profile_data = {
            'user_id': user.user_id,
            'username': user.username,
            'email': user.email,
            'push_notifications': getattr(user, 'push_notifications', True),
            'email_notifications': getattr(user, 'email_notifications', False),
            'dm_sounds': getattr(user, 'dm_sounds', True),
        }
        
        # Return user settings
        return Response(profile_data)
    
    def patch(self, request):
        """
        Update user settings
        """
        user = request.user
        
        # Update settings fields
        if 'push_notifications' in request.data:
            user.push_notifications = request.data['push_notifications']
        if 'email_notifications' in request.data:
            user.email_notifications = request.data['email_notifications']
        if 'dm_sounds' in request.data:
            user.dm_sounds = request.data['dm_sounds']
        
        # Save updated user
        user.save()
        
        return Response({'detail': 'Settings updated successfully'})

class DeleteAccountView(APIView):
    """
    API view for deleting a user account
    """
    permission_classes = [IsAuthenticated]
    
    def delete(self, request):
        """
        Delete user account
        """
        user = request.user
        
        try:
            # Delete the user's token
            if hasattr(user, 'auth_token'):
                user.auth_token.delete()
            
            # Delete associated profiles
            if hasattr(user, 'players'):
                user.players.delete()
            elif hasattr(user, 'coaches'):
                user.coaches.delete()
            elif hasattr(user, 'renters'):
                user.renters.delete()
                
            # Delete the user
            user.delete()
            
            return Response({'detail': 'Account deleted successfully'}, 
                           status=status.HTTP_204_NO_CONTENT)
        except Exception as e:
            return Response({'detail': f'Error deleting account: {str(e)}'},
                           status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
class TeamMatchmakingView(APIView):
    permission_classes = [IsAuthenticated]
    
    def get(self, request):
        # Get filter parameters from query string
        sport = request.query_params.get('sport', None)
        region = request.query_params.get('region', None)
        experience_level = request.query_params.get('experience_level', None)
        num_results = int(request.query_params.get('num_results', 5))
        
        # Use the team_matchmaking utility function
        match_results = team_matchmaking(
            sport=sport,
            region=region,
            experience_level=experience_level,
            num_results=num_results
        )
        
        # Prepare the response data
        response_data = []
        for result in match_results:
            team = result['team']
            match_type = result['match_type']
            match = result['match']
            
            # Get team details
            team_data = {
                'team_id': team.team_id,
                'team_name': team.team_name,
                'region': team.region,
                'player_count': len(team.player_id)
            }
            
            # Add team profile
            profile = profile_team(team)
            team_data.update({
                'avg_age': profile['avg_age'],
                'avg_show_up_rate': profile['avg_show_up_rate'],
                'team_sport': profile['team_sport'],
                'experience_level': profile['experience_level']
            })
            
            # Add match details based on match type
            if match_type == 'team':
                # Add matched team details
                match_profile = profile_team(match)
                match_data = {
                    'match_type': 'team',
                    'team_id': match.team_id,
                    'team_name': match.team_name,
                    'player_count': len(match.player_id),
                    'avg_age': match_profile['avg_age'],
                    'avg_show_up_rate': match_profile['avg_show_up_rate'],
                }
            elif match_type == 'roster':
                # Add roster details
                match_data = {
                    'match_type': 'roster',
                    'players': [{
                        'user_id': player.user_id.user_id,
                        'username': player.user_id.username,
                        'age': getattr(player.user_id, 'age', None),
                        'experience_level': player.experience_level,
                        'preferred_sports': player.preferred_sports,
                    } for player in match]
                }
            else:
                # No match found
                match_data = {
                    'match_type': 'none',
                    'message': 'No suitable opponent or players available.'
                }
            
            # Combine team and match data
            result_data = {
                'team': team_data,
                'match': match_data
            }
            
            response_data.append(result_data)
            
        return Response(response_data)