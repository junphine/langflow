# Path: src/backend/langflow/database/models/flow.py
from pydantic import BaseModel, Field, validator
from sqlmodel import Field, Relationship, JSON, Column, SQLModel
from uuid import UUID, uuid4
from typing import Dict, Optional, List
from datetime import datetime
import sqlalchemy as sa

metadata = sa.MetaData(schema="workflow")

class JobBase(SQLModel):
    runId: Optional[str] = Field(default_factory=uuid4, unique=True)
    workflowId: Optional[str] = Field(index=True)
    currentTaskState: Optional[str] = Field(index=False)
    data: Optional[str] = Field(default=None)

class Job(JobBase, table=True):
    __tablename__ = 'Jobs'
    metadata = metadata
    tenantId: str = Field(index=True,default='1')
    id: Optional[int] = Field(primary_key=True, default=None, unique=True)
    createdAt: Optional[datetime] = Field(sa_column=sa.Column(sa.DateTime(timezone=True), nullable=False))
    updatedAt: Optional[datetime] = Field(sa_column=sa.Column(sa.DateTime(timezone=True), nullable=False))


class JobCreate(JobBase):
    pass

class JobRead(JobBase):
    id: int

class JobUpdate(JobBase):
    pass

