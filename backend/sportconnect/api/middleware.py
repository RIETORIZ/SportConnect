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
        
        # Map to your custom Users model based on email
        try:
            # Assuming the Django username is an MD5 hash of the email, 
            # we need to find the Users by email
            custom_user = Users.objects.get(email=django_user.email)
            return custom_user
        except Users.DoesNotExist:
            print(f"User with email {django_user.email} not found in Users model")
            return AnonymousUser()
    except Token.DoesNotExist:
        return AnonymousUser()

class TokenAuthMiddleware(MiddlewareMixin):
    def process_request(self, request):
        request.user = SimpleLazyObject(lambda: get_user_from_token(request))
        return None