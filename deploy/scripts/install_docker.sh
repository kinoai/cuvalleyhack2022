#!/bin/bash
# Install nvidia-docker and recommended CUDA drivers

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common ubuntu-drivers-common nvidia-driver-470
curl https://get.docker.com | sh \
  && sudo systemctl --now enable docker
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker
sudo groupadd docker
sudo usermod -aG docker ubuntu
