from pymongo import MongoClient
import os
from dotenv import load_dotenv

load_dotenv()

MONGO_URL = os.getenv("MONGO_URL", "mongodb://localhost:27017/egyptnest")

class Database:
    client = None
    database = None

    @classmethod
    def initialize(cls):
        cls.client = MongoClient(MONGO_URL)
        cls.database = cls.client.egyptnest

    @classmethod
    def get_collection(cls, collection_name):
        if cls.database is None:
            cls.initialize()
        return cls.database[collection_name]

# Initialize database connection
Database.initialize()

# Collections
users_collection = Database.get_collection("users")
properties_collection = Database.get_collection("properties")
bookings_collection = Database.get_collection("bookings")
messages_collection = Database.get_collection("messages")
conversations_collection = Database.get_collection("conversations")