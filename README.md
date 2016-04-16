# MongoDB32Labs
Labs and Setup for 3.2 Talk


###Files and their purposes
| First Header  | Second Header |
| ------------- | ------------- |
|fast_run.sh | Runs the following sub-commands to build a cluster in 3.0, then upgrade it to 3.2 with WiredTiger, new Replication Protocol and  ReplicaSet based config servers|
|get_mongod_downloads.sh | Detects OSX vs Linux and download  3.0.11 and 3.2.4 into  3.0/ and 3.2/ folders inside them a bin folder exists with binaries|
|>build_procceses.sh | This build 2 replia-sets/shards with 3 members each, 3 config servers, and 1 mongos now and outputs their port ranges|
|>>config_replset.js| To build the replica sets this javascript code is called to initalise them|
|>populate_data_sharded_and_unsharded.sh| This is used to create a samples database with 2 collections where one is sharded and the other is not. Sharding and data creation are both done for you.|
|>>populate_fakedata.js| This is the functions the above code executes to preform those tasks|
|>make_secondaries_wt.sh|Takes r1-3 and r2-3 and rebuilds them as wiredTiger nodes but deleting their data, changing the startup to
use wired tiger, then resyncing|
|>upgrade_all_to_3.2.4.sh| This upgrades all the binaries to 3.2 this is all replica nodes, config nodes, and mongos node|
|>upgrade_replica_proto_version.sh| This logs into r1 and r2 replicasets's primaries and then reconfigures them to allow the new 
dumps and restoes 1 to make it wiredTiger and starts as replset also|
|>>upgrade_replica_proto_version.js| This is the underlying code doing the reconfiguration|
|>upgrade_config_to_replicaset.sh| This is a bit of a cheat is kills all configs and the mongos, restarts 2&3 as replica members, dumps and restoes 1 to make it wiredTiger and starts as replset also|
|reset_lab.sh| Special code to cleanup your downloaded, dumped, and created folders allowing you to reset the lab to a refresh version|
|set_bin_dir.sh| Used by a few scripts to update config.conf , spefically the bin_dir and mongo_dbpath_root folder locations|
|config.conf| Stores the config so multiple scripts can jsut source it to make things cleaner|


This Lab is built to go with the Percona Live 2016 SJC Tutorial on MongoDB 3.2 -  *MongoDB 3.2: Getting the most out of it*


##To Run
Simple run ./fast_run.sh after cloning , or run the scripts manually based on the order above


##Known issues
###wger versions
Some linux builds use wget 1.15 it has been found sometimes using https://  urls return 503 Service Unavailable, if this is the case replace https with http in get_mongod_downloads.sh 

### Expected errors due to db.shutdownServer()
restore from mmap into wiredtiger
MongoDB shell version: 3.2.4
connecting to: 127.0.0.1:44444/test
2016-04-16T22:08:11.815+0100 E QUERY    [thread1] Error: error doing query: failed: network error while attempting to run command 'shutdown' on host '127.0.0.1:44444'  :
DB.prototype.runCommand@src/mongo/shell/db.js:132:1
