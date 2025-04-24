
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register(r'users', views.UserViewSet)
router.register(r'players', views.PlayerViewSet)
router.register(r'coaches', views.CoachViewSet)
router.register(r'renters', views.RenterViewSet)
router.register(r'teams', views.TeamViewSet)
router.register(r'team-members', views.TeamMemberViewSet)
router.register(r'fields', views.SportsFieldViewSet)
router.register(r'matches', views.MatchViewSet)
router.register(r'training', views.TrainingSessionViewSet)
router.register(r'bookings', views.FieldBookingViewSet)
router.register(r'reservations', views.ReservationViewSet)
router.register(r'messages', views.DirectMessageViewSet)

urlpatterns = [
    # Authentication endpoints
    path('auth/register/', views.RegisterView.as_view(), name='register'),
    path('auth/login/', views.LoginView.as_view(), name='login'),
    path('auth/logout/', views.LogoutView.as_view(), name='logout'),
    
    # User profile
    path('users/profile/', views.UserProfileView.as_view(), name='user-profile'),
    
    # Recommendation endpoints
    path('recommendations/fields/', views.RecommendedFieldsView.as_view(), name='recommended-fields'),
    path('recommendations/coaches/', views.RecommendedCoachesView.as_view(), name='recommended-coaches'),
    path('recommendations/players/', views.MatchingPlayersView.as_view(), name='matching-players'),
    
    # Team operations
    path('teams/<int:pk>/join/', views.JoinTeamView.as_view(), name='join-team'),
    
    # Training operations
    path('training/<int:pk>/invite/', views.InviteToTrainingView.as_view(), name='invite-to-training'),
    
    # Include router URLs
    path('', include(router.urls)),

     # Existing URLs
    path('ping/', views.ping, name='ping'),
]