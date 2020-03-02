FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
        build-essential \
        curl \
        cmake \
        git \
        libatlas-base-dev \
        libatlas-dev \
        libboost-all-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        libhdf5-dev \
        libhdf5-serial-dev \
        libleveldb-dev \
        liblmdb-dev \
        libopencv-dev \
        libprotobuf-dev \
        libviennacl-dev \
        libsnappy-dev \
        lsb-release \
        protobuf-compiler \
        opencl-headers \
        ocl-icd-opencl-dev \
        python3 \
        python3-setuptools \
        python3-dev \
        python3-pip \
        wget
        
RUN pip3 install --upgrade pip &&\
    pip3 install --upgrade numpy protobuf opencv-python

ENV OPENPOSE_ROOT=/opt/openpose

WORKDIR $OPENPOSE_ROOT

RUN git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose $OPENPOSE_ROOT && \
    cd $OPENPOSE_ROOT && \
    git submodule update --init --recursive --remote

# set up CPU only and build
RUN mkdir $OPENPOSE_ROOT/build && \
    cd $OPENPOSE_ROOT/build && \
    cmake -DGPU_MODE=CPU_ONLY -DBUILD_PYTHON=ON .. && \
    make -j`nproc`

ENV OPENPOSE_MODELS="/opt/openpose/models/"
ENV PYTHONPATH="/opt/openpose/build/python:$PYTHONPATH"

WORKDIR $OPENPOSE_ROOT