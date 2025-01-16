@echo off
REM Usage: ffmpeg.bat input_file output_file [ffmpeg_options]

set INPUT_FILE=%1
set OUTPUT_FILE=%2
shift
shift

docker run --gpus all -e NVIDIA_DRIVER_CAPABILITIES=all -it --rm -v "%cd%:/workspace" -w /workspace ffmpeg-hw ffmpeg -i "%INPUT_FILE%" "%OUTPUT_FILE%" %*