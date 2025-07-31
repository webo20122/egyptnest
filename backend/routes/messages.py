from fastapi import APIRouter, HTTPException, status, Depends
from models import MessageCreate, MessageResponse, ConversationResponse
from database import messages_collection, conversations_collection, users_collection
from routes.auth import get_current_user
from datetime import datetime
from typing import List

router = APIRouter()

@router.post("/conversations", response_model=dict)
async def create_conversation(participant_id: str, property_id: str = None, current_user: dict = Depends(get_current_user)):
    # Check if conversation already exists
    participants = sorted([current_user["id"], participant_id])
    existing_conversation = conversations_collection.find_one({
        "participants": participants,
        "property_id": property_id
    })
    
    if existing_conversation:
        return {
            "conversation_id": existing_conversation["id"],
            "message": "Conversation already exists"
        }
    
    from auth import generate_uuid
    conversation_id = generate_uuid()
    
    conversation_doc = {
        "id": conversation_id,
        "participants": participants,
        "property_id": property_id,
        "created_at": datetime.utcnow(),
        "updated_at": datetime.utcnow()
    }
    
    conversations_collection.insert_one(conversation_doc)
    
    return {
        "conversation_id": conversation_id,
        "message": "Conversation created successfully"
    }

@router.get("/conversations", response_model=dict)
async def get_conversations(current_user: dict = Depends(get_current_user)):
    conversations = list(conversations_collection.find({
        "participants": current_user["id"]
    }))
    
    conversation_list = []
    for conv in conversations:
        conv.pop("_id", None)
        
        # Get other participant details
        other_participant_id = None
        for participant in conv["participants"]:
            if participant != current_user["id"]:
                other_participant_id = participant
                break
        
        if other_participant_id:
            participant = users_collection.find_one({"id": other_participant_id})
            if participant:
                conv["other_participant"] = {
                    "id": participant["id"],
                    "first_name": participant["first_name"],
                    "last_name": participant["last_name"],
                    "profile_image": participant.get("profile_image")
                }
        
        # Get last message
        last_message = messages_collection.find_one(
            {"conversation_id": conv["id"]},
            sort=[("created_at", -1)]
        )
        if last_message:
            last_message.pop("_id", None)
            conv["last_message"] = last_message
        
        conversation_list.append(conv)
    
    return {
        "conversations": conversation_list,
        "total": len(conversation_list)
    }

@router.post("/", response_model=dict)
async def send_message(message_data: MessageCreate, current_user: dict = Depends(get_current_user)):
    # Verify conversation exists and user is participant
    conversation = conversations_collection.find_one({"id": message_data.conversation_id})
    if not conversation:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Conversation not found"
        )
    
    if current_user["id"] not in conversation["participants"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You are not a participant in this conversation"
        )
    
    from auth import generate_uuid
    message_id = generate_uuid()
    
    message_doc = {
        "id": message_id,
        "conversation_id": message_data.conversation_id,
        "sender_id": current_user["id"],
        "content": message_data.content,
        "message_type": message_data.message_type,
        "is_read": False,
        "created_at": datetime.utcnow()
    }
    
    messages_collection.insert_one(message_doc)
    
    # Update conversation last updated time
    conversations_collection.update_one(
        {"id": message_data.conversation_id},
        {"$set": {"updated_at": datetime.utcnow()}}
    )
    
    return {
        "message": "Message sent successfully",
        "message_id": message_id
    }

@router.get("/{conversation_id}", response_model=dict)
async def get_messages(conversation_id: str, current_user: dict = Depends(get_current_user)):
    # Verify conversation exists and user is participant
    conversation = conversations_collection.find_one({"id": conversation_id})
    if not conversation:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Conversation not found"
        )
    
    if current_user["id"] not in conversation["participants"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You are not a participant in this conversation"
        )
    
    messages = list(messages_collection.find({
        "conversation_id": conversation_id
    }).sort("created_at", 1))
    
    # Remove MongoDB _id field
    for message in messages:
        message.pop("_id", None)
    
    return {
        "messages": messages,
        "total": len(messages)
    }

@router.put("/{message_id}/read", response_model=dict)
async def mark_message_as_read(message_id: str, current_user: dict = Depends(get_current_user)):
    message = messages_collection.find_one({"id": message_id})
    if not message:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Message not found"
        )
    
    # Verify user is in the conversation
    conversation = conversations_collection.find_one({"id": message["conversation_id"]})
    if not conversation or current_user["id"] not in conversation["participants"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You don't have permission to mark this message as read"
        )
    
    messages_collection.update_one(
        {"id": message_id},
        {"$set": {"is_read": True}}
    )
    
    return {
        "message": "Message marked as read"
    }