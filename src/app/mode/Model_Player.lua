
local Model_Player = class("Model_Player")


function Model_Player:ctor()
	self:reset()
end

function Model_Player:reset()
	self._passLevel = nil 	-- 通过的关卡
	self._recordList = nil
	self._passGuid = nil
	self._answerTips = nil
end

function Model_Player:getInstance()
	if not self._instance then
		self._instance = Model_Player.new()
	end
	return self._instance
end

-- 获取通过的关卡
function Model_Player:getPassLevel()
	if self._passLevel == nil then
		local user_default = cc.UserDefault:getInstance()
		local pass_level = user_default:getIntegerForKey("passLevel", 0)
		self._passLevel = pass_level
	end
	return self._passLevel
end
-- 检查当前关卡是否通过
function Model_Player:isPassLevel( level )
	assert( level," !! level is nil !! ")
	return self:getPassLevel() >= level
end

function Model_Player:savePassLevel( level )
	assert( level," !! level is nil !! ")
	if self._passLevel >= level then
		return
	end
	self._passLevel = level
	cc.UserDefault:getInstance():setIntegerForKey("passLevel",level)
end

-- 根据当前难度设置题目
function Model_Player:getQuest( selectLevel )
	local quest = {}
	if self:isPassGuid() then
		local blank = 1
		for i = 1,9 do
			quest[i] = {}
			if selectLevel >= 1 and selectLevel <= 100 then
				-- 难度1 每行1-3个空白
				blank = random(1,3)
			elseif selectLevel >= 101 and selectLevel <= 200 then
				-- 难度2 每行2-4个空白
				blank = random(2,4)
			elseif selectLevel >= 201 and selectLevel <= 300 then
				-- 难度3 每行23-4个空白
				blank = random(3,4)
			elseif selectLevel >= 301 and selectLevel <= 400 then
				-- 难度4 每行4-5个空白
				blank = random(4,5)
			elseif selectLevel >= 401 and selectLevel <= 500 then
				-- 难度4 每行5-6个空白
				blank = random(5,6)
			end
			for j = 1,blank do
				local num = random(1,9)
				table.insert(quest[i],num)
			end
		end
	else
		quest = {
			{6,8},{2,9},{1,2},{5,8},{2,5},{4,1},{1},{5},{6}
		}
	end
	return quest
end


-- 读取记录数据
function Model_Player:getRecordList()
	if not self._recordList then
		self._recordList = {}
		local user_default = cc.UserDefault:getInstance()
		local record_data = user_default:getStringForKey("recordList", "")
		if record_data ~= "" then
			self._recordList = json.decode( record_data )
		end
	end
	return self._recordList
end

-- 存贮记录数据
function Model_Player:saveRecordList( recordData )
	assert( recordData," !! recordData is nil !! ")

	-- 检查是否需要存盘
	local has_index = 0
	for i,v in ipairs( self._recordList ) do
		if tonumber(v.level) == tonumber(recordData.level) then
			if tonumber(v.passTime) <= tonumber(recordData.passTime) then
				return
			else
				has_index = i
				break
			end
		end
	end

	if has_index > 0 then
		self._recordList[has_index].passTime = recordData.passTime
		self._recordList[has_index].recordTime = os.time()
	else
		local meta = {}
		meta.level = recordData.level -- 当前关卡
		meta.passTime = recordData.passTime -- 通关时间
		meta.recordTime = os.time()	-- 记录时间
		table.insert( self._recordList,meta )
	end
	-- 存盘
	local json_data = json.encode( self._recordList )
	local user_default = cc.UserDefault:getInstance()
	user_default:setStringForKey("recordList", json_data)
end

function Model_Player:getRecordTimeByLevel( level )
	assert( level," !! level is nil !! " )
	local list = self:getRecordList()
	for i,v in ipairs(list) do
		if tonumber(v.level) == tonumber(level) then
			return v.passTime
		end
	end
	return 0
end

-- 新手引导是否通过
function Model_Player:isPassGuid()
	if self._passGuid == nil then
		local user_default = cc.UserDefault:getInstance()
		self._passGuid = user_default:getIntegerForKey("passGuid", 0)
	end
	return self._passGuid == 1
end
-- 设置新手引导已经通过
function Model_Player:setPassGuid()
	if self._passGuid ~= 1 then
		self._passGuid = 1
		local user_default = cc.UserDefault:getInstance()
		user_default:setIntegerForKey("passGuid", 1)
	end
end

-- 获取提示的次数
function Model_Player:getAnswerTips()
	if self._answerTips == nil then
		local user_default = cc.UserDefault:getInstance()
		-- 默认10次
		self._answerTips = user_default:getIntegerForKey("answerTips", 10)
	end
	return self._answerTips
end

-- 设置提示的次数
function Model_Player:useAnswerTips()
	if self:getAnswerTips() <= 0 then
		return
	end
	self._answerTips = self._answerTips - 1
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey("answerTips", self._answerTips)
end

function Model_Player:getContinueData()
	return self._continueData
end

function Model_Player:setContinueData( data )
	self._continueData = data
end

return Model_Player