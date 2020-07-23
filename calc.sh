#!/bin/bash


#for n in $2*1080p30*.yuv
for n in $2*720p30*.yuv
do
#	ffmpeg -s 1920x1080 -i $1 -s 1920x1080 -i $n -lavfi psnr="" -f null - 2>> psnr1080.log
#	ffmpeg -s 1920x1080 -i $1 -s 1920x1080 -i $n -lavfi ssim="" -f null - 2>> ssim1080.log 
#	ffmpeg -s 1920x1080 -i $1 -s 1920x1080 -i $n -lavfi libvmaf="" -f null - 2>> vmaf1080.log 
	ffmpeg -s 1280x720 -i $1 -s 1280x720 -i $n -lavfi psnr="" -f null - 2>> psnr720.log 
	ffmpeg -s 1280x720 -i $1 -s 1280x720 -i $n -lavfi ssim="" -f null - 2>> ssim720.log 
	ffmpeg -s 1280x720 -i $1 -s 1280x720 -i $n -lavfi libvmaf="" -f null - 2>> vmaf720.log 
echo "Done"
done
