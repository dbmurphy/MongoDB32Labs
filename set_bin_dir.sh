. config.conf
if [ $# -gt 0 ]
then
	bin_dir_new=$1
	mongo_dbpath_root_new=$2
fi
if [ -z ${bin_dir_new} ]
then
	read -p "What should the binary directory for mongo processes be? [`echo $bin_dir]` > " bin_dir_new
fi

bin_dir_new=${bin_dir_new:-$bin_dir}

if [ -z ${mongo_dbpath_root_new} ]
then
	read -p "What should the root directory for all mongo dbpath's be? [`echo $mongo_dbpath_root`] > " mongo_dbpath_root_new
fi

mongo_dbpath_root_new=${mongo_dbpath_root_new:-$mongo_dbpath_root}

echo "Changing bin_dir to $bin_dir_new"
sed -i ""  "s|bin_dir.*|bin_dir=`echo $bin_dir_new`|" config.conf

echo "Changing mongo_dbpath_root to $mongo_dbpath_root_new"
sed -i "" "s|mongo_dbpath_root.*|mongo_dbpath_root=`echo $mongo_dbpath_root_new`|" config.conf

