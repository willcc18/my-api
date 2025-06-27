from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
<<<<<<< HEAD
    return {"Hello": "From the cloud!777"}
