#!/usr/bin/bash
HOST_NAME=$1
HOST_IP=$2

echo $HOST_NAME $HOST_IP 

PID=`docker inspect --format="{{ .State.Pid }}" $HOST_NAME`

#如果netns目录不存在则新建
if [ ! -d /var/run/netns ]; then
	echo "新建目录 /var/run/netns"
	mkdir -p /var/run/netns/
fi

#进程网络命名空间不存在文件，新建软连接
if [ ! -f /var/run/netns/$PID ]; then
	echo "新建软连接 /var/run/netns/$PID"
	ln -s /proc/$PID/ns/net /var/run/netns/$PID
fi

#设置制定IP地址
ip netns exec $PID ifconfig eth0 $HOST_IP/24 up

#查看设置结果
ip netns exec $PID ip addr

ping -c 4 $HOST_IP

