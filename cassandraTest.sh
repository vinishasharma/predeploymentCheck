#!/bin/bash  

#deploy cassandra
function deployCassandra(){
directoryHome="./predeploymentcheck"
hostName=$1
portName=$2
uname=$3
passwd=$4

echo "host name: $hostName portName: $portName user: $uname passwrd: $passwd"

readCassandraConfig
export CASSANDRA_CONTACT_POINT_ONE=$cassandra_contact_point
export PORT_NAME=$port
echo "host name: $CASSANDRA_CONTACT_POINT_ONE port name : $PORT_NAME"

if [ "$(ls -A $directoryHome/db)" ]; then

echo "$directoryHome/db directory is not Empty"

for file in `cd $directoryHome/db && ls -A *.cql`;do
echo "Executing Cassandra CQL File $file"
deployCas=$(/home/zac/Softwares/apache-cassandra-3.10/bin/cqlsh $hostName $portName -u $uname -p $passwd -f $directoryHome/db/$file)
if [ $deployCas -eq 0 ]; then
echo "command not executed successfully"
else
echo "command executed successfully"
fi
done

else

echo "$directoryHome directory is empty"

fi

}


#read cassandra config
readCassandraConfig(){
cassandra_contact_point=$(jq '.["cloud-dev"].contactNodes[0]' $directoryHome/config/cassandra-config.json)
port=$(jq '.["cloud-dev"].contactPort' $directoryHome/config/cassandra-config.json)
}
 
deployCassandra $1 $2 $3 $4
