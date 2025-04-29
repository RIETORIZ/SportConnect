from rest_framework import serializers
from django.contrib.auth.models import User
from django.contrib.auth.hashers import make_password
from django.conf import settings
from api.models import Users, Sports, Players, Coaches, Renters, Teams, TeamMember
from api.models import SportsFields, Matches, TrainingSessions, ReservationTables, FieldBookings, DirectMessages


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = Users
        fields = ['user_id', 'username', 'email', 'phone_number', 'region', 'age', 'gender']
        read_only_fields = ['user_id']
        
    def create(self, validated_data):
        if 'password' in validated_data:
            validated_data['password_hash'] = make_password(validated_data.pop('password'))
        return super().create(validated_data)
    
    def update(self, instance, validated_data):
        if 'password' in validated_data:
            validated_data['password_hash'] = make_password(validated_data.pop('password'))
        return super().update(instance, validated_data)

class ReservationSerializer(serializers.ModelSerializer):
    field_name = serializers.CharField(source='field_id.field_name', read_only=True)
    user_name = serializers.CharField(source='user_id.username', read_only=True)
    match_teams = serializers.SerializerMethodField(read_only=True)
    
    class Meta:
        model = ReservationTables
        fields = ['id', 'field_id', 'user_id', 'match_id', 'reserved_at', 
                 'field_name', 'user_name', 'match_teams']
        read_only_fields = ['id']
    
    def get_match_teams(self, obj):
        if obj.match_id:
            return f"{obj.match_id.team1_id.team_name} vs {obj.match_id.team2_id.team_name}"
        return None

class FieldBookingSerializer(serializers.ModelSerializer):
    field_name = serializers.CharField(source='field_id.field_name', read_only=True)
    user_name = serializers.CharField(source='user_id.username', read_only=True)
    
    class Meta:
        model = FieldBookings
        fields = ['booking_id', 'field_id', 'user_id', 'booking_date', 'booking_start_time',
                 'booking_end_time', 'payment_method', 'total_price', 'field_name', 'user_name']
        read_only_fields = ['booking_id']

class DirectMessageSerializer(serializers.ModelSerializer):
    sender_name = serializers.CharField(source='sender_id.username', read_only=True)
    receiver_name = serializers.CharField(source='receiver_id.username', read_only=True)
    
    class Meta:
        model = DirectMessages
        fields = ['message_id', 'sender_id', 'receiver_id', 'message_text', 'sent_at',
                 'sender_name', 'receiver_name']
        read_only_fields = ['message_id', 'sent_at']

class ConversationSerializer(serializers.Serializer):
    user_id = serializers.IntegerField()
    user_name = serializers.CharField()
    last_message = serializers.CharField(allow_null=True)
    last_message_time = serializers.DateTimeField(allow_null=True)
    user_image_url = serializers.CharField(allow_null=True, allow_blank=True)


class SportsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Sports
        fields = ['sport_id', 'sport_name', 'description']
        read_only_fields = ['sport_id']

class TeamSerializer(serializers.ModelSerializer):
    coach_name = serializers.CharField(read_only=True)  # Removed the redundant source
    player_names = serializers.ListField(read_only=True)
    
    class Meta:
        model = Teams
        fields = ['team_id', 'team_name', 'coach_id', 'location', 'player_id', 
                 'region', 'coach_name', 'player_names']
        read_only_fields = ['team_id']

class TeamMemberSerializer(serializers.ModelSerializer):
    team_name = serializers.CharField(source='team_id.team_name', read_only=True)
    player_name = serializers.CharField(source='user_id.user_id.username', read_only=True)
    
    class Meta:
        model = TeamMember
        fields = ['team_member_id', 'team_id', 'user_id', 'joined_at', 'team_name', 'player_name']
        read_only_fields = ['team_member_id']

class SportsFieldSerializer(serializers.ModelSerializer):
    renter_name = serializers.CharField(source='renter_id.user_id.username', read_only=True)
    
    class Meta:
        model = SportsFields
        fields = ['field_id', 'field_name', 'location', 'field_image', 'rent_price_per_hour',
                 'suitable_sports', 'available_for_female', 'renter_id', 'comments', 
                 'review', 'renter_name']
        read_only_fields = ['field_id', 'review']

class MatchSerializer(serializers.ModelSerializer):
    field_name = serializers.CharField(source='field_id.field_name', read_only=True)
    team1_name = serializers.CharField(source='team1_id.team_name', read_only=True, required=False)
    team2_name = serializers.CharField(source='team2_id.team_name', read_only=True, required=False)
    
    class Meta:
        model = Matches
        fields = ['match_id', 'field_id', 'team1_id', 'team2_id', 'match_date', 
                 'match_time', 'field_name', 'team1_name', 'team2_name']
        read_only_fields = ['match_id']
        extra_kwargs = {
            'team1_id': {'required': False},
            'team2_id': {'required': False}
        }

class TrainingSessionSerializer(serializers.ModelSerializer):
    coach_name = serializers.CharField(source='coach_id.user_id.username', read_only=True)
    team_name = serializers.CharField(source='team_id.team_name', read_only=True)
    field_name = serializers.CharField(source='field_id.field_name', read_only=True)
    
    class Meta:
        model = TrainingSessions
        fields = ['session_id', 'coach_id', 'team_id', 'training_date', 'training_time',
                 'field_id', 'coach_name', 'team_name', 'field_name']
        read_only_fields = ['session_id']

class RegisterSerializer(serializers.Serializer):
    username = serializers.CharField(required=True)
    email = serializers.EmailField(required=True)
    password = serializers.CharField(write_only=True, required=True)
    role = serializers.ChoiceField(choices=['player', 'coach', 'renter'], required=True)
    
    # Add these fields
    phone_number = serializers.CharField(required=False, allow_blank=True)
    region = serializers.CharField(required=False, allow_blank=True)
    age = serializers.IntegerField(required=False)
    gender = serializers.CharField(required=False, allow_blank=True)
    
    # Role-specific fields
    # For players
    preferred_sports = serializers.CharField(required=False, allow_blank=True)
    experience_level = serializers.CharField(required=False, allow_blank=True)
    
    # For coaches
    specialization = serializers.CharField(required=False, allow_blank=True)
    years_of_experience = serializers.IntegerField(required=False)
    certifications = serializers.CharField(required=False, allow_blank=True)
    
    # For renters
    business_name = serializers.CharField(required=False, allow_blank=True)
    contact_info = serializers.CharField(required=False, allow_blank=True)

class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField(required=True)
    password = serializers.CharField(write_only=True, required=True)

class PlayerSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user_id.username', read_only=True)
    email = serializers.EmailField(source='user_id.email', read_only=True)
    region = serializers.CharField(source='user_id.region', read_only=True)
    
    class Meta:
        model = Players
        fields = ['user_id', 'username', 'email', 'age', 'gender', 'preferred_sports', 
                  'experience_level', 'region']
        read_only_fields = ['user_id']

class CoachSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user_id.username', read_only=True)
    email = serializers.EmailField(source='user_id.email', read_only=True)
    region = serializers.CharField(source='user_id.region', read_only=True)
    
    class Meta:
        model = Coaches
        fields = ['user_id', 'username', 'email', 'specialization', 'years_of_experience', 
                 'certifications', 'review', 'rating', 'gender', 'region']
        read_only_fields = ['user_id', 'review', 'rating']

class RenterSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user_id.username', read_only=True)
    email = serializers.EmailField(source='user_id.email', read_only=True)
    region = serializers.CharField(source='user_id.region', read_only=True)
    
    class Meta:
        model = Renters
        fields = ['user_id', 'username', 'email', 'business_name', 'contact_info', 
                 'fields_owned', 'rating', 'gender', 'region']
        read_only_fields = ['user_id', 'fields_owned', 'rating']# api/serializers.py
