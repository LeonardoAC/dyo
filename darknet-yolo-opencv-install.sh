#!/bin/sh
# ----------------------------------------------------
# Leonardo A Carrilho
# 2021 ,July
# Install Darknet + Yolo, OpenCV into Raspberry
# ----------------------------------------------------

# Expand SD size
echo "Antes de comecar o processo de instalacao, aumente o tamanho do SD card"
sudo rasp-config

# Clean apt-get cache
sudo rm -f /var/cache/apt/archives/*

# update pip
pip install --upgrade pip

# update
sudo apt-get update && sudo apt-get upgrade

# Install necessary packages
sudo apt-get install build-essential cmake unzip pkg-config libjpeg-dev libpng-dev libtiff-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev
sudo apt-get install libgtk-3-dev
sudo apt-get install libcanberra-gtk*
sudo apt-get install libatlas-base-dev gfortran
sudo apt-get install python3-dev

# ----------------------------------------------------
#                  D A R K N ET
# ----------------------------------------------------
#
# Clone darknet
# git install is required
git init
git clone https://github.com/AlexeyAB/darknet.git
cd darknet
make

# Download the weights (yolov3 and yolov4)
wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov3.weights
wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.weights

# check out the installation 
echo "Testando a instalacao..."
./darknet detect cfg/yolov3.cfg yolov3.weights data/person.jpg

# ----------------------------------------------------
#                   O P E N C V
# ----------------------------------------------------
cd ..
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib

# Create folder to build opencv
mkdir -p opencv_build
cd opencv_build
cmake -DOPENCV_EXTRA_MODULES_PATH=/home/pi/opencv_contrib/modules /home/pi/opencv
make -j5

reboot
