local db = require("db") 
local request_uri = ngx.var.uri ;  
local surl = string.sub(request_uri,2)
local url = db.getUrl(surl);
ngx.redirect(url)