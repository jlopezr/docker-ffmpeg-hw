# Stage 1: Build FFmpeg with NVIDIA GPU support
FROM nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04 AS builder

# Set the working directory
WORKDIR /app

# Set environment variable to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install the necessary packages
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    pkg-config \
    zlib1g-dev \
    nasm \    
    && rm -rf /var/lib/apt/lists/*

# Install the NVIDIA Video Codec SDK
RUN git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git && \
    cd nv-codec-headers && \
    make && \
    make install && \
    cd .. && \
    rm -rf nv-codec-headers

# Install FFmpeg with NVIDIA GPU support
RUN git clone https://git.ffmpeg.org/ffmpeg.git && \
    cd ffmpeg && ./configure --enable-cuda-nvcc --enable-cuvid --enable-nvenc --enable-nonfree --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --disable-static --enable-shared  --enable-decoder=png --enable-encoder=png && make -j $(nproc) && \
    make -j $(nproc) && \
    make install && \
    cd .. && \
    rm -rf ffmpeg

# Stage 2: Create the final image with only FFmpeg and its dependencies
FROM nvidia/cuda:11.2.2-cudnn8-runtime-ubuntu20.04

# Copy FFmpeg from the builder stage
COPY --from=builder /usr/local /usr/local

# Set the entrypoint
CMD ["bash"]