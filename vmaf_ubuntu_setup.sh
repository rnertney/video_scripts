git clone https://github.com/Netflix/vmaf.git
sudo apt install gcc g++ nasm python3-pip
cd vmaf/
sudo -H pip3 install meson ninja
pip3 install cython numpy
make
sudo make install
