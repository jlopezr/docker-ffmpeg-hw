#!/bin/bash
docker run --gpus all -e NVIDIA_DRIVER_CAPABILITIES=all -it --rm -v "$(pwd):/workspace" -w /workspace ffmpeg-hw ffmpeg "$@"