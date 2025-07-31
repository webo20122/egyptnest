#!/usr/bin/env python3
"""
EgyptNest Backend API Testing Suite
Comprehensive testing for all backend endpoints
"""

import requests
import json
import time
from datetime import datetime, timedelta
from typing import Dict, Any

# Configuration
BASE_URL = "http://localhost:8001/api"
HEADERS = {"Content-Type": "application/json"}

class EgyptNestAPITester:
    def __init__(self):
        self.base_url = BASE_URL
        self.headers = HEADERS.copy()
        self.guest_token = None
        self.host_token = None
        self.guest_user = None
        self.host_user = None
        self.test_property_id = None
        self.test_booking_id = None
        self.test_conversation_id = None
        self.results = {
            "authentication": {"passed": 0, "failed": 0, "errors": []},
            "users": {"passed": 0, "failed": 0, "errors": []},
            "properties": {"passed": 0, "failed": 0, "errors": []},
            "bookings": {"passed": 0, "failed": 0, "errors": []},
            "messages": {"passed": 0, "failed": 0, "errors": []}
        }

    def log_result(self, category: str, test_name: str, success: bool, error: str = None):
        """Log test results"""
        if success:
            self.results[category]["passed"] += 1
            print(f"✅ {test_name}")
        else:
            self.results[category]["failed"] += 1
            self.results[category]["errors"].append(f"{test_name}: {error}")
            print(f"❌ {test_name}: {error}")

    def make_request(self, method: str, endpoint: str, data: Dict = None, auth_token: str = None) -> Dict:
        """Make HTTP request with error handling"""
        url = f"{self.base_url}{endpoint}"
        headers = self.headers.copy()
        
        if auth_token:
            headers["Authorization"] = f"Bearer {auth_token}"
        
        try:
            if method == "GET":
                response = requests.get(url, headers=headers, timeout=10)
            elif method == "POST":
                response = requests.post(url, headers=headers, json=data, timeout=10)
            elif method == "PUT":
                response = requests.put(url, headers=headers, json=data, timeout=10)
            elif method == "DELETE":
                response = requests.delete(url, headers=headers, timeout=10)
            
            return {
                "status_code": response.status_code,
                "data": response.json() if response.content else {},
                "success": response.status_code < 400
            }
        except requests.exceptions.RequestException as e:
            return {
                "status_code": 0,
                "data": {},
                "success": False,
                "error": str(e)
            }

    def test_health_check(self):
        """Test API health endpoint"""
        print("\n🔍 Testing Health Check...")
        response = self.make_request("GET", "/health")
        
        if response["success"] and response["data"].get("status") == "healthy":
            self.log_result("authentication", "Health Check", True)
        else:
            self.log_result("authentication", "Health Check", False, 
                          f"Status: {response['status_code']}, Data: {response['data']}")

    def test_authentication(self):
        """Test authentication endpoints"""
        print("\n🔐 Testing Authentication...")
        
        # Test user registration - Guest
        guest_data = {
            "email": "sarah.ahmed@example.com",
            "password": "SecurePass123!",
            "first_name": "Sarah",
            "last_name": "Ahmed",
            "phone": "+201234567890",
            "user_type": "guest"
        }
        
        response = self.make_request("POST", "/auth/register", guest_data)
        if response["success"] and "access_token" in response["data"]:
            self.guest_token = response["data"]["access_token"]
            self.guest_user = response["data"]["user"]
            self.log_result("authentication", "Guest Registration", True)
        else:
            self.log_result("authentication", "Guest Registration", False,
                          f"Status: {response['status_code']}, Data: {response['data']}")

        # Test user registration - Host
        host_data = {
            "email": "mohamed.hassan@example.com",
            "password": "HostPass456!",
            "first_name": "Mohamed",
            "last_name": "Hassan",
            "phone": "+201987654321",
            "user_type": "host"
        }
        
        response = self.make_request("POST", "/auth/register", host_data)
        if response["success"] and "access_token" in response["data"]:
            self.host_token = response["data"]["access_token"]
            self.host_user = response["data"]["user"]
            self.log_result("authentication", "Host Registration", True)
        else:
            self.log_result("authentication", "Host Registration", False,
                          f"Status: {response['status_code']}, Data: {response['data']}")

        # Test duplicate registration
        response = self.make_request("POST", "/auth/register", guest_data)
        if response["status_code"] == 400:
            self.log_result("authentication", "Duplicate Registration Prevention", True)
        else:
            self.log_result("authentication", "Duplicate Registration Prevention", False,
                          f"Expected 400, got {response['status_code']}")

        # Test login
        login_data = {
            "email": "sarah.ahmed@example.com",
            "password": "SecurePass123!"
        }
        
        response = self.make_request("POST", "/auth/login", login_data)
        if response["success"] and "access_token" in response["data"]:
            self.log_result("authentication", "User Login", True)
        else:
            self.log_result("authentication", "User Login", False,
                          f"Status: {response['status_code']}, Data: {response['data']}")

        # Test invalid login
        invalid_login = {
            "email": "sarah.ahmed@example.com",
            "password": "WrongPassword"
        }
        
        response = self.make_request("POST", "/auth/login", invalid_login)
        if response["status_code"] == 401:
            self.log_result("authentication", "Invalid Login Prevention", True)
        else:
            self.log_result("authentication", "Invalid Login Prevention", False,
                          f"Expected 401, got {response['status_code']}")

        # Test get current user
        if self.guest_token:
            response = self.make_request("GET", "/auth/me", auth_token=self.guest_token)
            if response["success"] and response["data"].get("email") == "sarah.ahmed@example.com":
                self.log_result("authentication", "Get Current User", True)
            else:
                self.log_result("authentication", "Get Current User", False,
                              f"Status: {response['status_code']}, Data: {response['data']}")

    def test_users(self):
        """Test user management endpoints"""
        print("\n👤 Testing User Management...")
        
        if not self.guest_token:
            self.log_result("users", "User Profile Tests", False, "No guest token available")
            return

        # Test get user profile
        response = self.make_request("GET", "/users/profile", auth_token=self.guest_token)
        if response["success"] and response["data"].get("email") == "sarah.ahmed@example.com":
            self.log_result("users", "Get User Profile", True)
        else:
            self.log_result("users", "Get User Profile", False,
                          f"Status: {response['status_code']}, Data: {response['data']}")

        # Test update user profile
        update_data = {
            "first_name": "Sarah Updated",
            "phone": "+201111111111"
        }
        
        response = self.make_request("PUT", "/users/profile", update_data, auth_token=self.guest_token)
        if response["success"] and "Profile updated successfully" in response["data"].get("message", ""):
            self.log_result("users", "Update User Profile", True)
        else:
            self.log_result("users", "Update User Profile", False,
                          f"Status: {response['status_code']}, Data: {response['data']}")

        # Test get user by ID
        if self.guest_user:
            user_id = self.guest_user["id"]
            response = self.make_request("GET", f"/users/{user_id}")
            if response["success"] and response["data"].get("id") == user_id:
                self.log_result("users", "Get User By ID", True)
            else:
                self.log_result("users", "Get User By ID", False,
                              f"Status: {response['status_code']}, Data: {response['data']}")

        # Test unauthorized access
        response = self.make_request("GET", "/users/profile")
        if response["status_code"] == 401:
            self.log_result("users", "Unauthorized Access Prevention", True)
        else:
            self.log_result("users", "Unauthorized Access Prevention", False,
                          f"Expected 401, got {response['status_code']}")

    def test_properties(self):
        """Test property management endpoints"""
        print("\n🏠 Testing Property Management...")
        
        if not self.host_token:
            self.log_result("properties", "Property Tests", False, "No host token available")
            return

        # Test create property (host only)
        property_data = {
            "title": "Luxurious Nile View Apartment in Cairo",
            "description": "Beautiful 2-bedroom apartment with stunning Nile views, located in the heart of Cairo. Perfect for tourists and business travelers.",
            "property_type": "apartment",
            "price_per_night": 150.0,
            "location": {
                "address": "123 Nile Corniche Street",
                "city": "Cairo",
                "country": "Egypt",
                "coordinates": {"lat": 30.0444, "lng": 31.2357}
            },
            "amenities": ["WiFi", "Air Conditioning", "Kitchen", "Balcony", "Parking"],
            "images": ["https://example.com/image1.jpg", "https://example.com/image2.jpg"],
            "max_guests": 4,
            "bedrooms": 2,
            "bathrooms": 2,
            "host_id": self.host_user["id"] if self.host_user else ""
        }
        
        response = self.make_request("POST", "/properties/", property_data, auth_token=self.host_token)
        if response["success"] and "property_id" in response["data"]:
            self.test_property_id = response["data"]["property_id"]
            self.log_result("properties", "Create Property", True)
        else:
            self.log_result("properties", "Create Property", False,
                          f"Status: {response['status_code']}, Data: {response['data']}")

        # Test guest cannot create property
        if self.guest_token:
            response = self.make_request("POST", "/properties/", property_data, auth_token=self.guest_token)
            if response["status_code"] == 403:
                self.log_result("properties", "Guest Create Property Prevention", True)
            else:
                self.log_result("properties", "Guest Create Property Prevention", False,
                              f"Expected 403, got {response['status_code']}")

        # Test get all properties
        response = self.make_request("GET", "/properties/")
        if response["success"] and "properties" in response["data"]:
            self.log_result("properties", "Get All Properties", True)
        else:
            self.log_result("properties", "Get All Properties", False,
                          f"Status: {response['status_code']}, Data: {response['data']}")

        # Test get properties with filters
        response = self.make_request("GET", "/properties/?city=Cairo&min_price=100&max_price=200")
        if response["success"]:
            self.log_result("properties", "Get Properties with Filters", True)
        else:
            self.log_result("properties", "Get Properties with Filters", False,
                          f"Status: {response['status_code']}, Data: {response['data']}")

        # Test get property by ID
        if self.test_property_id:
            response = self.make_request("GET", f"/properties/{self.test_property_id}")
            if response["success"] and response["data"].get("id") == self.test_property_id:
                self.log_result("properties", "Get Property By ID", True)
            else:
                self.log_result("properties", "Get Property By ID", False,
                              f"Status: {response['status_code']}, Data: {response['data']}")

        # Test get host properties
        response = self.make_request("GET", "/properties/host/my-properties", auth_token=self.host_token)
        if response["success"] and "properties" in response["data"]:
            self.log_result("properties", "Get Host Properties", True)
        else:
            self.log_result("properties", "Get Host Properties", False,
                          f"Status: {response['status_code']}, Data: {response['data']}")

        # Test guest cannot access host properties
        if self.guest_token:
            response = self.make_request("GET", "/properties/host/my-properties", auth_token=self.guest_token)
            if response["status_code"] == 403:
                self.log_result("properties", "Guest Host Properties Prevention", True)
            else:
                self.log_result("properties", "Guest Host Properties Prevention", False,
                              f"Expected 403, got {response['status_code']}")

    def test_bookings(self):
        """Test booking management endpoints"""
        print("\n📅 Testing Booking Management...")
        
        if not self.guest_token or not self.test_property_id:
            self.log_result("bookings", "Booking Tests", False, "Missing guest token or property ID")
            return

        # Test create booking
        check_in = datetime.now() + timedelta(days=7)
        check_out = datetime.now() + timedelta(days=10)
        
        booking_data = {
            "property_id": self.test_property_id,
            "check_in": check_in.isoformat(),
            "check_out": check_out.isoformat(),
            "guests": 2,
            "total_price": 450.0,
            "guest_id": self.guest_user["id"] if self.guest_user else ""
        }
        
        response = self.make_request("POST", "/bookings/", booking_data, auth_token=self.guest_token)
        if response["success"] and "booking_id" in response["data"]:
            self.test_booking_id = response["data"]["booking_id"]
            self.log_result("bookings", "Create Booking", True)
        else:
            self.log_result("bookings", "Create Booking", False,
                          f"Status: {response['status_code']}, Data: {response['data']}")

        # Test get user bookings
        response = self.make_request("GET", "/bookings/my-bookings", auth_token=self.guest_token)
        if response["success"] and "bookings" in response["data"]:
            self.log_result("bookings", "Get User Bookings", True)
        else:
            self.log_result("bookings", "Get User Bookings", False,
                          f"Status: {response['status_code']}, Data: {response['data']}")

        # Test get host bookings
        if self.host_token:
            response = self.make_request("GET", "/bookings/host/bookings", auth_token=self.host_token)
            if response["success"] and "bookings" in response["data"]:
                self.log_result("bookings", "Get Host Bookings", True)
            else:
                self.log_result("bookings", "Get Host Bookings", False,
                              f"Status: {response['status_code']}, Data: {response['data']}")

        # Test update booking status
        if self.test_booking_id and self.host_token:
            response = self.make_request("PUT", f"/bookings/{self.test_booking_id}/status?status=confirmed", 
                                       auth_token=self.host_token)
            if response["success"]:
                self.log_result("bookings", "Update Booking Status", True)
            else:
                self.log_result("bookings", "Update Booking Status", False,
                              f"Status: {response['status_code']}, Data: {response['data']}")

        # Test conflicting booking
        conflicting_booking = booking_data.copy()
        conflicting_booking["check_in"] = (check_in + timedelta(days=1)).isoformat()
        conflicting_booking["check_out"] = (check_out + timedelta(days=1)).isoformat()
        
        response = self.make_request("POST", "/bookings/", conflicting_booking, auth_token=self.guest_token)
        if response["status_code"] == 400:
            self.log_result("bookings", "Conflicting Booking Prevention", True)
        else:
            self.log_result("bookings", "Conflicting Booking Prevention", False,
                          f"Expected 400, got {response['status_code']}")

    def test_messages(self):
        """Test messaging system endpoints"""
        print("\n💬 Testing Messaging System...")
        
        if not self.guest_token or not self.host_token:
            self.log_result("messages", "Message Tests", False, "Missing tokens")
            return

        # Test create conversation
        conversation_data = {
            "participant_id": self.host_user["id"] if self.host_user else "",
            "property_id": self.test_property_id
        }
        
        response = self.make_request("POST", "/messages/conversations", conversation_data, auth_token=self.guest_token)
        if response["success"] and "conversation_id" in response["data"]:
            self.test_conversation_id = response["data"]["conversation_id"]
            self.log_result("messages", "Create Conversation", True)
        else:
            self.log_result("messages", "Create Conversation", False,
                          f"Status: {response['status_code']}, Data: {response['data']}")

        # Test get conversations
        response = self.make_request("GET", "/messages/conversations", auth_token=self.guest_token)
        if response["success"] and "conversations" in response["data"]:
            self.log_result("messages", "Get Conversations", True)
        else:
            self.log_result("messages", "Get Conversations", False,
                          f"Status: {response['status_code']}, Data: {response['data']}")

        # Test send message
        if self.test_conversation_id:
            message_data = {
                "conversation_id": self.test_conversation_id,
                "content": "Hello! I'm interested in booking your property. Is it available for the dates I selected?",
                "message_type": "text",
                "sender_id": self.guest_user["id"] if self.guest_user else ""
            }
            
            response = self.make_request("POST", "/messages/", message_data, auth_token=self.guest_token)
            if response["success"] and "message_id" in response["data"]:
                message_id = response["data"]["message_id"]
                self.log_result("messages", "Send Message", True)
                
                # Test mark message as read
                response = self.make_request("PUT", f"/messages/{message_id}/read", auth_token=self.host_token)
                if response["success"]:
                    self.log_result("messages", "Mark Message as Read", True)
                else:
                    self.log_result("messages", "Mark Message as Read", False,
                                  f"Status: {response['status_code']}, Data: {response['data']}")
            else:
                self.log_result("messages", "Send Message", False,
                              f"Status: {response['status_code']}, Data: {response['data']}")

            # Test get messages
            response = self.make_request("GET", f"/messages/{self.test_conversation_id}", auth_token=self.guest_token)
            if response["success"] and "messages" in response["data"]:
                self.log_result("messages", "Get Messages", True)
            else:
                self.log_result("messages", "Get Messages", False,
                              f"Status: {response['status_code']}, Data: {response['data']}")

    def run_all_tests(self):
        """Run all test suites"""
        print("🚀 Starting EgyptNest Backend API Tests...")
        print("=" * 50)
        
        # Wait for server to be ready
        print("⏳ Waiting for server to be ready...")
        time.sleep(2)
        
        # Run tests in order
        self.test_health_check()
        self.test_authentication()
        self.test_users()
        self.test_properties()
        self.test_bookings()
        self.test_messages()
        
        # Print summary
        self.print_summary()

    def print_summary(self):
        """Print test results summary"""
        print("\n" + "=" * 50)
        print("📊 TEST RESULTS SUMMARY")
        print("=" * 50)
        
        total_passed = 0
        total_failed = 0
        
        for category, results in self.results.items():
            passed = results["passed"]
            failed = results["failed"]
            total_passed += passed
            total_failed += failed
            
            status = "✅" if failed == 0 else "❌"
            print(f"{status} {category.upper()}: {passed} passed, {failed} failed")
            
            if results["errors"]:
                for error in results["errors"]:
                    print(f"   • {error}")
        
        print("-" * 50)
        print(f"TOTAL: {total_passed} passed, {total_failed} failed")
        
        if total_failed == 0:
            print("🎉 All tests passed! Backend API is working correctly.")
        else:
            print(f"⚠️  {total_failed} tests failed. Please check the errors above.")

if __name__ == "__main__":
    tester = EgyptNestAPITester()
    tester.run_all_tests()