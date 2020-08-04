#!/bin/bash

#LOCATION=/var/www/html/*.ts
TMPLOC=/mnt
LOCATION=$TMPLOC/*.nut
PRESET=slow
CPU_DIV=3
FRAMES=21570

#rm -rf /var/www/html/*
rm -rf $TMPLOC/split*

echo "exctracting framecount..."
#TODO: well now it has a space in front of the number
#FRAMES=$(ffmpeg -r 30 -pix_fmt yuv420p -s 3840x2160 -i $1 -map 0:v:0 -c copy -f null - 2>&1 | grep -o '^[^ ]*' | grep frame | grep -o '[[:digit:]]*')
echo "done. Framecount = $FRAMES"


echo "splitting initial file into $CPU_DIV segments"
SPLIT_FRAMES=$((FRAMES/CPU_DIV))
echo "segment size = $SPLIT_FRAMES"


#TODO:can we dynamically make command off cpu_div
ffmpeg -hide_banner -loglevel warning -r 30 -s 3840x2160 -pix_fmt yuv420p \
-i $1 -c:v copy -flags +cgop -map 0 -f segment -segment_list $TMPLOC/split.ffcat \
-segment_list_type ffconcat \
-segment_frames \
$((SPLIT_FRAMES)),\
$((SPLIT_FRAMES*2)) \
$TMPLOC/split%03d.nut

echo "done. encoding at max parallelism"
COUNT=0

start=`date +%s`
for i in $LOCATION
do
echo $i
#ffmpeg -hide_banner -loglevel warning -f rawvideo -pix_fmt yuv420p -r 30 -s 3840x2160 -i $i -y -c:v libx265 -b:v 20M -x265-params "--log-level=1:" -preset $PRESET $i.enc.nut &
ffmpeg -f rawvideo -pix_fmt yuv420p -r 30 -s 3840x2160 -i $i -y -c:v libx265 -b:v 20M -preset $PRESET $i.enc.nut &
COUNT=$((COUNT+1))
pid=$!
done

wait $pid
end=`date +%s`
echo Execution time was `expr $end - $start` seconds.


FPS=$((end-start))
FPS=$((FRAMES/FPS))
echo "Total FPS:$FPS"
