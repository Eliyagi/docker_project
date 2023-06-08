#!/bin/bash


#install docker:

sudo apt-get install docker.io 1>/dev/null

#pulling images
#sudo docker pull ubuntu
#sudo docker pull php
#sudo docker pull centos
#sudo docker pull nginx
#sudo docker pull abh1nav/dockerui
#sudo docker pull adejonge/helloworld

while true
do

	echo -e "\nMenu:\n1.Pull Image\n2.Run x Nginx\n3.Save containers list to logs file\n4.Run dockerUI and open in web browser\n5.Make a html google home page\n6.Make a containers with a mount to the html page in step 5\n7.nginx container with edited html using exec command \n8.Delete all containers\n"
	read CHOICE

	if [ $CHOICE == "1" ]
	then
		while true
		echo -e "Choose image to Pull: php/ubuntu/centos/nginx\n"
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
		echo -e "How many nginx's containers you want? \n"
		read NUM
		for i in `seq $((NUM+0))`
		do
			echo -e "enter specific port for the container \n"
			read PORTNUM
			sudo docker run -d -p $PORTNUM:80 nginx
		done
		echo -e "Showing all nginx's containers:\n"
		sleep 1
		sudo docker ps | grep nginx
	
	elif [ $CHOICE == "3" ]
	then
		##Get all containers list and save to logs file##
		echo -e "containers list:\n--------------------" >> iplist.log
		for i in `sudo docker ps | awk 'NR>1{print $1}'`
		do
			sudo docker inspect $i |grep IPAddress\": |head -1 | awk '{print $2}' >> iplist.log
		done
		echo -e "--------------------\n" >> iplist.log
	
	elif [ $CHOICE == "4" ]
	then
		##Pull and run dockerUI##
		#sudo docker pull abh1nav/dockerui
		sudo docker run -d -p 9000:9000 -v /var/run/docker.sock:/docker.sock \
--name dockerui abh1nav/dockerui:latest -e="/docker.sock"

		##save IP in logs file##
		ip=`sudo docker ps | grep dockerui |awk 'NR=1{print $1}'`
		dockerIP=`sudo docker inspect $ip |grep IPAddress\": | head -1 | awk '{print $2}'`
		echo -e "dockerui IP:\n--------------------\n$dockerIP\n--------------------\n" >> iplist.log
	
		sleep 1
		##Open dockerUI page##
		conPORT=`sudo docker ps | grep dockerui |awk 'NR=1{print $11}' | head -1 | awk -F ':' '{print $2 }' | awk -F '-' '{print $1 }'`
		echo "container port is:"$conPORT
		echo -e "container ip is:"$dockerIP"\n"
		xdg-open http://localhost:$conPORT/
	
	elif [ $CHOICE == "5" ]
	then
		##Make a html google home page ##
		mkdir web 2>/dev/null
		curl www.google.com > web/index.html
	
	elif [ $CHOICE == "6" ]
	then
		##Make a container with a mount to the html in step 5 ##
		sudo docker run -d -p 80 -v /home/eliya/dockerFinal/web:/usr/share/nginx/html nginx
		sleep 1
	
		##Get the port and show enter the web page##
		conPORT=`sudo docker ps | grep nginx |awk 'NR=1{print $10}' | head -1 | awk -F ':' '{print $2 }' | awk -F '-' '{print $1 }'`
		echo "container port is:"$conPORT
		xdg-open http://localhost:$conPORT/
	
	elif [ $CHOICE == "7" ]
	then
		##New nginx container with edited html page using exec command ##
		sudo docker run -d -p 80 --name a1 nginx
	
		##edit the index file inside the container##
		sudo docker exec -i -t a1 bash -c "cd /usr/share/nginx/html ; echo '<h1>new html page edited manually<h1>' > index.html ; exit"	
		sleep 1
	
		##Get the port and show enter the web page##
		conPORT=`sudo docker ps | grep nginx |awk 'NR=1{print $10}' | head -1 | awk -F ':' '{print $2 }' | awk -F '-' '{print $1 }'`
		xdg-open http://localhost:$conPORT/
	
	elif [ $CHOICE == "8" ]
	then
		##Delete all containers##	
		for i in `sudo docker ps -a | awk 'NR>1{print $1}'`; 
	        do
	        	sudo docker rm -f  $i ;
	        done
        
	        echo -e "All containers are deleted successfully"
	        sleep 2
	else
		echo -e "Choose 1-7 only ! \n"
	fi
sleep 2
echo -e "\nPlease Chosse Again:"
sleep 1

done
