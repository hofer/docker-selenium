#!/bin/bash

echo "Kill remaining Chrome and chromedriver instances (if any)"
killall Xvfb
killall x11vnc
killall chromedriver
killall chrome

echo "Starting framebuffer..."
/usr/bin/Xvfb :20 -screen 0 1024x768x24 -fbdir /var/run -ac > /xvfb.log 2>&1 &
nohup x11vnc -forever -usepw -shared -display :20 > /x11vnc.log 2>&1 & 

if [ $VIDEOON == "TRUE" ]
then
  echo "Starting video recording..."
  sleep 2
  ffmpeg -f x11grab -r 25 -s 1024x768 -i :20.0+0,0 out.mpeg > /video.log 2>&1 &
fi

echo "Starting chrome driver..."
timeout --kill-after 2 1800 /srv/chromedriver $*
