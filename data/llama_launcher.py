import os
import sys
import platform
import subprocess
import requests
import zipfile
import ctypes

# --------------
# Define Globals
# --------------

# Flag to enable additional logging for llama_launcher.py
DEBUG_LLAMA = False

# Link to latest llama.cpp GitHub releases as string
LLAMA_RELEASE = "https://api.github.com/repos/ggerganov/llama.cpp/releases/latest"

BASE_DIR = os.path.dirname(os.path.abspath(__file__))   # /data
PROJECT_ROOT = os.path.abspath(os.path.join(BASE_DIR, ".."))  # project root

BIN_DIR = os.path.join(PROJECT_ROOT, "llama")
MODELS_DIR = os.path.join(PROJECT_ROOT, "models")

os.makedirs(BIN_DIR, exist_ok=True)
os.makedirs(MODELS_DIR, exist_ok=True)


# ---------------------
# Environment Detection
# ---------------------


def detect_arch():
    """
    Detects and returns CPU architecture string
    """

    arch = platform.machine().lower()
    if arch in ("amd64", "x86_64"):
        return "x64"
    if arch in ("arm64", "aarch64"):
        return "arm64"
    raise RuntimeError(f"Unsupported architecture: {arch}")


def detect_cpu_cores():
    """
    Detects and returns CPU core count integer
    """

    return os.cpu_count() or 1


def detect_os():
    """
    Detects and returns OS string
    """

    return platform.system().lower()


# ---------------------
# Accelerator Detection
# ---------------------


def has_cuda():
    """
    Detects and returns boolean for CUDA acceleration available
    """

    lib_name = "nvcuda.dll" if platform.system() == "Windows" else "libcuda.so"
    try:
        ctypes.CDLL(lib_name)
        return True
    except Exception:
        return False


def has_vulkan():
    """
    Detects and returns boolean for Vulkan acceleration available
    """

    lib_name = "vulkan-1.dll" if platform.system() == "Windows" else "libvulkan.so.1"
    try:
        ctypes.CDLL(lib_name)
        return True
    except Exception:
        return False


# -------------------------------------
# Download and Prepare llama.cpp Assets
# -------------------------------------


def download_release_asset(tags):
    """
    Downloads latest llama.cpp release assets and returns resulting path
    """

    if DEBUG_LLAMA:
        print(f"ll::download_release_asset: Searching for asset containing all of: {tags}")

    response = requests.get(LLAMA_RELEASE)
    response.raise_for_status()
    release = response.json()

    for asset in release["assets"]:
        asset_name = asset["name"].lower()
        if all(tag.lower() in asset_name for tag in tags):
            url = asset["browser_download_url"]
            destination = os.path.join(BIN_DIR, asset["name"])
            if DEBUG_LLAMA:
                print(f"ll::download_release_asset: Downloading {asset['name']}...")
            with requests.get(url, stream=True) as r:
                r.raise_for_status()
                with open(destination, "wb") as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)
            return destination

    raise RuntimeError(f"No asset found containing all of: {tags}")


def extract_zip(path):
    """
    Unzips llama.cpp release assets to a named-build folder
    """
    
    folder_name = os.path.splitext(os.path.basename(path))[0]
    target_dir = os.path.join(BIN_DIR, folder_name)
    if DEBUG_LLAMA: 
        print(f"ll::extract_zip: Extracting {path} to {target_dir}...")
    os.makedirs(target_dir, exist_ok=True)
    with zipfile.ZipFile(path, "r") as z:
        z.extractall(target_dir)


# ---------------------
# Build App Environment
# ---------------------


def validate_binary():
    """
    Locates llama-server.exe path, downloads if not present, returns path to llama-server.exe
    """
    
    arch = detect_arch()
    os_environment = detect_os()
    if DEBUG_LLAMA:
        print(f"ll::validate_binary: Detected architecture: {arch}, OS: {os_environment}")

    os_tag = "win" if os_environment == "windows" else "linux" if os_environment == "linux" else "macos"
    if os_tag == "linux":
        os_tag = "ubuntu"

    cuda = has_cuda()
    vulkan = has_vulkan()

    search_tags = [os_tag]
    if cuda and arch == "x64":
        if DEBUG_LLAMA:
            print("ll::validate_binary: CUDA acceleration enabled.")
        search_tags.extend(["cuda", arch])
    elif vulkan and (arch == "x64" or os_tag == "ubuntu"):
        if DEBUG_LLAMA:
            print(f"ll::validate_binary: Vulkan acceleration enabled ({arch}).")
        search_tags.extend(["vulkan", arch])
    else:
        if DEBUG_LLAMA:
            print(f"ll::validate_binary: No hardware acceleration available for {os_tag} {arch}, falling back to CPU.")
        search_tags.append(arch)

    if DEBUG_LLAMA:
        print(f"ll::validate_binary: Selected build tags: {search_tags}")

    for root, dirs, files in os.walk(BIN_DIR):
        for f in files:
            full_path_lower = os.path.join(root, f).lower()
            if "server" in f.lower() and all(t.lower() in full_path_lower for t in search_tags):
                return os.path.join(root, f)

    zip_path = download_release_asset(search_tags)
    extract_zip(zip_path)
    if DEBUG_LLAMA:
        print(f"ll::validate_binary: Cleaning up {zip_path}...")
    os.remove(zip_path)

    for root, dirs, files in os.walk(BIN_DIR):
        for f in files:
            full_path_lower = os.path.join(root, f).lower()
            if "server" in f.lower() and all(t.lower() in full_path_lower for t in search_tags):
                return os.path.join(root, f)

    raise RuntimeError("Failed to locate llama-server binary after extraction")


# ------------------------------
# Launch SWBF2-Modding-Assistant
# ------------------------------


def launch_llama(llama_binary, address="127.0.0.1", port=8081, context_length=2048):
    """
    Launches llama-server.exe by given path with given arguments
    """
    
    threads = detect_cpu_cores()
    if DEBUG_LLAMA:
        print(f"ll::launch_llama: Detected {threads} CPU cores.")

    cmd = [
        llama_binary,
        "--host", address,
        "--port", str(port),
        "--ctx-size", str(context_length),
        "--threads", str(threads),
        "--models-dir", os.path.abspath(MODELS_DIR),
        "--sleep-idle-seconds", "300",
        "--reasoning-format", "deepseek",
        "--metrics",
        "--no-slots",
        "--direct-io",
        "--no-webui"
    ]

    if DEBUG_LLAMA:
        print(f"ll::launch_llama: Launching llama-server with args: {cmd}")
    
    if DEBUG_LLAMA:
        out = sys.stdout
    else:
        out = subprocess.DEVNULL
    
    proc = subprocess.Popen(
        cmd,
        stdout=out,
        stderr=out
    )

    if DEBUG_LLAMA:
        print("ll::launch_llama: Server started in background.")
    return proc


# -------------------------------------------------
# Main - Simply launches llama-server with defaults
# -------------------------------------------------


#if __name__ == "__main__":
#    LLAMA_BINARY = validate_binary()
#    launch_llama(LLAMA_BINARY)