from sqlalchemy.dialects import registry

# Register the Ignite end point

registry.register("ignite.pyodbc", "ohflow.interface.db.ignite_odbc_dialect", "IgniteDialect_pyodbc")
registry.register("ignite", "ohflow.interface.db.ignite_dialect", "IgniteDialect_pyignite")
registry.register("ignite.thin", "ohflow.interface.db.ignite_dialect", "IgniteDialect_pyignite")