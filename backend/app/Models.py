from pydantic import BaseModel
from sqlalchemy import Column, Integer, String,Double
from app.DataBase import Base


class User(Base):
    __tablename__ = "user"
    user_id = Column(Integer,primary_key=True)
    username = Column(String)
    password = Column(String)

class Product(Base):
    __tablename__ ="product"
    id = Column(Integer,primary_key=True)
    product_name = Column(String)
    img_url = Column(String)
    product_type = Column(String)
    product_price = Column(Double)
    product_details = Column(String)
    