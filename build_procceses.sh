. config.conf
#Build the main data folders
mkdir -p $mongo_dbpath_root
cd $mongo_dbpath_root
##Make config and mongos folders
mkdir -p {c1,c2,c3,m1}/data
##Make shard member folders
for shard in "${shards[@]}";do
	for node in  `seq 1 3`;do
		mkdir -p ${shard}-${node}
	done
 done

cd "$start_dir"
#Start the processes

port_prefix=2700
for shard in "${shards[@]}";do
	echo -e "Starting Shard: ${shard} processes"
	for i in `seq 1 3`;do
		$bin_dir/mongod --fork --logpath $mongo_dbpath_root/${shard}-${i}/mongo.log --dbpath $mongo_dbpath_root/${shard}-${i} --port ${port_prefix}${i} --replSet ${shard} --shardsvr --nohttpinterface 
		echo -e "Enabling ${shard} replica set"
	done
	sleep 10
	i=$((i-2))
	$bin_dir/mongo --quiet --port ${port_prefix}${i} --eval "var replSet='${shard}'" "${start_dir}/config_replset.js"
	if [ "$?" -ne 0 ];then
		exit 1
	fi
	port_prefix=$((port_prefix + 100))
	
done

#config
for i in `seq 1 3`;do
	$bin_dir/mongod --fork --logpath $mongo_dbpath_root/c${i}/mongo.log --dbpath $mongo_dbpath_root/c${i} --port 1900${i} --configsvr
done

echo -e "Sleeping to be nice (20)..."
sleep 20

#mongos 
echo -e "Starting Mongos"
$bin_dir/mongos --fork --logpath $mongo_dbpath_root/m1/mongos.log --configdb localhost:19001,localhost:19002,localhost:19003
sleep 5
echo -e "Adding Shards"
port_prefix=2700
for shard in "${shards[@]}";do 
	$bin_dir/mongo --quiet --eval "printjson(db.getSisterDB('admin').runCommand({addShard: '${shard}/localhost:${port_prefix}1'}))" 
	port_prefix=$((port_prefix + 100))
done
echo -e "Service\t\tPortRange"
echo -e "Mongos\t\t27017"
echo -e "Config\t\t19001-19003"
port_prefix=2700
for shard in "${shards[@]}";do
	echo -e "${shard}\t\t${port_prefix}1-${port_prefix}3"
	port_prefix=$((port_prefix + 100))
done
