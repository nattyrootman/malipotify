


"""  acces_token=create_access_token(
        data={"sub":user_db.email},
        expires_delta=timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES))

    return {
        "acces_token":acces_token,
        "token_type":"bearer",
        "user":{
            "id": str(user.id),
            "email": user.email,
            "name": user.name  # ou autres champs
        }
    }
    """