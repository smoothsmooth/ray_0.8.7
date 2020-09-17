FROM openrl/baseimage:cuda10-cudnn7-aliyun

RUN rm -rf /etc/apt/sources.list.d && apt-get update && apt-get install -y language-pack-zh-hans \
    git \
    libsm6 \
    libxext6 \
    libxrender-dev \
    redis-tools \
    vim \
    wget \
    pkg-config build-essential libssl-dev libffi-dev --fix-missing && \
    locale-gen zh_CN.UTF-8 && \
    localedef -c -f UTF-8 -i zh_CN zh_CN.utf8 

ENV LC_ALL zh_CN.UTF-8

SHELL ["/bin/bash", "-c"]

ADD ./Miniconda3-latest-Linux-x86_64.sh /Miniconda3-latest-Linux-x86_64.sh

ADD ./requirements.txt /requirements.txt

RUN bash /Miniconda3-latest-Linux-x86_64.sh -b

ENV PATH /root/miniconda3/bin:$PATH

ENV CONDA_PREFIX /root/miniconda3/envs/wargame

# Clear .bashrc (it refuses to run non-interactively otherwise).
RUN echo > ~/.bashrc

# Add conda logic to .bashrc.
RUN conda init bash

#Create new environment and install some dependencies.
RUN conda create -y -n ray python=3.7 \
   protobuf \
   numpy \
   ninja \
   pyyaml \
   mkl \
   mkl-include \
   setuptools \
   cmake \
   cffi \
   typing 

# Activate environment in .bashrc.
RUN echo "conda activate ray" >> /root/.bashrc

# Make bash excecute .bashrc even when running non-interactively.
ENV BASH_ENV /root/.bashrc

# Install PolyBeast's requirements.  -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install --default-timeout=1000 -i https://mirrors.aliyun.com/pypi/simple -r /requirements.txt

ENV OMP_NUM_THREADS 1
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

ADD ./shell /shell
RUN chmod +x -R /shell
ENV PATH /shell:$PATH

# add code server 
COPY code-server_3.4.1_amd64.deb .
RUN dpkg -i code-server_3.4.1_amd64.deb
COPY config.yaml /root/.config/code-server/config.yaml

WORKDIR /


