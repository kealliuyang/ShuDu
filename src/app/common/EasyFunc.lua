--
-- Author   :   刘阳
-- Date     :   2018-09-04
-- Desc     :   这三个方法只是针对调试写日志的 后面会删掉 如果要用 改一下 easyWriteFileLog方法里面的路径





local function dump_value_disk(v)
    if type(v) == "string" then
        v = "\"" .. v .. "\""
    end
    return tostring(v)
end

local function dumpStrToDisk(value, description, nesting)
    if type(nesting) ~= "number" then nesting = 3 end

    local lookupTable = {}
    local result = {}

    local traceback = string.split(debug.traceback("", 2), "\n")
    --print("dump from: " .. string.trim(traceback[3]))

    local function dump_(value, description, indent, nest, keylen)
        description = description or "<var>"
        local spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(dump_value_disk(description)))
        end
        if type(value) ~= "table" then
            if description ~= "<var>" then
                result[#result +1 ] = string.format("%s%s%s = %s", indent, dump_value_disk(description), spc, dump_value_disk(value))
            else
                result[#result +1 ] = string.format("%s", dump_value_disk(value))
            end
        elseif lookupTable[tostring(value)] then
            result[#result +1 ] = string.format("%s%s%s = *REF*", indent, dump_value_disk(description), spc)
        else
            lookupTable[tostring(value)] = true
            if nest > nesting then
                result[#result +1 ] = string.format("%s%s = *MAX NESTING*", indent, dump_value_disk(description))
            else
                result[#result +1 ] = string.format("%s%s = {", indent, dump_value_disk(description))
                local indent2 = indent.."    "
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = dump_value_disk(k)
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
        easyWriteFileLog(line.."\r\n")
    end
end

-- 写入文件
local function easyWriteFileLog(content, mode)  
    mode = mode or "a+"
    local path = "D:\\111.lua"
    if cc.FileUtils:getInstance():isFileExist(path) then
        local file = io.open(path, mode)
        if file then  
            if file:write(content) == nil then return false end  
            io.close(file)  
            return true  
        else  
            return false  
        end
    end  
end


-- 秒数 -> 天,时,分,秒
local function getFormatTime(sec)
    assert( sec," !! sec is nil !! ")
    local secondsPerMinute = 60
    local minutesPerHour   = 60
    local hoursPerDay      = 24
    local secondsPerHour   = secondsPerMinute * minutesPerHour
    local secondsPerDay    = secondsPerHour   * hoursPerDay

    local days    = math.floor(sec / secondsPerDay)
    local hours   = math.floor((sec - days*secondsPerDay) / secondsPerHour)
    local minutes = math.floor((sec - days*secondsPerDay - hours*secondsPerHour) / secondsPerMinute)
    local seconds = math.floor(sec - days*secondsPerDay - hours*secondsPerHour - minutes*secondsPerMinute)

    return days, hours, minutes, seconds
end

local __random_counter = 1
local random = function(t, e)
    __random_counter = __random_counter + 1
    math.randomseed(os.time() + __random_counter)
    for i = 1, 6 do
        math.random()
    end
    return math.random(t, e)
end

--[[
    随机一个数组 数字不重复
]]
local function getRandomArray( numStart,numEnd )
    local org_source = {}
    for i = numStart,numEnd do
        table.insert( org_source,i )
    end
    local dest_source = {}
    while #org_source > 0 do
        local index = random( 1,#org_source )
        table.insert( dest_source,org_source[index] )
        table.remove( org_source,index )
    end
    return dest_source
end

rawset(_G, "easyWriteFileLog", easyWriteFileLog)
rawset(_G, "dumpStrToDisk", dumpStrToDisk)
rawset(_G, "getFormatTime", getFormatTime)
rawset(_G, "random", random)
rawset(_G, "getRandomArray", getRandomArray)