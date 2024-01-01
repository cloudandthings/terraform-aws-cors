import os
import json

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from mangum import Mangum

app = FastAPI()

cors_env = os.environ.get("cors")
cors_config = json.loads(cors_env)

app.add_middleware(
    CORSMiddleware,
    allow_origins=cors_config['origins'],
    allow_credentials=True,
    allow_methods=cors_config['methods'],
    allow_headers=cors_config['headers'],
)

@app.get("/")
def get():
    return "GET /"

@app.post("/")
def post():
    return "POST /"

@app.put("/")
def put():
    return "PUT /"

@app.delete("/")
def delete():
    return "DELETE /"

@app.patch("/")
def patch():
    return "PATCH /"

def lambda_handler(event, context):
    handler = Mangum(app)
    response = handler(event, context)
    return response
