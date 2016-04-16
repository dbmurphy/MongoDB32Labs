. config.conf


echo "Killing all processes"
kill `ps auux | egrep '19001|19002|19003|mongos' | grep -v egrep| awk '{print $2}'` 2>&1 > /dev/null
echo "sleeping to let proccesses cleanup (3)"
sleep 3

echo "Changing bin_dir to 3.2"
./set_bin_dir.sh  ./3.2/bin $mongo_dbpath_root

echo "Reloading config!"
. config.conf

echo Rebuild first config server as WiredTiger and replicaset, then formatting other config serers as WiredTiger and replicating from the first server as a replicaset

for i in `seq 2  3`
do
                rm -rf $mongo_dbpath_root/c${i}/*
                $bin_dir/mongod --storageEngine wiredTiger --replSet config --fork --logpath ${mongo_dbpath_root}/c${i}/mongo.log  --dbpath $mongo_dbpath_root/c${i} --port 1900${i} --configsvr
done

for i in 1;do
	echo "proceesing c${i}"
	echo "starting c${i} on none standard port"
	$bin_dir/mongod --fork --logpath ${mongo_dbpath_root}/c${i}/mongo.log  --dbpath $mongo_dbpath_root/c${i} --port 44444
	echo "dumping data to ${start_dir}/config_dump/ "
	$bin_dir/mongodump --quiet --port 44444 -o config_dump 
	echo "requesting shutdown after dump"
	$bin_dir/mongo --port 44444 --eval "db.getSisterDB('admin').runCommand({shutdown:1})"
	rm -rf $mongo_dbpath_root/c${i}/*
	sleep 3
	echo "Restarting on non-standard port with empty folder and  as wiredTiger"
	$bin_dir/mongod --storageEngine wiredTiger --fork --logpath ${mongo_dbpath_root}/c${i}/mongo.log  --dbpath $mongo_dbpath_root/c${i} --port 44444
	echo "restore from mmap into wiredtiger"
	$bin_dir/mongorestore --quiet --port 44444 config_dump 
	$bin_dir/mongo --port 44444 --eval "db.getSisterDB('admin').runCommand({shutdown:1})"
	sleep 3
	echo "restarting into normal mode as part of the replset and as wiredtiger"
	$bin_dir/mongod --storageEngine wiredTiger --replSet config --fork --logpath ${mongo_dbpath_root}/c${i}/mongo.log  --dbpath $mongo_dbpath_root/c${i} --port 1900${i} --configsvr
	echo "Initialize first config as a replicaset ( this will not remove data)"
	$bin_dir/mongo --port 19001 --eval "var replSet='config'" "${start_dir}/config_replset.js"
	echo "Sleeping to allow the nows to do an initial sync (15), this takes a bit longer than normal the first time!"
	sleep 15
	$bin_dir/mongo --port 19001 --eval "rs.status()"
done


#mongos
echo "Starting Mongos"
$bin_dir/mongos --fork --logpath ${mongo_dbpath_root}/m1/mongos.log --configdb config/localhost:19001,localhost:19002,localhost:19003
sleep 5


