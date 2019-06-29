
function clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local newObject = {}
        lookup_table[object] = newObject
        for key, value in pairs(object) do
            newObject[_copy(key)] = _copy(value)
        end
        return setmetatable(newObject, getmetatable(object))
    end
    return _copy(object)
end
function string.trim(input)
    input = string.gsub(input, "^[ \t\n\r]+", "")
    return string.gsub(input, "[ \t\n\r]+$", "")
end
function string.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end
local function dump_value_(v)
    if type(v) == "string" then
        v = "\"" .. v .. "\""
    end
    return tostring(v)
end
function dump(value, description, nesting)
    if type(nesting) ~= "number" then nesting = 3 end

    local lookupTable = {}
    local result = {}

    local traceback = string.split(debug.traceback("", 2), "\n")
    print("dump from: " .. string.trim(traceback[3]))

    local function dump_(value, description, indent, nest, keylen)
        description = description or "<var>"
        local spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(dump_value_(description)))
        end
        if type(value) ~= "table" then
            result[#result +1 ] = string.format("%s%s%s = %s", indent, dump_value_(description), spc, dump_value_(value))
        elseif lookupTable[tostring(value)] then
            result[#result +1 ] = string.format("%s%s%s = *REF*", indent, dump_value_(description), spc)
        else
            lookupTable[tostring(value)] = true
            if nest > nesting then
                result[#result +1 ] = string.format("%s%s = *MAX NESTING*", indent, dump_value_(description))
            else
                result[#result +1 ] = string.format("%s%s = {", indent, dump_value_(description))
                local indent2 = indent.."    "
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = dump_value_(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then keylen = vkl end
                    values[k] = v
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    dump_(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result +1] = string.format("%s}", indent)
            end
        end
    end
    dump_(value, description, "- ", 1)

    for i, line in ipairs(result) do
        print(line)
    end
end
function calHashCard( source )
	local result = {}
	for i,v in ipairs( source ) do
		if result[v] == nil then
			result[v] = 1
		else
			result[v] = result[v] + 1
		end
	end
	return result
end
function checkHuBySource( source )
	-- 1:余牌数量为0 则返回 "能胡牌"
	if #source == 0 then
		return true
	end
	-- 2:判断前三张是否相同
	if source[1] == source[2] and source[1] == source[3] then
		-- 相同 移除前三张
		for i = #source,1,-1 do
			if i <= 3 then
				table.remove(source,i)
			end
		end
		-- 递归再次验证
		return checkHuBySource(source)
	else
		-- 不同 判断是否存在顺子
		local num1 = source[1]
		local num2 = num1 + 1
		local num3 = num1 + 2
		if checkHasNumBySource( source,num2 ) and checkHasNumBySource( source,num3 ) then
			-- 移除这三张牌
			local has1,index1 = checkHasNumBySource( source,num1 )
			table.remove( source,index1 )
			local has2,index2 = checkHasNumBySource( source,num2 )
			table.remove( source,index2 )
			local has3,index3 = checkHasNumBySource( source,num3 )
			table.remove( source,index3 )
			-- 递归再次验证
			return checkHuBySource(source)
		end
	end
	return false
end
-- 计算当前的手牌能不能胡
function checkHu( cardNum,source )
	-- 构造新的手牌数组
	local new_source = clone( source )
	table.insert( new_source,cardNum )
	table.sort( new_source )

	-- 步骤1 从上述数组中找到一对做"将",并从数组中移除
	local hash_card = calHashCard( new_source )
	local jiang = {}
	for k,v in pairs( hash_card ) do
		if v >= 2 then
			table.insert( jiang,k )
		end
	end
	local remove_jiang = {}
	for i,v in ipairs( jiang ) do
		local left = clone( new_source )
		local temp = 0
		for a = #left,1,-1 do
			if left[a] == v and temp < 2 then
				table.remove( left,a )
				temp = temp + 1
			end
		end
		table.insert( remove_jiang,left )
	end

	-- 步骤2 每组进行检查
	for i,v in ipairs( remove_jiang ) do
		local can = checkHuBySource(v)
		if can then
			return true
		end
	end

	return false
end
function checkHasNumBySource( source,num )
	if num > 9 then
		return false
	end
	for i,v in ipairs(source) do
		if v == num then
			return true,i
		end
	end
	return false
end

local pai = { 5,5,6,6,7,7,7 }

function getHuResult()
	local result = {}
	for i = 1,9 do
		local can = checkHu(i,pai)
		if can then
			table.insert( result,i )
		end
	end
	local oo = { 11,21,31,41,51,61,71 }
	for i,v in ipairs(oo) do
		local can = checkHu(v,pai)
		if can then
			table.insert( result,v )
		end
	end
	dump( result,"---------------> result = " )
	return result
end

getHuResult()