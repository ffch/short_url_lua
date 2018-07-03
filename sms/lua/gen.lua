local code = require("code")  
local db = require("db")  
local cjson = require "cjson"

local request_method = ngx.var.request_method
local args = nil
local param = nil
--获取参数的值
if "GET" == request_method then
    args = ngx.req.get_uri_args()
elseif "POST" == request_method then
    ngx.req.read_body()
    args = ngx.req.get_post_args()
end
param = args["url"]
if not param then
	ngx.say("failed to get url: ", err)
    return
end

ngx.say("ngx.params : ", param, "<br/>")  
local res = db.genCode(param);
ngx.say("ngx.genCode_res : ", cjson.encode(res), "<br/>") 
