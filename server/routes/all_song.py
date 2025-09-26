
from fastapi import APIRouter,HTTPException, Depends, status,Header,UploadFile ,File,Form

from routes.auth_user import router
from routes.auth_user import get_current_user

from beanie_models.user import User
from beanie_models.load_song_model import Song
import traceback
from middleware.middleware import auth_middleware




song_router = APIRouter()

@song_router.get("/songlist")
async def song_list( user=Depends(get_current_user)):
    
     song=await Song.find_all().to_list()
     return song





 #if not user:
       # raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Unauthorized")


    
    
   






    


