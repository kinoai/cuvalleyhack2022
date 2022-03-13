from typing import Optional
from pydantic import BaseModel
from fastapi import File, UploadFile

class PredictionData(BaseModel):
    param1: str
    param2: int
    param3: bool
    param4: bytes
