[](/data/html/android-chrome-256x256.png)
# swbf2-modding-assistant
A local AI assistant for modding Star Wars Battlefront II (2005). 

# Installation
- Simply download and extract the repo to your preferred directory. If placed in the BF2_Modtools directory, the assistant may be able to access your addon data folders.
- For Windows: Run Run_Assistant-Windows.bat as administrator once for environment setup, it can be run under normal privileges afterwards.
- For Linux/MacOS: Run Run_Assistant-Linux.sh with sudo once for environment setup, it can be run under normal privileges afterwards.
- Drop in any GGUF LLMs you wish that supports function-calling/tool-use into the models folder. Reccommend 2+ billion parameter models for best results. Higher parameter models may perform better, if your hardware can run them at a timely pace.

# Dependencies
- Python
- Web Browser
- Bring your own GGUF LLM
- The app will download an appropriate release of llama.cpp for your detected hardware on first startup. You may replace it with your own preferred release at any time.
