#!/usr/bin/bash
BR0_IP=$1
brctl addbr br1
ifconfig br1 $1/24 up

