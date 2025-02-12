import os
from typing import Annotated, get_type_hints

import joblib
from fastapi import FastAPI
from pandera import DataFrameModel
from pandera.typing import DataFrame as DataFrame
from pydantic import WithJsonSchema
import pandas as pd

# # Load your model
model = None
InputType = Annotated[DataFrame[DataFrameModel], WithJsonSchema(DataFrameModel.to_json_schema())]
OutputType = Annotated[DataFrame[DataFrameModel], WithJsonSchema(DataFrameModel.to_json_schema())]

app = FastAPI()

if os.path.exists('model.pkl'):
    with open('model.pkl', 'rb') as f:
        
        model = joblib.load(f)
        types = get_type_hints(model.predict)
        r = types.pop('return')
        i = list(types.items())[0][1]
        InputType = Annotated[DataFrame[i], WithJsonSchema(i.to_json_schema())]
        OutputType = Annotated[DataFrame[r], WithJsonSchema(r.to_json_schema())]


@app.get("/health")
def health() -> dict[str, str]:
    if model is None:
        return {"STATUS": "ERROR", "MESSAGE": "Model not loaded"}
    return {"STATUS": "OK"}

@app.post("/predict/")
def predict(data: InputType) -> OutputType:
    return model.predict(pd.DataFrame(data))
