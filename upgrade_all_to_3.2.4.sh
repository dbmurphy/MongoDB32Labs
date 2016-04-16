. config.conf


echo -e "Killing all processes"
killall mongod mongosi 2>&1 > /dev/null
echo -e "sleeping to let proccesses cleanup (3)"
sleep 3
echo -e "Changing bin_dir to 3.2"
./set_bin_dir.sh  ./3.2/bin $mongo_dbpath_root

echo -e "Reloading config!"
. config.conf
echo -e $bin_dir
echo -e Start the processes on 3.2

#replSet1
for i in `seq 1  2`;do
	$bin_dir/mongod --fork --logpath ${mongo_dbpath_root}/r1-${i}/mongo.log  --dbpath $mongo_dbpath_root/r1-${i} --port 1700${i} --replSet r1 --shardsvr --nohttpinterface --storageEngine mmapv1
done
	#Already moved this to wiredTiger do not need to force MMAPv1
	$bin_dir/mongod --fork --logpath ${mongo_dbpath_root}/r1-3/mongo.log  --dbpath $mongo_dbpath_root/r1-3 --port 17003 --replSet r1 --shardsvr --nohttpinterface
#replSet2
for i in `seq 1  2`;do
	$bin_dir/mongod --fork --logpath ${mongo_dbpath_root}/r2-${i}/mongo.log  --dbpath $mongo_dbpath_root/r2-${i} --port 1800${i} --replSet r2 --shardsvr --nohttpinterface --storageEngine mmapv1
done
	# Already moved this to wiredTiger do not need to force MMAPv1
	$bin_dir/mongod --fork --logpath ${mongo_dbpath_root}/r2-3/mongo.log  --dbpath $mongo_dbpath_root/r2-3 --port 18003 --replSet r2 --shardsvr --nohttpinterface
#config
for i in `seq 1  3`;do
	$bin_dir/mongod --fork --logpath ${mongo_dbpath_root}/c${i}/mongo.log  --dbpath $mongo_dbpath_root/c${i} --port 1900${i} --configsvr
done


#mongos
echo -e "Starting Mongos"
$bin_dir/mongos --fork --logpath ${mongo_dbpath_root}/m1/mongos.log --configdb localhost:19001,localhost:19002,localhost:19003
sleep 5

echo -e  "Service\t\tPortRange"
echo -e  "Mongos\t\t27017"
echo -e  "Config\t\t19001-19003"
echo -e  "Shard1\t\t17001-17003"
echo -e  "Shard2\t\t18001-18003"
