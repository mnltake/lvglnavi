#!/bin/bash
cd ~
n=8
echo 1/$n
sudo apt update 
sudo apt upgrade -y

echo 2/$n #RTKLIB
cd ~
git clone https://github.com/tomojitakasu/RTKLIB.git
cd ~/RTKLIB/app/str2str/gcc
make 

echo 3/$n #neopixcel
cd ~
git clone https://github.com/jgarff/rpi_ws281x
sudo apt-get install scons -y
cd rpi_ws281x
scons
sudo pip3 install rpi_ws281x

echo 4/$n #autostartstr2str
cd ~/lvglnavi
sudo cp -f ./str2str-in.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable str2str-in.service


echo 5/$n #shutdouwn button
sudo cp -f ./shutdownbuttond.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable shutdownbuttond.service

echo 6/$n #shp
sudo apt install libgeos-dev python3-numpy -y
sudo pip3 install pyshp Shapely pymap3d

echo 7/$n #GPIO UART
sudo cp -fb  ./config.txt /boot/config.txt
sudo systemctl disable hciuart

echo 8/$n #lvgl micropython
cd ~
sudo apt install build-essential libreadline-dev libffi-dev git pkg-config libsdl2-2.0-0 libsdl2-dev parallel wmctrl -y
git clone --recurse-submodules https://github.com/lvgl/lv_micropython.git
cd ~/lvglnavi/
# mv ./lv_conf.h ~/lv_micropython/lib/lv_bindings/lv_conf.h
cp -f ./lv_drv_conf.h ~/lv_micropython/lib/lv_bindings/driver/SDL/lv_drv_conf.h
# mv ./SDL_monitor.c ~/lv_micropython/lib/lv_bindings/driver/SDL/SDL_monitor.c
cp -f ./qrcodegen.c ~/lv_micropython/lib/lv_bindings/lvgl/src/extra/libs/qrcode/qrcodegen.c
cd ~/lv_micropython
make -C mpy-cross -j4
make -C ports/unix/ -j4
sudo ln -f ./ports/unix/micropython /usr/local/bin/micropython

cd ~/lvglnavi
echo Setting yourself
echo nano ~/lvglnavi/config.init.template 
echo nano ~/lvglnavi/str2str-in.sh.template
echo sudo reboot