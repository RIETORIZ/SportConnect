
import random
from django.db.models import Q
from .models import SportsFields, Coaches, Players, Users

def recommend_fields(user, fields_queryset=None):
    """
    Recommend sports fields based on user's region and preferred sport.
    
    Parameters:
        user: User object with region and preferred_sports attributes
        fields_queryset: Optional queryset of SportsFields objects to filter from
                         (if None, all SportsFields objects will be used)
    
    Returns:
        QuerySet: Recommended fields sorted by review in descending order
    """
    try:
        # Get the player profile associated with the user
        player = Players.objects.get(user_id=user.user_id)
        
        # Get user region and preferred sport
        region = user.region
        preferred_sport = player.preferred_sports
        
        # If no queryset provided, use all fields
        if fields_queryset is None:
            fields_queryset = SportsFields.objects.all()
        
        # Filter fields by region
        fields_in_region = fields_queryset.filter(location=region)
        
        # Filter fields by sport suitability
        # Using Q objects for case-insensitive contains search
        fields_for_sport = fields_in_region.filter(
            Q(suitable_sports__icontains=preferred_sport)
        )
        
        # Sort by review in descending order
        recommended_fields = fields_for_sport.order_by('-review')
        
        return recommended_fields
    
    except Players.DoesNotExist:
        return SportsFields.objects.none()  # Return an empty queryset if no player profile exists

def recommend_coaches(player, coaches_queryset=None):
    """
    Recommend coaches for a player based on region and preferred sport.
    
    Parameters:
        player: Player object with region and preferred_sports attributes
        coaches_queryset: Optional queryset of Coaches objects to filter from
                          (if None, all Coaches objects will be used)
    
    Returns:
        QuerySet: Recommended coaches sorted by review in descending order
    """
    # Get player region and preferred sport
    region = player.user_id.region
    preferred_sport = player.preferred_sports
    
    # If no queryset provided, use all coaches
    if coaches_queryset is None:
        coaches_queryset = Coaches.objects.all()
    
    # Filter coaches by region
    coaches_in_region = coaches_queryset.filter(user_id__region=region)
    
    # Filter coaches by specialization
    # Using Q objects for case-insensitive contains search
    coaches_for_sport = coaches_in_region.filter(
        Q(specialization__icontains=preferred_sport)
    )
    
    # Sort by review in descending order
    recommended_coaches = coaches_for_sport.order_by('-review')
    
    return recommended_coaches



def build_user_map():
    """
    Create a dictionary mapping:
       user_id -> (age, region, gender)
    """
    user_map = {}
    for user in Users.objects.all():
        user_map[user.user_id] = (user.age, user.region, user.gender)
    return user_map

def can_play_together(age1, age2):
    """
    Age Laws:
      - both < 18:         abs(age1 - age2) <= 5
      - one < 18, one >= 18: abs(age1 - age2) <= 2
      - both >= 18:         abs(age1 - age2) <= 10
    """
    if age1 < 18 and age2 < 18:
        return abs(age1 - age2) <= 5
    elif (age1 < 18 and age2 >= 18) or (age2 < 18 and age1 >= 18):
        return abs(age1 - age2) <= 2
    else:
        return abs(age1 - age2) <= 10

def find_matches_for_player(target_row, all_players, user_map, show_rate_threshold=1.0):
    """
    Given a target_row from Players and the whole Players queryset,
    return all candidate opponents who:
      - Have the same preferred sport (or contain the given sport)
      - Have the same experience_level
      - Are in the same region (via user_map lookup)
      - Satisfy the age difference constraints (using can_play_together)
      - Have a similar show_up_rate to the target (difference <= threshold)
      - Exclude the target player (by user_id)
    Then sort the candidates with these priorities:
      1. Higher show_up_rate (descending)
      2. Lower absolute age difference from target (ascending)
    """
    uid = target_row.user_id.user_id
    target_sport = target_row.preferred_sports
    target_exp = target_row.experience_level

    if uid not in user_map:
        return Players.objects.none()

    tgt_age, tgt_region, _ = user_map[uid]
    
    # Step 1: Initial filtering by sport, experience_level, and excluding self.
    df_candidates = all_players.filter(
        preferred_sports__icontains=target_sport,
        experience_level=target_exp
    ).exclude(user_id=uid)
    
    valid_rows = []
    # Create a temporary list to hold candidate rows plus age difference
    for player in df_candidates:
        cand_uid = player.user_id.user_id
        if cand_uid not in user_map:
            continue
        cand_age, cand_region, _ = user_map[cand_uid]
        # Check region and age constraint
        if cand_region != tgt_region or not can_play_together(tgt_age, cand_age):
            continue
        age_diff = abs(tgt_age - cand_age)
        valid_rows.append((player, age_diff))
    
    # If no valid candidates, return empty queryset
    if not valid_rows:
        return Players.objects.none()
    
    # Extract sorted players
    sorted_players = [player for player, _ in valid_rows]
    
    return sorted_players

def matchmaking(sport, Players_DB, user_map, show_rate_threshold=1.0):
    """
    For a specified sport, pick a random target player from Players_DB whose preferred_sports
    contains the given sport and then find all opponent matches using the criteria:
      - Same region (using user_map)
      - Same experience_level
      - Age difference per defined age laws
      - Show_up_rate difference within show_rate_threshold
      
    This function returns the target player and potential opponents.
    """
    candidates_for_target = Players_DB.filter(
        preferred_sports__icontains=sport
    )
    if candidates_for_target.exists():
        target_row = candidates_for_target.order_by('?').first()
        uid = target_row.user_id.user_id
        if uid not in user_map:
            print(f"Target user_id {uid} not found in user_map.")
            return None, []
        
        tgt_age, tgt_region, _ = user_map[uid]
    
        
        opponents = find_matches_for_player(target_row, Players_DB, user_map, show_rate_threshold)
        num_opponents = len(opponents)
        
        if num_opponents > 0:
            return target_row, opponents
        else:
            print("No potential opponents found.")
            return target_row, []
    else:
        print(f"No players found with preferred sport '{sport}'.")
        return None, []