

from beanie import Document, Indexed, init_beanie
from pydantic import BaseModel,EmailStr,Field

from datetime import datetime, timedelta
import uuid


class FavoriteSong(Document):
    user_id:str
    song_id:str
    created_at:datetime = Field(default_factory=datetime.utcnow)


    class Settings:
        name:"FavSongs"
