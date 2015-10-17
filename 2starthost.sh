#!/usr/bin/bash
HOST_NAME=$1
HOST_IP=$2
IMAGE_NAME=$3

echo $HOST_NAME $HOST_IP $IMAGE_NAME

HAS_BR0=`ifconfig | grep br0 | wc -l`

if [ $HAS_BR0 -ne 1 ];
then
	echo "don't have inited br0,please check!!"
	exit -2;	
fi

docker run -d --name=$HOST_NAME -h $HOST_NAME $IMAGE_NAME

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
VETH_NAME=${HOST_NAME}_veth1
echo $VETH_NAME
#新建eth1
ip link add $VETH_NAME type veth peer name veth1

ip link set veth1 netns $PID

brctl addif br0 $VETH_NAME

ifconfig $VETH_NAME up

#设置制定IP地址
ip netns exec $PID ifconfig veth1 $HOST_IP/24 up

#VDEV_NAME=`brctl show | grep docker0 | grep -v grep|awk '{print $4}'`

#brctl delif docker0 $VDEV_NAME

#brctl addif br0 $VDEV_NAME
#查看设置结果
ip netns exec $PID ip addr

ping -c 4 $HOST_IP

