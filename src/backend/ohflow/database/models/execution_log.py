# Path: src/backend/langflow/database/models/flow.py

from pydantic import BaseModel, Field, validator
from sqlmodel import Field, Relationship, JSON, Column, SQLModel
from uuid import UUID, uuid4
from typing import Dict, Optional, List
from datetime import datetime
import sqlalchemy as sa


class ExecutionLogBase(SQLModel):
    runId: str = Field(index=True)
    workflowId: Optional[str] = Field(index=True)
    currentState: Optional[str] = Field(index=False)
    nextState: Optional[str] = Field(index=False)
    outputPort: Optional[str] = Field(index=False)
    runTime: Optional[int] = Field(default=0,nullable=False)
    data: Optional[str] = Field(default=None)
    logs: Optional[str] = Field(default=None)



class ExecutionLog(ExecutionLogBase, table=True):
    __tablename__ = 'ExecutionLogs'
    tenantId: str = Field(index=True,default='1')
    id: Optional[int] = Field(primary_key=True, unique=True)

    createdAt: Optional[datetime] = Field(sa_column=sa.Column(sa.DateTime(timezone=True), nullable=False))
    updatedAt: Optional[datetime] = Field(sa_column=sa.Column(sa.DateTime(timezone=True), nullable=False))



class ExecutionLogCreate(ExecutionLogBase):
    pass

class ExecutionLogRead(ExecutionLogBase):
    id: int
    createdAt: Optional[datetime]

class ExecutionLogUpdate(ExecutionLogBase):
    pass

