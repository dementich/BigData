sed -i "s/localhost/$(hostname -i)/g" /root/hadoop/etc/hadoop/hdfs-site.xml
sed -i "s/localhost/$(hostname -i)/g" /root/hadoop/etc/hadoop/yarn-site.xml
#sed -i "s/localhost/$(hostname -i)/g" /root/hive/conf/hive-site.xml

service ssh start
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh
hive --service metastore > /dev/null 2>&1 &
sleep 300
hive --service hiveserver2 > /dev/null 2>&1 &
sleep 300

jupyter notebook --no-browser --ip=0.0.0.0 --port 8888 --notebook-dir=/home/dementich --allow-root

#/bin/bash