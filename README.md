()# FFmpeg with NVIDIA GPU Support Docker Image

This repository contains a Dockerfile to build a Docker image with FFmpeg configured to use NVIDIA GPU support.

## Prerequisites

- Docker installed on your machine
- NVIDIA drivers installed on your host machine
- NVIDIA Container Toolkit installed on your host machine

## Building the Docker Image

To build the Docker image, run the following command:

```sh
./build.sh
```

or

```sh
docker build -t ffmpeg-hw .
```

## Running the Docker Container

To run the Docker container, run the following command:

```sh
./run.sh
```

or

```sh
docker run --gpus all -it ffmpeg-hw
```

If you want to use NVENC you must add the NVIDIA_DRIVER_CAPABILITIES variable. More info [here](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/1.10.0/user-guide.html)

```sh
docker run --gpus all -e NVIDIA_DRIVER_CAPABILITIES=all -it ffmpeg-hw
```

# Dockerfile structure
The Dockerfile is divided into two stages:

- Builder Stage: This stage uses the nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04 image to install all necessary development tools and dependencies, including FFmpeg with NVIDIA GPU support.
- Final Stage: This stage uses the nvidia/cuda:11.2.2-cudnn8-runtime-ubuntu20.04 image and copies the built FFmpeg from the builder stage, resulting in a smaller final image.

# License
This project is licensed under the MIT License.
