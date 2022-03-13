from pathlib import Path
from functools import lru_cache
from typing import Any

import numpy as np
import pandas as pd
from fastapi import Depends, FastAPI, File, UploadFile, Body
from fastapi.middleware.cors import CORSMiddleware
from starlette.responses import RedirectResponse
from starlette import status
import aiofiles

from schemas import PredictionData
from settings import DATA_PATH as data_path


# TODO add model type
@lru_cache
def load_model() -> Any:
    """Load the prediction model into the application.

    Returns:
        Any: _description_
    """
    return


app = FastAPI()


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/", include_in_schema=False)
def root():
    return RedirectResponse(url="/docs")


@app.post("/dataset", status_code=status.HTTP_200_OK)
async def upload_dataset(password: str = Body(...), dataset: UploadFile = File(...)) -> Any:
    file_save_path: Path = data_path / dataset.filename
    async with aiofiles.open(file_save_path, "wb") as f:
        while content := await dataset.read(1024):
            await f.write(content)
    return {"Dataset": "OK"}


# TODO agree on returned type
@app.post("/predict")
def predict(prediction_data: PredictionData, model: Any = Depends(load_model)) -> Any:
    prediction_df: pd.DataFrame = pd.DataFrame(prediction_data.dict())
    prediction: np.ndarray = model.predict(prediction_df)
    return
