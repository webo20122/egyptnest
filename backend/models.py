from pydantic import BaseModel, EmailStr, validator
from typing import Optional, List, Dict, Any
from datetime import datetime
from enum import Enum
import uuid

class UserType(str, Enum):
    GUEST = "guest"
    HOST = "host"

class PropertyType(str, Enum):
    APARTMENT = "apartment"
    HOUSE = "house"
    VILLA = "villa"
    ROOM = "room"

class BookingStatus(str, Enum):
    PENDING = "pending"
    CONFIRMED = "confirmed"
    CANCELLED = "cancelled"
    COMPLETED = "completed"

# User Models
class UserBase(BaseModel):
    email: EmailStr
    first_name: str
    last_name: str
    phone: Optional[str] = None
    user_type: UserType
    profile_image: Optional[str] = None

class UserCreate(UserBase):
    password: str

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class UserResponse(UserBase):
    id: str
    is_verified: bool = False
    created_at: datetime
    updated_at: datetime

class UserUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    phone: Optional[str] = None
    profile_image: Optional[str] = None

# Property Models
class PropertyBase(BaseModel):
    title: str
    description: str
    property_type: PropertyType
    price_per_night: float
    location: Dict[str, Any]  # {address, city, country, coordinates}
    amenities: List[str]
    images: List[str]
    max_guests: int
    bedrooms: int
    bathrooms: int

class PropertyCreate(PropertyBase):
    host_id: str

class PropertyResponse(PropertyBase):
    id: str
    host_id: str
    is_active: bool = True
    created_at: datetime
    updated_at: datetime
    rating: Optional[float] = 0.0
    review_count: int = 0

# Booking Models
class BookingBase(BaseModel):
    property_id: str
    check_in: datetime
    check_out: datetime
    guests: int
    total_price: float

class BookingCreate(BookingBase):
    guest_id: str

class BookingResponse(BookingBase):
    id: str
    guest_id: str
    status: BookingStatus
    created_at: datetime
    updated_at: datetime

# Message Models
class MessageBase(BaseModel):
    conversation_id: str
    content: str
    message_type: str = "text"  # text, image, file

class MessageCreate(MessageBase):
    sender_id: str

class MessageResponse(MessageBase):
    id: str
    sender_id: str
    created_at: datetime
    is_read: bool = False

class ConversationResponse(BaseModel):
    id: str
    participants: List[str]
    property_id: Optional[str] = None
    last_message: Optional[MessageResponse] = None
    created_at: datetime
    updated_at: datetime

# Token Models
class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    user_id: Optional[str] = None