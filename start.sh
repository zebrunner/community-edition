#!/bin/bash

# to cauto clean selenoid/appium video crontab is configured to remove mp4 older than 24hrs
#0 * * * * find $HOME/tools/stage-infra/selenoid/video -mindepth 1 -maxdepth 1 -mmin +1440 -name '*.mp4' | xargs rm -rf


# pull required docker images
docker pull selenoid/vnc:chrome_67.0
docker pull selenoid/vnc:firefox_60.0
docker pull selenoid/video-recorder

#-------------- START EVERYTHING ------------------------------
docker-compose up -d
