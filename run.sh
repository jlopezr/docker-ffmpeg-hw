#!/bin/bash
docker run --gpus all -e NVIDIA_DRIVER_CAPABILITIES=all -it --rm ffmpeg-hw