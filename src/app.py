from functools import lru_cache
from typing import Any, Type

import pandas as pd
from fastapi import Depends, FastAPI
from starlette.responses import RedirectResponse



# TODO add model type
@lru_cache
def load_model() -> Any:
    """Load the prediction model into the application.

    Returns:
        Any: _description_
    """
    return


app = FastAPI()


@app.get("/", include_in_schema=False)
def root():
    return RedirectResponse(url="/docs")


# TODO agree on returned type
@app.post("/predict")
def predict(prediction_data: PredictionData, model: Any = Depends(load_model)) -> Any:
    prediction_df: pd.DataFrame = pd.DataFrame(prediction_data.dict())
    prediction: np.ndarray = model.predict(prediction_df)
    return
