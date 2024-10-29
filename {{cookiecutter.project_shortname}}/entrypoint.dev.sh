#!/bin/bash

# Enable exit on non 0
set -euo pipefail

if [ ! -d "/workspace/.venv" ]; then
    echo "Virtual environment not found, running poetry install..."
    # Create a virtualenv at .venv in /workspace directory so we can easily see the site-packages
    poetry config virtualenvs.create true && \
    poetry config virtualenvs.in-project true && \
    poetry config virtualenvs.path "/workspace/.venv" && \
    poetry install --no-interaction --no-ansi
else
    echo "Virtual environment found at /workspace/.venv; skipping poetry install"
fi

# Activate the virtual environment
source /workspace/.venv/bin/activate

# Same thing for the node_modules
if [ ! -d "/workspace/node_modules" ]; then
    echo "Node modules not found, running yarn install..."
    yarn install
    export COREPACK_ENABLE_DOWNLOAD=1
    corepack yarn run build-dev
else
    echo "Node modules found at /workspace/node_modules; skipping yarn install"
fi

# Execute the main command passed to the container
exec "$@"
