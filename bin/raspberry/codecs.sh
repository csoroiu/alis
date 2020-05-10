#!/bin/bash
for codec in AGIF FLAC H263 H264 MJPA MJPB MJPG MPG2 MPG4 MVC0 PCM THRA VORB VP6 VP8 WMV9 WVC1; do
    echo -e "$codec:\t$(/opt/vc/bin/vcgencmd codec_enabled $codec)" ;
done
