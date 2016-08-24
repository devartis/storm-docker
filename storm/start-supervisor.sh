export IP=`hostname -i`
sed -i -e "s/%zookeeper%/$ZK_PORT_2181_TCP_ADDR/g" $STORM_HOME/conf/storm.yaml
sed -i -e "s/%nimbus%/$NIMBUS_PORT_6627_TCP_ADDR/g" $STORM_HOME/conf/storm.yaml
sed -i -e "s/%hostname%/$IP/g" $STORM_HOME/conf/storm.yaml

/usr/sbin/sshd && supervisord
