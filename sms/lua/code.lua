local _M = {} 

function _M.encodeBase62(src)
    local b64chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    local res = ''
	local multiple = 0
	local num = math.abs(src)
	while num > 0 do
		local decimal = num%62
		num = math.floor(num/62)
		res = string.sub(b64chars,decimal+1,decimal+1) ..res
	end
	
	return res
end

function _M.encodeFormatBase62(src)
    local b64chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    local res = ''
	local multiple = 0
	local num = math.abs(src)
	while num > 0 do
		local decimal = num%62
		num = math.floor(num/62)
		res = string.sub(b64chars,decimal+1,decimal+1) ..res
	end
	local len = #res
	if len < 4 then
		for i=1, 4-len do
			res = string.sub(b64chars,1,1) ..res
		end
	end
	return res
end

function _M.decodeBase62(str62)
     local b62chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    local temp={}
    for i=0,61 do
        temp[string.sub(b62chars,i+1,i+1)] = i
    end
	local data = 0
    for i=1,#str62 do
        if i > #str62 then
            break
        end
		local str1=string.sub(str62,i,i)
		
		if not temp[str1] then
            return
		end
		data = data * 62 + temp[str1]
    end
 
    return data
end

function _M.hashConvert(v)  
    local ch = 0  
    local val = 0  
      
    if(v) then  
        for i=1,#v do  
            ch = v:byte(i)  
            if( ch >= 65 and ch <= 90 ) then  
                ch = ch + 32  
            end  
            val = val*0.7 + ch  --0.7是加权  
        end  
    end  
    val = val .. ''  
    val = val:gsub("+","")  
    val = val:gsub("%.","")  

    return string.format('%s',val)    
end 
return _M 