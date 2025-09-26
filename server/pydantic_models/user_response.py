from pydantic import BaseModel,EmailStr
from datetime import datetime, timedelta

class UserResponse(BaseModel):
    id:str
    name:str
    email:EmailStr
    created_at: datetime
    is_active: bool




class AuthResponse(BaseModel):
    token: str
    token_type: str = "bearer"
    user: UserResponse



