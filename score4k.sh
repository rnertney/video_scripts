#!/bin/bash

MASTER="../../../../source/*3840*"
ENCODER=$1
TESTDIR="../encodes/$ENCODER"
LOGPATH="./$ENCODER"

for DISTORTED in $TESTDIR/*.mp4 
do
filename="${DISTORTED##*/}"

ffmpeg -i $DISTORTED -framerate 30 -s 3840x2160 -pix_fmt yuv420p -i $MASTER \
-lavfi libvmaf="log-fmt=json:ms_ssim=1:ssim=1:psnr=1:log_path=$LOGPATH/${filename}.vmaf.json:model_path=/home/ubuntu/ffmpeg_sources/vmaf/model/vmaf_4k_v0.6.1.pkl" -f null - 
#-lavfi libvmaf="ms_ssim=1:ssim=1:psnr=1:log_fmt=json:log_path=$LOGPATH/${filename}.vmaf.json:model_path=/home/ubuntu/ffmpeg_sources/vmaf/model/vmaf_4k_v0.6.1.pkl" -f null - 
done

