
	port=parseInt(db.adminCommand("getCmdLineOpts").parsed.net.port)
	port2=port+1;
	port3=port+2;

	conf = {
		_id : replSet,
		members: [
			{ _id:0 , host:"localhost:"+port,priority:10},
			{ _id:1 , host:"localhost:"+port2},
			{ _id:2 , host:"localhost:"+port3},
		]
	};	
		
	printjson(conf)
	printjson(rs.initiate(conf));

