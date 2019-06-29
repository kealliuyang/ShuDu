
local Model_TwentyFour = class("Model_TwentyFour")

function Model_TwentyFour:ctor()
	self:reset()
end

function Model_TwentyFour:reset()
	self._currentLv = nil
	self._currentPoint = nil
	self._recordList = nil
end

function Model_TwentyFour:getInstance()
	if not self._instance then
		self._instance = Model_TwentyFour.new()
	end
	return self._instance
end

function Model_TwentyFour:getLevelAndPoint()
	if self._currentLv == nil then
		local user_default = cc.UserDefault:getInstance()
		self._currentLv = user_default:getIntegerForKey("tfPassLevel", 1)
	end
	if self._currentPoint == nil then
		local user_default = cc.UserDefault:getInstance()
		-- 当前可以打开的关卡
		self._currentPoint = user_default:getIntegerForKey("tfPassPoint", 0)
	end
	return self._currentLv,self._currentPoint
end

function Model_TwentyFour:setLevelAndPoint( level,point )
	assert( level," !! level is nil !!")
	assert( point," !! point is nil !!")
	if self._currentLv == level and self._currentPoint == point then
		return
	end
	self._currentLv = level
	self._currentPoint = point
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey("tfPassLevel", self._currentLv)
	user_default:setIntegerForKey("tfPassPoint", self._currentPoint)
end

-- 读取General记录数据
function Model_TwentyFour:getRecordList()
	if not self._recordList then
		self._recordList = {}
		local user_default = cc.UserDefault:getInstance()
		local record_data = user_default:getStringForKey("tf_recordList", "")
		if record_data ~= "" then
			self._recordList = json.decode( record_data )
		end
	end
	return self._recordList
end

-- 存贮记录数据
function Model_TwentyFour:saveRecordList( score )
	assert( score," !! score is nil !! ")

	local need_save = false
	-- 最多存储20条记录
	if #self._recordList < 20 then
		local meta = {}
		meta.score = score
		meta.time = os.time()
		table.insert( self._recordList,meta )
		need_save = true
	else
		if self._recordList[#self._recordList].score > score then
			self._recordList[#self._recordList].score = score
			self._recordList[#self._recordList].time = os.time()
			need_save = true
		end
	end
	if need_save then
		table.sort( self._recordList, function(a,b)
			return a.score < b.score
		end )
		-- 存盘
		local json_data = json.encode( self._recordList )
		local user_default = cc.UserDefault:getInstance()
		user_default:setStringForKey("tf_recordList", json_data)
	end
	return need_save
end

-- 获取最好的积分
function Model_TwentyFour:getMaxScore()
	if self._recordList == nil then
		self:getRecordList()
	end
	if self._recordList[#self._recordList] then
		return self._recordList[#self._recordList].score
	end
	return 0
end


return Model_TwentyFour