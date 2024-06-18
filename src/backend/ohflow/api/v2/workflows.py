import datetime
from typing import List
from uuid import UUID

from langflow.api.utils import remove_api_keys, is_number
from langflow.api.v1.schemas import WorkFlowListCreate, WorkFlowListRead
from langflow.database.models.workflow import (
    WorkFlow,
    WorkFlowCreate,
    WorkFlowRead,
    WorkFlowReadWithStyle,
    WorkFlowUpdate,
)
from langflow.services.utils import get_session
from sqlmodel import Session, select
from fastapi import APIRouter, Depends, HTTPException
from fastapi.encoders import jsonable_encoder

from fastapi import File, UploadFile
import json

# build router
router = APIRouter(prefix="/workflows", tags=["WorkFlows"])


@router.post("/", response_model=WorkFlowRead, status_code=201)
def create_flow(*, session: Session = Depends(get_session), flow: WorkFlowCreate):
    """Create a new flow."""
    db_flow = WorkFlow.from_orm(flow)
    db_flow.createdAt = datetime.datetime.now()
    db_flow.updatedAt = datetime.datetime.now()
    session.add(db_flow)
    session.commit()
    session.refresh(db_flow)
    return db_flow


@router.get("/", response_model=list[WorkFlowReadWithStyle], status_code=200)
def read_flows(*, session: Session = Depends(get_session)):
    """Read all flows."""
    try:
        flows = session.exec(select(WorkFlow).filter(WorkFlow.uuid!=None)).all()
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e)) from e
    return [jsonable_encoder(flow) for flow in flows]


@router.get("/template", response_model=list[WorkFlowReadWithStyle], status_code=200)
def read_template_flows(*, session: Session = Depends(get_session)):
    """Read all flows."""
    try:
        flows = session.exec(select(WorkFlow).filter(WorkFlow.uuid==None)).all()
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e)) from e
    return [jsonable_encoder(flow) for flow in flows]


@router.get("/{flow_id}", response_model=WorkFlowReadWithStyle, status_code=200)
def read_flow(*, session: Session = Depends(get_session), flow_id):
    """Read a flow."""
    if is_number(flow_id):
        if flow := session.get(WorkFlow, flow_id):
            return flow
    else:
        flow = session.exec(select(WorkFlow).filter(WorkFlow.uuid==flow_id)).one_or_none()
        if flow:
            return flow
    raise HTTPException(status_code=404, detail="WorkFlow not found")


@router.patch("/{flow_id}", response_model=WorkFlowRead, status_code=200)
def update_flow(
    *, session: Session = Depends(get_session), flow_id, flow: WorkFlowUpdate
):
    """Update a flow."""

    db_flow = session.get(WorkFlow, flow_id)
    if not db_flow:
        raise HTTPException(status_code=404, detail="WorkFlow not found")
    flow_data = flow.dict(exclude_unset=True)
    for key, value in flow_data.items():
        setattr(db_flow, key, value)
    db_flow.updatedAt = datetime.datetime.now()
    session.add(db_flow)
    session.commit()
    session.refresh(db_flow)
    return db_flow


@router.delete("/{flow_id}", status_code=200)
def delete_flow(*, session: Session = Depends(get_session), flow_id: UUID):
    """Delete a flow."""
    flow = session.query(WorkFlow).filter(WorkFlow.uuid==flow_id).one_or_none()
    if not flow:
        raise HTTPException(status_code=404, detail="WorkFlow not found")
    session.delete(flow)
    session.commit()
    return {"message": "WorkFlow deleted successfully"}


# Define a new model to handle multiple flows


@router.post("/batch/", response_model=List[WorkFlowRead], status_code=201)
def create_flows(*, session: Session = Depends(get_session), flow_list: WorkFlowListCreate):
    """Create multiple new flows."""
    db_flows = []
    for flow in flow_list.flows:
        db_flow = WorkFlow.from_orm(flow)
        session.add(db_flow)
        db_flows.append(db_flow)
    session.commit()
    for db_flow in db_flows:
        session.refresh(db_flow)
    return db_flows


@router.post("/upload/", response_model=List[WorkFlowRead], status_code=201)
async def upload_file(
    *, session: Session = Depends(get_session), file: UploadFile = File(...)
):
    """Upload flows from a file."""
    contents = await file.read()
    data = json.loads(contents)
    if "flows" in data:
        flow_list = WorkFlowListCreate(**data)
    else:
        flow_list = WorkFlowListCreate(flows=[WorkFlowCreate(**flow) for flow in data])
    return create_flows(session=session, flow_list=flow_list)


@router.get("/download/", response_model=WorkFlowListRead, status_code=200)
async def download_file(*, session: Session = Depends(get_session)):
    """Download all flows as a file."""
    flows = read_flows(session=session)
    return WorkFlowListRead(flows=flows)
