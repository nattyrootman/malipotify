


from beanie import Document, Indexed, init_beanie
from pydantic import BaseModel,EmailStr,Field

from datetime import datetime, timedelta
import uuid

class Song(Document):

    song:str
    thumbnail:str
    artist:str
    song_name:str
    hex_color:str
    uploaded_by:str
    created_at:datetime=  Field(default_factory=datetime.utcnow)


    class Settings:
        name:"Songs"
        


    





