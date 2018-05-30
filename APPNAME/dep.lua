#!/usr/bin/env tarantool

local fio = require 'fio'
local yaml = require 'yaml'

local luaroot = debug.getinfo(1,"S")
local source  = fio.abspath(luaroot.source:match('^@(.+)'));
local script_path = source:match("^(.*/)")
local appname = script_path:match("^.*/([^/]+)/")

local args = {
	['--luarocks-config'] = os.getenv('HOME')..'/.luarocks/config.lua';
	['--meta-file']       = '';
	['--luarocks-tree']   = nil;
	['--dev']             = nil;
}

for i = 1,#arg/2 do args[ arg[i*2-1] ] = arg[i*2] end

local meta_file = fio.abspath( args['--meta-file'] )
local metatext = fio.open(meta_file):read(2^20)
local cfg = metatext:match('^%s*%{') and require'json'.decode(metatext) or yaml.decode(metatext)
assert(cfg,"config not loaded")
local tree = args['--luarocks-tree']
cfg.name = cfg.name or appname
assert(cfg.name, "Name must be defined")
local function debug(f,...)
	print(string.format('[%s] '..f,cfg.name,...))
end
debug('Installing dependencies...')

local function install(dep)
	local cmd = {'luarocks', 'install'}
	if tree then
		table.insert(cmd,'--tree='..tree)
	elseif args['--local'] then
		table.insert(cmd,'--local')
	end
	table.insert(cmd,dep)
	local raw_cmd = table.concat(cmd,' ')
	debug("%s...",raw_cmd)
	local res = os.execute(raw_cmd)
	if res ~= 0 then
		error(string.format("[%s] %s: failed to install",cfg.name, dep))
	end
	debug("%s: success", table.concat(cmd,' '))
end

if cfg.tnt_deps then
	(function()
		local path = args['--luarocks-config']
		local dir = fio.dirname(path)
		if not fio.path.is_dir(dir) then
			fio.mkdir(dir)
		end
		if fio.path.exists(path) then
			local data = fio.open(path):read()
			if data:match('rocks%.tarantool%.org') then
				debug("Already have rocks.tarantool.org")
				return
			end
		end
		debug("Patch %s with rocks.tarantool.org",path)
		local fh = fio.open(path,{'O_APPEND','O_RDWR'})
		fh:write('\nrocks_servers = {[[http://rocks.tarantool.org/]]}\n')
		fh:close()
	end)()
	for _,dep in pairs(cfg.tnt_deps) do
		install(dep)
	end
	debug("Installed %s",dep)
end
if cfg.deps then
	for _,dep in pairs(cfg.deps) do
		install(dep)
		debug("Installed %s",dep)
	end
end
