

local Model_JunShi = class("Model_JunShi")



function Model_JunShi:ctor()
	self:reset()
end


function Model_JunShi:reset()
	self._coin = nil
	self._recordList = nil
	self:getRecordList()
end


function Model_JunShi:getInstance()
	if not self._instance then
		self._instance = Model_JunShi.new()
	end
	return self._instance
end



function Model_JunShi:getCoin()
	if self._coin == nil then
		local user_default = cc.UserDefault:getInstance()
		self._coin = user_default:getIntegerForKey("junshiCoin", 0)
		if self._coin <= 0 then
			self._coin = 30
			user_default:setIntegerForKey("junshiCoin", self._coin)
		end
	end
	return self._coin
end

function Model_JunShi:setCoin( addCoin )
	self._coin = self:getCoin() + addCoin
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey("junshiCoin", self._coin)
end

function Model_JunShi:initCoin()
	self._coin = 30
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey("junshiCoin", self._coin)
end


-- 读取记录数据
function Model_JunShi:getRecordList()
	if not self._recordList then
		self._recordList = {}
		local user_default = cc.UserDefault:getInstance()
		local record_data = user_default:getStringForKey("junshi_recordList", "")
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
function Model_JunShi:saveRecordList( score,peopleIndex )
	assert( score," !! score is nil !! ")
	assert( peopleIndex," !! peopleIndex is nil !! ")

	local need_save = false
	-- 最多存储10条记录
	if #self._recordList < 10 then
		local meta = {}
		meta.score = score
		meta.time = os.time()
		meta.people = peopleIndex
		table.insert( self._recordList,meta )
		need_save = true
	else
		if self._recordList[#self._recordList].score < score then
			self._recordList[#self._recordList].score = score
			self._recordList[#self._recordList].people = peopleIndex
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
		user_default:setStringForKey("junshi_recordList", json_data)
	end
	return need_save
end













return Model_JunShi