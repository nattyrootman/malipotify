

from fastapi import APIRouter,HTTPException, Depends, status,Header
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from beanie_models.user import User
from pydantic_models.create_user import CreateUser
from pydantic_models.login_user import LoginUser
from passlib.context import CryptContext
from jose import JWTError, jwt

from datetime import datetime, timedelta
from typing import Optional
import os
from dotenv import load_dotenv

from pydantic_models.user_response import UserResponse,AuthResponse
from fastapi.security import HTTPBearer
from middleware.middleware import auth_middleware




load_dotenv()
router=APIRouter()
pwd_context=CryptContext(schemes=["bcrypt"],deprecated="auto")
ACCESS_TOKEN_EXPIRE_MINUTES = 7

SECRET_KEY=os.getenv("SECRET_KEY")
ALGORITHM=os.getenv("ALGORITHM")

security = HTTPBearer()

def get_password_hash(password):
    return pwd_context.hash(password)

def verify_password(plain_password,hashed_password):
    return pwd_context.verify(plain_password,hashed_password)

def create_access_token (data:dict,expires_delta:Optional[timedelta]=None):
    to_encode=data.copy()

    expire=datetime.utcnow()+(expires_delta or timedelta(day=7))
    to_encode.update({'exp':expire})

    return jwt.encode(to_encode,SECRET_KEY, algorithm=ALGORITHM)


    
@router.post('/signup')
async def signup(user:CreateUser):
     existing_user= await User.find_one(User.email==user.email)
     if existing_user:
        raise HTTPException(status_code=409,detail="Email already registered")
        
     newUser=User(name=user.name,email=user.email,password=get_password_hash(user.password),is_active=True,created_at=datetime.utcnow())

     await newUser.insert()

     token=jwt.encode({'sub':str(newUser.id)},SECRET_KEY,algorithm=ALGORITHM)
    
    
     return {
        "token": token,
        "user": {
            "id": str(newUser.id),  # Explicitly convert to string
            "name": newUser.name,
            "email": newUser.email,
            "is_active": newUser.is_active,
            "created_at": newUser.created_at.isoformat()
        }
    }

    


@router.post('/login')
async def login(login_user:LoginUser):
    user= await User.find_one(User.email==login_user.email)
    if not user:
        raise HTTPException("cet email n'exist pas")

    if not verify_password(login_user.password,user.password):
        raise HTTPException("mot de passe incorrect")
        
    token=jwt.encode({'sub':str(user.id)},SECRET_KEY,algorithm=ALGORITHM)
    
    return {
        "token": token,
        "user": {
            "id": str(user.id),  # Explicitly convert to string
            "name": user.name,
            "email": user.email,
            "is_active": user.is_active,
            "created_at": user.created_at.isoformat()
        }
    }



async def get_current_user(credentials:HTTPAuthorizationCredentials=Depends(security)):

    try:
        token=credentials.credentials
        payload=jwt.decode(token,SECRET_KEY,algorithms=[ALGORITHM])
        user_id=payload.get("sub")

        if not user_id:
            raise HTTPException(status_code=401,detail="invalid token is not valid ")

        user=await User.get(user_id)

        if not user:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,detail="user not fund") 


        return user

    except JWTError:
        raise HTTPException(status_code=401,detail="invalid token is not valid ")
    


    


@router.get("/user")
async def getUser(user=Depends(get_current_user)):
   
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return  {"user": {
        "id": str(user.id),
        "name": user.name,
        "email":user.email,
        "is_active": user.is_active
    }}






