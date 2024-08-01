# Router for base api
from fastapi import APIRouter

router_v2 = APIRouter(
    prefix="/api/v2",
)

# custom chat api
from .v2.llm_chat import router as llm_chat_router

router_v2.include_router(llm_chat_router)

# workflows:

from .v2.workflows import router as workflows_router
from .v2.nodes import router as nodes_router
from .v2.triggers import router as triggers_router
from .v2.jobs import router as jobs_router
from .v2.run_logs import router as run_logs_router
from .v2.execution_logs import router as execution_logs_router


router_v2.include_router(workflows_router)
router_v2.include_router(nodes_router)
router_v2.include_router(triggers_router)
router_v2.include_router(jobs_router)
router_v2.include_router(run_logs_router)
router_v2.include_router(execution_logs_router)






