#!/usr/bin/env python3

# @raycast.schemaVersion 1
# @raycast.title uuid
# @raycast.mode inline

# @raycast.author negasus
# @raycast.authorURL https://negasus.dev
# @raycast.description Generate UUIDv4 and copy it to the clipboard

import sys
import uuid
import subprocess 

result = str(uuid.uuid4())

subprocess.run("pbcopy", universal_newlines=True, input=result)

hint = "uuid copied to the clipboard"

if sys.stdout.isatty():
    print(hint)
else:
    sys.stdout.write(hint)
