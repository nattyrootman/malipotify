
from fastapi import APIRouter,HTTPException, Depends, status,Header
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from beanie_models.user import User
from passlib.context import CryptContext
from jose import JWTError, jwt
import os
from dotenv import load_dotenv

load_dotenv()

SECRET_KEY=os.getenv("SECRET_KEY")
ALGORITHM=os.getenv("ALGORITHM")

def auth_middleware(token=Header()):
    try:
      if not token:
        raise HTTPException(status_code=401,detail="No token access")
    
      verify_token=jwt.decode(token,SECRET_KEY,algorithms=[ALGORITHM])
   
      if not verify_token:
        raise HTTPException(status_code=401,detail="Unauthorized,access denied")

      user_id=verify_token.get("id")
      return {"id":user_id,
              "token":token
      }

    except JWTError :
         raise HTTPException(status_code=401,detail="token is invali")




async def auth_middleware2(authorization: str = Header()):
    if not authorization:
        raise HTTPException(status_code=401, detail="No token access")

    scheme, _, token = authorization.partition(" ")
    if scheme.lower() != "bearer":
        raise HTTPException(status_code=401, detail="Invalid auth scheme")

    payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
    return {"id": payload.get("id"), "token": token}
