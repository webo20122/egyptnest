from fastapi import APIRouter, HTTPException, status, Depends, Query
from models import PropertyCreate, PropertyResponse
from database import properties_collection
from routes.auth import get_current_user
from datetime import datetime
from typing import List, Optional

router = APIRouter()

@router.post("/", response_model=dict)
async def create_property(property_data: PropertyCreate, current_user: dict = Depends(get_current_user)):
    if current_user["user_type"] != "host":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only hosts can create properties"
        )
    
    from auth import generate_uuid
    property_id = generate_uuid()
    
    property_doc = {
        "id": property_id,
        "host_id": current_user["id"],
        "title": property_data.title,
        "description": property_data.description,
        "property_type": property_data.property_type,
        "price_per_night": property_data.price_per_night,
        "location": property_data.location,
        "amenities": property_data.amenities,
        "images": property_data.images,
        "max_guests": property_data.max_guests,
        "bedrooms": property_data.bedrooms,
        "bathrooms": property_data.bathrooms,
        "is_active": True,
        "rating": 0.0,
        "review_count": 0,
        "created_at": datetime.utcnow(),
        "updated_at": datetime.utcnow()
    }
    
    properties_collection.insert_one(property_doc)
    
    return {
        "message": "Property created successfully",
        "property_id": property_id
    }

@router.get("/", response_model=dict)
async def get_properties(
    skip: int = Query(0, ge=0),
    limit: int = Query(10, ge=1, le=100),
    city: Optional[str] = None,
    property_type: Optional[str] = None,
    min_price: Optional[float] = None,
    max_price: Optional[float] = None
):
    filter_query = {"is_active": True}
    
    if city:
        filter_query["location.city"] = {"$regex": city, "$options": "i"}
    if property_type:
        filter_query["property_type"] = property_type
    if min_price is not None:
        filter_query["price_per_night"] = {"$gte": min_price}
    if max_price is not None:
        if "price_per_night" in filter_query:
            filter_query["price_per_night"]["$lte"] = max_price
        else:
            filter_query["price_per_night"] = {"$lte": max_price}
    
    properties = list(properties_collection.find(filter_query).skip(skip).limit(limit))
    total = properties_collection.count_documents(filter_query)
    
    # Remove MongoDB _id field
    for prop in properties:
        prop.pop("_id", None)
    
    return {
        "properties": properties,
        "total": total,
        "skip": skip,
        "limit": limit
    }

@router.get("/{property_id}", response_model=dict)
async def get_property(property_id: str):
    property_doc = properties_collection.find_one({"id": property_id})
    if not property_doc:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Property not found"
        )
    
    property_doc.pop("_id", None)
    return property_doc

@router.get("/host/my-properties", response_model=dict)
async def get_host_properties(current_user: dict = Depends(get_current_user)):
    if current_user["user_type"] != "host":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only hosts can access this endpoint"
        )
    
    properties = list(properties_collection.find({"host_id": current_user["id"]}))
    
    # Remove MongoDB _id field
    for prop in properties:
        prop.pop("_id", None)
    
    return {
        "properties": properties,
        "total": len(properties)
    }