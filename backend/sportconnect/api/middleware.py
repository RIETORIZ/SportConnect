# Update or create api/middleware.py with this content

from rest_framework.authtoken.models import Token
from django.utils.functional import SimpleLazyObject
from django.contrib.auth.models import AnonymousUser
from django.utils.deprecation import MiddlewareMixin
from api.models import Users

def get_user_from_token(request):
    auth_header = request.META.get('HTTP_AUTHORIZATION', '')
    if not auth_header.startswith('Token '):
        return AnonymousUser()

    token_key = auth_header[6:]  # Skip 'Token ' prefix
    
    try:
        # Get the Django User from the token
        token = Token.objects.get(key=token_key)
        django_user = token.user
        
        # Map to your custom Users model
        try:
            from api.models import Users
            # Include select_related to fetch the related profile in one query
            custom_user = Users.objects.select_related('players', 'coaches', 'renters').get(email=django_user.email)
            return custom_user
        except Users.DoesNotExist:
            print(f"No matching custom user found for email: {django_user.email}")
            return AnonymousUser()
    except Exception as e:
        print(f"Error in get_user_from_token: {e}")
        return AnonymousUser()

class TokenAuthMiddleware(MiddlewareMixin):
    def process_request(self, request):
        request.user = SimpleLazyObject(lambda: get_user_from_token(request))
        return None