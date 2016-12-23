mkdir -p {2.6,3.0,3.2,3.4}
uname -a | grep 'Darwin' 2>&1 >/dev/null
if [ $? -eq 0  ]
then 
	echo "Downloading Binaries for OSX"
	wget -q --show-progress https://fastdl.mongodb.org/osx/mongodb-osx-x86_64-2.6.12.tgz
	wget -q --show-progress https://fastdl.mongodb.org/osx/mongodb-osx-x86_64-3.0.11.tgz 
	wget -q --show-progress https://fastdl.mongodb.org/osx/mongodb-osx-x86_64-3.2.4.tgz 
	wget -q --show-progress https://fastdl.mongodb.org/osx/mongodb-osx-ssl-x86_64-3.4.1.tgz
	
	echo -e "Decompressing downloads"
	gzip -d mongodb-osx-x86_64-2.6.12.tgz
	tar xf mongodb-osx-x86_64-2.6.12.tar -C 2.6 --strip-components=1
	gzip -d mongodb-osx-x86_64-3.0.11.tgz
	tar xf mongodb-osx-x86_64-3.0.11.tar -C 3.0 --strip-components=1
	gzip -d mongodb-osx-x86_64-3.2.4.tgz
	tar xf mongodb-osx-x86_64-3.2.4.tar -C 3.2 --strip-components=1
	gzip -d mongodb-osx-ssl-x86_64-3.4.1.tgz
	tar xf mongodb-osx-ssl-x86_64-3.4.1.tar -C 3.4 --strip-components=1
        
	echo "Cleaning up compressed files"
	rm mongodb-osx-x86_64-2.6.12.tar
	rm mongodb-osx-x86_64-3.2.4.tar
	rm mongodb-osx-x86_64-3.0.11.tar
	rm mongodb-osx-ssl-x86_64-3.4.1.tgz
else
	echo "Downloading Binaries for Linux x86_64 generic"
	wget --help | grep show-progress > /dev/null 
	if [ "$?" -eq 0 ]
	then
		wget -q --show-progress https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.6.12.tgz
		wget -q --show-progress https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.0.11.tgz
		wget -q --show-progress https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.2.4.tgz
		wget -q --show-progress https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-amazon-3.4.1.tgz
	else
		wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.6.12.tgz
		wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.0.11.tgz
        wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.2.4.tgz
        wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-amazon-3.4.1.tgz
	fi

	echo "Decompressing downloads"
	gzip -d mongodb-linux-x86_64-2.6.12.tgz
	tar xf mongodb-linux-x86_64-2.6.12.tar -C 2.6 --strip-components=1
	gzip -d mongodb-linux-x86_64-3.0.11.tgz
	tar xf mongodb-linux-x86_64-3.0.11.tar -C 3.0 --strip-components=1
 	gzip -d mongodb-linux-x86_64-3.2.4.tgz 
	tar xf mongodb-linux-x86_64-3.2.4.tar -C 3.2 --strip-components=1
	gzip -d mongodb-linux-x86_64-amazon-3.4.1.tgz 
	tar xf mongodb-linux-x86_64-amazon-3.4.1.tar -C 3.4 --strip-components=1
	
	echo "Cleaning up compressed files"
	rm mongodb-linux-x86_64-2.6.12.tar
	rm mongodb-linux-x86_64-3.0.11.tar
    rm mongodb-linux-x86_64-3.2.4.tar
    rm mongodb-linux-x86_64-amazon-3.4.1.tar
fi


