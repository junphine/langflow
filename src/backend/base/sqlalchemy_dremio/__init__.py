__version__ = '3.0.2'

from .db import Connection, connect
from sqlalchemy.dialects import registry

# Register the Flight end point
registry.register("dremio", "sqlalchemy_dremio.base", "DremioDialect")
registry.register("dremio.pyodbc", "sqlalchemy_dremio.base", "DremioDialect")
registry.register("dremio+flight", "sqlalchemy_dremio.flight", "DremioDialect_flight")
registry.register("dremio.flight", "sqlalchemy_dremio.flight", "DremioDialect_flight")
