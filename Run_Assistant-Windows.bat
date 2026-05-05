@echo off
cd /d "%~dp0"

REM Create virtual environment
if not exist .venv (
    echo Creating virtual environment...
    python -m venv .venv
)

REM Activate virtual environment
echo Activating virtual environment...
call .venv\Scripts\activate

REM Install dependencies
echo Installing dependencies...
pip install -r requirements.txt

REM Run server
echo Starting swbf2-modding-assistant
cd data
python server.py

REM OLD METHOD BELOW
REM uvicorn server:app --host 127.0.0.1 --port 8080 --workers 1
REM Note: host and port must be changed in server.py as well!