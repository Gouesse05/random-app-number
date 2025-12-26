
from fastapi import FastAPI
from sqlmodel import SQLModel, Field, create_engine, Session, select
import os


# Database configuration: set `DATABASE_URL` env var to use Postgres/TimescaleDB.
# Example: export DATABASE_URL="postgresql+psycopg2://user:pass@host:5432/dbname"
DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./test.db")


engine = create_engine(DATABASE_URL, echo=False)


def init_db() -> None:
	"""Create database tables (SQLModel metadata)."""
	SQLModel.metadata.create_all(engine)


app = FastAPI(title="Random Number App API")


@app.on_event("startup")
def on_startup() -> None:
	init_db()


class Item(SQLModel, table=True):
	id: int | None = Field(default=None, primary_key=True)
	name: str


@app.get("/", tags=["root"])
def read_root() -> dict:
	return {"message": "Bienvenue — Random Number App API"}


@app.get("/health", tags=["health"])
def health() -> dict:
	return {"status": "ok"}


@app.post("/items/", response_model=Item, tags=["items"])
def create_item(item: Item) -> Item:
	with Session(engine) as session:
		session.add(item)
		session.commit()
		session.refresh(item)
		return item


@app.get("/items/", response_model=list[Item], tags=["items"])
def list_items() -> list[Item]:
	with Session(engine) as session:
		items = session.exec(select(Item)).all()
		return items

