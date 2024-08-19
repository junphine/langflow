from enum import Enum
from pathlib import Path
from typing import Any, Dict, List, Optional, Union
from uuid import UUID

from ohflow.database.models.workflow import WorkFlowCreate,WorkFlowRead

from pydantic import BaseModel, Field, field_validator


class WorkFlowListCreate(BaseModel):
    flows: List[WorkFlowCreate]


class WorkFlowListRead(BaseModel):
    flows: List[WorkFlowRead]



class InitResponse(BaseModel):
    flowId: str


class BuiltResponse(BaseModel):
    built: bool



