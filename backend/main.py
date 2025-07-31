from fastapi import FastAPI, HTTPException, Depends, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
import os
from dotenv import load_dotenv
import uvicorn

# Load environment variables
load_dotenv()

# Create FastAPI app
app = FastAPI(
    title="EgyptNest API",
    description="A comprehensive Airbnb-like platform API",
    version="1.0.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Security
security = HTTPBearer()

# Import routers
from routes import auth, users, properties, bookings, messages

# Include routers
app.include_router(auth.router, prefix="/api/auth", tags=["authentication"])
app.include_router(users.router, prefix="/api/users", tags=["users"])  
app.include_router(properties.router, prefix="/api/properties", tags=["properties"])
app.include_router(bookings.router, prefix="/api/bookings", tags=["bookings"])
app.include_router(messages.router, prefix="/api/messages", tags=["messages"])

@app.get("/api/health")
async def health_check():
    return {"status": "healthy", "message": "EgyptNest API is running"}

@app.get("/")
async def root():
    return {"message": "Welcome to EgyptNest API"}

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8001, reload=True)