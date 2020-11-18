assert(instance_name, "instance_name is required from symlink")

etcd = {
	-- endpoints     = { 'http://127.0.0.1:4001','http://127.0.0.1:2379' }
	-- login         = "...",
	-- password      = "...",
	prefix        = '/my/tarantool/app';
	instance_name = instance_name;
	timeout       = 1;
	boolean_auto  = true,
}

box = {
	background              = true,
	pid_file                = instance_name..".pid",
	work_dir                = "/var/lib/tarantool/"..instance_name,
	memtx_dir               = "/var/lib/tarantool/snaps/"..instance_name,
	wal_dir                 = "/var/lib/tarantool/xlogs/"..instance_name,
}
