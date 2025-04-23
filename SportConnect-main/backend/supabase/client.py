from supabase import create_client, Client
import os

url = os.getenv("SUPABASE_URL")  # Store in .env file
key = os.getenv("SUPABASE_KEY")  # Store in .env file

supabase: Client = create_client(url, key)
