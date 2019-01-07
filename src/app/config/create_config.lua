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
-- 九宫格数独创建

-- 根据现有的数独
-- 1、随机交换某两行（只能是同一个九宫格内的两行）
-- 2、随机交换某两列（只能是同一个九宫格内的两列）
-- 这样就生成了一个新的数独

local A = {
	[1] = {4,7,6,1,5,9,2,8,3},
	[2] = {9,3,1,2,8,6,5,7,4},
	[3] = {8,2,5,4,7,3,1,6,9},
	[4] = {5,6,7,3,2,8,4,9,1},
	[5] = {3,1,8,6,9,4,7,5,2},
	[6] = {2,4,9,5,1,7,6,3,8},
	[7] = {1,8,2,9,6,5,3,4,7},
	[8] = {6,9,4,7,3,2,8,1,5},
	[9] = {7,5,3,8,4,1,9,2,6}
}



function printAArray()
	for i = 1,9 do
		local row = A[i]
		local str = ""
		for j = 1,9 do
			str = str.." "..row[j]
		end
		print(str)
	end
	print("---------------------------------")
end

function printAry( source )
    print("{")
	for i = 1,9 do
        local str = "    "
		local row = source[i]
		str = str.."{"..row[1].value
		for j = 2,9 do
			str = str..","..row[j].value
		end
		str = str.."}"
        if i ~= 9 then
            str = str..","
        end
		print(str)
	end
    print("},")
	-- print("---------------------------------")
end

local random_counter = 1
function random(t, e)
    random_counter = random_counter + 1
    math.randomseed(os.time() + random_counter)
    for i = 1, 6 do
        math.random()
    end
    return math.random(t, e)
end



-- for i,v in ipairs(swap) do
-- 	local str = " 第 "..i.."组交换数为:"
-- 	str = str.." first = "..v.first.." second = "..v.second
-- 	print(str)
-- end


function swapFunc( source,swap )
	for i,v in ipairs(source[1]) do
		v.value = swap.second
	end
	for i,v in ipairs(source[2]) do
		v.value = swap.first
	end
end


function createArray()
    local New_Ary = {}
    for i = 1,9 do
        New_Ary[i] = {}
        for j = 1,9 do
            New_Ary[i][j] = { value = A[i][j],row = i,col = j }
        end
    end

    local num = { 1,2,3,4,5,6,7,8,9 }
    local b = {}
    while #num > 0 do
        local index = random(1,#num)
        local val = num[index]
        table.insert( b,val )
        table.remove( num,index )
    end
    local swap = {{},{},{},{}}
    -- 取出四组交换数
    for i = 1,4 do
        local a1_index = random(1,#b)
        local a1 = b[a1_index]
        table.remove( b,a1_index )
        local b1_index = random(1,#b)
        local b1 = b[b1_index]
        table.remove( b,b1_index )
        swap[i] = { first = a1,second = b1 }
    end

    -- 根据交换数 交换现有的数独
    local change = {}
    for i,v in ipairs(swap) do
        change[i] = { {},{} }
        for a = 1,9 do
            for b = 1,9 do
                if New_Ary[a][b].value == swap[i].first then
                    table.insert( change[i][1],New_Ary[a][b] )
                end
                if New_Ary[a][b].value == swap[i].second then
                    table.insert( change[i][2],New_Ary[a][b] )
                end
            end
        end
    end

    swapFunc( change[1],swap[1] )
    swapFunc( change[2],swap[2] )
    swapFunc( change[3],swap[3] )
    swapFunc( change[4],swap[4] )

    -- printAry(New_Ary)
    return New_Ary
end


for i = 1,500 do
    local ary = createArray()
    printAry(ary)
end
