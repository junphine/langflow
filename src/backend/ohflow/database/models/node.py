# Path: src/backend/langflow/database/models/flow.py

from pydantic import BaseModel, Field, validator
from sqlmodel import Field, Relationship, JSON, Column, SQLModel
from uuid import UUID, uuid4
from typing import Dict, Optional, List
from datetime import datetime
import sqlalchemy as sa


class NodeBase(SQLModel):
    name: str = Field(index=True)
    description: Optional[str] = Field(index=False)
    code: Optional[str] = Field(index=False)
    css: Optional[str] = Field(index=False)
    outputNodes: Optional[List] = Field(default=None)
    editableFields: Optional[List] = Field(default=None)
    @validator('outputNodes','editableFields')
    def validate_json(v):
        # dict_keys(['description', 'name', 'id', 'data'])
        if not v:
            return v
        if not isinstance(v, list):
            raise ValueError("outputNodes/editableFields must be a valid List JSON")

        return v


class Node(NodeBase, table=True):
    __tablename__ = 'Nodes'
    tenantId: str = Field(index=True,default='1')
    id: Optional[int] = Field(primary_key=True, unique=True)
    uuid: Optional[str] = Field(default_factory=uuid4, unique=True)
    outputNodes: Optional[List] = Field(default=None, sa_column=Column(JSON))
    editableFields: Optional[List] = Field(default=None, sa_column=Column(JSON))
    createdAt: Optional[datetime] = Field(sa_column=sa.Column(sa.DateTime(timezone=True), nullable=False))
    updatedAt: Optional[datetime] = Field(sa_column=sa.Column(sa.DateTime(timezone=True), nullable=False))



class NodeCreate(NodeBase):
    pass

class NodeRead(NodeBase):
    id: int
    uuid: Optional[str]

class NodeUpdate(NodeBase):
    pass

