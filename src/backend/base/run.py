import os
import sys
import asyncio
from asyncio import WindowsSelectorEventLoopPolicy

asyncio.set_event_loop_policy(WindowsSelectorEventLoopPolicy())
print(sys.argv)
import langchain_core.pydantic_v1
#os.environ['PYDANTIC_SKIP_VALIDATING_CORE_SCHEMAS'] = 'true'
#sys.argv = ['run.py', 'run', '--env-file', '.env']

from langflow.__main__ import *

if __name__ == "__main__":
    main()