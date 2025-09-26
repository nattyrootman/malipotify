



"""
@router.post('/signup',response_model=UserResponse)
async def signup(user:CreateUser):
    try:

        existing_user= await User.find_one(User.email==user.email)
        if existing_user:
          raise HTTPException(status_code=409,detail="Email already registered")

        newUser=User(name=user.name,email=user.email,password=get_password_hash(user.password),is_active=True,created_at=datetime.utcnow())
        await newUser.insert()
        
       
        return newUser
        
    except HTTPException:
        raise


    except Exception as e:
        raise HTTPException(status_code=500,detail=str(e))

    

    

#login user endpoint
@router.post('/login',response_model=AuthResponse)
async def login(login_user:LoginUser):
    user= await User.find_one(User.email==login_user.email)
    if not user or not verify_password(login_user.password,user.password):
        raise HTTPException(
            status_code=401,detail=" invalid credentials",
            headers={"WWW-Authenticate":"Bearer"}
            )
    
    

    token=create_access_token(
        data={"sub":str(user.id)},
        expires_delta=timedelta(days=7))

    return AuthResponse(
        token=token,
        token_type="bearer",

        user=UserResponse(
            id=str(user.id),
            name=user.name,
            email=user.email,
            created_at=user.created_at,
            is_active=user.is_active
        )
    )
    



async def get_current_user(credentials:HTTPAuthorizationCredentials=Depends(security)):

    try:
        auth_token=credentials.credentials
        payload=jwt.decode(auth_token,SECRET_KEY,algorithms=[ALGORITHM])
        user_id=payload.get("sub")

        if not user_id:
            raise HTTPException(status_code=401,detail="invalid token is not valid ")

        user=await User.get(user_id)

        if not user:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,detail="user not fund") 

        print(f"[DEBUG] User authenticated: id={user.id}, name={user.name}, email={user.email}")

        return user
        
        

    except  JWTError:
        raise HTTPException(
            status_code=401,
            detail="Invalid: token is not valid",
           
        )



@router.get("/user",response_model=UserResponse)
async def getUser(user:User=Depends(get_current_user)):
    print(f"[DEBUG] Route /me accessed by {user.email}")
    return UserResponse(
        id=str(user.id),                  
        name=user.name,
        email=user.email,
        created_at=user.created_at,
        is_active=user.is_active
    )


"""


