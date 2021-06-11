#!/bin/bash

for BITRATE in {1..40}
do
ffmpeg -y -pix_fmt yuv420p -framerate 30 -s 3840x2160 -i $1 \
	-c:v libx265 -vsync 0 -preset slow -b:v ${BITRATE}M -f mp4 \
	-tag:v hvc1 -threads 16 -x265-params keyint=60:min-keyint=60:scenecut=0:bitrate=$((BITRATE * 1000)):vbv-maxrate=$((BITRATE * 1000)):vbv-bufsize=$((1000 * (BITRATE / 2))):open-gop=0 $1_$BITRATE.mp4
done
