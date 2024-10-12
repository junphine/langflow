import sys
print(sys.argv)

#sys.argv = ['run.py', 'run', '--env-file', '.env']

from langflow.__main__ import *


if __name__ == "__main__":
    main()