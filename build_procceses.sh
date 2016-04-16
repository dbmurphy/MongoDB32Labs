. config.conf
#Build the main data folders
mkdir -p $mongo_dbpath_root
cd $mongo_dbpath_root
mkdir -p {r1-1,r1-2,r1-3,r2-1,r2-2,r2-3,c1,c2,c3,m1}/data

cd "$start_dir"
#Start the processes

#replSet1
for i in `seq 1 3`;do
	$bin_dir/mongod --fork --logpath $mongo_dbpath_root/r1-${i}/mongo.log --dbpath $mongo_dbpath_root/r1-${i} --port 1700${i} --replSet r1 --shardsvr --nohttpinterface 
done

#replSet2
for i in `seq 1 3`;do
	$bin_dir/mongod --fork --logpath $mongo_dbpath_root/r2-${i}/mongo.log --dbpath $mongo_dbpath_root/r2-${i} --port 1800${i} --replSet r2 --shardsvr --nohttpinterface
done

#config
for i in `seq 1 3`;do
	$bin_dir/mongod --fork --logpath $mongo_dbpath_root/c${i}/mongo.log --dbpath $mongo_dbpath_root/c${i} --port 1900${i} --configsvr
done


echo -e "Building ReplSet1" 
$bin_dir/mongo --quiet --port 17001 --eval "var replSet='r1'" "${start_dir}/config_replset.js"
sleep 5
echo -e "Building ReplSet2"
$bin_dir/mongo --quiet --port 18001 --eval "var replSet='r2'" "${start_dir}/config_replset.js"
sleep 5

echo -e "Sleeping to be nice (20)..."
sleep 20

#mongos 
echo -e "Starting Mongos"
$bin_dir/mongos --fork --logpath $mongo_dbpath_root/m1/mongos.log --configdb localhost:19001,localhost:19002,localhost:19003
sleep 5
echo -e "Adding Shards"
$bin_dir/mongo --quiet --eval "printjson(db.getSisterDB('admin').runCommand({addShard: 'r1/localhost:17001'}))" 
$bin_dir/mongo --quiet --eval "printjson(db.getSisterDB('admin').runCommand({addShard: 'r2/localhost:18001'}))" 


echo -e "Service\t\tPortRange"
echo -e "Mongos\t\t27017"
echo -e "Config\t\t19001-19003"
echo -e "Shard1\t\t17001-17003"
echo -e "Shard2\t\t18001-18003"
