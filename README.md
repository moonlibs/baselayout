* Use your myappname instead of APPNAME
* For development environment APPNAME is fetched as containing folder name
* Reside your complete app layout in `app/`, starting from `app/myappname.lua`
* Install dependencies with `make dep`
* Create rpm package with `make build`
* Create as much instances, as you need, with symlinks to init lua
* Dev instance may be started with
	* tarantoolctl to symlink (ex: `tarantoolctl start instance_001`)
	* tarantool to symlink (ex: `tarantool instance_001`)
* In production environment application is installed in `/usr/share/APPNAME/...` with all dependencies
* Live instances creates as symlink in `/etc/tarantool/instances.enables/instance_xxx.lua` -> `/usr/share/APPNAME/init.lua`

# Bootstrap
To boostrap your own application rename variable `MYAPPNAME` inside `bootstrap.sh` and execute bootstrap.
