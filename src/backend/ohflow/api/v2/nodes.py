import datetime
from typing import List
from uuid import UUID

from langflow.api.utils import remove_api_keys

from ohflow.database.models.node import (
    Node,
    NodeCreate,
    NodeRead,
    NodeUpdate,
)
from langflow.services.utils import get_session
from sqlmodel import Session, select
from fastapi import APIRouter, Depends, HTTPException
from fastapi.encoders import jsonable_encoder

from fastapi import File, UploadFile
import json

# build router
router = APIRouter(prefix="/nodes", tags=["Nodes"])


@router.post("/", response_model=NodeRead, status_code=201)
def create_flow(*, session: Session = Depends(get_session), flow: NodeCreate):
    """Create a new flow."""
    db_flow = Node.from_orm(flow)
    db_flow.createdAt = datetime.datetime.now()
    db_flow.updatedAt = datetime.datetime.now()
    session.add(db_flow)
    session.commit()
    session.refresh(db_flow)
    return db_flow


@router.get("/", response_model=list[NodeRead], status_code=200)
def read_flows(*, session: Session = Depends(get_session)):
    """Read all flows."""
    try:
        flows = session.exec(select(Node)).all()
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e)) from e
    return [jsonable_encoder(flow) for flow in flows]


@router.get("/{flow_id}", response_model=NodeRead, status_code=200)
def read_flow(*, session: Session = Depends(get_session), flow_id):
    """Read a flow."""
    if flow := session.get(Node, flow_id):
        return flow
    else:
        raise HTTPException(status_code=404, detail="Node not found")


@router.patch("/{flow_id}", response_model=NodeRead, status_code=200)
def update_flow(
    *, session: Session = Depends(get_session), flow_id, flow: NodeUpdate
):
    """Update a flow."""

    db_flow = session.get(Node, flow_id)
    if not db_flow:
        raise HTTPException(status_code=404, detail="Node not found")
    flow_data = flow.dict(exclude_unset=True)
    for key, value in flow_data.items():
        setattr(db_flow, key, value)
    db_flow.updatedAt = datetime.datetime.now()
    session.add(db_flow)
    session.commit()
    session.refresh(db_flow)
    return db_flow


@router.delete("/{flow_id}", status_code=200)
def delete_flow(*, session: Session = Depends(get_session), flow_id: str):
    """Delete a flow."""
    flow = session.query(Node).filter(Node.uuid==flow_id).one_or_none()
    if not flow:
        raise HTTPException(status_code=404, detail="Node not found")
    session.delete(flow)
    session.commit()
    return {"message": "Node deleted successfully"}


# Define a new model to handle multiple flows


@router.post("/batch/", response_model=List[NodeRead], status_code=201)
def create_flows(*, session: Session = Depends(get_session), flow_list: List[NodeCreate]):
    """Create multiple new flows."""
    db_flows = []
    for flow in flow_list:
        db_flow = Node.from_orm(flow)
        session.add(db_flow)
        db_flows.append(db_flow)
    session.commit()
    for db_flow in db_flows:
        session.refresh(db_flow)
    return db_flows


@router.post("/upload/", response_model=List[NodeRead], status_code=201)
async def upload_file(
    *, session: Session = Depends(get_session), file: UploadFile = File(...)
):
    """Upload flows from a file."""
    contents = await file.read()
    data = json.loads(contents)
    flows=[NodeCreate(**flow) for flow in data]
    return create_flows(session=session, flow_list=flows)


@router.get("/download/", response_model=List[NodeRead], status_code=200)
async def download_file(*, session: Session = Depends(get_session)):
    """Download all flows as a file."""
    flows = read_flows(session=session)
    return flows
