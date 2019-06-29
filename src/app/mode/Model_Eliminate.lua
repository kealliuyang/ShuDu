

local Model_Eliminate = class("Model_Eliminate")


function Model_Eliminate:ctor()
	self:reset()
end

function Model_Eliminate:reset()
	self._recordGeneralList = nil
	self._recordAdvancedList = nil
	self:getGeneralRecordList()
	self:getAdvancedRecordList()
	self._continueGeneralData = nil
	self._continueAdvancedData = nil
	self._continueHardData = nil
end

function Model_Eliminate:getInstance()
	if not self._instance then
		self._instance = Model_Eliminate.new()
	end
	return self._instance
end

-- 读取General记录数据
function Model_Eliminate:getGeneralRecordList()
	if not self._recordGeneralList then
		self._recordGeneralList = {}
		local user_default = cc.UserDefault:getInstance()
		local record_data = user_default:getStringForKey("eli_recordGeneralList", "")
		if record_data ~= "" then
			self._recordGeneralList = json.decode( record_data )
		end
	end
	return self._recordGeneralList
end
-- 存贮General记录数据
function Model_Eliminate:saveGeneralRecordList( score )
	assert( score," !! score is nil !! ")

	local need_save = false
	-- 最多存储10条记录
	if #self._recordGeneralList < 10 then
		local meta = {}
		meta.score = score
		meta.time = os.time()
		table.insert( self._recordGeneralList,meta )
		need_save = true
	else
		if self._recordGeneralList[#self._recordGeneralList].score < score then
			self._recordGeneralList[#self._recordGeneralList].score = score
			need_save = true
		end
	end
	if need_save then
		table.sort( self._recordGeneralList, function(a,b)
			return a.score > b.score
		end )
		-- 存盘
		local json_data = json.encode( self._recordGeneralList )
		local user_default = cc.UserDefault:getInstance()
		user_default:setStringForKey("eli_recordGeneralList", json_data)
	end
end
-- 获取General最大的分数
function Model_Eliminate:getMaxGeneralScore()
	if #self._recordGeneralList > 0 then
		return self._recordGeneralList[1].score
	end
	return 0
end
-- 读取Advanced记录数据
function Model_Eliminate:getAdvancedRecordList()
	if not self._recordAdvancedList then
		self._recordAdvancedList = {}
		local user_default = cc.UserDefault:getInstance()
		local record_data = user_default:getStringForKey("eli_recordAdvancedList", "")
		if record_data ~= "" then
			self._recordAdvancedList = json.decode( record_data )
		end
	end
	return self._recordAdvancedList
end
-- 存贮Advanced记录数据
function Model_Eliminate:saveAdvancedRecordList( score )
	assert( score," !! score is nil !! ")

	local need_save = false
	-- 最多存储10条记录
	if #self._recordAdvancedList < 10 then
		local meta = {}
		meta.score = score
		meta.time = os.time()
		table.insert( self._recordAdvancedList,meta )
		need_save = true
	else
		if self._recordAdvancedList[#self._recordAdvancedList].score < score then
			self._recordAdvancedList[#self._recordAdvancedList].score = score
			need_save = true
		end
	end
	if need_save then
		table.sort( self._recordAdvancedList, function(a,b)
			return a.score > b.score
		end )
		-- 存盘
		local json_data = json.encode( self._recordAdvancedList )
		local user_default = cc.UserDefault:getInstance()
		user_default:setStringForKey("eli_recordAdvancedList", json_data)
	end
end
-- 获取Advanced最大的分数
function Model_Eliminate:getAdvancedScore()
	if #self._recordAdvancedList > 0 then
		return self._recordAdvancedList[1].score
	end
	return 0
end
-- 临时存储General数据 用于继续游戏
function Model_Eliminate:saveContinueGeneralData( putBlock,createBlock,score,refreshTimes,hideRow,countDownTime )
	self._continueGeneralData = {}
	self._continueGeneralData.putBlock = putBlock
	self._continueGeneralData.createBlock = createBlock
	self._continueGeneralData.score = score
	self._continueGeneralData.refreshTimes = refreshTimes
	self._continueGeneralData.hideRow = hideRow
	self._continueGeneralData.countDownTime = countDownTime
	-- 存盘
	local json_data = json.encode( self._continueGeneralData )
	local user_default = cc.UserDefault:getInstance()
	user_default:setStringForKey("eli_continueGeneralData", json_data)
end
function Model_Eliminate:getContinueGeneralData()
	if not self._continueGeneralData then
		local user_default = cc.UserDefault:getInstance()
		local continue_data = user_default:getStringForKey("eli_continueGeneralData", "")
		if continue_data ~= "" then
			self._continueGeneralData = {}
			self._continueGeneralData = json.decode( continue_data )
		end
	end
	return self._continueGeneralData
end
function Model_Eliminate:clearContinueGeneralData()
	self._continueGeneralData = nil

	local user_default = cc.UserDefault:getInstance()
	user_default:setStringForKey("eli_continueGeneralData", "")
end
-- 临时存储Advanced数据 用于继续游戏
function Model_Eliminate:saveContinueAdvancedData( putBlock,createBlock,score,refreshTimes,countDownTime )
	self._continueAdvancedData = {}
	self._continueAdvancedData.putBlock = putBlock
	self._continueAdvancedData.createBlock = createBlock
	self._continueAdvancedData.score = score
	self._continueAdvancedData.refreshTimes = refreshTimes
	self._continueAdvancedData.countDownTime = countDownTime

	-- 存盘
	local json_data = json.encode( self._continueAdvancedData )
	local user_default = cc.UserDefault:getInstance()
	user_default:setStringForKey("eli_continueAdvancedData", json_data)
end
function Model_Eliminate:getContinueAdvancedData()
	if not self._continueAdvancedData then
		local user_default = cc.UserDefault:getInstance()
		local continue_data = user_default:getStringForKey("eli_continueAdvancedData", "")
		if continue_data ~= "" then
			self._continueAdvancedData = {}
			self._continueAdvancedData = json.decode( continue_data )
		end
	end
	return self._continueAdvancedData
end
function Model_Eliminate:clearContinueAdvancedData()
	self._continueAdvancedData = nil

	local user_default = cc.UserDefault:getInstance()
	user_default:setStringForKey("eli_continueAdvancedData", "")
end

-- 临时存储困难模式数据 用于继续游戏
function Model_Eliminate:saveContinueHardData( putBlock,createBlock,score,refreshTimes,hideRow,hideCol,countDownTime )
	self._continueHardData = {}
	self._continueHardData.putBlock = putBlock
	self._continueHardData.createBlock = createBlock
	self._continueHardData.score = score
	self._continueHardData.refreshTimes = refreshTimes
	self._continueHardData.hideRow = hideRow
	self._continueHardData.hideCol = hideCol
	self._continueHardData.countDownTime = countDownTime

	-- 存盘
	local json_data = json.encode( self._continueHardData )
	local user_default = cc.UserDefault:getInstance()
	user_default:setStringForKey("eli_continueHardData", json_data)
end
function Model_Eliminate:getContinueHardData()
	if not self._continueHardData then
		local user_default = cc.UserDefault:getInstance()
		local continue_data = user_default:getStringForKey("eli_continueHardData", "")
		if continue_data ~= "" then
			self._continueHardData = {}
			self._continueHardData = json.decode( continue_data )
		end
	end
	return self._continueHardData
end
function Model_Eliminate:clearContinueHardData()
	self._continueHardData = nil

	local user_default = cc.UserDefault:getInstance()
	user_default:setStringForKey("eli_continueHardData", "")
end

return Model_Eliminate