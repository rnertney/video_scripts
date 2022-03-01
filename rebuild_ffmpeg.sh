BUILDDR=ffmpeg44

anykey() {
echo "Finsihed $1, Press any key to continue"
while [ true ] ; do
read -t 3 -n 1
if [ $? = 0 ] ; then
break ;
fi
done
}

installReqs() {
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
}

buildNasm() {
cd ~/ffmpeg_sources && \
wget https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.bz2 && \
tar xjvf nasm-2.14.02.tar.bz2 && \
cd nasm-2.14.02 && \
./autogen.sh && \
PATH="$HOME/bin/$VER/:$PATH" ./configure --prefix="$HOME/$BUILDDR" --bindir="$HOME/bin/$VER" && \
make -j`nproc` && \
make install

anykey "built nasm"
}

buildYasm() {
cd ~/ffmpeg_sources && \
wget -O yasm-1.3.0.tar.gz https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz && \
tar xzvf yasm-1.3.0.tar.gz && \
cd yasm-1.3.0 && \
./configure --prefix="$HOME/$BUILDDR" --bindir="$HOME/bin/$VER" && \
make -j`nproc` && \
make install
anykey "built asm"
}

buildx264() {
cd ~/ffmpeg_sources && \
git -C x264 pull 2> /dev/null || git clone --depth 1 https://code.videolan.org/videolan/x264.git && \
cd x264 && \
PATH="$HOME/bin/$VER:$PATH" PKG_CONFIG_PATH="$HOME/$BUILDDR/lib/pkgconfig" ./configure --prefix="$HOME/$BUILDDR" --bindir="$HOME/bin/$VER" --enable-static --enable-pic && \
PATH="$HOME/bin/$VER:$PATH" make -j`nproc` && \
make install
anykey "built x264"
}

buildx265() {
sudo apt-get install libnuma-dev && \
cd ~/ffmpeg_sources && \
wget -O x265.tar.bz2 https://bitbucket.org/multicoreware/x265_git/get/master.tar.bz2 && \
tar xjvf x265.tar.bz2 && \
cd multicoreware*/build/linux && \
PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED=off ../../source && \
PATH="$HOME/bin:$PATH" make -j`nproc` && \
make install
anykey "built x265"
}

buildxVP9() {
cd ~/ffmpeg_sources && \
git -C libvpx pull 2> /dev/null || git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git && \
cd libvpx && \
PATH="$HOME/bin/$VER:$PATH" ./configure --prefix="$HOME/$BUILDDR" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm && \
PATH="$HOME/bin/$VER:$PATH" make -j`nproc` && \
make install
anykey "built vp9"
}

buildAAC() {
cd ~/ffmpeg_sources && \
git -C fdk-aac pull 2> /dev/null || git clone --depth 1 https://github.com/mstorsjo/fdk-aac && \
cd fdk-aac && \
autoreconf -fiv && \
./configure --prefix="$HOME/$BUILDDR" --disable-shared && \
make -j`nproc` && \
make install
anykey "built AAC"
}

buildLAME() {
cd ~/ffmpeg_sources && \
wget -O lame-3.100.tar.gz https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz && \
tar xzvf lame-3.100.tar.gz && \
cd lame-3.100 && \
PATH="$HOME/bin/$VER:$PATH" ./configure --prefix="$HOME/$BUILDDR" --bindir="$HOME/bin/$VER" --disable-shared --enable-nasm && \
PATH="$HOME/bin/$VER:$PATH" make -j`nproc` && \
make install
anykey "Built LAME"
}

buildOPUS() {
cd ~/ffmpeg_sources && \
git -C opus pull 2> /dev/null || git clone --depth 1 https://github.com/xiph/opus.git && \
cd opus && \
./autogen.sh && \
./configure --prefix="$HOME/$BUILDDR" --disable-shared && \
make -j`nproc` && \
make install
anykey "Built OPUS"
}

buildxAV1() {
cd ~/ffmpeg_sources && \
git clone https://aomedia.googlesource.com/aom && \
cmake aom && \
PATH="$HOME/bin/$VER/:$PATH" make -j`nproc` && \
sudo make install
anykey "Built AOM AV1"
}


buildSVT_AV1() {
rm -rf ~/ffmpeg_sources/SVT-AV1
cd ~/ffmpeg_sources/ && \ 
git clone https://github.com/AOMediaCodec/SVT-AV1 && \
cd SVT-AV1 && \
git checkout refs/tags/v0.9.1 -b v0.9.1 && \

cd ~/ffmpeg_sources/SVT-AV1 && \
cd Build && \
cmake .. -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=Release && \
make -j`nproc` && \
sudo make install
anykey "Buil all SVTs"
}


buildSVT_HEVC() {
rm -rf ~/ffmpeg_sources/SVT-HEVC
cd ~/ffmpeg_sources/ && \ 
git clone https://github.com/OpenVisualCloud/SVT-HEVC.git && \
git checkout refs/tags/v1.5.1 -b v1.5.1 && \

cd ~/ffmpeg_sources/SVT-HEVC && \
mkdir build && \
cd build && \
cmake .. -DCMAKE_BUILD_TYPE=Release && \
make -j $(nproc) && \
sudo make install
}

buildSVT_VP9() {
rm -rf ~/ffmpeg_sources/SVT-VP9
cd ~/ffmpeg_sources/ && \ 
git clone https://github.com/OpenVisualCloud/SVT-VP9 && \
git checkout refs/tags/v0.3.0 -b v0.3.0 && \

cd ~/ffmpeg_sources/SVT-VP9 && \
cd Build && cmake .. -DCMAKE_BUILD_TYPE=release && \
make -j `nproc` && \
sudo make install 
}

cloneFFMPEG() {
rm -rf ~/ffmpeg_sources/ffmpeg && \
cd ~/ffmpeg_sources && \
git clone https://github.com/FFmpeg/FFmpeg ffmpeg && \
cd ffmpeg && \
git checkout -b tag4.4 n4.4
anykey "Cloned FFMPEG"
}

patchSVT() {
cd ~/ffmpeg_sources/ffmpeg && \
git am ../SVT-HEVC/ffmpeg_plugin/n4.4-0001-lavc-svt_hevc-add-libsvt-hevc-encoder-wrapper.patch
anykey "patched HEVC successfully"
}

buildNVENC() {
cd ~/ffmpeg_sources && \
git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git && \
cd nv-codec-headers && sudo make install && \
cd .. && \
sudo apt-get install linux-headers-$(uname -r) && \
distribution=$(. /etc/os-release;echo $ID$VERSION_ID | sed -e 's/\.//g') && \
wget https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/cuda-$distribution.pin && \
sudo mv cuda-$distribution.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/7fa2af80.pub && \
echo "deb http://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64 /" | sudo tee /etc/apt/sources.list.d/cuda.list && \
sudo apt-get update
sudo apt-get -y install cuda-drivers

export PATH=$PATH:/usr/local/cuda/bin/
anykey "Built NVENC"
}

buildVMAF() {
python3 -m pip install meson
python3 -m pip install ninja
python3 -m pip install cython
python3 -m pip install numpy
#
cd ~/ffmpeg_sources && \
git clone https://github.com/Netflix/vmaf.git && \
cd vmaf && \
make -j`nproc` && \
cd libvmaf/build && \
sudo ninja -vC . install
}

echo "Moving to final step"
#clone vmaf, make -j, into ninja, ninja -vC . install, copy to /usr/lib/pkgconfig (or wherever pkg-config --variable pc_path pkg-config points to
#--enable-libsvtvp9 \

buildFFMPEG() {
cd ~/ffmpeg_sources/ffmpeg && \
PATH="$HOME/bin/$VER/:$PATH" \
PKG_CONFIG_PATH="$HOME/$BUILDDR/lib/pkgconfig" \
./configure   \
--prefix="$HOME/$BUILDDR"   \
--pkg-config-flags="--static"   \
--extra-cflags="-I$HOME/$BUILDDR/include -I/usr/local/cuda/include"   \
--extra-ldflags="-L$HOME/$BUILDDR/lib -L/usr/local/cuda/lib64"   \
--extra-libs="-lpthread -lm"   \
--bindir="$HOME/bin/$VER/"   \
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
--enable-libsvthevc \
--enable-libsvtav1 \
--enable-nvenc \
--enable-libvmaf \
--enable-version3 \
--enable-nonfree \
--enable-libnpp && \
PATH="$HOME/bin/$VER/:$PATH" make -j`nproc` && make install

echo "export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:/usr/local/lib/pkgconfig:/usr/local/lib/x86_64-linux-gnu/pkgconfig" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib:/home/`whoami`/ffmpeg_sources/vmaf/libvmaf/build/src/" >> ~/.bashrc
}

#installReqs
#buildNasm
#buildYasm
#buildx264
#buildx265
#buildxVP9
#buildAAC
#buildLAME
#buildOPUS
buildxAV1
#buildSVT_AV1
#buildSVT_HEVC
#cloneFFMPEG
#patchSVT
#buildNVENC
#buildVMAF
buildFFMPEG
#
