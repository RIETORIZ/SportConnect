import random
from django.db.models import Q, Avg
from .models import SportsFields, Coaches, Players, Users, Teams, TeamMember

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

# ───────────────────────────────────────────────────────────────
# Team Priority Queue Matchmaking Algorithm
# ───────────────────────────────────────────────────────────────

def profile_team(team):
    """
    Calculate key metrics for a team:
    - Average age of team members
    - Average show up rate
    - Team's primary sport (based on most common)
    - Team's experience level (based on most common)
    
    Parameters:
        team: A Team model object
        
    Returns:
        dict: Calculated team profile metrics
    """
    # Get list of player IDs from the team
    player_ids = team.player_id
    
    # If no players, return default values
    if not player_ids:
        return {
            'avg_age': None,
            'avg_show_up_rate': None,  # Assuming this field exists in your model
            'team_sport': None,
            'experience_level': None
        }
    
    # Get all players in this team
    players = Players.objects.filter(user_id__in=player_ids)
    
    if not players.exists():
        return {
            'avg_age': None,
            'avg_show_up_rate': None,
            'team_sport': None,
            'experience_level': None
        }
    
    # Calculate average age
    users = Users.objects.filter(user_id__in=player_ids)
    avg_age = users.aggregate(Avg('age'))['age__avg']
    
    # For this implementation, let's assume Players has a show_up_rate field
    # If it doesn't exist, you can remove this or set a default
    avg_show_up_rate = players.aggregate(Avg('show_up_rate'))['show_up_rate__avg'] if hasattr(Players, 'show_up_rate') else 0.0
    
    # Find most common sport and experience level
    # This is a simplified approach - in pandas we'd use mode()
    sports_count = {}
    exp_levels_count = {}
    
    for player in players:
        sport = player.preferred_sports
        exp = player.experience_level
        
        sports_count[sport] = sports_count.get(sport, 0) + 1
        exp_levels_count[exp] = exp_levels_count.get(exp, 0) + 1
    
    # Get the most common sport and experience level
    team_sport = max(sports_count.items(), key=lambda x: x[1])[0] if sports_count else None
    experience_level = max(exp_levels_count.items(), key=lambda x: x[1])[0] if exp_levels_count else None
    
    return {
        'avg_age': avg_age,
        'avg_show_up_rate': avg_show_up_rate,
        'team_sport': team_sport,
        'experience_level': experience_level
    }

def age_rules_ok(age1, age2):
    """
    Check if two ages comply with the age matching rules.
    Same rules as can_play_together but handle None values.
    
    Parameters:
        age1, age2: Ages to compare (can be None)
        
    Returns:
        bool: True if ages comply with rules, False otherwise
    """
    if age1 is None or age2 is None:
        return False
        
    if age1 < 18 and age2 < 18:
        return abs(age1 - age2) <= 5
    elif (age1 < 18 and age2 >= 18) or (age2 < 18 and age1 >= 18):
        return abs(age1 - age2) <= 2
    else:
        return abs(age1 - age2) <= 10

def match_for_team(team, τ_team=1.0, τ_player=1.0, min_roster=1):
    """
    Find a match for a team: either another team or a roster of players.
    
    Parameters:
        team: Team object to find match for
        τ_team: Threshold for team show-up rate difference
        τ_player: Threshold for individual player show-up rate difference
        min_roster: Minimum number of players to include in roster
        
    Returns:
        tuple: (match_type, match_result)
            match_type: 'team', 'roster', or 'none'
            match_result: Team object, QuerySet of Players, or None
    """
    # Get team profile
    team_profile = profile_team(team)
    trg_age = team_profile['avg_age']
    trg_su = team_profile['avg_show_up_rate']
    trg_sport = team_profile['team_sport']
    trg_level = team_profile['experience_level']
    trg_size = len(team.player_id)
    trg_region = team.region
    
    # If we don't have enough profile info, can't match
    if None in [trg_age, trg_sport, trg_level, trg_region]:
        return 'none', None
    
    # First, try to match with another team
    # Find teams in same region with same sport and experience level
    candidate_teams = Teams.objects.filter(
        region=trg_region, 
    ).exclude(team_id=team.team_id)
    
    # Filter candidate teams
    matching_teams = []
    for cand_team in candidate_teams:
        cand_profile = profile_team(cand_team)
        
        # Skip if profile info is missing
        if None in [cand_profile['avg_age'], cand_profile['team_sport'], 
                    cand_profile['experience_level'], cand_profile['avg_show_up_rate']]:
            continue
            
        # Check sport and experience level match
        if (cand_profile['team_sport'] == trg_sport and 
            cand_profile['experience_level'] == trg_level):
            
            # Check age rules
            if age_rules_ok(trg_age, cand_profile['avg_age']):
                
                # Check show-up rate difference
                if abs(trg_su - cand_profile['avg_show_up_rate']) <= τ_team:
                    # Add team and its age gap to our matching teams
                    matching_teams.append((cand_team, abs(cand_profile['avg_age'] - trg_age), 
                                          cand_profile['avg_show_up_rate']))
    
    # If we found matching teams, return the best one
    if matching_teams:
        # Sort by show-up rate (descending) then age gap (ascending)
        sorted_teams = sorted(matching_teams, key=lambda x: (-x[2], x[1]))
        return 'team', sorted_teams[0][0]  # Return the best team
    
    # Fallback: find individual players
    # Query for players with matching criteria
    candidate_players = Players.objects.filter(
        user_id__region=trg_region,
        preferred_sports__icontains=trg_sport,
        experience_level=trg_level
    )
    
    # Filter and sort players
    matching_players = []
    user_map = build_user_map()
    
    for player in candidate_players:
        player_uid = player.user_id.user_id
        
        # Skip if not in user map
        if player_uid not in user_map:
            continue
            
        player_age = user_map[player_uid][0]
        
        # Check age rules
        if age_rules_ok(trg_age, player_age):
            # For this implementation, we'll assume Players has a show_up_rate field
            # If it doesn't exist, you can set a default or remove this check
            player_su = getattr(player, 'show_up_rate', 0.0)
            
            # Check show-up rate difference
            if abs(trg_su - player_su) <= τ_player:
                matching_players.append((player, abs(player_age - trg_age), player_su))
    
    # If we found matching players, return the best ones
    if matching_players:
        # Sort by show-up rate (descending) then age gap (ascending)
        sorted_players = sorted(matching_players, key=lambda x: (-x[2], x[1]))
        
        # Get the number of players we need
        need = max(min_roster, trg_size)
        # Get the top N players
        top_players = [p[0] for p in sorted_players[:need]]
        
        return 'roster', top_players
    
    # No matches found
    return 'none', None

def team_matchmaking(sport=None, region=None, experience_level=None, num_results=5):
    """
    Find potential team matches based on sport, region, and experience level.
    
    Parameters:
        sport: Optional sport to filter by
        region: Optional region to filter by
        experience_level: Optional experience level to filter by
        num_results: Number of match results to return
        
    Returns:
        list: List of dicts containing match results
            [{
                'team': Team object,
                'match_type': 'team'|'roster'|'none',
                'match': Team object or list of Player objects or None
            }]
    """
    # Start with all teams
    teams_query = Teams.objects.all()
    
    # Apply filters if provided
    if region:
        teams_query = teams_query.filter(region=region)
    
    # Get a sample of teams to match
    # We'll need to manually filter by sport and experience level since they're derived
    teams = list(teams_query)
    
    # Filter teams by sport and experience level if specified
    if sport or experience_level:
        filtered_teams = []
        for team in teams:
            profile = profile_team(team)
            team_sport = profile['team_sport']
            team_exp = profile['experience_level']
            
            if (not sport or (team_sport and sport in team_sport)) and \
               (not experience_level or team_exp == experience_level):
                filtered_teams.append(team)
        teams = filtered_teams
    
    # Randomly sample teams if we have more than requested
    if len(teams) > num_results:
        teams = random.sample(teams, num_results)
    
    # Find matches for each team
    results = []
    for team in teams:
        match_type, match = match_for_team(team)
        results.append({
            'team': team,
            'match_type': match_type,
            'match': match
        })
    
    return results