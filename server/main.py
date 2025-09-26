from fastapi import FastAPI,HTTPException
from fastapi.middleware.cors import CORSMiddleware

#import database.py as db
from database import init_db
import hashlib
import bcrypt
import motor.motor_asyncio
from motor.motor_asyncio import AsyncIOMotorClient
from pydantic import BaseModel

from beanie import Document, Indexed, init_beanie
from routes.auth_user import router
from routes.upload_file import upload_router
from routes.all_song import song_router

from routes.favorite_song import song_router




app=FastAPI()

app.add_middleware(
     CORSMiddleware,
     allow_origins=["*"],  # Mets l'URL exacte de ton frontend en production
     allow_credentials=True,
     allow_methods=["*"],
     allow_headers=["*"],
)

app.include_router(router,prefix='/auth')
app.include_router(upload_router,prefix='/auth')
app.include_router(song_router,prefix='/auth')




@app.on_event("startup")
async def app_start():

    global mongo_client
    mongo_client=await init_db()