//Build Schemas

function get_string(length,chars){
    var result = '';
    for (var i = length; i > 0; --i) result += chars[Math.round(Math.random() * (chars.length - 1))];
    return result;
}

function get_string_string(length){
    chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return get_string(length,chars);
}
function get_string_int(length){
    chars = '0123456789';
    return get_string(length,chars);	
}

function generate_doc(){
	string2 = get_string_int(5);
	comment1 = get_string_string(2048)
	doc = {
		time: ISODate(),
		b1:  Math.random()* 100 > 50,
		s1:  get_string_string(32),
		s2:	 string2, 
		i1:  parseInt(string2),
		user_id :  Math.round(Math.random()* 10000000000),
		comments: [
			comment1,get_string_string(2048),get_string_string(2048),get_string_string(2048),get_string_string(2048),get_string_string(2048)
		],
		comment_bin : BinData(0,comment1),
		friends: [ 
			parseInt(get_string_int(16)),
			parseInt(get_string_int(16)),
			parseInt(get_string_int(16)),
			parseInt(get_string_int(16)),
			parseInt(get_string_int(16)),
			parseInt(get_string_int(16)),
			parseInt(get_string_int(16)),
			parseInt(get_string_int(16)),
			parseInt(get_string_int(16))]
	};
	return doc;
}

function enable_profiler(db,level,sizeMB){
	shard=db.getSiblingDB('config').databases.findOne({_id:"samples"}).primary;
	host =  db.getSiblingDB('config').shards.findOne({_id:shard}).host;
	newCon = new Mongo(host);
	newCon = newCon.getDB('samples');
	printjson(newCon.setProfilingLevel(0));
	printjson(newCon.system.profile.drop());
	printjson(newCon.runCommand( { create: "system.profile", capped: true, size: (sizeMB * 1024 * 1024) } ))	;
	printjson(newCon.setProfilingLevel(2));

}

function generate_someprofileentries(db){
	points = Math.round(Math.random()*1000,2)
	range_good = Math.round((Math.random()*1000)/10,2)
	range_bad = Math.round((Math.random()*1000)/20,2)
	unindexed = 100 
	print("Running "+points+" point queries");
	point_queries(db,"col1",points);
	print("Running "+range_good+" range queries");
	range_queries(db,"col1",range_good,true,false);
	print("Running "+range_good+" range queries with sort");
	range_queries(db,"col1",range_good,true,true);
	print("Running "+range_bad+" bad range queries");
	range_queries(db,"col1",range_bad,false,false);
	print("Running "+range_bad+" bad range queries with sort");
	range_queries(db,"col1",range_bad,false,true);
	print("Running "+unindexed+" table scan queries");
	table_scan(db,"col1",unindexed);
	return true
}
function point_queries(db,collection,count){
	for (i = 0; i < count; i++) { 
		db.getCollection(collection).find({user_id: Math.round(Math.random()* 10000000000)}).forEach(function(doc){x=doc});
	}
}
function table_scan(db,collection,count){
	for (i = 0; i < count; i++) { 
		db.getCollection(collection).find().forEach(function(doc){x=doc});
	}
}
function range_queries(db,collection,count,useIndex,useSort){
	for (i = 0; i < count; i++) { 
		findDoc = {};
		if (useIndex == true){
			range = [ Math.round(Math.random()* 10000000000) ,  Math.round(Math.random()* 10000000000) ].sort()
			findDoc['$query']= { user_id : { $lt : range[0], $gte : range[1] }};
		}
		else{
			range = [ get_string_int(5) ,  get_string_int(5) ].sort()
			findDoc['$query']= { s2 : { $lt : range[0], $gte : range[1] }};
		}
		if (useSort == true){
			findDoc['$orderby'] = { user_id:1};
		}
		db.getCollection(collection).find(findDoc).forEach(function(doc){x=doc});

	}
}




db=db.getMongo().getDB('samples');
print("Enabled sharding on samples")
printjson(db.adminCommand({ enableSharding : 'samples' }))
col1 = db.getCollection('col1');
col2 = db.getCollection('col2');

col1.ensureIndex({user_id:1})
print("Populating col1");
while(col1.count()< Math.pow(10,4) ){
	col1.insert(generate_doc());
}
print("Populating col2");
while(col2.count()< Math.pow(10,4)){
	col2.insert(generate_doc());
}
print("Shard col1 with hashed index on _id")
db.col2.ensureIndex({"_id":"hashed"});
printjson(sh.shardCollection("samples.col2", {_id:"hashed"}))
enable_profiler(db,2,100);

print("Run profiler data generation on col1")
generate_someprofileentries(db)


