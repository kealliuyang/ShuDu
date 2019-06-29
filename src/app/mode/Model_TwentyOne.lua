
local Model_TwentyOne = class("Model_TwentyOne")




function Model_TwentyOne:ctor()
	self:reset()
end

function Model_TwentyOne:reset()
	self._coin = nil
	self._recordList = nil
	self:getRecordList()
end


function Model_TwentyOne:getInstance()
	if not self._instance then
		self._instance = Model_TwentyOne.new()
	end
	return self._instance
end



function Model_TwentyOne:getCoin()
	if self._coin == nil then
		local user_default = cc.UserDefault:getInstance()
		self._coin = user_default:getIntegerForKey("twentyOneCoin", 0)
		if self._coin < 200 then
			self._coin = 200
			user_default:setIntegerForKey("twentyOneCoin", 200)
		end
	end
	return self._coin
end

function Model_TwentyOne:setCoin( addCoin )
	self._coin = self:getCoin() + addCoin
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey("twentyOneCoin", self._coin)
end




-- 读取记录数据
function Model_TwentyOne:getRecordList()
	if not self._recordList then
		self._recordList = {}
		local user_default = cc.UserDefault:getInstance()
		local record_data = user_default:getStringForKey("twenty_one_recordList", "")
		if record_data ~= "" then
			self._recordList = json.decode( record_data )

			table.sort( self._recordList, function(a,b)
				return a.score > b.score
			end )
		end
	end
	return self._recordList
end

-- 存贮记录数据
function Model_TwentyOne:saveRecordList( score )
	assert( score," !! score is nil !! ")

	local need_save = false
	-- 最多存储10条记录
	if #self._recordList < 10 then
		local meta = {}
		meta.score = score
		meta.time = os.time()
		table.insert( self._recordList,meta )
		need_save = true
	else
		if self._recordList[#self._recordList].score < score then
			self._recordList[#self._recordList].score = score
			self._recordList[#self._recordList].time = os.time()
			need_save = true
		end
	end
	if need_save then
		table.sort( self._recordList, function(a,b)
			return a.score > b.score
		end )
		-- 存盘
		local json_data = json.encode( self._recordList )
		local user_default = cc.UserDefault:getInstance()
		user_default:setStringForKey("twenty_one_recordList", json_data)
	end
	return need_save
end










return Model_TwentyOne