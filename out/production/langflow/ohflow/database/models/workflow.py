# Path: src/backend/langflow/database/models/flow.py
from pydantic import BaseModel, Field, validator
from sqlmodel import Field, Relationship, JSON, Column, SQLModel
from uuid import UUID, uuid4
from typing import Dict, Optional, List
from datetime import datetime
import sqlalchemy as sa
metadata = sa.MetaData(schema="workflow")

class WorkFlowBase(SQLModel):
    name: str = Field(index=True)
    author: Optional[str] = Field(index=True)
    description: Optional[str] = Field(index=False)
    data: Optional[List] = Field(default=None)

    @validator("data")
    def validate_json(v):
        # dict_keys(['description', 'name', 'id', 'data'])
        if not v:
            return v
        if not isinstance(v, list):
            raise ValueError("WorkFlow must be a valid List JSON")

        return v


class WorkFlow(WorkFlowBase, table=True):
    __tablename__ = 'Workflows'
    metadata = metadata
    tenantId: str = Field(index=True,default='1')
    id: Optional[int] = Field(primary_key=True, default=None, unique=True)
    uuid: Optional[UUID] = Field(default_factory=uuid4, unique=True)
    data: Optional[List] = Field(default=None, sa_column=Column(JSON))
    style: Optional[str] = Field(default=None)
    createdAt: Optional[datetime] = Field(sa_column=sa.Column(sa.DateTime(timezone=True),default=None, nullable=False))
    updatedAt: Optional[datetime] = Field(sa_column=sa.Column(sa.DateTime(timezone=True),default=None, nullable=False))



class WorkFlowCreate(WorkFlowBase):
    pass


class WorkFlowRead(WorkFlowBase):
    id: int
    uuid: Optional[UUID]


class WorkFlowReadWithStyle(WorkFlowRead):
    style: Optional[str] = None


class WorkFlowUpdate(SQLModel):
    name: Optional[str] = None
    description: Optional[str] = None
    data: Optional[List] = None

