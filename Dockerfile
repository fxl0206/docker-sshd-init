FROM docker.io/centos

MAINTAINER fxl0206@gmail.com

USER root

ADD include/init.sh /init.sh

#初始化ssh环境
RUN yum -y install passwd expect net-tools java ssh-keygen tar wget openssh-server openssh-clients sudo && ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key && ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key && mkdir /var/run/sshd && /init.sh

# 启动sshd服务并且暴露22端口  
CMD ["/usr/sbin/sshd", "-D"]
