from pymongo import MongoClient
from dotenv import load_dotenv
import os
import motor.motor_asyncio
from motor.motor_asyncio import AsyncIOMotorClient
from pydantic import BaseModel
from beanie import Document, Indexed, init_beanie

from beanie_models.user import User
from beanie_models.favorite_song import FavariteSong







load_dotenv()

mongo_url=os.getenv('mongo_url')
DATABASE_NAME=os.getenv('DATABASE_NAME','mydatabase')

mongo_client:AsyncIOMotorClient=None

async def init_db():
    print("Connecting to MongoDB...")
    global  mongo_client
    try:
        mongo_client=AsyncIOMotorClient(mongo_url)
        await mongo_client.admin.command("ping")
        print("MongoDB connection successful. Initializing Beanie...")
        await init_beanie(database=mongo_client[DATABASE_NAME],document_models=[User,Song,FavoriteSong])
        return mongo_client
    except   Exception as e:
        print(f"Error connecting to MongoDB or initializing Beanie: {e}")
        
        raise
    



