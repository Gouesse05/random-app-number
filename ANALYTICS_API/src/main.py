from typing import Union
from fastapi import FastAPI
from src.api.events import router as events_router

app = FastAPI()

app.include_router(events_router, prefix="/api/events")

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}

@app.get("/healthz")
def read_health_api():
    return {"status": "ok"}
