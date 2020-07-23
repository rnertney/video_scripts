sudo apt-get update -qq && sudo apt-get -y install \
  autoconf \
  automake \
  build-essential \
  cmake \
  git-core \
  libass-dev \
  libfreetype6-dev \
  libsdl2-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  pkg-config \
  texinfo \
  wget \
  zlib1g-dev \
python3 \
python3-pip \
vim-gtk \
htop \
gcc \
g++

mkdir -p ~/ffmpeg_sources

cd ~/ffmpeg_sources && \
wget https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.bz2 && \
tar xjvf nasm-2.14.02.tar.bz2 && \
cd nasm-2.14.02 && \
./autogen.sh && \
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" && \
make -j && \
make install

cd ~/ffmpeg_sources && \
wget -O yasm-1.3.0.tar.gz https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz && \
tar xzvf yasm-1.3.0.tar.gz && \
cd yasm-1.3.0 && \
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" && \
make -j && \
make install

cd ~/ffmpeg_sources && \
git -C x264 pull 2> /dev/null || git clone --depth 1 https://code.videolan.org/videolan/x264.git && \
cd x264 && \
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static --enable-pic && \
PATH="$HOME/bin:$PATH" make -j && \
make install

sudo apt-get -y install mercurial libnuma-dev && \
cd ~/ffmpeg_sources && \
if cd x265 2> /dev/null; then hg pull && hg update && cd ..; else hg clone https://bitbucket.org/multicoreware/x265; fi && \
cd x265/build/linux && \
PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED=off ../../source && \
PATH="$HOME/bin:$PATH" make -j && \
make install

cd ~/ffmpeg_sources && \
git -C libvpx pull 2> /dev/null || git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git && \
cd libvpx && \
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm && \
PATH="$HOME/bin:$PATH" make -j && \
make install

cd ~/ffmpeg_sources && \
git -C fdk-aac pull 2> /dev/null || git clone --depth 1 https://github.com/mstorsjo/fdk-aac && \
cd fdk-aac && \
autoreconf -fiv && \
./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
make -j && \
make install

cd ~/ffmpeg_sources && \
wget -O lame-3.100.tar.gz https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz && \
tar xzvf lame-3.100.tar.gz && \
cd lame-3.100 && \
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --disable-shared --enable-nasm && \
PATH="$HOME/bin:$PATH" make -j && \
make install


cd ~/ffmpeg_sources && \
git -C opus pull 2> /dev/null || git clone --depth 1 https://github.com/xiph/opus.git && \
cd opus && \
./autogen.sh && \
./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
make -j && \
make install

cd ~/ffmpeg_sources && \
git -C aom pull 2> /dev/null || git clone --depth 1 https://aomedia.googlesource.com/aom && \
mkdir -p aom_build && \
cd aom_build && \
PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED=off -DENABLE_NASM=on ../aom && \
PATH="$HOME/bin:$PATH" make -j && \
make install

rm -rf ~/ffmpeg_sources/SVT*
#cd ~/ffmpeg_sources/ && \ 
#git clone https://github.com/OpenVisualCloud/SVT-HEVC.git && \
#git clone https://github.com/OpenVisualCloud/SVT-AV1 && \
#git clone https://github.com/OpenVisualCloud/SVT-VP9
#
#cd ~/ffmpeg_sources/SVT-VP9 && \
#git pull && \
#cd Build && cmake .. && \
#make -j `nproc` && \
#sudo make install 
#
#
#cd ~/ffmpeg_sources/SVT-HEVC && \
#git pull &&\
#cd Build/linux && \
#./build.sh release && \
#cd Release &&\ 
#sudo make install
#
#
#cd ~/ffmpeg_sources/SVT-AV1 && \
#git pull && \
#cd Build/linux && \
#./build.sh release && \
#cd Release && \
#sudo make install

cd ~/ffmpeg_sources && \
git clone https://github.com/FFmpeg/FFmpeg ffmpeg && \
cd ffmpeg && \
git checkout -b tag4.3.1 n4.3.1 

#cd ~/ffmpeg_sources/ffmpeg && \
#git apply ../SVT-HEVC/ffmpeg_plugin/0001-lavc-svt_hevc-add-libsvt-hevc-encoder-wrapper.patch
#git apply ../SVT-AV1/ffmpeg_plugin/0001-Add-ability-for-ffmpeg-to-run-svt-av1-with-svt-hevc.patch
#git apply ../SVT-VP9/ffmpeg_plugin/0001-Add-ability-for-ffmpeg-to-run-svt-vp9-with-hevc-av1.patch


cd ~/ffmpeg_sources && \
git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git && \
cd nv-codec-headers && sudo make install && \
cd .. && \
wget http://us.download.nvidia.com/tesla/450.51.05/nvidia-driver-local-repo-ubuntu1604-450.51.05_1.0-1_amd64.deb && \
sudo dpkg -i nvidia-driver-local-repo-ubuntu1604-450.51.05_1.0-1_amd64.deb && \
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-ubuntu1604.pin && \
sudo mv cuda-ubuntu1604.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub && \
sudo add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/ /" && \
sudo apt-get update && \
sudo apt-get -y install cuda

export PATH=$PATH:/usr/local/cuda/bin/


python3 -m pip install meson
python3 -m pip install ninja
python3 -m pip install cython

cd ~/ffmpeg_sources && \
git clone https://github.com/Netflix/vmaf.git && \
cd vmaf && \
make -j && \
cd libvmaf/build && \
sudo ninja -vC . install

#clone vmaf, make -j, into ninja, ninja -vC . install, copy to /usr/lib/pkgconfig (or wherever pkg-config --variable pc_path pkg-config points to

cd ~/ffmpeg_sources/ffmpeg && \
PATH="$HOME/bin:$PATH" \
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" \
./configure   \
--prefix="$HOME/ffmpeg_build"   \
--pkg-config-flags="--static"   \
--extra-cflags="-I$HOME/ffmpeg_build/include -I/usr/local/cuda/include"   \
--extra-ldflags="-L$HOME/ffmpeg_build/lib -L/usr/local/cuda/lib64"   \
--extra-libs="-lpthread -lm"   \
--bindir="$HOME/bin"   \
--enable-gpl   \
--enable-libaom   \
--enable-libass   \
--enable-libfdk-aac   \
--enable-libfreetype   \
--enable-libmp3lame   \
--enable-libopus   \
--enable-libvorbis   \
--enable-libvpx   \
--enable-libx264   \
--enable-libx265   \
--enable-nonfree \
--enable-cuda-sdk \
--enable-cuvid \
--enable-nvenc \
--enable-libvmaf \
--enable-version3 \
--enable-nonfree \
--enable-libnpp && \
PATH="$HOME/bin:$PATH" make -j && make install

echo "export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:/usr/local/lib/pkgconfig:/usr/local/lib/x86_64-linux-gnu/pkgconfig" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib:/home/`whoami`/ffmpeg_sources/vmaf/libvmaf/build/src/" >> ~/.bashrc

#
