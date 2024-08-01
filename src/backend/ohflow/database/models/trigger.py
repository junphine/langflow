# Path: src/backend/langflow/database/models/flow.py
from pydantic import BaseModel, Field, validator
from sqlmodel import Field, Relationship, JSON, Column, SQLModel
from uuid import UUID, uuid4
from typing import Dict, Optional, List
from datetime import datetime
import sqlalchemy as sa
metadata = sa.MetaData(schema="workflow")

class TriggerBase(SQLModel):
    name: str = Field(index=True)
    shortcode: Optional[str] = Field(index=False,unique=True)
    workflowId: Optional[str] = Field(index=True)


class Trigger(TriggerBase, table=True):
    __tablename__ = 'Triggers'
    metadata = metadata
    tenantId: str = Field(index=True,default='1')
    id: Optional[str] = Field(default_factory=uuid4, primary_key=True)
    createdAt: Optional[datetime] = Field(sa_column=sa.Column(sa.DateTime(timezone=True), nullable=False))
    updatedAt: Optional[datetime] = Field(sa_column=sa.Column(sa.DateTime(timezone=True), nullable=False))


class TriggerCreate(TriggerBase):
    pass

class TriggerRead(TriggerBase):
    id: str

class TriggerUpdate(TriggerBase):
    pass

