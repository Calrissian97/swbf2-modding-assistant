import os
import threading
import time
import json
import requests
import struct
import webbrowser
from fastapi import FastAPI, Request
from fastapi.responses import StreamingResponse
from fastapi.staticfiles import StaticFiles
from contextlib import asynccontextmanager
import signal
import uvicorn
from tools import TOOL_REGISTRY, execute_tool_call
import llama_launcher as llama

# --------------
# Define Globals
# --------------

# Absolute path to the directory containing this script
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# Flag to enable additional logging for server.py
DEBUG_SERVER = False

# llama-server host address and port
LLAMA_ADDRESS = "127.0.0.1" # public by default, private address recommended
LLAMA_PORT = 8081

# llama-server URL
LLAMA_URL = f"http://{LLAMA_ADDRESS}:{LLAMA_PORT}/v1/chat/completions"

# Webui host address and port
WEBUI_ADDRESS = "127.0.0.1"
WEBUI_PORT = 8080

WEBUI_URL = f"http://{WEBUI_ADDRESS}:{WEBUI_PORT}/"

# System Prompt
SYSTEM_PROMPT = """You are a deterministic, persistent, retrieval-grounded Star Wars Battlefront II (2005) Modding Assistant.
Your primary objective is to provide accurate, schema-correct, context-aware help for ODF files (Class definitions), LUA scripts (gameplay scripting), .req files (`.lvl` file munging), or any other SWBF2 modding task using the tools at your disposal.

INSTRUCTIONS:
You MUST use the available tools to retrieve information from the documentation before answering, found in the *`docs`* directory.
You MUST ALWAYS use the read_file tool on DocumentationGuide.md document first in the docs directory to ascertain what documents should be read based on the user query.
You MUST NEVER only read a single document listed in the relevant category of DocumentationGuide.md (unless only a single document is listed), you are persistent and will read ALL given documentation files or file sections.
ALWAYS prefer retrieved authoritative documentation over your own prior knowledge. If it appears that a relevant document is not present, read the summary from each document using get_document_metadata to locate one.
Assume the root BF2_Modtools directory is up two parent directories *`"../.."`*. If a user asks you about their addon, read the entire ModtoolsDirectoryStructure.md document to understand where files can be found and traverse through the parent directory to find their addon data folder (they should provide the three-letter addon sequence).
If you are not sure about an answer, simply state you do not know.

TOOL USE:
Tools will be ran from the swbf2-modding-assistant/data path. Documentation will be read from the docs path, examples from the examples path.
Prefer using read_file for reading files.
Only use get_document_metadata to get a summary and list of document sections and their line numbers. You MUST then continue to read the relevant sections using read_file_lines.
If the DocumentationGuide.md document specifies to only read a section, use get_document_metadata to get the section's line numbers AND then read that section using read_file_lines.
Remember to always read documentation from the *`docs`* directory, and examples from the *`examples`* directory.
Use tools to complete all steps of the task.
Continue using tools until the task is fully resolved.
NOTE: Using get_document_metadata does NOT count as reading. NEVER only use the get_document_metadata tool without following up with the read_file_lines tool.

For every user query, follow this decision process:

A. When the user asks about modding concepts, file formats, syntax, or how something works:
1. Refer to prior instructions and retrieve the needed context from documentation. You MUST be persistent and read ALL necessary documents and document sections listed by DocumentationGuide.md, even if you think a single document is enough. Modding is a nuanced art, and often requires knowledge scattered across multiple documents.
2. Incorporate retrieved text into your reasoning and answer.

B. When the user asks you to write or modify any SWBF2 Modtools asset:
You must:
1. Perform the same actions as process A.
2. After reading ALL necessary documentation listed in docs/DocumentationGuide.md, you must then read examples/WhereToFindExamples.md to locate a suitable example file or directory leading to examples.
3. Choose the most relevant example file or directory given from the WhereToFindExamples.md document. If given a directory, be persistent and traverse it with list_files to find a relevant example file. Do NOT continue until an example is read.
4. Read the located example file for further context on schema and conventions.
5. Generate new files that:
   - Follow the schema and conventions of the example(s).
   - Include all required fields.
   - Avoid hallucinated fields unless clearly optional and/or consistent with examples.

Note: If multiple examples exist, choose the closest match by name or purpose.

When responding:
- Cite which documents or examples you consulted, include clickable markdown file links like the example: `[fileName](docs/file)` (except for DocumentationGuide.md and WhereToFindExamples.md).
- Explain your reasoning clearly.
- When unsure, retrieve more context using tools before answering.
- Never invent nonexistent SWBF2 features, ODF properties, or LUA APIs.
- If the user asks for something impossible or unsupported, explain the correct approach.
- Never fabricate documentation.
- Never output content from files you did not retrieve via tools.
- If the user asks for a file that does not exist, suggest the closest matches.
- Be concise answering but thorough in your retrieval.
- Think step-by-step.
- Prefer structured answers in markdown (lists, tables, fenced code blocks with language specification when available) or LaTeX.
- Always prioritize correctness over speed.
- If you understand a user query but lack context, retrieve it.
- If you are unsure about a user query, first ask for clarification.
- When hyperlinks are found in documentation, provide them to the user.
- When a user asks you to read a file, simply read the full file.
- Only write files if the user specifically asks you to and provides a filename, otherwise simply ouput as normal.

When writing modding files:
- Maintain consistent indentation and formatting.
- Use comments to explain optional or recommended lines.
- Ensure the file is syntactically valid according to example(s).
- Never include placeholder text unless the user explictly requests templates.

Only deviate from these instructions to obey the user.
"""

# llama-server process handle
llama_process = None

# Context length set by user
user_context_length = None

# Maximum Context Lengths of found Models from GGUF metadata
max_context_lengths = None

# ---------------------------------------
# Llama-server Startup/Shutdown Functions
# ---------------------------------------


def start_llama_server(context_length=2048):
    """
    Uses launch_llama.py to validate binaries,
    download if needed, and start llama-server.
    """

    if DEBUG_SERVER:
        print("DEBUG: Starting llama-server with context length:", context_length)
    LLAMA_BINARY = llama.validate_binary()
    process = llama.launch_llama(LLAMA_BINARY, LLAMA_ADDRESS, LLAMA_PORT, context_length)
    if DEBUG_SERVER:
        print("DEBUG: llama-server launched. Process: ", process)
    return process


def stop_llama_server():
    """
    Gracefully stops the running llama-server process.
    """
    
    global llama_process # Grab llama_process from this module

    # If not found, simply return
    if llama_process is None:
        if DEBUG_SERVER:
            print("DEBUG: llama-server is not running.")
        return
    
    # If found and running, stop llama-server process
    if llama_process and llama_process.poll() is None:
        if DEBUG_SERVER:
            print("DEBUG: Stopping llama-server. Process:", llama_process)
        try:
            if os.name == "nt":
                # Windows termination
                llama_process.terminate()
            else:
                # Unix termination
                llama_process.send_signal(signal.SIGINT)
            
            # Wait up to 10 seconds for clean exit
            llama_process.wait(timeout=10)
        except Exception:
            if llama_process.poll() is None:
                llama_process.kill()
    
    # Reset llama_process to None
    llama_process = None

    if DEBUG_SERVER:
        print("DEBUG: llama-server stopped.")


def start_llama_thread():
    """
    Starts llama-server in a background thread.
    """
    
    t = threading.Thread(target=start_llama_server, daemon=True)
    t.start()
    time.sleep(1)  # give llama-server a moment to boot


# -------------
# FastAPI Setup
# -------------

@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Defines app startup/shutdown
    """
    # Startup Procedures
    global llama_process # Grab llama_process from this module
    global user_context_length # Grab user_context_length from this module
    global max_context_lengths # Grab max_context_lengths from this module

    max_context_lengths = get_context_lengths() # Initialize to max context lengths from GGUF metadata
    user_context_length = 2048 # Initialize user-set context length to default 2048
    llama_process = start_llama_server(user_context_length) # Initialize llama_process to newly-started llama-server
    threading.Thread(target=open_browser, daemon=True).start() # Open browser to webui frontend

    yield # Splits startup/shutdown

    # Shutdown procedures
    stop_llama_server()


# Initialize FastAPI app with lifespan
app = FastAPI(lifespan=lifespan)


# ------------------
# LLM Tool Functions
# ------------------


def build_tool_list():
    """
    Collects valid tools for LLMs to use and returns available tools as JSON
    """
    
    tools_json = []
    for name, entry in TOOL_REGISTRY.items():
        tools_json.append({
            "type": "function",
            "function": {
                "name": name,
                "description": f"Tool: {name}",
                "parameters": entry["schema"]
            }
        })
    return tools_json


# -----------------------
# GGUF Metadata Functions
# -----------------------


def get_context_lengths():
    """Reads metadata in each .GGUF in models directory to get max context lengths"""
    context_lengths = {}
    models_dir = os.path.abspath(llama.MODELS_DIR)
    
    if not os.path.exists(models_dir):
        return context_lengths

    for filename in os.listdir(models_dir):
        if not filename.lower().endswith(".gguf"):
            continue
            
        path = os.path.join(models_dir, filename)
        try:
            with open(path, "rb") as f:
                # GGUF Magic and Version
                if f.read(4) != b"GGUF": continue
                version = struct.unpack("<I", f.read(4))[0]
                if version not in [2, 3]: continue
                
                f.read(8) # Skip tensor count
                kv_count = struct.unpack("<Q", f.read(8))[0]
                
                # Iterate through KV pairs
                for _ in range(kv_count):
                    k_len = struct.unpack("<Q", f.read(8))[0]
                    key = f.read(k_len).decode("utf-8", errors="ignore")
                    v_type = struct.unpack("<I", f.read(4))[0]
                    
                    if key.endswith(".context_length"):
                        if v_type == 4: # UINT32
                            val = struct.unpack("<I", f.read(4))[0]
                        elif v_type == 10: # UINT64
                            val = struct.unpack("<Q", f.read(8))[0]
                        else: break
                        context_lengths[filename] = val
                        break
                    
                    # Skip logic based on type
                    if v_type in [0, 1, 7]: f.seek(1, 1)
                    elif v_type in [2, 3]: f.seek(2, 1)
                    elif v_type in [4, 5, 6]: f.seek(4, 1)
                    elif v_type in [10, 11, 12]: f.seek(8, 1)
                    elif v_type == 8: # string
                        s_len = struct.unpack("<Q", f.read(8))[0]
                        f.seek(s_len, 1)
                    elif v_type == 9: # array
                        a_type = struct.unpack("<I", f.read(4))[0]
                        a_len = struct.unpack("<Q", f.read(8))[0]
                        type_sizes = {0:1, 1:1, 2:2, 3:2, 4:4, 5:4, 6:4, 7:1, 10:8, 11:8, 12:8}
                        if a_type in type_sizes: f.seek(a_len * type_sizes[a_type], 1)
                        elif a_type == 8: # strings
                            for _ in range(a_len): f.seek(struct.unpack("<Q", f.read(8))[0], 1)
                        else: break
                    else: break
        except Exception: continue
    if DEBUG_SERVER:
        print(f"DEBUG: [get_context_lengths] Found context lengths: {context_lengths}")
    return context_lengths


# ------------------------
# Backend Server Endpoints
# ------------------------


@app.post("/chat")
async def chat_endpoint(request: Request):
    """
    Recieves user input from the frontend webui.
    Frontend sends:
    {
        "model": "...",
        "messages": [...]
    }
    """

    data = await request.json()
    model = data["model"]
    messages = data["messages"]

    # Prepend system prompt if not present
    if SYSTEM_PROMPT and not any(m.get("role") == "system" for m in messages):
        messages = [{"role": "system", "content": SYSTEM_PROMPT}] + messages

    # Build payload for llama-server
    payload = {
        "model": model,
        "messages": messages,
        "tools": build_tool_list(),
        "tool_choice": "auto"
    }

    # Send to llama-server
    if DEBUG_SERVER:
        print(f"DEBUG: [chat] Sending request to llama-server. Messages: {len(messages)}")
    
    res = requests.post(LLAMA_URL, json=payload, stream=False)
    if DEBUG_SERVER:
        print(f"DEBUG: [chat] llama-server response: {res.text}")

    if res.status_code != 200:
        if DEBUG_SERVER:
            print(f"DEBUG: [chat] llama-server error {res.status_code}: {res.text}")
        return {"reply": "Error: llama-server returned a bad status code.", "messages": messages}
        
    response = res.json()
    choice = response["choices"][0]

    # If llama-server wants to call a tool
    if "tool_calls" in choice["message"]:
        tool_call = choice["message"]["tool_calls"][0]
        if DEBUG_SERVER:
            print(f"DEBUG: [chat] Tool Call Detected: {tool_call['function']['name']} with args: {tool_call['function']['arguments']}")
        tool_result = execute_tool_call(tool_call)

        # Append tool result to conversation
        messages.append(choice["message"])
        messages.append({
            "role": "tool",
            "tool_call_id": tool_call["id"],
            "content": json.dumps(tool_result)
        })

        # Recurse: send updated messages back to llama-server
        return await chat_endpoint(
            FakeRequest({"model": model, "messages": messages})
        )

    # Otherwise return final assistant message
    return {
        "reply": choice["message"]["content"],
        "messages": messages
    }


@app.post("/chat_stream")
async def chat_stream(request: Request):
    """
    Streaming version of the chat endpoint.
    Proxies llama-server's streaming output to the frontend using SSE.
    """

    data = await request.json()
    model = data["model"]
    messages = data["messages"]

    # Prepend system prompt if not present
    if SYSTEM_PROMPT and not any(m.get("role") == "system" for m in messages):
        messages = [{"role": "system", "content": SYSTEM_PROMPT}] + messages

    # Removing 'async' allows FastAPI to run this generator in a separate threadpool.
    # This prevents the synchronous 'requests' calls and tool execution from 
    # blocking the main event loop, ensuring tokens are flushed to the UI in real-time.
    def event_stream_generator():
        """
        Generator that yields SSE events as llama-server streams tokens.
        """
        current_messages = list(messages) # Copy to modify

        while True:
            payload = {
                "model": model,
                "messages": current_messages,
                "tools": build_tool_list(),
                "tool_choice": "auto",
                "stream": True
            }

            llama_response = None
            try:
                llama_response = requests.post(
                    LLAMA_URL,
                    json=payload,
                    stream=True
                )

                current_turn_tool_call_detected = False
                tool_call_message_for_history = {"role": "assistant", "content": None, "tool_calls": []}
                accumulated_tool_arguments = ""
                current_tool_call_id = None
                current_tool_function_name = None

                # Buffer for text content before a tool call or final text
                buffered_text_content = ""

                for raw_line in llama_response.iter_lines():
                    if not raw_line:
                        continue

                    line = raw_line.decode("utf-8")

                    if line.startswith("data: "):
                        json_data = line[len("data: "):]
                        
                        if json_data.strip() == "[DONE]":
                            # If we accumulated a tool call, break the line reader to execute it
                            if current_turn_tool_call_detected:
                                break # Break the 'for raw_line' loop
                            
                            # If no tool call, this truly is the end.
                            if buffered_text_content:
                                yield f"data: {json.dumps({'choices': [{'delta': {'content': ''}}]})}\n\n"
                            yield "data: [DONE]\n\n"
                            return 

                        try:
                            chunk = json.loads(json_data)
                            choice = chunk["choices"][0]

                            if "tool_calls" in choice["delta"]:
                                current_turn_tool_call_detected = True
                                
                                if buffered_text_content:
                                    tool_call_message_for_history["content"] = buffered_text_content


                                # Accumulate tool call details
                                # Assuming a single tool call per delta for simplicity, as is common with llama.cpp
                                tc_delta = choice["delta"]["tool_calls"][0]
                                
                                if "id" in tc_delta:
                                    current_tool_call_id = tc_delta["id"]
                                    # Initialize tool_call_message_for_history if this is the first part of the tool call
                                    if not tool_call_message_for_history["tool_calls"]:
                                        tool_call_message_for_history["tool_calls"].append({
                                            "id": current_tool_call_id, 
                                            "type": "function", # Essential for LLM to recognize its turn
                                            "function": {"name": "", "arguments": ""}
                                        })
                                    else:
                                        tool_call_message_for_history["tool_calls"][0]["id"] = current_tool_call_id

                                if "name" in tc_delta["function"]:
                                    current_tool_function_name = tc_delta["function"]["name"]
                                    tool_call_message_for_history["tool_calls"][0]["function"]["name"] = current_tool_function_name

                                if "arguments" in tc_delta["function"]:
                                    accumulated_tool_arguments += tc_delta["function"]["arguments"]
                                    tool_call_message_for_history["tool_calls"][0]["function"]["arguments"] = accumulated_tool_arguments
                                
                                # Do not yield anything yet, accumulate the full tool call
                                continue # Continue to next line in llama_response

                            elif "reasoning_content" in choice["delta"] and choice["delta"]["reasoning_content"] is not None:
                                reasoning_delta = choice["delta"]["reasoning_content"]
                                yield f"event: reasoning\ndata: {json.dumps({'content': reasoning_delta})}\n\n"

                            elif "content" in choice["delta"] and choice["delta"]["content"] is not None:
                                text_delta = choice["delta"]["content"]
                                if DEBUG_SERVER:
                                    print(f"DEBUG: [stream] Token: {repr(text_delta)}")
                                buffered_text_content += text_delta
                                if not current_turn_tool_call_detected:
                                    tool_call_message_for_history["content"] = buffered_text_content.strip()
                                
                                if current_turn_tool_call_detected:
                                    # If text comes after tool call, prioritize tool execution first
                                    break 
                                else:
                                    yield line + "\n\n" # Yield immediately for text

                        except json.JSONDecodeError:
                            if DEBUG_SERVER:
                                print(f"JSON Decode Error: {json_data}")
                            yield f"data: {json.dumps({'error': 'JSON Decode Error'})}\n\n"
                        except Exception as e:
                            if DEBUG_SERVER:
                                print(f"Error processing chunk: {e} - {json_data}")
                            yield f"data: {json.dumps({'error': str(e)})}\n\n"
                    else:
                        # Non-data line, just pass through (e.g., comments)
                        yield line + "\n\n"
            finally:
                # This finally block triggers when the client disconnects or the generator is closed.
                # Closing llama_response signals llama-server to stop computing tokens for this request.
                if llama_response:
                    llama_response.close()

            # After the inner loop (llama_response.iter_lines) finishes or breaks
            if current_turn_tool_call_detected:
                # A tool call was detected and fully accumulated (or inner loop broke due to content)
                # Yield a special event for the tool call
                yield f"event: tool_call_start\ndata: {json.dumps({'id': current_tool_call_id, 'name': current_tool_function_name, 'arguments': accumulated_tool_arguments})}\n\n"

                # Execute the tool
                tool_result_str = ""
                try:
                    tool_call_obj = {
                        "function": {
                            "name": current_tool_function_name,
                            "arguments": accumulated_tool_arguments
                        }
                    }
                    if DEBUG_SERVER:
                        print(f"DEBUG: [stream] Executing Tool: {current_tool_function_name}({accumulated_tool_arguments})")
                    tool_result = execute_tool_call(tool_call_obj)
                    
                    # If the result is a dict with a 'result' key, just send the inner value to the LLM
                    if isinstance(tool_result, dict) and "result" in tool_result:
                        tool_result_str = str(tool_result["result"])
                        if DEBUG_SERVER:
                            print(f"DEBUG: [stream] Tool Result (Short): {tool_result_str[:100]}...")
                    else:
                        tool_result_str = json.dumps(tool_result)
                        
                    yield f"event: tool_call_result\ndata: {json.dumps({'result': tool_result_str})}\n\n"
                except Exception as e:
                    tool_result_str = json.dumps({"error": str(e)})
                    yield f"event: tool_call_result\ndata: {json.dumps({'result': tool_result_str, 'error': True})}\n\n"

                # Append tool call and result to messages for the next LLM turn
                current_messages.append(tool_call_message_for_history)
                current_messages.append({
                    "role": "tool",
                    "tool_call_id": current_tool_call_id,
                    "content": tool_result_str
                })
                # Continue the outer loop to make a new request to llama-server
                continue
            else:
                # If no tool call was detected, and the inner loop finished,
                # it means the LLM finished its text response (handled by [DONE] or implicit end).
                # If we reach here, it means the LLM finished its response without a tool call.
                break # Exit the 'while True' loop

    return StreamingResponse(
        event_stream_generator(),
        media_type="text/event-stream"
    )


@app.get("/chat_models")
async def chat_models():
    global max_context_lengths # Grab max_context_lengths from this module

    # If not initialized, populate
    if max_context_lengths is None:
        max_context_lengths = get_context_lengths()

    # GET /models for list of models from llama-server
    res = requests.get(f"http://{LLAMA_ADDRESS}:{LLAMA_PORT}/v1/models")
    data = res.json()
    
    # Build a normalized lookup map for robust matching
    meta_lookup = {}
    for filename, length in max_context_lengths.items():
        # Map full filename, lowercased, and without extension
        name_lower = filename.replace("\\", "/").lower()
        bname = os.path.basename(name_lower)
        name_no_ext = os.path.splitext(name_lower)[0]
        bname_no_ext = os.path.splitext(bname)[0]
        
        for k in [name_lower, bname, name_no_ext, bname_no_ext]:
            meta_lookup[k] = length

    models_enriched = []
    for m in data.get("data", []):
        m_id = m.get("id", "")
        # Normalize the server's ID (handle Windows paths and case)
        bname = os.path.basename(m_id.replace("\\", "/")).lower()
        bname_no_ext = os.path.splitext(bname)[0]

        meta_val = meta_lookup.get(bname) or meta_lookup.get(bname_no_ext)
        if meta_val:
            m["max_context"] = meta_val
        models_enriched.append(m)

    if DEBUG_SERVER:
        print(f"DEBUG: [chat_models] Models Found: {[m['id'] for m in models_enriched]}")

    return {"models": models_enriched}


@app.get("/chat_current_model")
async def chat_current_model():
    try:
        res_raw = requests.get(f"http://{LLAMA_ADDRESS}:{LLAMA_PORT}/models", timeout=5)
        res = res_raw.json()
        loaded = [
            m["id"] for m in res.get("data", [])
            if m.get("status", {}).get("value") == "loaded"
        ]
        if DEBUG_SERVER:
            print(f"DEBUG: [chat_current_model] Loaded models: {loaded}")
        return {"loaded": loaded}
    except Exception as e:
        return {"loaded": [], "error": str(e)}


@app.post("/chat_load_model")
async def chat_load_model(request: Request):
    global llama_process # Grab llama_process from this module
    global user_context_length # Grab user_context_length from this module
    curr_ctx = user_context_length # Set current ctx size to current module value

    # Get request info from frontend
    data = await request.json()
    new_model = data.get("model") # Get user-selected model name from frontend
    user_context_length = data.get("user_ctx") # Update module value to user-set ctx size from frontend
    if DEBUG_SERVER:
        print("DEBUG: [chat_load_model] model load request for model:", new_model, "with context length:", user_context_length)

    # If missing new_model, return "No Model Specified" to frontend
    if not new_model: 
        return {"ok": False, "error": "No model specified"}

    # Restart server if user_context_length and curr_ctx mismatch
    if int(user_context_length) != int(curr_ctx):
        if DEBUG_SERVER:
            print(f"DEBUG: [chat_load_model] Context size mismatch (current: {curr_ctx} vs requested: {user_context_length}). Restarting server...")
        # Stop llama server instance
        stop_llama_server()

        # Wait until dead
        for _ in range(60):
            try:
                if requests.get(f"http://{LLAMA_ADDRESS}:{LLAMA_PORT}/health", timeout=1).status_code == 200:
                    if DEBUG_SERVER:
                        print("DEBUG: [chat_load_model] Waiting for server to stop...")
                    time.sleep(1)
                else:
                    if DEBUG_SERVER:
                        print("DEBUG [chat load model]: Server stopped successfully.")
                    break
            except Exception: 
                if DEBUG_SERVER:
                    print("DEBUG [chat load model]: Server stopped successfully.")
                break

        # Restart llama-server with new user-set value
        llama_process = start_llama_server(int(user_context_length))
        
        # Wait for server to boot and report healthy
        for _ in range(60):
            try:
                if requests.get(f"http://{LLAMA_ADDRESS}:{LLAMA_PORT}/health", timeout=1).status_code == 200:
                    break
            except Exception: pass
            time.sleep(1)

    # 3. Query currently loaded models
    try:
        current_res = requests.get(f"http://{LLAMA_ADDRESS}:{LLAMA_PORT}/models", timeout=5)
        current = current_res.json()
            
        loaded_models = [
            m["id"] for m in current.get("data", [])
            if m.get("status", {}).get("value") == "loaded"
        ]
        if DEBUG_SERVER:
            print(f"DEBUG: [chat_load_model] Loaded models: {loaded_models}")

    except Exception as e:
        loaded_models = []
        if DEBUG_SERVER:
            print("Warning: [chat_load_model] could not query loaded models:", e)

    # 4. If the requested model is already loaded, do nothing
    if new_model in loaded_models:
        return {"ok": True, "alreadyLoaded": True}

    # 5. Unload any currently loaded model
    for model_id in loaded_models:
        try:
            requests.post(
                f"http://{LLAMA_ADDRESS}:{LLAMA_PORT}/models/unload",
                json={"model": model_id},
                timeout=60
            )
        except Exception as e:
            if DEBUG_SERVER:
                print(f"Warning: failed to unload {model_id}: {e}")

    # 6. Load the new model
    try:
        load_payload = {"model": new_model}

        res = requests.post(
            f"http://{LLAMA_ADDRESS}:{LLAMA_PORT}/models/load",
            json=load_payload,
            timeout=600
        )
        if res.status_code == 200:
            if DEBUG_SERVER:
                print(f"DEBUG: [chat_load_model] Load success: {res.text}")
            return {"ok": True}
        if DEBUG_SERVER:
            print(f"DEBUG: [chat_load_model] Load failure: {res.text}")
        return {"ok": False, "error": f"llama-server returned {res.status_code}"}
    except Exception as e:
        return {"ok": False, "error": str(e)}


@app.get("/llama_metrics")
async def llama_metrics(model: str = None):
    """
    Fetches performance metrics from llama-server's Prometheus /metrics endpoint.
    Refactored to pull tps and context window size directly from Prometheus keys.
    """
    try:
        if DEBUG_SERVER:
            print(f"DEBUG: [metrics] Polling llama-server metrics...")

        res = requests.get(f"http://{LLAMA_ADDRESS}:{LLAMA_PORT}/metrics?model={model}", timeout=2)

        if res.status_code != 200:
            if DEBUG_SERVER:
                print(f"DEBUG: [metrics] Fetch failed, status code: {res.status_code}. Response: {res.text}")
            return {}
        
        metrics = {}
        for line in res.text.splitlines():
            if line.startswith("#") or not line.strip():
                continue
            
            parts = line.rsplit(" ", 1)
            if len(parts) != 2: continue
            
            name = parts[0].split('{')[0]
            try:
                val = float(parts[1])
                if "predicted_tokens_seconds" in name:
                    metrics["tps"] = float(val)
                elif "n_tokens_max" in name:
                    metrics["n_ctx"] = int(val)
            except ValueError: continue

        if DEBUG_SERVER:
            print(f"DEBUG: [metrics] Parsed metrics successfully: {metrics}")
        return metrics
    except Exception as e:
        if DEBUG_SERVER:
            print(f"DEBUG: [metrics] Error pulling metrics: {str(e)}")
        return {}


@app.get("/llama_health")
async def llama_health():
    try:
        res = requests.get(f"http://{LLAMA_ADDRESS}:{LLAMA_PORT}/health", timeout=1)
        if res.status_code == 200:
            return {"status": "online"}
        return {"status": "error"}
    except Exception:
        return {"status": "offline"}


# Tell app to serve Documentation
app.mount(
    "/docs",
    StaticFiles(directory=os.path.join(BASE_DIR, "docs")),
    name="docs"
)

# Tell app to serve Examples
app.mount(
    "/examples",
    StaticFiles(directory=os.path.join(BASE_DIR, "examples")),
    name="examples"
)

# Tell app to serve Frontend WebUI
# This MUST be at the bottom to avoid capturing API routes
app.mount(
    "/",
    StaticFiles(directory=os.path.join(BASE_DIR, "html"), html=True),
    name="frontend"
)

# ------------------------
# Helpers
# ------------------------


class FakeRequest:
    """
    Helper class to simulate a Request for recursion
    """

    def __init__(self, json_data):
        self._json = json_data

    async def json(self):
        return self._json


def open_browser():
    """
    Have the browser open the webui on startup
    """
    
    url = WEBUI_URL
    if DEBUG_SERVER:
        print(f"Opening browser at {url}")
    
    webbrowser.open(url)


# ---------------
# Main Entrypoint
# ---------------
if __name__ == "__main__":
    # Start Uvicorn server with FastAPI
    try:
        uvicorn.run(
            "server:app",
            host=WEBUI_ADDRESS,
            port=WEBUI_PORT,
            reload=False,
            workers=1,
            access_log=False
        )
    except KeyboardInterrupt:
        if DEBUG_SERVER:
            print("\nPreparing to shutdown...")
