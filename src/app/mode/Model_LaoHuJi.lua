

local Model_LaoHuJi = class("Model_LaoHuJi")


function Model_LaoHuJi:ctor()
	self:reset()
end


function Model_LaoHuJi:reset()
	self._coin = nil
	self._gameType = nil
	-- 动物城是否解锁的标志 0:没有 1:解锁
	self._unlockAnimal = nil
	-- 海底世界是否解锁的标志 0:没有 1:解锁
	self._unlockAnimalSeabed = nil
	-- 初始化记录
	self._recordList = nil
	self:getRecordList()
	-- 成就数据
	self._achievementData = nil
	self:getAchievementData()
	-- 累计金币数
	self._highCoin = nil
	-- 连续押中次数
	self._lianxuyazhong = nil
	-- 累计押中
	self._leijiyazhong = nil
	-- 累计游戏次数
	self._playTimes = nil

	-- 临时的连续押中次数
	self._temp_lianxu = 0
end

function Model_LaoHuJi:getInstance()
	if not self._instance then
		self._instance = Model_LaoHuJi.new()
	end
	return self._instance
end

function Model_LaoHuJi:getCoin()
	if not self._coin then
		local user_default = cc.UserDefault:getInstance()
		self._coin = user_default:getIntegerForKey("laohuji_coin", lhj_default_coin)
		
		-- 当金币为0的时候 初始化给500
		if self._coin == 0 then
			self:saveCoin( lhj_default_coin )
		end
	end
	return self._coin
end

function Model_LaoHuJi:saveCoin( coin )
	assert( coin," !! coin is nil !! ")
	self._coin = coin
	cc.UserDefault:getInstance():setIntegerForKey("laohuji_coin",coin)
end

function Model_LaoHuJi:isAnimalOpen()
	if self._unlockAnimal == nil then
		local user_default = cc.UserDefault:getInstance()
		self._unlockAnimal = user_default:getIntegerForKey("laohuji_animal", 0)
	end
	return self._unlockAnimal == 1
end

function Model_LaoHuJi:saveAnimalOpen()
	self._unlockAnimal = 1
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey("laohuji_animal", 1)
end

-- 获取临时的连续押中次数
function Model_LaoHuJi:getTempLianXu()
	return self._temp_lianxu
end

function Model_LaoHuJi:addTempLianXu()
	self._temp_lianxu = self._temp_lianxu + 1
	self:setLianXuYaZhong( self._temp_lianxu )
end

function Model_LaoHuJi:clearTempLianXu()
	self._temp_lianxu = 0
end

-- 累计金币数
function Model_LaoHuJi:getHighCoin()
	if self._highCoin == nil then
		local user_default = cc.UserDefault:getInstance()
		self._highCoin = user_default:getIntegerForKey("laohuji_highcoin", lhj_default_coin)
	end
	return self._highCoin
end

function Model_LaoHuJi:setHighCoin( num )
	assert( num," !! num is nil !! ")
	if num > self:getHighCoin() then
		self._highCoin = num
		local user_default = cc.UserDefault:getInstance()
		user_default:setIntegerForKey("laohuji_highcoin", num)
	end
end

-- 连续押中
function Model_LaoHuJi:getLianXuYaZhong()
	if self._lianxuyazhong == nil then
		local user_default = cc.UserDefault:getInstance()
		self._lianxuyazhong = user_default:getIntegerForKey("laohuji_lianxuyazhong", 0)
	end
	return self._lianxuyazhong
end

function Model_LaoHuJi:setLianXuYaZhong( num )
	assert( num," !! num is nil !! ")
	if num > self:getLianXuYaZhong() then
		self._lianxuyazhong = num
		local user_default = cc.UserDefault:getInstance()
		user_default:setIntegerForKey("laohuji_lianxuyazhong", num)
	end
end

-- 累计押中
function Model_LaoHuJi:geLeiJiYaZhong()
	if self._leijiyazhong == nil then
		local user_default = cc.UserDefault:getInstance()
		self._leijiyazhong = user_default:getIntegerForKey("laohuji_leijiyazhong", 0)
	end
	return self._leijiyazhong
end

function Model_LaoHuJi:setLeiJiYaZhong( num )
	assert( num," !! num is nil !! ")
	self._leijiyazhong = num
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey("laohuji_leijiyazhong", num)
end

-- 游戏次数
function Model_LaoHuJi:gePlayTimes()
	if self._playTimes == nil then
		local user_default = cc.UserDefault:getInstance()
		self._playTimes = user_default:getIntegerForKey("laohuji_totaltimes", 0)
	end
	return self._playTimes
end

function Model_LaoHuJi:setPlayTimes( num )
	assert( num," !! num is nil !! ")
	self._playTimes = num
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey("laohuji_totaltimes", num)
end

-- 海底世界
function Model_LaoHuJi:isSeabedOpen()
	if self._unlockAnimalSeabed == nil then
		local user_default = cc.UserDefault:getInstance()
		self._unlockAnimalSeabed = user_default:getIntegerForKey("laohuji_seabed", 0)
	end
	return self._unlockAnimalSeabed == 1
end

function Model_LaoHuJi:saveSeabedOpen()
	self._unlockAnimalSeabed = 1
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey("laohuji_seabed", 1)
end


function Model_LaoHuJi:setGameType( mode )
	self._gameType = mode
end

function Model_LaoHuJi:getGameType()
	return self._gameType
end

function Model_LaoHuJi:getCostCoin()
	if self._gameType == 1 then
		return 1
	end
	if self._gameType == 2 then
		return 5
	end
	if self._gameType == 3 then
		return 10
	end
	return 1
end

-- 读取记录数据
function Model_LaoHuJi:getRecordList()
	if not self._recordList then
		self._recordList = {}
		local user_default = cc.UserDefault:getInstance()
		local record_data = user_default:getStringForKey("lhj_recordList", "")
		if record_data ~= "" then
			self._recordList = json.decode( record_data )
		end
	end
	return self._recordList
end

-- 存贮记录数据 score:积分 
function Model_LaoHuJi:saveRecordList( score )
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
		user_default:setStringForKey("lhj_recordList", json_data)
	end
	return need_save
end

-- 成就是否已经领取的数据
function Model_LaoHuJi:getAchievementData()
	if self._achievementData == nil then
		self._achievementData = {}
		local user_default = cc.UserDefault:getInstance()
		local record_data = user_default:getStringForKey("lhj_achievement", "")
		if record_data == "" then
			self._achievementData = { 0,0,0,0,0,0,0,0,0,0 }
		else
			self._achievementData = json.decode( record_data )
		end
	end
	return self._achievementData
end

function Model_LaoHuJi:saveAchievementData( index )
	assert( index," !! index is nil !! " )
	self._achievementData[index] = 1
	-- 存盘
	local json_data = json.encode( self._achievementData )
	local user_default = cc.UserDefault:getInstance()
	user_default:setStringForKey("lhj_achievement", json_data)
end


function Model_LaoHuJi:isAchievementGet( index )
	assert( index," !! index is nil !! " )
	return self._achievementData[index] and self._achievementData[index] == 1
end


return Model_LaoHuJi