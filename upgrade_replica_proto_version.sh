. config.conf

echo "Upgrading ReplSet1 to new protocol version"
$bin_dir/mongo --port 17001 --quiet --eval "var replSet='r1'" "${start_dir}/upgrade_replica_proto_version.js"
sleep 5
echo "Upgrading ReplSet2 to new protocol version"
$bin_dir/mongo --port 18001 --quiet --eval "var replSet='r2'" "${start_dir}/upgrade_replica_proto_version.js"
sleep 5
