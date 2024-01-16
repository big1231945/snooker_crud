from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from datetime import timedelta,datetime

import jwt.exceptions 
from app.DataBase import get_db

from app.Models import User

router = APIRouter(
    prefix="/admin", tags=["admin"], responses={404: {"description": "Not found"}}
)

JWT_SECRET_KEY = "AKLSHFkldsjhflkzdhjgioxvdsfkuhsdkfjygsyhjdgfhjdvbjxhgfkuysadkygfsyfgdkhjhsagdfkjhsdcygKHJGhgjkhgkjhgKJHGKJHGHjhsgdfkjhg"
SECRET_KEY = JWT_SECRET_KEY
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_HOUR = 24
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

def get_user_by_username(db: Session, username: str):
    return db.query(User).filter(User.username == username).first()

def create_admin_access_token(data: dict, expires_delta: timedelta):
    to_encode = data.copy()
    expire = datetime.utcnow() + expires_delta
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

def authenticate_token(token: str = Depends(oauth2_scheme)):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username = payload.get("sub")
        if username is None:
            raise HTTPException(
                status_code=401, detail="ข้อมูล authentication ไม่ถูกต้อง"
            )
    except jwt.exceptions.ExpiredSignatureError:
        raise HTTPException(status_code=402, detail="Token หมดเวลา")
    except jwt.exceptions.InvalidSignatureError:
        raise HTTPException(status_code=403, detail="signature ไม่ถูกต้อง")
    except Exception:
        raise HTTPException(status_code=404, detail="Could not validate credentials")
    return username





@router.post("/login")
async def loginAdmin(
    db: Session = Depends(get_db), form_data: OAuth2PasswordRequestForm = Depends()
):
    user = get_user_by_username(db, form_data.username)
    if not user:
        raise HTTPException(
            status_code=400, detail="รหัสไม่ถูกต้อง username หรือ password"
        )
    if user.password != form_data.password:
        raise HTTPException(
            status_code=400, detail="รหัสไม่ถูกต้อง username หรือ password"
        )
    access_token_expires = timedelta(hours=ACCESS_TOKEN_EXPIRE_HOUR)
    access_token = create_admin_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires
    )
    return {    
        "access_token": access_token
    }