

from pydantic import BaseModel,EmailStr
from datetime import datetime, timedelta

class UploadResponse(BaseModel):
    id:str
    song:str
    thumbnail:str
    artist:str
    song_name:str
    hex_color:str
    uploaded_by:str
    created_at:datetime
     
