from fastapi import APIRouter, HTTPException, status, Depends
from models import BookingCreate, BookingResponse, BookingStatus
from database import bookings_collection, properties_collection
from routes.auth import get_current_user
from datetime import datetime

router = APIRouter()

@router.post("/", response_model=dict)
async def create_booking(booking_data: BookingCreate, current_user: dict = Depends(get_current_user)):
    # Verify property exists
    property_doc = properties_collection.find_one({"id": booking_data.property_id})
    if not property_doc:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Property not found"
        )
    
    # Check if property is available for the dates
    existing_bookings = bookings_collection.find({
        "property_id": booking_data.property_id,
        "status": {"$in": ["confirmed", "pending"]},
        "check_out": {"$gt": booking_data.check_in},
        "check_in": {"$lt": booking_data.check_out}
    })
    
    if list(existing_bookings):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Property is not available for the selected dates"
        )
    
    from auth import generate_uuid
    booking_id = generate_uuid()
    
    booking_doc = {
        "id": booking_id,
        "property_id": booking_data.property_id,
        "guest_id": current_user["id"],
        "check_in": booking_data.check_in,
        "check_out": booking_data.check_out,
        "guests": booking_data.guests,
        "total_price": booking_data.total_price,
        "status": "pending",
        "created_at": datetime.utcnow(),
        "updated_at": datetime.utcnow()
    }
    
    bookings_collection.insert_one(booking_doc)
    
    return {
        "message": "Booking created successfully",
        "booking_id": booking_id,
        "status": "pending"
    }

@router.get("/my-bookings", response_model=dict)
async def get_user_bookings(current_user: dict = Depends(get_current_user)):
    bookings = list(bookings_collection.find({"guest_id": current_user["id"]}))
    
    # Remove MongoDB _id field and add property details
    for booking in bookings:
        booking.pop("_id", None)
        property_doc = properties_collection.find_one({"id": booking["property_id"]})
        if property_doc:
            booking["property"] = {
                "title": property_doc["title"],
                "location": property_doc["location"],
                "images": property_doc["images"][:1] if property_doc["images"] else []
            }
    
    return {
        "bookings": bookings,
        "total": len(bookings)
    }

@router.get("/host/bookings", response_model=dict)
async def get_host_bookings(current_user: dict = Depends(get_current_user)):
    if current_user["user_type"] != "host":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only hosts can access this endpoint"
        )
    
    # Get host properties
    host_properties = list(properties_collection.find({"host_id": current_user["id"]}))
    property_ids = [prop["id"] for prop in host_properties]
    
    # Get bookings for host properties
    bookings = list(bookings_collection.find({"property_id": {"$in": property_ids}}))
    
    # Remove MongoDB _id field and add property/guest details
    for booking in bookings:
        booking.pop("_id", None)
        
        # Add property details
        property_doc = properties_collection.find_one({"id": booking["property_id"]})
        if property_doc:
            booking["property"] = {
                "title": property_doc["title"],
                "location": property_doc["location"]
            }
        
        # Add guest details
        from database import users_collection
        guest = users_collection.find_one({"id": booking["guest_id"]})
        if guest:
            booking["guest"] = {
                "first_name": guest["first_name"],
                "last_name": guest["last_name"],
                "email": guest["email"]
            }
    
    return {
        "bookings": bookings,
        "total": len(bookings)
    }

@router.put("/{booking_id}/status", response_model=dict)
async def update_booking_status(booking_id: str, status: BookingStatus, current_user: dict = Depends(get_current_user)):
    booking = bookings_collection.find_one({"id": booking_id})
    if not booking:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Booking not found"
        )
    
    # Check if user is the host of the property or the guest
    property_doc = properties_collection.find_one({"id": booking["property_id"]})
    if not property_doc:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Property not found"
        )
    
    if property_doc["host_id"] != current_user["id"] and booking["guest_id"] != current_user["id"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You don't have permission to update this booking"
        )
    
    bookings_collection.update_one(
        {"id": booking_id},
        {"$set": {"status": status, "updated_at": datetime.utcnow()}}
    )
    
    return {
        "message": "Booking status updated successfully",
        "booking_id": booking_id,
        "status": status
    }