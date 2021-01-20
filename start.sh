sed -i "s/localhost/$(hostname -i)/g" /root/hadoop/etc/hadoop/hdfs-site.xml
sed -i "s/localhost/$(hostname -i)/g" /root/hadoop/etc/hadoop/yarn-site.xml

service ssh start
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh

#runuser -l dementich -c 'jupyter notebook --no-browser --ip=0.0.0.0 --port 8888 --notebook-dir=/home/dementich'
jupyter notebook --no-browser --ip=0.0.0.0 --port 8888 --notebook-dir=/home/dementich --allow-root
#$HOME/hive/bin/hive --service metastore &
#sleep 5
#cd $HOME
#pyspark &
#/bin/bash