./get_mongod_downloads.sh
./build_procceses.sh
sleep 2
./populate_data_sharded_and_unsharded.sh
./make_secondaries_wt.sh
./upgrade_all_to_3.2.4.sh
sleep 2
./upgrade_replica_proto_version.sh
./upgrade_config_to_replicaset.sh
