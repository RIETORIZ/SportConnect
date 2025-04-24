from django.test import TestCase, Client
import json
from django.urls import reverse

class AuthenticationTests(TestCase):
    def setUp(self):
        # Setup code (e.g., creating test users) goes here
        pass
        
    def test_login_endpoint(self):
        client = Client()
        data = {
            'email': 'windruchp0@jigsy.com',
            'password': '$2a$04$65xin29fvBvTi/W0UhvBAOyMxekeIol93p9TsOVezUQzpGU.TtvUq'
        }
        url = reverse('login')  # Assuming you've named your URL pattern 'login'
        response = client.post(url, json.dumps(data), content_type='application/json')
        
        # Print response for debugging
        print(f"Status Code: {response.status_code}")
        print(f"Response: {response.content.decode()}")
        
        # Then add your assertions
        self.assertEqual(response.status_code, 200)  # or whatever status code you expect