import datetime
from typing import List
from uuid import UUID
import string
from ohflow.database.models.execution_log import ExecutionLog, ExecutionLogRead
from ohflow.database.models.run_log import RunLog
from ohflow.database.models.workflow import WorkFlow

from ohflow.api.utils import dict_to_object

from ohflow.database.models.job import (
    Job,
    JobCreate,
    JobRead,
    JobUpdate,
)
from langflow.services.utils import get_session
from sqlmodel import Session, select
from fastapi import APIRouter, Depends, HTTPException
from fastapi.encoders import jsonable_encoder

from fastapi import File, UploadFile
import json

# build router
router = APIRouter(prefix="/jobs", tags=["Jobs"])


@router.post("/", response_model=JobRead, status_code=201)
def create_flow_job(*, session: Session = Depends(get_session), flow: JobCreate):
    """Create a new flow."""
    db_flow = Job.from_orm(flow)
    db_flow.createdAt = datetime.datetime.now()
    db_flow.updatedAt = datetime.datetime.now()
    session.add(db_flow)
    session.commit()
    session.refresh(db_flow)
    return db_flow


@router.post("/process_next_job", response_model=ExecutionLogRead, status_code=201)
@router.get("/process_next_job", response_model=ExecutionLogRead, status_code=201)
async def process_flow_job(*, session: Session = Depends(get_session)):
    """Process a new flow. Find the first incomplete job"""
    try:
        job = session.exec(select(Job).filter(Job.currentTaskState!='_COMPLETE').limit(1)).one()
        if job:
            log = await process_job(job,session)
            return log
        raise HTTPException(status_code=404, detail="Job not found")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e)) from e



@router.get("/", response_model=list[JobRead], status_code=200)
def read_flow_jobs(*, session: Session = Depends(get_session)):
    """Read all flows."""
    try:
        flows = session.exec(select(Job)).all()
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e)) from e
    return [jsonable_encoder(flow) for flow in flows]


@router.get("/{job_id}", response_model=JobRead, status_code=200)
def read_flow_job(*, session: Session = Depends(get_session), job_id):
    """Read a flow."""
    if flow := session.get(Job, job_id):
        return flow
    else:
        raise HTTPException(status_code=404, detail="Job not found")


@router.patch("/{job_id}", response_model=JobRead, status_code=200)
def update_flow_job(
    *, session: Session = Depends(get_session), job_id, flow: JobUpdate
):
    """Update a flow."""

    db_flow = session.get(Job, job_id)
    if not db_flow:
        raise HTTPException(status_code=404, detail="Job not found")
    flow_data = flow.dict(exclude_unset=True)

    for key, value in flow_data.items():
        setattr(db_flow, key, value)
    db_flow.updatedAt = datetime.datetime.now()
    session.add(db_flow)
    session.commit()
    session.refresh(db_flow)
    return db_flow


@router.delete("/{job_id}", status_code=200)
def delete_flow_job(*, session: Session = Depends(get_session), job_id):
    """Delete a flow."""
    flow = session.get(Job, job_id)
    if not flow:
        raise HTTPException(status_code=404, detail="Job not found")
    session.delete(flow)
    session.commit()
    return {"message": "Job deleted successfully"}


# Define a new model to handle multiple flows


@router.post("/batch/", response_model=List[JobRead], status_code=201)
def create_flow_jobs(*, session: Session = Depends(get_session), flow_list: List[JobCreate]):
    """Create multiple new flows."""
    db_flows = []
    for flow in flow_list:
        db_flow = Job.from_orm(flow)
        session.add(db_flow)
        db_flows.append(db_flow)
    session.commit()
    for db_flow in db_flows:
        session.refresh(db_flow)
    return db_flows


@router.post("/upload/", response_model=List[JobRead], status_code=201)
async def upload_file(
    *, session: Session = Depends(get_session), file: UploadFile = File(...)
):
    """Upload flows from a file."""
    contents = await file.read()
    data = json.loads(contents)
    flows=[JobCreate(**flow) for flow in data]
    return create_flow_jobs(session=session, flow_list=flows)


@router.get("/download/", response_model=List[JobRead], status_code=200)
async def download_file(*, session: Session = Depends(get_session)):
    """Download all flows as a file."""
    flows = read_flow_jobs(session=session)
    return flows


async def process_job(job: Job, session: Session):
    obj = json.loads(job.data)
    runId = job.runId
    workflow = session.exec(select(WorkFlow).filter(WorkFlow.uuid==job.workflowId)).one()
    workflow = workflow.data

    log = ""

    start_time = datetime.datetime.now()
    if job.currentTaskState=='_CREATED':
        job.currentTaskState = '1'

    flow_it = filter(lambda x: x['id'] == job.currentTaskState,workflow)
    node_list = list(flow_it)
    if len(node_list)==0:
        raise "Error: currentTaskState is not existed in workflow!"

    n = dict_to_object(node_list[0])

    log += f"[*] CURRENT STATE: {n.id}: {n.data.label}\n"
    next_state = 0

    output_object = obj
    output_port = 0

    if n.type == "output":
        next_state = "_COMPLETE"
        log += "Complete.\n"


    # Step 1: Execute Logic
    elif hasattr(n.data,'code') and n.data.code:
        template_code = n.data.code
        code_globals = n.data
        code_globals.obj = obj
        final_code = render(template_code, code_globals)
        log += f"final output code:\n{final_code}\n"
        try:
            output = eval(final_code)
            if output is not None and isinstance(output,object):
                output_object = output.obj
                output_port = output.outputPort
            if output is not None and isinstance(output,dict):
                output_object = output['obj']
                output_port = output['outputPort']
        except Exception as e:
            log += "Error: eval code is occur in workflow! "+str(e)+'\n'

    if n.type != "output":
        log += f"output port: {output_port}\n"

        # Step 2: Set the desired output port
        if hasattr(n,"out"):
            if len(n.out) == 1:
                next_state = n.out[0]
            else:
                next_state = n.out[output_port]
        log += f"->NEXT STATE: {next_state}\n"

    job.currentTaskState = next_state
    job.data = json.dumps(output_object,indent=2,ensure_ascii=False)

    session.add(job)

    end_time = datetime.datetime.now()
    time_diff = (end_time - start_time).total_seconds() * 1000

    run_log = session.query(RunLog).filter(RunLog.runId==runId).one_or_none()
    if not run_log:
        run_log = RunLog()
        run_log.runId = runId
        run_log.workflowId = job.workflowId
        run_log.createdAt = datetime.datetime.now()
    run_log.updatedAt = datetime.datetime.now()
    run_log.runTime+=time_diff
    session.add(run_log)
    # Move the task to the next state
    data = json.dumps(obj,indent=2,ensure_ascii=False)
    execution_log = ExecutionLog()
    execution_log.__dict__.update({
        "tenantId": "1",
        "workflowId": job.workflowId,
        "createdAt": datetime.datetime.now(),
        "updatedAt": datetime.datetime.now(),
        "runId": runId,
        "data": data,
        "logs": log,
        "currentState": n.id,
        "nextState": next_state,
        "outputPort": output_port,
        "runTime": time_diff
    })
    session.add(execution_log)
    session.commit()
    session.refresh(job)
    return execution_log

def render(code,context):
    if hasattr(context,'as_dict'):
        vars = context.as_dict()
    else:
        vars = context.__dict__
    template_str = string.Template(code)
    ret = template_str.substitute(vars)
    try:
        return ret.format_map(vars)
    except:
        return ret