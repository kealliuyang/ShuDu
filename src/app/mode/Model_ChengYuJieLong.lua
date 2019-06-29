

local Model_ChengYuJieLong = class("Model_ChengYuJieLong")


function Model_ChengYuJieLong:ctor()
	self:reset()
end

function Model_ChengYuJieLong:reset()
	self._maxLevel = 45
	self._level = 1
	self._score = 0
	self._quest = {}
	self._passGuid = nil
	-- 记录
	self._recordList = nil
	self:getRecordList()
end


function Model_ChengYuJieLong:getInstance()
	if not self._instance then
		self._instance = Model_ChengYuJieLong.new()
	end
	return self._instance
end

function Model_ChengYuJieLong:isPassGuid()
	if self._passGuid == nil then
		local user_default = cc.UserDefault:getInstance()
		self._passGuid = user_default:getIntegerForKey("cyjl_passguid", 0)
	end
	return self._passGuid == 1
end

function Model_ChengYuJieLong:setPassGuid()
	self._passGuid = 1
	cc.UserDefault:getInstance():setIntegerForKey("cyjl_passguid",1)
end

function Model_ChengYuJieLong:getLevel()
	return self._level
end

function Model_ChengYuJieLong:setLevel()
	self._level = self._level + 1
end

function Model_ChengYuJieLong:getScore()
	return self._score
end

function Model_ChengYuJieLong:addScore( score )
	assert( score," !! score is nil !! " )
	self._score = self._score + score
end

function Model_ChengYuJieLong:clearData()
	self._level = 1
	self._score = 0
	-- 已经随机的题库 用于筛选
	self._quest = {}
end

function Model_ChengYuJieLong:getMaxLevel()
	return self._maxLevel
end

-- 获得题库数量
function Model_ChengYuJieLong:getQuestCount()
	local count = 1
	if self._level == 1 then
		count = 1
	elseif self._level >= 2 and self._level <= 3 then
		count = 2
	elseif self._level >= 4 and self._level <= 6 then
		count = 3
	elseif self._level >= 7 and self._level <= 10 then
		count = 4
	elseif self._level >= 11 and self._level <= 15 then
		count = 5
	elseif self._level >= 16 and self._level <= 21 then
		count = 6
	elseif self._level >= 22 and self._level <= 28 then
		count = 7
	elseif self._level >= 29 and self._level <= 36 then
		count = 8
	elseif self._level >= 37 and self._level <= 45 then
		count = 9
	end
	return count
end

-- 获得题库数据
function Model_ChengYuJieLong:getQuestData()
	local quest_data = {}
	local count = self:getQuestCount()
	for i = 1,count do
		local index = self:getRandomQuestIndex()
		table.insert( self._quest,index )
		table.insert( quest_data,cyjl_quest_config[index] )
	end

	return quest_data
end

function Model_ChengYuJieLong:getRandomQuestIndex()
	while true do
		local index = random( 1,#cyjl_quest_config )
		local has = self:hasQuestIndex( index )
		if not has then
			return index
		end
	end
end

function Model_ChengYuJieLong:hasQuestIndex( index )
	assert( index," !! index is nil !! " )
	for i,v in ipairs( self._quest ) do
		if v == index then
			return true
		end
	end
	return false
end

-- 读取记录数据
function Model_ChengYuJieLong:getRecordList()
	if not self._recordList then
		self._recordList = {}
		local user_default = cc.UserDefault:getInstance()
		local record_data = user_default:getStringForKey("cyjl_recordList", "")
		if record_data ~= "" then
			self._recordList = json.decode( record_data )
		end
	end
	return self._recordList
end

-- 存贮记录数据 score:积分 
function Model_ChengYuJieLong:saveRecordList()
	local need_save = false
	-- 最多存储10条记录
	if #self._recordList < 10 then
		local meta = {}
		meta.score = self._score
		meta.time = os.time()
		meta.level = self._level
		table.insert( self._recordList,meta )
		need_save = true
	else
		if self._recordList[#self._recordList].score < self._score then
			self._recordList[#self._recordList].score = self._score
			self._recordList[#self._recordList].time = os.time()
			self._recordList[#self._recordList].level = self._level
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
		user_default:setStringForKey("cyjl_recordList", json_data)
	end
	return need_save
end


return Model_ChengYuJieLong
