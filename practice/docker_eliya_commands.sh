#!/bin/bash

###Initial Commands###

#install docker:
#first option
sudo apt-get install docker.io

#second option updated verion
curl -fsSL https://get.docker.com -o install-docker.sh
sh install-docker.sh --dry-run
sudo sh install-docker.sh

#search images
sudo docker search ubuntu
sudo docker search nagios

#pulling images
sudo docker pull ubuntu
sudo docker pull jasanrivers/nahios

#deleting image and show images
sudo docker rmi php 2>/dev/null
sudo docker images

###run Containers##
sudo docker run -d centos /bin/bash -c "counter=0 ; while true; do echo $counter ; let counter=counter+1 ; sleep 1 ; done"
sudo docker run -d ubuntu /bin/bash -c "while true; do echo eliya ; sleep 1 ; done"

###Show logs of specific Ubuntu container###
sudo docker logs `sudo docker ps | grep ubuntu | awk '{print $1}'`

###Create Ubuntu's Containers###
for i in {1..10}
do
	sudo docker run -d ubuntu /bin/bash -c  "while true; do echo eliya ; sleep 1 ; done" 2>/dev/null
done

sudo docker ps

###Stop Ubuntu's Containers###
for i in `sudo docker ps | grep ubuntu | awk '{print $1}'`
do
	sudo docker stop $i
done

#show stopped containers###
sudo docker ps -a


###Destroy Ubuntu's Containers###
for i in `sudo docker ps | grep ubuntu | awk '{print $1}'`
do
	sudo docker rm -f $i
done

sudo docker ps
