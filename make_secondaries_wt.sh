. config.conf
#Start the processes

#replSet1
	kill `ps auux | grep 17003 | grep -v grep | awk '{print $2}'` 2>&1 > /dev/null
	rm -rf ${mongo_dbpath_root}/r1-3/*
	sleep 3
	"$bin_dir/mongod" --fork --logpath ${mongo_dbpath_root}/r1-3/mongo.log  --dbpath ${mongo_dbpath_root}/r1-3 --port 17003 --replSet r1 --shardsvr --nohttpinterface  --storageEngine wiredTiger

#replSet2
	kill `ps auux | grep 18003| grep -v grep | awk '{print $2}'` 2>&1 >/dev/null
	rm -rf ${mongo_dbpath_root}/r2-3/* 
	sleep 3
	"$bin_dir/mongod" --fork --logpath ${mongo_dbpath_root}/r2-3/mongo.log  --dbpath ${mongo_dbpath_root}/r2-3 --port 18003 --replSet r2 --shardsvr --nohttpinterface --storageEngine wiredTiger

