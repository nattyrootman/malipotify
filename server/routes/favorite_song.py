

from fastapi import APIRouter,HTTPException, Depends, status,Header,UploadFile ,File,Form

from routes.auth_user import router
from routes.auth_user import get_current_user

from beanie_models.favorite_song_model import FavoriteSong
#from beanie_models.song_model import  FavoriteSong


favorite_router=APIRouter()

@favorite_router.post("favorite/{song_id}")
async def favorites_song( song_id:str,  user:User=Depends(get_current_user)):
    song =song.get(song_id)
    if not song:
        raise HTTPException(status_code=404, detail="Song not found")

    existing_song=FavoriteSong.find_one(FavoriteSong.user_id==str(user.id),FavoriteSong.song_id==song_id)

    if existing_song:
        raise HTTPException(status_code=400,detail="cette chanson existe déja comme favorie")

    favorite_song=await FavoriteSong(user_id=str(user.id),song_id=song_id) 

    await favorite_song.insert()

    return {"favorite":favorite_song.id}


@favorite_router.delete("favorite/{song_id}")
async def delete_favorite(song_id,user:User=Depends(get_current_user)):

    favorite_song=await FavoriteSong.find_one(FavoriteSong.user_id==str(user.id),FavoriteSong.song_id==song_id)
    if not favorite_song:
        raise HTTPException(status_code=404,detail="chanson non trouvée")

    await favorite_song.delete()  

    return {"message": "Song Removed from favorites"}  


@favorite_router.get('/favorite')
async def get_favorit_songs(user:User=Depends(get_current_user)):
    favorite_songs=await FavoriteSong.find(FavoriteSong.user_id==str(user.id)).to_list()
   
    songs_ids=[fav.song_id for fav in favorite_songs]

    songs=await Song.find(Song.id.in_(songs_ids)).to_list()

    return songs


