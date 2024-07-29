from fastapi import FastAPI 
from pydantic import BaseModel 
from fastapi.applications import JSONResponse
from typing import Union
from main import Recommendator



app = FastAPI()
recommendator = Recommendator("pickleData") 


class Inputs(BaseModel):

    Cutoff : Union[int , float]
    Com : str   
    BranchCode : str


@app.get("/")

async def welocme():

    return "welcome to ml prediction"

@app.post("/recommend")
async def recommend(inputs : Inputs ):

    Cutoff  = inputs.Cutoff
    Com =  inputs.Com.upper()
    BranchCode = inputs.BranchCode.upper()

    colleges = recommendator.getColleges([Cutoff , Com , BranchCode])

    return (JSONResponse({"Colleges" : colleges}))

# python -m uvicorn server:app --host localhost --port 4000 --reload    