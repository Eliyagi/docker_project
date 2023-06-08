#!/bin/bash

echo -e "Menu:\n1.Pull Image\n2. Run X Ubuntus\n3.Remove Image/Container\n4.Run App Specific port\n"
read CHOICE
if [ $CHOICE == "1" ]
then
	while true
	echo -e "Choose image to install: php/ubuntu/centos/nginx\n"
	read OS 
	do
	if [ $OS == "centos" ] || [ $OS == "php" ] || [ $OS == "ubuntu" ] || [ $OS == "nginx" ]
	then
		sudo docker pull $OS
		break
	else
		echo -e "Enter good OS\n"
	fi
	done
elif [ $CHOICE == "2" ]
then
	echo -e "How many ubuntu's containers you want? \n"
	read NUM
	for i in `seq $((NUM+0))`
	do
		sudo docker run -d ubuntu /bin/bash -c  "while true; do echo eliya ; sleep 1 ; done" 2>/dev/null
	done
	
	sudo docker ps | grep ubuntu
elif [ $CHOICE == "3" ]
then
	echo -e "Do you want to delete image or container?\n"
	read DEL
	id [ $DEL == "image" ]
	then
		while true
		echo -e "Choose image to delete: php/ubuntu/centos/nginx\n"
		read OS
		do
		if [ $OS == "centos" ] || [ $OS == "php" ] || [ $OS == "ubuntu" ] || [ $OS == "nginx" ]
		then
			sudo doker rmi $OS 2>/dev/null
			break
		else
			echo -e "Enter good OS\n"
		fi
		done
	elif [ $DEL == "container" ]
	then
		sudo docker ps
		echo -e "Enter container ID\n"	
		read CONTAINER
		sudo docker rm -f $CONTAINER 2>/dev/null
		echo -e "\n"
		sudo docker ps
	else
		echo -e "Select image/container only !\n"
	fi
elif [ $CHOICE == "4" ]
then
	echo -e "Enter a port: \n"
	read PORT
	sudo docker run -d -p $PORT:8080 adejonge/helloworld
	sudo docker ps | awk 'NR==2'
fi
