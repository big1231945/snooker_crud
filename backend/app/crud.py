from fastapi import APIRouter, Depends, HTTPException
from app.DataBase import get_db
from sqlalchemy.orm import Session
from app.Models import Product
from app.login import authenticate_token

router = APIRouter(prefix="/crud",tags=["crud"],responses={404: {"description": "Not found"}})



def create_product(db: Session, data: dict):
    my_data = Product(**data)
    db.add(my_data)
    db.commit()
    return my_data

def update_data(db: Session, db_data: Product, data: dict):
    for key, value in data.items():
        setattr(db_data, key, value)
    db.commit()

def delete_data(db: Session, db_data: Product):
    db.delete(db_data)
    db.commit()

def get_data_by_id(db: Session, id: int):
    return db.query(Product).filter(Product.id == id).first()

@router.post("/product", dependencies=[Depends(authenticate_token)])
async def get_product(db: Session = Depends(get_db)):
    data = db.query(Product).all()
    return {"product": data}

@router.post("/add", dependencies=[Depends(authenticate_token)])
async def add(data: dict, db: Session = Depends(get_db)):
    data = create_product(db, data)
    if data:
        return {"message": "เพิ่มสำเร็จ"}
    else:
        raise HTTPException(status_code=400, detail="เพิ่มไม่สำเร็จ")
    
@router.put("/update/{product_id}", dependencies=[Depends(authenticate_token)])
def update_my_data(product_id: int, data: dict, db: Session = Depends(get_db)):
    db_data = get_data_by_id(db, product_id)
    if db_data:
        update_data(db, db_data, data)
        return {"message": "อัพเดทสำเร็จ"}
    else:
        raise HTTPException(status_code=400, detail="อัพเดทไม่สำเร็จ")
    
@router.delete("/delete/{product_id}", dependencies=[Depends(authenticate_token)])
def delete_my_data(product_id: int, db: Session = Depends(get_db)):
    db_data = get_data_by_id(db, product_id)
    if db_data:
        delete_data(db, db_data)
        return {"message": "ลบข้อมูลสำเร็จ"}
    else:
        raise HTTPException(status_code=400, detail="ลบข้อมูลไม่สำเร็จ")