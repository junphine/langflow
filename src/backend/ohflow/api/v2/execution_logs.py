import datetime
from typing import List
from uuid import UUID
from langflow.api.utils import remove_api_keys

from ohflow.database.models.execution_log import (
    ExecutionLog,
    ExecutionLogCreate,
    ExecutionLogRead,
    ExecutionLogUpdate,
)
from langflow.services.utils import get_session
from sqlmodel import Session, select
from fastapi import APIRouter, Depends, HTTPException
from fastapi.encoders import jsonable_encoder

from fastapi import File, UploadFile
import json

# build router
router = APIRouter(prefix="/execution_logs", tags=["ExecutionLogs"])


@router.post("/", response_model=ExecutionLogRead, status_code=201)
def create_execution_log(*, session: Session = Depends(get_session), flow: ExecutionLogCreate):
    """Create a new flow."""
    db_flow = ExecutionLog.from_orm(flow)
    db_flow.createdAt = datetime.datetime.now()
    db_flow.updatedAt = datetime.datetime.now()
    session.add(db_flow)
    session.commit()
    session.refresh(db_flow)
    return db_flow


@router.get("/", response_model=list[ExecutionLogRead], status_code=200)
def read_execution_logs(*, session: Session = Depends(get_session)):
    """Read all flows."""
    try:
        flows = session.exec(select(ExecutionLog)).all()
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e)) from e
    return [jsonable_encoder(flow) for flow in flows]


@router.get("/{run_id}", response_model=list[ExecutionLogRead], status_code=200)
def read_execution_log(*, session: Session = Depends(get_session), run_id):
    """Read a flow."""
    if logs := session.query(ExecutionLog).filter(ExecutionLog.runId==run_id).all():
        return logs
    else:
        raise HTTPException(status_code=404, detail="ExecutionLog not found")


@router.patch("/{log_id}", response_model=ExecutionLogRead, status_code=200)
def update_execution_log(
    *, session: Session = Depends(get_session), log_id, flow: ExecutionLogUpdate
):
    """Update a flow."""

    db_flow = session.get(ExecutionLog, log_id)
    if not db_flow:
        raise HTTPException(status_code=404, detail="ExecutionLog not found")
    flow_data = flow.dict(exclude_unset=True)
    for key, value in flow_data.items():
        setattr(db_flow, key, value)
    db_flow.updatedAt = datetime.datetime.now()
    session.add(db_flow)
    session.commit()
    session.refresh(db_flow)
    return db_flow


@router.delete("/{log_id}", status_code=200)
def delete_execution_log(*, session: Session = Depends(get_session), log_id):
    """Delete a flow."""
    flow = session.get(ExecutionLog, log_id)
    if not flow:
        raise HTTPException(status_code=404, detail="ExecutionLog not found")
    session.delete(flow)
    session.commit()
    return {"message": "ExecutionLog deleted successfully"}


# Define a new model to handle multiple flows


@router.post("/batch/", response_model=List[ExecutionLogRead], status_code=201)
def create_execution_logs(*, session: Session = Depends(get_session), flow_list: List[ExecutionLogCreate]):
    """Create multiple new flows."""
    db_flows = []
    for flow in flow_list:
        db_flow = ExecutionLog.from_orm(flow)
        session.add(db_flow)
        db_flows.append(db_flow)
    session.commit()
    for db_flow in db_flows:
        session.refresh(db_flow)
    return db_flows


@router.post("/upload/", response_model=List[ExecutionLogRead], status_code=201)
async def upload_file(
    *, session: Session = Depends(get_session), file: UploadFile = File(...)
):
    """Upload flows from a file."""
    contents = await file.read()
    data = json.loads(contents)
    flows=[ExecutionLogCreate(**flow) for flow in data]
    return create_execution_logs(session=session, flow_list=flows)


@router.get("/download/", response_model=List[ExecutionLogRead], status_code=200)
async def download_file(*, session: Session = Depends(get_session)):
    """Download all flows as a file."""
    flows = read_execution_logs(session=session)
    return flows
