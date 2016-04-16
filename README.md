# MongoDB32Labs
Labs and Setup for 3.2 Talk


###Files and their purposes
| First Header  | Second Header |
| ------------- | ------------- |
|fast_run.sh | Runs the following sub-commands to build a cluster in 3.0, then upgrade it to 3.2 with WiredTiger, new Replication Protocol and  ReplicaSet based config servers|
|get_mongod_downloads.sh | Detects OSX vs Linux and download  3.0.11 and 3.2.4 into  3.0/ and 3.2/ folders inside them a bin folder exists with binaries|
|  build_procceses.sh | This build 2 replia-sets/shards with 3 members each, 3 config servers, and 1 mongos now and outputs their port ranges|
|     config_replset.js| To build the replica sets this javascript code is called to initalise them|
|  populate_data_sharded_and_unsharded.sh| This is used to create a samples database with 2 collections where one is sharded and the other is not. Sharding and data creation are both done for you.|
|    populate_fakedata.js| This is the functions the above code executes to preform those tasks|
|    make_secondaries_wt.sh|Takes r1-3 and r2-3 and rebuilds them as wiredTiger nodes but deleting their data, changing the startup to
use wired tiger, then resyncing|
|  upgrade_all_to_3.2.4.sh| This upgrades all the binaries to 3.2 this is all replica nodes, config nodes, and mongos node|
|  upgrade_replica_proto_version.sh| This logs into r1 and r2 replicasets's primaries and then reconfigures them to allow the new 
dumps and restoes 1 to make it wiredTiger and starts as replset also|
|    upgrade_replica_proto_version.js| This is the underlying code doing the reconfiguration|
|  upgrade_config_to_replicaset.sh| This is a bit of a cheat is kills all configs and the mongos, restarts 2&3 as replica members, dumps and restoes 1 to make it wiredTiger and starts as replset also|
|reset_lab.sh| Special code to cleanup your downloaded, dumped, and created folders allowing you to reset the lab to a refresh version|
|set_bin_dir.sh| Used by a few scripts to update config.conf , spefically the bin_dir and mongo_dbpath_root folder locations|
|config.conf| Stores the config so multiple scripts can jsut source it to make things cleaner|


This Lab is built to go with the Percona Live 2016 SJC Tutorial on MongoDB 3.2 -  *MongoDB 3.2: Getting the most out of it*


