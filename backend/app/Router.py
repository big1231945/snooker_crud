from fastapi import APIRouter
from app import crud,login
api_router = APIRouter()

api_router.include_router(router=login.router)
api_router.include_router(router=crud.router)