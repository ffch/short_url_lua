local mysql = require "resty.mysql"
local _M = {} 
host = "192.168.1.216"
port = 3306
database = "sms_sharding"
user = "sms"
password = "sms123"
charset = "utf8"
max_packet_size = 1024 * 1024
function _M.connect()
    db, err = mysql:new()
	if not db then
		ngx.say("failed to instantiate mysql: ", err)
		return
	end
	db:set_timeout(1000) 
	local ok, err, errcode, sqlstate = db:connect{
		host,
		port,
		database,
		user,
		password,
		charset,
		max_packet_size,
	}
	if not ok then
		ngx.say("failed to connect: ", err, ": ", errcode, " ", sqlstate)
		return
	end
	return db
end

function _M.insert(db,sql)
	--local sql = "select url from t_short_url where surl = " .. 
    local res, err, errcode, sqlstate =
		db:query(sql)
	if not res then
		ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
		return
	end
	return res
end

function _M.insertUrl(db,surl,url,hash)
	local sql = "insert into t_short_url(surl,url,hash) values (" .. surl .."," .. url .."," ..hash
    local res, err, errcode, sqlstate =
		db:query(sql)
	if not res then
		ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
		return
	end
	return res
end

function _M.query(db,sql)
	--local sql = "select url from t_short_url where surl = " .. 
    local res, err, errcode, sqlstate =
		db:query(sql)
	if not res then
		ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
		return
	end
	return res
end

function _M.queryLimit(db,sql,n)
	--local sql = "select url from t_short_url where surl = " .. 
    local res, err, errcode, sqlstate =
		db:query(sql,n)
	if not res then
		ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
		return
	end
	return res
end

function _M.queryUrl(db,surl)
	local sql = "select url from t_short_url where surl = " ..surl 
    local res, err, errcode, sqlstate =
		db:query(sql,1)
	if not res then
		ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
		return
	end
	return res
end

function _M.queryMaxId(db)
	local sql = "select max(id)+1 from t_short_url" 
    local res, err, errcode, sqlstate =
		db:query(sql,1)
	if not res then
		ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
		return
	end
	return res
end

return _M 