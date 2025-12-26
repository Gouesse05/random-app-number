# Random App Number

FastAPI application with SQLModel, Docker support, and TimescaleDB integration.

## Project Structure

```
random-app-number/
├── ANALYTICS_API/
│   ├── .github/
│   │   └── copilot-instructions.md
│   ├── src/
│   │   └── main.py              # FastAPI app logic
│   ├── requirements.txt          # Python dependencies
│   ├── Dockerfile               # Docker image (Python 3.12.3)
│   └── docker-compose.yml       # Docker Compose configuration
├── .git/
└── README.md
```

## Quick Start

### Option 1: Local Development (uvicorn)

1. **Clone the repository:**
```bash
git clone https://github.com/Gouesse05/random-app-number.git
cd random-app-number/ANALYTICS_API
```

2. **Create and activate virtual environment:**
```bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. **Install dependencies:**
```bash
pip install -r requirements.txt
```

4. **Run the server:**
```bash
uvicorn src.main:app --reload
```

Access Swagger UI: **http://127.0.0.1:8000/docs**

### Option 2: Docker

1. **Build and run with docker-compose:**
```bash
cd random-app-number/ANALYTICS_API
docker-compose up --build
```

Access Swagger UI: **http://localhost:8000/docs**

2. **Stop the container:**
```bash
docker-compose down
```

## API Endpoints

- **GET** `/` - Welcome message
- **GET** `/health` - Health check
- **POST** `/items/` - Create a new item
- **GET** `/items/` - List all items

## Environment Variables

- `DATABASE_URL` - Database connection string (default: `sqlite:///./test.db`)
  - Example for PostgreSQL/TimescaleDB: `postgresql+psycopg2://user:pass@host:5432/dbname`

## Dependencies

- **FastAPI** - Modern web framework
- **SQLModel** - SQL database ORM with Pydantic models
- **SQLAlchemy** - SQL toolkit and ORM
- **Pydantic** - Data validation
- **Gunicorn** - Production WSGI server
- **Uvicorn** - ASGI server for FastAPI

See `ANALYTICS_API/requirements.txt` for pinned versions.

## Development

### Running tests
Currently no tests configured. Add test files and run with:
```bash
pytest
```

### Code structure
- `src/main.py` - Core FastAPI application with SQLModel models and endpoints

### Adding new endpoints
1. Edit `src/main.py`
2. Add your route functions decorated with `@app.get()`, `@app.post()`, etc.
3. Uvicorn hot-reload will automatically reflect changes

## Docker Details

- **Base Image:** `python:3.12.3-slim`
- **Working Directory:** `/app`
- **Port:** 8000 (exposed)
- **Default Command:** `uvicorn main:app --host 0.0.0.0 --port 8000`

## Production Deployment

Use **Gunicorn** with Uvicorn workers:
```bash
gunicorn -k uvicorn.workers.UvicornWorker main:app -w 4 -b 0.0.0.0:8000
```

Or run Docker container in production mode:
```bash
docker build -t random-app-number ANALYTICS_API/
docker run -p 8000:8000 random-app-number
```

## Useful Links

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [SQLModel Documentation](https://sqlmodel.tiangolo.com/)
- [Uvicorn Documentation](https://www.uvicorn.org/)

## License

MIT
