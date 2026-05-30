from fastapi import FastAPI

app = FastAPI()
@app.get("/")
def root():
    return {"status": "BookVault Backend is running!"}