
from pydantic import BaseModel, EmailStr, Field

import motor.motor_asyncio
from motor.motor_asyncio import AsyncIOMotorClient
from pydantic import BaseModel

from beanie import Document, Indexed, init_beanie

class CreateUser(BaseModel):
    name:str= Field(...,min_lenght=3,max_lenght=50)
    email:EmailStr=Field(..., description="User email address" )
    password:str=Field(...,min_lenght=6)

