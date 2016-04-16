. config.conf 
if [ -z $mongo_dbpath_root ]
then
	echo "BAILING! - dbpath was empty would have removed /"
	exit 255
fi

rm -rf ${mongo_dbpath_root}/* ${start_dir}/config_dump
killall mongos mongod
rm -rf ${start_dir}/3.0 ${start_dir}/3.2
${start_dir}/set_bin_dir.sh ./3.0/bin /labs
