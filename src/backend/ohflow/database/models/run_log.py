# Path: src/backend/langflow/database/models/flow.py


from pydantic import BaseModel, Field, validator
from sqlmodel import Field, Relationship, JSON, Column, SQLModel
from uuid import UUID, uuid4
from typing import Dict, Optional, List
from datetime import datetime
import sqlalchemy as sa


class RunLogBase(SQLModel):
    runId: Optional[str] = Field(default_factory=uuid4, unique=True)
    workflowId: Optional[str] = Field(index=True)
    runTime: Optional[int] = Field(default=0,nullable=False)

class RunLog(RunLogBase, table=True):
    __tablename__ = 'RunLogs'
    tenantId: str = Field(index=True,default='1')
    id: Optional[int] = Field(primary_key=True, unique=True)
    createdAt: Optional[datetime] = Field(sa_column=sa.Column(sa.DateTime(timezone=True), nullable=False))
    updatedAt: Optional[datetime] = Field(sa_column=sa.Column(sa.DateTime(timezone=True), nullable=False))


class RunLogCreate(RunLogBase):
    pass

class RunLogRead(RunLogBase):
    id: int
    createdAt: Optional[datetime]

class RunLogUpdate(RunLogBase):
    pass

