FROM nvidia/cuda:13.0.2-runtime-ubuntu24.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1

# Install Python and dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    git \
    wget \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN git clone https://github.com/comfyanonymous/ComfyUI.git /app/ComfyUI

WORKDIR /app/ComfyUI

# Note: use the installer from comfyui to find the correct download urls.
# break-system-packages on the container is fine i think.
RUN pip install --break-system-packages --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu129 && \
    pip install --break-system-packages --no-cache-dir -r requirements.txt

# Clone ComfyUI-Chord and install dependencies
RUN git clone --recursive https://github.com/ubisoft/ComfyUI-Chord.git /app/ComfyUI/custom_nodes/ComfyUI-Chord && \
    pip install --break-system-packages --no-cache-dir -r /app/ComfyUI/custom_nodes/ComfyUI-Chord/requirements.txt

EXPOSE 8188
CMD ["python", "main.py", "--listen", "0.0.0.0", "--port", "8188"]
