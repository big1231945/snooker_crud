from fastapi import FastAPI
import uvicorn
from app.Router import api_router
app = FastAPI()

app.include_router(router=api_router,prefix="/api")

@app.get("/")
def hello():
    return "Hi"


if __name__ == "__main__":
    uvicorn.run(port=80,reload=True)
    #uvicorn main:app --port 80 --reload