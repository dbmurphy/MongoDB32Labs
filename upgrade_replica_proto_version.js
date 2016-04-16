cfg = rs.conf();
//print("Old Replication Config")
//printjson(cfg);
cfg.protocolVersion=1;
print("Command Result for "+cfg._id)
printjson(rs.reconfig(cfg));
//print("New Replication Config")
//printjson(rs.conf())
