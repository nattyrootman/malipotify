

import motor.motor_asyncio
from motor.motor_asyncio import AsyncIOMotorClient
from pydantic import BaseModel,EmailStr,Field


from beanie import Document, Indexed, init_beanie
from datetime import datetime, timedelta


class User(Document):
    
    name:str=Field(..., min_length=1, max_length=50)
    email:EmailStr=Field(..., unique=True,description="email address")
    password:str=Field(..., min_length=6)
    created_at:datetime=  Field(default_factory=datetime.utcnow)
    is_active:bool=Field(default=True)

    class Settings:
        name="users"
        index:["email"]

