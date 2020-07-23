#!/bin/bash

LOCATION=/var/www/html/*.ts
PRESET=slower
CPU_DIV=9

rm -rf /var/www/html/*

echo "exctracting framecount..."
FRAMES=$(ffmpeg -i $1 -map 0:v:0 -c copy -f null - 2>&1 | grep -o '^[^ ]*' | grep frame | grep -o '[[:digit:]]*')
echo "done. Framecount = $FRAMES"


echo "splitting initial file into $CPU_DIV segments"
SPLIT_FRAMES=$((FRAMES/CPU_DIV))

#TODO:can we dynamically make command off cpu_div
ffmpeg -hide_banner -loglevel warning \
-i $1 -c:v copy -flags +cgop -map 0 -f segment -segment_list /tmp/split.m3u8 \
-segment_list_type m3u8 \
-segment_frames \
$((SPLIT_FRAMES)),\
$((SPLIT_FRAMES*2)),\
$((SPLIT_FRAMES*3)),\
$((SPLIT_FRAMES*4)),\
$((SPLIT_FRAMES*5)),\
$((SPLIT_FRAMES*6)),\
$((SPLIT_FRAMES*7)),\
$((SPLIT_FRAMES*8)) \
/tmp/split%03d.ts

echo "done. encoding at max parallelism"
COUNT=0

start=`date +%s`
for i in $LOCATION
do
ffmpeg -hide_banner -loglevel warning -i $i -y -c:v libx265 -b:v 20M -x265-params "--log-level=1:" -preset $PRESET /tmp/$i.enc.ts &
COUNT=$((COUNT+1))
pid=$!
done

wait $pid
end=`date +%s`
echo Execution time was `expr $end - $start` seconds.


FPS=$((end-start))
FPS=$((FRAMES/FPS))
echo "Total FPS=$FPS"
