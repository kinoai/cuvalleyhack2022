from pydantic import BaseModel


class PredictionData(BaseModel):
    param1: str
    param2: int
    param3: bool
    param4: bytes
