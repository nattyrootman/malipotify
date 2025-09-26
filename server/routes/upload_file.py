

from fastapi import APIRouter,HTTPException, Depends, status,Header,UploadFile ,File,Form

from routes.auth_user import router
from routes.auth_user import get_current_user

from beanie_models.user import User
from beanie_models.load_song_model import Song
import traceback

import cloudinary
import cloudinary.uploader
import cloudinary.api
from cloudinary.uploader import upload


# Import the CloudinaryImage and CloudinaryVideo methods for the simplified syntax used in this guide
from cloudinary import CloudinaryImage
from cloudinary import CloudinaryVideo
from dotenv import load_dotenv
import os
import uuid

from pydantic_models.user_response import UserResponse
from pydantic_models.upload_response import UploadResponse


upload_router=APIRouter()
load_dotenv()

cloudinary.config( 
  cloud_name = os.getenv("CLOUDINARY_CLOUD_NAME"), 
  api_key = os.getenv("CLOUDINARY_API_KEY"),
  api_secret = os.getenv("CLOUDINARY_API_SECRET"),
  secure = True
  )



@upload_router.post("/upload")
async def upload_song(song:UploadFile=File(...),
                thumbnail:UploadFile=File(...),artist:str=Form(...),
                song_name:str=Form(...),hex_color:str=Form(...),
                user:User=Depends(get_current_user)
                ):
                try:
                  song_id=str(uuid.uuid4())
                  thumbnail_id=str(uuid.uuid4())
                  song_res= upload(song.file,resource_type="auto",folder=f"songs/{song_id}")
                  print(song_res)
                  thumbnail_res= upload(thumbnail.file,resource_type="image",folder=f"songs/{song_id}")
                
                  print(thumbnail_res)
                
                  new_song=Song(
                    
                    song=song_res["secure_url"],
                    thumbnail=thumbnail_res["secure_url"],
                    artist=artist,
                    song_name=song_name,
                    hex_color=hex_color,
                    uploaded_by= str(user.id),
                    )


                  await new_song.insert()

                  return UploadResponse(
                    id=str(new_song.id),
                    song=new_song.song,
                    thumbnail=new_song.thumbnail,
                    artist=new_song.artist,
                    song_name=new_song.song_name,
                    hex_color=new_song.hex_color,
                    uploaded_by=new_song.uploaded_by,
                    created_at=new_song.created_at

                  )
                    

                except Exception as e:
                   print(f"Upload error: {str(e)}") 
                   traceback.print_exc() 
                   raise HTTPException(status_code=500,detail=str(e))
               

                   





    



