import os
import subprocess
import re
import json

# ---------------------------
# Tools for the LLM to access
# ---------------------------


def get_document_metadata(filePath):
    """
    Reads the "table of contents" of a file by given path
    to return a list of sections and their line numbers
    """
    
    if not os.path.exists(filePath):
        raise FileNotFoundError(f"The file '{filePath}' does not exist.")
    else:
        sections = []
        summary = []
        with open(filePath, 'r', encoding='utf-8') as file:
            in_sections_block = False
            first_header_passed = False
            for line in file:
                stripped = line.strip()

                if not first_header_passed:
                    if stripped.startswith("# "):
                        first_header_passed = True
                    continue

                if stripped.startswith("Sections:"):
                    in_sections_block = True
                    continue
                
                if in_sections_block:
                    if stripped.startswith("- "):
                        match = re.search(r"-\s*(.*?)\s*\(lines\s*(\d+)\s*[-–—]\s*(\d+)\)", stripped)
                        if match:
                            name, start, end = match.groups()
                            sections.append({
                                "name": name,
                                "start_line": int(start),
                                "end_line": int(end)
                            })
                    elif stripped == "---" or (not stripped and sections):
                        # Stop parsing once we hit the separator or an empty line after finding sections
                        break
                else:
                    # Collect text between the document header and the Sections block
                    summary.append(line)

        final_summary = "".join(summary).strip()
        if not sections:
            with open(filePath, 'r', encoding='utf-8') as f:
                return {"content": f.read()}

        return {
            "summary": final_summary,
            "sections": sections
        }


def read_file_lines(filePath, start_line, end_line):
    """
    Reads and returns the given lines of a file by the given path
    """
    
    if not os.path.exists(filePath):
        raise FileNotFoundError(f"The file '{filePath}' does not exist.")
    
    lines = []
    with open(filePath, 'r', encoding='utf-8') as file:
        for i, line in enumerate(file, 1):
            if i >= start_line and i <= end_line:
                lines.append(line)
            elif i > end_line:
                break
    return "".join(lines)


def read_file(filePath):
    """
    Reads an entire file by the given path, returns contents
    """
    
    with open(filePath, 'r', encoding='utf-8') as file:
        return file.read()


def edit_file(filePath, searchStr, replaceStr):
    """
    Edits a file by the given path and given search and replace strings
    """
    
    if not os.path.exists(filePath):
        raise FileNotFoundError(f"The file '{filePath}' does not exist.")

    with open(filePath, 'r', encoding='utf-8') as file:
        content = file.read()

    if content.count(searchStr) == 0:
        raise ValueError("The search string was not found in the file. Ensure the snippet matches exactly, including indentation.")
    if content.count(searchStr) > 1:
        raise ValueError("The search string matches multiple locations. Please provide a more unique code block.")

    new_content = content.replace(searchStr, replaceStr)

    with open(filePath, 'w', encoding='utf-8') as file:
        file.write(new_content)
    return f"Successfully edited {os.path.basename(filePath)}."


def write_file(filePath, content):
    """
    Writes a non-existing file at the given path with the given content
    """
    
    # If file exists, exit and raise error
    if os.path.exists(filePath):
        raise FileExistsError(f"The file '{filePath}' already exists.")
    else:
        with open(filePath, 'w', encoding='utf-8') as file:
            file.write(content)


def list_files(directory):
    """
    Returns a list of files in a given directory
    """
    
    if not os.path.exists(directory):
        raise FileNotFoundError(f"The directory '{directory}' does not exist.")
    elif not os.path.isdir(directory):
        raise NotADirectoryError(f"The path '{directory}' is not a directory.")
    else:
        # append " (directory)" to filename if it's a folder
        items = []
        for entry in os.listdir(directory):
            full_path = os.path.join(directory, entry)
            if os.path.isdir(full_path):
                items.append(f"{entry} (directory)")
            else:
                items.append(entry)
        return items
        # return os.listdir(directory)


def run_batch_script(filePath):
    """
    Runs a batch script at the given path and returns output
    """
    
    if not os.path.exists(filePath):
        raise FileNotFoundError(f"The file '{filePath}' does not exist.")
    
    # Ensure the file has a .bat extension to prevent arbitrary execution of other file types
    if not filePath.lower().endswith(".bat"):
        raise ValueError(f"The file '{filePath}' is not a batch script (.bat).")

    try:
        # Explicitly call cmd.exe /c to execute the batch file.
        # This is safer than shell=True with just the filePath, as it treats filePath as a single argument.
        result = subprocess.run(
            ["cmd.exe", "/c", filePath],
            capture_output=True,
            text=True, # Decode stdout/stderr as text
            check=True, # Raise CalledProcessError for non-zero exit codes
            encoding='utf-8' # Ensure consistent encoding for input/output
        )
        return f"Batch script '{os.path.basename(filePath)}' executed successfully.\nOutput:\n{result.stdout}"
    except subprocess.CalledProcessError as e:
        return (f"Error executing batch script '{os.path.basename(filePath)}'.\n"
                f"Exit Code: {e.returncode}\n"
                f"Stdout: {e.stdout}\n"
                f"Stderr: {e.stderr}")
    except Exception as e:
        return f"An unexpected error occurred: {e}"


def search_in_file(filePath, pattern):
    """
    Searches for a regex pattern in a file and returns matches with line numbers
    """
    
    if not os.path.exists(filePath):
        raise FileNotFoundError(f"The file '{filePath}' does not exist.")

    matches = []
    regex = re.compile(pattern)

    with open(filePath, 'r', encoding='utf-8') as file:
        for i, line in enumerate(file, 1):
            if regex.search(line):
                matches.append({
                    "line": i,
                    "content": line.strip()
                })
    return matches


# Valid functions for LLMs to call
TOOL_REGISTRY = {
    "get_document_metadata": {
        "function": get_document_metadata,
        "schema": {
            "type": "object",
            "properties": {
                "filePath": {"type": "string"}
            },
            "required": ["filePath"]
        }
    },
    "read_file_lines": {
        "function": read_file_lines,
        "schema": {
            "type": "object",
            "properties": {
                "filePath": {"type": "string"},
                "start_line": {"type": "integer"},
                "end_line": {"type": "integer"}
            },
            "required": ["filePath", "start_line", "end_line"]
        }
    },
    "read_file": {
        "function": read_file,
        "schema": {
            "type": "object",
            "properties": {
                "filePath": {"type": "string"}
            },
            "required": ["filePath"]
        }
    },
    "edit_file": {
        "function": edit_file,
        "schema": {
            "type": "object",
            "properties": {
                "filePath": {"type": "string"},
                "searchStr": {"type": "string"},
                "replaceStr": {"type": "string"}
            },
            "required": ["filePath", "searchStr", "replaceStr"]
        }
    },
    "write_file": {
        "function": write_file,
        "schema": {
            "type": "object",
            "properties": {
                "filePath": {"type": "string"},
                "content": {"type": "string"}
            },
            "required": ["filePath", "content"]
        }
    },
    "list_files": {
        "function": list_files,
        "schema": {
            "type": "object",
            "properties": {
                "directory": {"type": "string"}
            },
            "required": ["directory"]
        }
    },
    "run_batch_script": {
        "function": run_batch_script,
        "schema": {
            "type": "object",
            "properties": {
                "filePath": {"type": "string"}
            },
            "required": ["filePath"]
        }
    },
    "search_in_file": {
        "function": search_in_file,
        "schema": {
            "type": "object",
            "properties": {
                "filePath": {"type": "string"},
                "pattern": {"type": "string"}
            },
            "required": ["filePath", "pattern"]
        }
    }
}

def execute_tool_call(tool_call):
    """
    Execute specified function with given arguments and returns results for LLMs
    """
    
    name = tool_call["function"]["name"]
    args = json.loads(tool_call["function"]["arguments"])

    if name not in TOOL_REGISTRY:
        return {"error": f"Unknown tool '{name}'"}

    fn = TOOL_REGISTRY[name]["function"]

    try:
        result = fn(**args)
        return {"result": result}
    except Exception as e:
        return {"error": str(e)}


# Tests functions to be used by LLMs
if __name__ == "__main__":
    try:
        # 1. List files in data/docs
        docs_dir = "docs"
        print(f"--- Testing list_files in {docs_dir} ---")
        files = list_files(docs_dir)
        print(f"Files found: {files}\n")

        if files:
            # 2. Read metadata for the first file found
            target_doc = os.path.join(docs_dir, files[0])
            print(f"--- Testing read_document_metadata on {target_doc} ---")
            metadata = get_document_metadata(target_doc)
            print(f"Summary: {metadata['summary'][:100]}...\n")

            # 3. Read the first section from metadata
            if metadata['sections']:
                first_sec = metadata['sections'][0]
                print(f"--- Testing read_file_lines for section: {first_sec['name']} ---")
                lines = read_file_lines(target_doc, first_sec['start_line'], first_sec['end_line'])
                print(f"Content Preview:\n{lines[:150]}...\n")

        # 4. Write a temporary test.bat
        test_bat_name = "test_temp.bat"
        print(f"--- Testing write_file: {test_bat_name} ---")
        if os.path.exists(test_bat_name):
            os.remove(test_bat_name)
        write_file(test_bat_name, 'echo "hello from console!"')

        # 5. Read the file back
        print(f"Read result: {read_file(test_bat_name).strip()}")

        # 6. Edit the file
        print(edit_file(test_bat_name, "hello from console!", "hello from bat!"))

        # 7. Run the batch script
        print(f"--- Testing run_batch_script ---")
        print(run_batch_script(test_bat_name))

    except Exception as e:
        print(f"Test encountered an error: {e}")
    finally:
        # 8. Cleanup
        if os.path.exists(test_bat_name):
            os.remove(test_bat_name)
            print(f"\nCleaned up {test_bat_name}.")
