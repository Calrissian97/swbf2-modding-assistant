#!/bin/bash
set -e

# Move to script directory
cd "$(dirname "$0")"

# Check venv
if [ ! -d ".venv" ]; then
    echo "Virtual environment not found. Creating one..."
    python3 -m venv .venv
fi

echo "Activating virtual environment..."
source .venv/bin/activate

echo "Installing dependencies (if needed)..."
pip install -r requirements.txt

echo "Launching app..."
python server.py
