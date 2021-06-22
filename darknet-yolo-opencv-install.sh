#!/bin/sh
# ----------------------------------------------------
# Leonardo A Carrilho
# 2021 ,July
# Install Darknet + Yolo, OpenCV into Raspberry
# ----------------------------------------------------
#
# clean screen
clean

# Expand SD size
clean
echo "Antes de comecar o processo de instalacao, aumente o tamanho do SD card"
sudo rasp-config

# Check out if is apt-get or yum based
if [ ! $(apt-get) eq " " ]; then
	installer="apt-get install -y"
	# update
	sudo apt-get -y update && sudo apt-get upgrade -y
elif [ ! $(yum) eq " " ]; then
	installer="yum install -y"
	# update
	sudo yum update -y && sudo yum upgrade -y
elif 
	installer="quit"
fi

# Clean apt-get cache
clean
echo "Cleaning apt-get cache..."
sudo rm -f /var/cache/apt/archives/*

# update pip
clean
echo "Updating PIP..."
pip install --upgrade pip


# Install necessary packages
clean
echo "Installing packages needed..."
sudo $installer build-essential cmake unzip pkg-config libjpeg-dev libpng-dev libtiff-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev
sudo $installer libgtk-3-dev
sudo $installer install libcanberra-gtk*
sudo $installer libatlas-base-dev gfortran
sudo $installer python3-dev

clean
echo " ----------------------------------------------------"
echo "                 D A R K N E T                       "
echo " ----------------------------------------------------"
#
# Clone darknet
# git install is required
git init
echo "Cloning darknet project from github..."
git clone https://github.com/AlexeyAB/darknet.git
cd darknet
echo "Compiling darknet..."
make

# Download the weights (yolov3 and yolov4)
clean
echo "Downloading yolov3 weights..."
wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov3.weights
echo "Downloading yolov4 weights..."
wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.weights

# check out the installation 
echo "Testando a instalacao..."
exec ./darknet detect cfg/yolov3.cfg yolov3.weights data/person.jpg

clean
echo " ----------------------------------------------------"
echo "                  O P E N C V                        "
echo " ----------------------------------------------------"
cd ..
echo "Downloading opencv from github..."
git clone https://github.com/opencv/opencv.git
echo "Downloading opencv_contrib from github..."
git clone https://github.com/opencv/opencv_contrib

# Create folder to build opencv
echo "Criando directory opencv_build..."
mkdir -p opencv_build
cd opencv_build
echo "Compiling..."
cmake -DOPENCV_EXTRA_MODULES_PATH=/home/pi/opencv_contrib/modules /home/pi/opencv
echo "Last job..."
make -j5

reboot
