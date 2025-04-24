from django.db import models
from django.contrib.postgres.fields import ArrayField
from rest_framework.authtoken.models import Token as BaseToken

class Users(models.Model):
    user_id = models.AutoField(primary_key=True)
    username = models.CharField(max_length=100, unique=True, null=False)
    password_hash = models.CharField(max_length=100, null=False)
    email = models.EmailField(max_length=254, unique=True, null=False)
    phone_number = models.CharField(max_length=20, blank=True, null=True)
    region = models.CharField(max_length=50, blank=True, null=True)
    age = models.IntegerField(blank=True, null=True)
    gender = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        db_table = 'users'

    def __str__(self):
        return self.username

class Sports(models.Model):
    sport_id = models.AutoField(primary_key=True)
    sport_name = models.CharField(max_length=100, null=False)
    description = models.TextField(blank=True, null=True)

    class Meta:
        db_table = 'sports'

class Players(models.Model):
    user_id = models.OneToOneField(Users, on_delete=models.CASCADE, primary_key=True, db_column='user_id')
    age = models.IntegerField(blank=True, null=True)
    gender = models.CharField(max_length=10, blank=True, null=True)
    preferred_sports = models.CharField(max_length=100, blank=True, null=True)
    experience_level = models.CharField(max_length=20, blank=True, null=True)

    class Meta:
        db_table = 'players'

    def __str__(self):
        return f"{self.user_id.username} ({self.user_id.user_id})"

class Coaches(models.Model):
    user_id = models.OneToOneField(Users, on_delete=models.CASCADE, primary_key=True, db_column='user_id')
    specialization = models.CharField(max_length=200, blank=True, null=True)
    years_of_experience = models.IntegerField(blank=True, null=True)
    certifications = models.CharField(max_length=200, blank=True, null=True)
    review = models.FloatField(default=0.0)
    rating = models.FloatField(default=0.0)
    gender = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        db_table = 'coaches'

    def __str__(self):
        return f"{self.user_id.username} ({self.user_id.user_id})"

class Renters(models.Model):
    user_id = models.OneToOneField(Users, on_delete=models.CASCADE, primary_key=True, db_column='user_id')
    business_name = models.CharField(max_length=100, blank=True, null=True)
    contact_info = models.CharField(max_length=200, blank=True, null=True)
    fields_owned = models.IntegerField(default=0)
    rating = models.FloatField(default=0.0)
    gender = models.CharField(max_length=10, blank=True, null=True)

    class Meta:
        db_table = 'renters'

    def __str__(self):
        return f"{self.user_id.username} ({self.user_id.user_id})"

class Teams(models.Model):
    team_id = models.AutoField(primary_key=True)
    team_name = models.CharField(max_length=100, null=False)
    coach_id = models.ForeignKey(Coaches, on_delete=models.SET_NULL, null=True, blank=True, db_column='coach_id')
    location = models.CharField(max_length=100, blank=True, null=True)
    player_id = ArrayField(models.IntegerField(), default=list)  # Changed to ArrayField
    region = models.CharField(max_length=50, blank=True, null=True)

    class Meta:
        db_table = 'teams'

    def player_names(self):
        player_list = Players.objects.filter(user_id__in=self.player_id)
        return ", ".join([player.user_id.username for player in player_list])
    player_names.short_description = 'Player Names'

    def coach_name(self):
        if self.coach_id:
            return self.coach_id.user_id.username
        return None
    coach_name.short_description = 'Coach Name'

class TeamMember(models.Model):
    team_member_id = models.AutoField(primary_key=True)
    team_id = models.ForeignKey(Teams, on_delete=models.CASCADE, null=False, db_column='team_id')
    user_id = models.ForeignKey(Players, on_delete=models.CASCADE, null=False, db_column='user_id')
    joined_at = models.DateField(null=False)

    class Meta:
        db_table = 'team_member'
        unique_together = (('team_id', 'user_id'),)

    def __str__(self):
        return f"{self.team_id.team_name} - {self.user_id.user_id.username}"

class SportsFields(models.Model):
    field_id = models.AutoField(primary_key=True)
    field_name = models.CharField(max_length=100, null=False)
    location = models.CharField(max_length=100, null=False)
    field_image = models.TextField(blank=True, null=True)
    rent_price_per_hour = models.DecimalField(max_digits=10, decimal_places=2, null=False)
    suitable_sports = models.CharField(max_length=200, null=False)
    available_for_female = models.BooleanField(default=True)
    renter_id = models.ForeignKey(Renters, on_delete=models.CASCADE, null=False, db_column='renter_id')
    comments = models.TextField(blank=True, null=True)
    review = models.FloatField(default=0.0)  # Changed to match the actual column name

    class Meta:
        db_table = 'sports_fields'

    def __str__(self):
        return f"{self.field_name} ({self.field_id})"

class Matches(models.Model):
    match_id = models.AutoField(primary_key=True)
    field_id = models.ForeignKey(SportsFields, on_delete=models.CASCADE, null=False, db_column='field_id')
    team1_id = models.ForeignKey(Teams, related_name='team1_matches', on_delete=models.CASCADE, null=False, db_column='team1_id')
    team2_id = models.ForeignKey(Teams, related_name='team2_matches', on_delete=models.CASCADE, null=False, db_column='team2_id')
    match_date = models.DateField(null=False)
    match_time = models.TimeField(null=False)

    class Meta:
        db_table = 'matches'

    def __str__(self):
        return f"{self.match_date} - {self.team1_id.team_name} vs {self.team2_id.team_name}"

class TrainingSessions(models.Model):
    session_id = models.AutoField(primary_key=True)
    coach_id = models.ForeignKey(Coaches, on_delete=models.CASCADE, null=False, db_column='coach_id')
    team_id = models.ForeignKey(Teams, on_delete=models.CASCADE, null=False, db_column='team_id')
    training_date = models.DateField(null=False)
    training_time = models.TimeField(null=False)
    field_id = models.ForeignKey(SportsFields, on_delete=models.CASCADE, null=False, db_column='field_id')

    class Meta:
        db_table = 'training_sessions'

    def __str__(self):
        return f"{self.training_date} - {self.coach_id.user_id.username} - {self.team_id.team_name}"

class ReservationTables(models.Model):
    id = models.AutoField(primary_key=True)
    field_id = models.ForeignKey(SportsFields, on_delete=models.CASCADE, null=False, db_column='field_id')
    user_id = models.ForeignKey(Users, on_delete=models.CASCADE, null=False, db_column='user_id')
    match_id = models.ForeignKey(Matches, on_delete=models.SET_NULL, null=True, blank=True, db_column='match_id')
    reserved_at = models.DateField(null=False)

    class Meta:
        db_table = 'reservation_tables'

    def __str__(self):
        return f"{self.reserved_at} - {self.user_id.username} - {self.field_id.field_name}"

class FieldBookings(models.Model):
    booking_id = models.AutoField(primary_key=True)
    field_id = models.ForeignKey(SportsFields, on_delete=models.CASCADE, null=False, db_column='field_id')
    user_id = models.ForeignKey(Users, on_delete=models.CASCADE, null=False, db_column='user_id')
    booking_date = models.DateField(null=False)
    booking_start_time = models.TimeField(null=False)
    booking_end_time = models.TimeField(null=False)
    payment_method = models.CharField(max_length=50, null=False)
    total_price = models.DecimalField(max_digits=10, decimal_places=2, null=False)

    class Meta:
        db_table = 'field_bookings'

    def __str__(self):
        return f"{self.booking_date} - {self.user_id.username} - {self.field_id.field_name}"

class DirectMessages(models.Model):
    message_id = models.AutoField(primary_key=True)
    sender_id = models.ForeignKey(Users, related_name='sent_messages', on_delete=models.CASCADE, null=False, db_column='sender_id')
    receiver_id = models.ForeignKey(Users, related_name='received_messages', on_delete=models.CASCADE, null=False, db_column='receiver_id')
    message_text = models.TextField(null=False)
    sent_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'direct_messages'

    def __str__(self):
        return f"{self.sent_at} - {self.sender_id.username} -> {self.receiver_id.username}"
    

class CustomToken(models.Model):
    key = models.CharField(max_length=40, primary_key=True)
    user = models.OneToOneField(Users, on_delete=models.CASCADE, related_name='auth_token')
    created = models.DateTimeField(auto_now_add=True)