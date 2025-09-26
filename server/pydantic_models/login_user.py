
import motor.motor_asyncio
from motor.motor_asyncio import AsyncIOMotorClient
from pydantic import BaseModel,EmailStr,Field

from beanie import Document, Indexed, init_beanie


class LoginUser (BaseModel) :
    email:str
    password:str = Field(..., min_length=1)