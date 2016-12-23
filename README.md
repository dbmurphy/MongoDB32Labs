# MongoDB32Labs
Labs and Setup for 3.2 Talk


###Files and their purposes
| First Header  | Second Header |
| ------------- | ------------- |
|fast_run.sh | Runs the following sub-commands to build a cluster in 3.0, then upgrade it to 3.2 with WiredTiger, new Replication Protocol and  ReplicaSet based config servers|
|get_mongod_downloads.sh | Detects OSX vs Linux and download 2.6.12, 3.0.11 and 3.2.4 into  2.6, 3.0/ and 3.2/ folders inside them a bin folder exists with binaries|
|>build_procceses.sh | This build N replia-sets/shards with 3 members each, 3 config servers, and 1 mongos now and outputs their port ranges|
|>>config_replset.js| To build the replica sets this javascript code is called to initalise them|
|>populate_data_sharded_and_unsharded.sh| This is used to create a samples database with 2 collections where one is sharded and the other is not. Sharding and data creation are both done for you.|
|reset_lab.sh| Special code to cleanup your downloaded, dumped, and created folders allowing you to reset the lab to a refresh version|
|set_bin_dir.sh| Used by a few scripts to update config.conf , spefically the bin_dir and mongo_dbpath_root folder locations|
|config.conf| Stores the config so multiple scripts can jsut source it to make things cleaner|


##To Run
Simple run ./fast_run.sh after cloning , or run the scripts manually based on the order above


##Known issues
###wget versions
Some linux builds use wget 1.15 it has been found sometimes using https://  urls return 503 Service Unavailable, if this is the case replace https with http in get_mongod_downloads.sh 

### Expected errors due to db.shutdownServer()
restore from mmap into wiredtiger
MongoDB shell version: 3.2.4
connecting to: 127.0.0.1:44444/test
2016-04-16T22:08:11.815+0100 E QUERY    [thread1] Error: error doing query: failed: network error while attempting to run command 'shutdown' on host '127.0.0.1:44444'  :
DB.prototype.runCommand@src/mongo/shell/db.js:132:1
