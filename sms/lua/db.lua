local mysql = require "resty.mysql"
local code = require("code")  

local _M = {} 

function _M.genCode(url)
    local db, err = mysql:new()
	if not db then
		ngx.say("failed to instantiate mysql: ", err)
		return
	end
	db:set_timeout(1000) 
	local ok, err, errcode, sqlstate = db:connect{
		host = "192.168.1.216",
		port = 3306,
		database = "sms_sharding",
		user = "sms",
		password = "sms123",
		charset = "utf8",
		max_packet_size = 1024 * 1024,
	}
	if not ok then
		ngx.say("failed to connect: ", err, ": ", errcode, " ", sqlstate, "<br/>")
		return
	end
	local sql = "select max(id)+1 as id from t_short_url" 
    local res, err, errcode, sqlstate =
		db:query(sql,1)
	if not res then
		ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".","<br/>")
		return
	elseif #(res) > 0 then
		local id = tonumber(res[1]["id"])
		local surl = code.encodeFormatBase62(id)
		ngx.say("ngx.id : ", id, "<br/>") 
		ngx.say("ngx.surl : ", surl, "<br/>") 
		local hash = code.hashConvert(url)
		ngx.say("ngx.url.hash: ", hash, "<br/>") 
		local insql = "insert into t_short_url(surl,url,hash) values (\'" ..surl .."\',\'" ..url .."\',\'" ..hash .."\')"
		ngx.say("ngx.url.insql: ", insql, "<br/>") 
		res, err, errcode, sqlstate =
			db:query(insql)
		if not res then
			ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".","<br/>")
			return
		end 
		return res
	end	
end

function _M.getUrl(surl)
    local db, err = mysql:new()
	if not db then
		ngx.say("failed to instantiate mysql: ", err)
		return
	end
	db:set_timeout(1000) 
	local ok, err, errcode, sqlstate = db:connect{
		host = "192.168.1.216",
		port = 3306,
		database = "sms_sharding",
		user = "sms",
		password = "sms123",
		charset = "utf8",
		max_packet_size = 1024 * 1024,
	}
	if not ok then
		ngx.say("failed to connect: ", err, ": ", errcode, " ", sqlstate, "<br/>")
		return
	end
	local sql = "select url from t_short_url where surl = \'" .. surl .."\'"
    local res, err, errcode, sqlstate =
		db:query(sql,1)
	if not res then
		ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".","<br/>")
		return
	elseif #(res) > 0 then
		local url = res[1]["url"]
		return url
	end	
end

return _M 
