from fastapi import APIRouter, HTTPException, status, Depends
from models import UserUpdate, UserResponse
from database import users_collection
from routes.auth import get_current_user
from datetime import datetime

router = APIRouter()

@router.get("/profile", response_model=dict)
async def get_user_profile(current_user: dict = Depends(get_current_user)):
    return {
        "id": current_user["id"],
        "email": current_user["email"],
        "first_name": current_user["first_name"],
        "last_name": current_user["last_name"],
        "phone": current_user.get("phone"),
        "user_type": current_user["user_type"],
        "profile_image": current_user.get("profile_image"),
        "is_verified": current_user.get("is_verified", False),
        "created_at": current_user.get("created_at"),
        "updated_at": current_user.get("updated_at")
    }

@router.put("/profile", response_model=dict)
async def update_user_profile(user_update: UserUpdate, current_user: dict = Depends(get_current_user)):
    update_data = {k: v for k, v in user_update.dict().items() if v is not None}
    update_data["updated_at"] = datetime.utcnow()
    
    users_collection.update_one(
        {"id": current_user["id"]},
        {"$set": update_data}
    )
    
    updated_user = users_collection.find_one({"id": current_user["id"]})
    
    return {
        "message": "Profile updated successfully",
        "user": {
            "id": updated_user["id"],
            "email": updated_user["email"],
            "first_name": updated_user["first_name"],
            "last_name": updated_user["last_name"],
            "phone": updated_user.get("phone"),
            "user_type": updated_user["user_type"],
            "profile_image": updated_user.get("profile_image")
        }
    }

@router.get("/{user_id}", response_model=dict)
async def get_user_by_id(user_id: str):
    user = users_collection.find_one({"id": user_id})
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    return {
        "id": user["id"],
        "first_name": user["first_name"],
        "last_name": user["last_name"],
        "user_type": user["user_type"],
        "profile_image": user.get("profile_image"),
        "is_verified": user.get("is_verified", False)
    }