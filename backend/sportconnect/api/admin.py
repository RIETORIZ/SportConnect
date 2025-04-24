from django import forms
from django.contrib import admin
from .models import Users, Sports, Players, Coaches, Renters, Teams, TeamMember, SportsFields, Matches, TrainingSessions, ReservationTables, FieldBookings, DirectMessages

class TeamsForm(forms.ModelForm):
    player_id = forms.MultipleChoiceField(
        choices=[],
        widget=forms.CheckboxSelectMultiple,
        required=False
    )

    def __init__(self, *args, **kwargs):
        super(TeamsForm, self).__init__(*args, **kwargs)
        self.fields['player_id'].choices = [(player.user_id.user_id, player.user_id.username) for player in Players.objects.all()]

    def clean_player_id(self):
        data = self.cleaned_data.get('player_id')
        return data

    class Meta:
        model = Teams
        fields = '__all__'

@admin.register(Users)
class UsersAdmin(admin.ModelAdmin):
    list_display = ('user_id', 'username', 'email', 'phone_number', 'region', 'age', 'gender')
    search_fields = ('username', 'email', 'phone_number')
    list_filter = ('region', 'gender')
    ordering = ('username',)

@admin.register(Sports)
class SportsAdmin(admin.ModelAdmin):
    list_display = ('sport_id', 'sport_name', 'description')
    search_fields = ('sport_name',)
    ordering = ('sport_name',)

@admin.register(Players)
class PlayersAdmin(admin.ModelAdmin):
    list_display = ('user_id', 'age', 'gender', 'preferred_sports', 'experience_level', 'user_details')
    search_fields = ('user_id__username', 'preferred_sports')
    list_filter = ('gender', 'experience_level')
    ordering = ('user_id',)

    def user_details(self, obj):
        return f"{obj.user_id.username} ({obj.user_id.email})"
    user_details.short_description = 'User Details'

@admin.register(Coaches)
class CoachesAdmin(admin.ModelAdmin):
    list_display = ('user_id', 'specialization', 'years_of_experience', 'certifications', 'review', 'rating', 'gender', 'user_details')
    search_fields = ('user_id__username', 'specialization')
    list_filter = ('gender',)
    ordering = ('user_id',)

    def user_details(self, obj):
        return f"{obj.user_id.username} ({obj.user_id.email})"
    user_details.short_description = 'User Details'

@admin.register(Renters)
class RentersAdmin(admin.ModelAdmin):
    list_display = ('user_id', 'business_name', 'contact_info', 'fields_owned', 'rating', 'gender', 'user_details')
    search_fields = ('user_id__username', 'business_name')
    list_filter = ('gender',)
    ordering = ('user_id',)

    def user_details(self, obj):
        return f"{obj.user_id.username} ({obj.user_id.email})"
    user_details.short_description = 'User Details'

@admin.register(Teams)
class TeamsAdmin(admin.ModelAdmin):
    form = TeamsForm
    list_display = ('team_id', 'team_name', 'coach_name', 'location', 'region', 'player_names')
    search_fields = ('team_name', 'coach_id__user_id__username', 'location')
    list_filter = ('region',)
    ordering = ('team_name',)

    def player_names(self, obj):
        player_list = Players.objects.filter(user_id__in=obj.player_id)
        return ", ".join([player.user_id.username for player in player_list])
    player_names.short_description = 'Player Names'

    def coach_name(self, obj):
        if obj.coach_id:
            return obj.coach_id.user_id.username
        return None
    coach_name.short_description = 'Coach Name'

@admin.register(TeamMember)
class TeamMemberAdmin(admin.ModelAdmin):
    list_display = ('team_member_id', 'team_name', 'player_name', 'joined_at')
    search_fields = ('team_id__team_name', 'user_id__user_id__username')
    list_filter = ('joined_at',)
    ordering = ('team_id', 'user_id')

    def team_name(self, obj):
        return obj.team_id.team_name
    team_name.short_description = 'Team Name'

    def player_name(self, obj):
        return obj.user_id.user_id.username
    player_name.short_description = 'Player Name'

@admin.register(SportsFields)
class SportsFieldsAdmin(admin.ModelAdmin):
    list_display = ('field_id', 'field_name', 'location', 'rent_price_per_hour', 'suitable_sports', 'available_for_female', 'renter_name', 'review')
    search_fields = ('field_name', 'location', 'suitable_sports')
    list_filter = ('available_for_female',)
    ordering = ('field_name',)

    def renter_name(self, obj):
        return obj.renter_id.user_id.username
    renter_name.short_description = 'Renter Name'

@admin.register(Matches)
class MatchesAdmin(admin.ModelAdmin):
    list_display = ('match_id', 'field_name', 'team1_name', 'team2_name', 'match_date', 'match_time')
    search_fields = ('field_id__field_name', 'team1_id__team_name', 'team2_id__team_name')
    list_filter = ('match_date',)
    ordering = ('match_date', 'match_time')

    def field_name(self, obj):
        return obj.field_id.field_name
    field_name.short_description = 'Field Name'

    def team1_name(self, obj):
        return obj.team1_id.team_name
    team1_name.short_description = 'Team 1 Name'

    def team2_name(self, obj):
        return obj.team2_id.team_name
    team2_name.short_description = 'Team 2 Name'

@admin.register(TrainingSessions)
class TrainingSessionsAdmin(admin.ModelAdmin):
    list_display = ('session_id', 'coach_name', 'team_name', 'training_date', 'training_time', 'field_name')
    search_fields = ('coach_id__user_id__username', 'team_id__team_name', 'field_id__field_name')
    list_filter = ('training_date',)
    ordering = ('training_date', 'training_time')

    def coach_name(self, obj):
        return obj.coach_id.user_id.username
    coach_name.short_description = 'Coach Name'

    def team_name(self, obj):
        return obj.team_id.team_name
    team_name.short_description = 'Team Name'

    def field_name(self, obj):
        return obj.field_id.field_name
    field_name.short_description = 'Field Name'

@admin.register(ReservationTables)
class ReservationTablesAdmin(admin.ModelAdmin):
    list_display = ('id', 'field_name', 'user_name', 'match_name', 'reserved_at')
    search_fields = ('field_id__field_name', 'user_id__username', 'match_id__match_id')
    list_filter = ('reserved_at',)
    ordering = ('reserved_at',)

    def field_name(self, obj):
        return obj.field_id.field_name
    field_name.short_description = 'Field Name'

    def user_name(self, obj):
        return obj.user_id.username
    user_name.short_description = 'User Name'

    def match_name(self, obj):
        if obj.match_id:
            return f"{obj.match_id.match_date} - {obj.match_id.team1_id.team_name} vs {obj.match_id.team2_id.team_name}"
        return None
    match_name.short_description = 'Match Name'

@admin.register(FieldBookings)
class FieldBookingsAdmin(admin.ModelAdmin):
    list_display = ('booking_id', 'field_name', 'user_name', 'booking_date', 'booking_start_time', 'booking_end_time', 'payment_method', 'total_price')
    search_fields = ('field_id__field_name', 'user_id__username')
    list_filter = ('booking_date',)
    ordering = ('booking_date', 'booking_start_time')

    def field_name(self, obj):
        return obj.field_id.field_name
    field_name.short_description = 'Field Name'

    def user_name(self, obj):
        return obj.user_id.username
    user_name.short_description = 'User Name'

@admin.register(DirectMessages)
class DirectMessagesAdmin(admin.ModelAdmin):
    list_display = ('message_id', 'sender_name', 'receiver_name', 'message_text', 'sent_at')
    search_fields = ('sender_id__username', 'receiver_id__username', 'message_text')
    list_filter = ('sent_at',)
    ordering = ('sent_at',)

    def sender_name(self, obj):
        return obj.sender_id.username
    sender_name.short_description = 'Sender Name'

    def receiver_name(self, obj):
        return obj.receiver_id.username
    receiver_name.short_description = 'Receiver Name'