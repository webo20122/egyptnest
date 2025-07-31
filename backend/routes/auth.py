from fastapi import APIRouter, HTTPException, status, Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from models import UserCreate, UserLogin, UserResponse, Token
from database import users_collection
from auth import get_password_hash, verify_password, create_access_token, verify_token, generate_uuid
from datetime import datetime

router = APIRouter()
security = HTTPBearer()

@router.post("/register", response_model=dict)
async def register(user: UserCreate):
    # Check if user already exists
    existing_user = users_collection.find_one({"email": user.email})
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="User with this email already exists"
        )
    
    # Create new user
    user_id = generate_uuid()
    hashed_password = get_password_hash(user.password)
    
    user_data = {
        "id": user_id,
        "email": user.email,
        "first_name": user.first_name,
        "last_name": user.last_name,
        "phone": user.phone,
        "user_type": user.user_type,
        "profile_image": user.profile_image,
        "hashed_password": hashed_password,
        "is_verified": False,
        "created_at": datetime.utcnow(),
        "updated_at": datetime.utcnow()
    }
    
    users_collection.insert_one(user_data)
    
    # Create access token
    access_token = create_access_token(data={"sub": user_id})
    
    return {
        "message": "User registered successfully",
        "access_token": access_token,
        "token_type": "bearer",
        "user": {
            "id": user_id,
            "email": user.email,
            "first_name": user.first_name,
            "last_name": user.last_name,
            "user_type": user.user_type
        }
    }

@router.post("/login", response_model=dict)
async def login(user_credentials: UserLogin):
    user = users_collection.find_one({"email": user_credentials.email})
    
    if not user or not verify_password(user_credentials.password, user["hashed_password"]):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password"
        )
    
    access_token = create_access_token(data={"sub": user["id"]})
    
    return {
        "message": "Login successful",
        "access_token": access_token,
        "token_type": "bearer",
        "user": {
            "id": user["id"],
            "email": user["email"],
            "first_name": user["first_name"],
            "last_name": user["last_name"],
            "user_type": user["user_type"]
        }
    }

async def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)):
    user_id = verify_token(credentials.credentials)
    user = users_collection.find_one({"id": user_id})
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    return user

@router.get("/me", response_model=dict)
async def get_current_user_info(current_user: dict = Depends(get_current_user)):
    return {
        "id": current_user["id"],
        "email": current_user["email"],
        "first_name": current_user["first_name"],
        "last_name": current_user["last_name"],
        "user_type": current_user["user_type"],
        "profile_image": current_user.get("profile_image"),
        "is_verified": current_user.get("is_verified", False)
    }