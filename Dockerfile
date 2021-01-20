FROM ubuntu:18.04

#install basic components
RUN	apt update && \
	apt install -yqq software-properties-common && \
	apt install -yqq net-tools && \
	apt install -yqq wget && \
	apt install -yqq bzip2 && \
	apt install -yqq git && \
	apt install -yqq vim

#install jupyter notebook
RUN	apt update	
RUN	add-apt-repository ppa:deadsnakes/ppa -y
RUN	apt install -yqq python3.8
RUN	apt install -yqq python3-pip python3-dev
RUN	pip3 install jupyter
RUN	adduser --home /home/dementich --disabled-password --gecos "" dementich
	
#install java
RUN apt-get update && \
	apt-get install openjdk-8-jdk -yqq
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH $JAVA_HOME/bin:$PATH

#install ssh
RUN	apt-get install -y openssh-server
RUN	apt-get install -y openssh-client
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
RUN	cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN	chmod 0600 ~/.ssh/authorized_keys
RUN	echo StrictHostKeyChecking no >> ~/.ssh/config

# Install hadoop
#COPY hadoop-2.10.1.tar.gz /root/hadoop-2.10.1.tar.gz
RUN cd $HOME && \
    wget http://apache.mirror.cdnetworks.com/hadoop/common/hadoop-2.10.1/hadoop-2.10.1.tar.gz && \
    tar -xf hadoop-2.10.1.tar.gz && \
    ln -s hadoop-2.10.1 hadoop && \
    rm hadoop-2.10.1.tar.gz
ENV HADOOP_HOME /root/hadoop
ENV HADOOP_CONFIG_HOME $HADOOP_HOME/etc/hadoop
ENV PATH $HADOOP_HOME/bin:$PATH
RUN echo "localhost" >> /root/hadoop/etc/hadoop/masters
COPY hadoop-env.sh /root/hadoop/etc/hadoop/hadoop-env.sh
COPY mapred-site.xml /root/hadoop/etc/hadoop/mapred-site.xml
COPY core-site.xml /root/hadoop/etc/hadoop/core-site.xml
COPY hdfs-site.xml /root/hadoop/etc/hadoop/hdfs-site.xml
COPY yarn-site.xml /root/hadoop/etc/hadoop/yarn-site.xml
COPY start.sh /root/start.sh
RUN $HADOOP_HOME/bin/hdfs namenode -format

CMD ["/bin/bash", "/root/start.sh"]

#How to run:
#docker run --name big_data_1 -p 8888:8888 -p 8088:8088 -p 9010:9010 -p 50070:50070 -p 50090:50090 -v /e/Worker:/home/dementich/Worker -it big_data bash
#docker run --name big_data_1 -v /e/Worker:/home/dementich/Worker -it big_data bash

EXPOSE 50020 50090 50070 50010 50075 8031 8032 8033 8040 8042 49707 22 8088 8030 9010 8888 