#!/bin/bash


# pull required docker images
docker pull selenoid/vnc:chrome_64.0
docker pull selenoid/vnc:chrome_63.0
docker pull selenoid/vnc:firefox_58.0
docker pull selenoid/vnc:firefox_57.0

#-------------- START EVERYTHING ------------------------------
docker-compose up -d
