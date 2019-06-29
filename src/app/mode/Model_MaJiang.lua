
local Model_MaJiang = class("Model_MaJiang")


function Model_MaJiang:ctor()
	self:reset()
end

function Model_MaJiang:reset()
	self._allCard = nil
	self._playerWin = nil
	self._continueData = nil
	-- 玩家的积分
	self._hasScore = nil
	-- 玩家的初始底分
	self._diScore = 10
	-- 玩家玩的局数
	self._playTimes = nil
	-- 玩家和ai的连庄数
	self._lianZhuang = nil
	-- 玩家初始积分
	self._orgScore = 3000
	-- 记录
	self._recordList = nil
	-- 模式
	self._gameType = nil
	-- 牌的num
	self._cardNum = {1,2,3,4,5,6,7,8,9,11,21,31,41,51,61,71}
	-- 初始化记录
	self:getRecordList()
end

function Model_MaJiang:getInstance()
	if not self._instance then
		self._instance = Model_MaJiang.new()
	end
	return self._instance
end

-- 获取当前所有的牌
function Model_MaJiang:getAllCard()
	-- 所有的牌 1-9 为1-9万 11东 21南 31西 41北 51中 61发 71白
	if self._allCard == nil then
	    self._allCard = {}
	    for i,v in ipairs( self._cardNum ) do
	    	for i = 1,4 do
	    		table.insert( self._allCard,v )
	    	end
	    end
	end
    return self._allCard
end

function Model_MaJiang:getCardNums()
	return self._cardNum
end

-- 获取上一局谁赢 1:玩家赢 2:AI赢 (默认玩家赢)
function Model_MaJiang:isPlayerWin()
	if self._playerWin == nil then
		local user_default = cc.UserDefault:getInstance()
		self._playerWin = user_default:getIntegerForKey("majiang_player_win", 1)
	end
	return self._playerWin == 1
end
-- 设置上一局谁赢 1:玩家赢 2:AI赢 (默认玩家赢)
function Model_MaJiang:setPlayerWin( value )
	assert( value," !! value is nil !! " )
	assert( value == 1 or value == 2," !! value must be 1 or 2 !! " )
	self._playerWin = value
	cc.UserDefault:getInstance():setIntegerForKey("majiang_player_win",value)
end

-- 继续游戏的数据
function Model_MaJiang:getContinueData()
	if not self._continueData then
		local user_default = cc.UserDefault:getInstance()
		local continue_data = user_default:getStringForKey("majiang_continueData", "")
		if continue_data ~= "" then
			self._continueData = {}
			self._continueData = json.decode( continue_data )
		end
	end
	return self._continueData
end


function Model_MaJiang:clearContinueData()
	self._continueData = nil
	local user_default = cc.UserDefault:getInstance()
	user_default:setStringForKey("majiang_continueData", "")
end

function Model_MaJiang:getHasScore()
	if not self._hasScore then
		local user_default = cc.UserDefault:getInstance()
		-- 玩家初始3000的积分
		self._hasScore = user_default:getIntegerForKey("majiang_has_score", self._orgScore)
	end
	return self._hasScore
end

function Model_MaJiang:setHasScore( value )
	assert( value," !! value is nil !! " )
	self._hasScore = value
	cc.UserDefault:getInstance():setIntegerForKey("majiang_has_score",value)
end

-- 已经玩的次数 用于计算底分( 底分10分起，每玩1局加5分 )
function Model_MaJiang:getPlayTimes()
	if not self._playTimes then
		local user_default = cc.UserDefault:getInstance()
		self._playTimes = user_default:getIntegerForKey("majiang_play_times", 0)
	end
	return self._playTimes
end

function Model_MaJiang:setPlayTimes( value )
	assert( value," !! value is nil !! " )
	self._playTimes = value
	cc.UserDefault:getInstance():setIntegerForKey("majiang_play_times",value)
end

function Model_MaJiang:getDiScore()
	return self._diScore
end

function Model_MaJiang:getLianZhuang()
	if not self._lianZhuang then
		self._lianZhuang = {}
		if self:isPlayerWin() then
			self._lianZhuang.player = 1
			self._lianZhuang.ai = 0
		else
			self._lianZhuang.player = 0
			self._lianZhuang.ai = 1
		end
	end
	return self._lianZhuang
end

--[[
	isPlayerWin:玩家赢
]]
function Model_MaJiang:setLianZhuang( isPlayerWin )
	if isPlayerWin then
		self._lianZhuang.player = self._lianZhuang.player + 1
		self._lianZhuang.ai = 0
	else
		self._lianZhuang.player = 0
		self._lianZhuang.ai = self._lianZhuang.ai + 1
	end
end

-- 读取记录数据
function Model_MaJiang:getRecordList()
	if not self._recordList then
		self._recordList = {}
		local user_default = cc.UserDefault:getInstance()
		local record_data = user_default:getStringForKey("mj_recordList", "")
		if record_data ~= "" then
			self._recordList = json.decode( record_data )
		end
	end
	return self._recordList
end

-- 存贮记录数据 score:积分 
function Model_MaJiang:saveRecordList( score )
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
		user_default:setStringForKey("mj_recordList", json_data)
	end
	return need_save
end

-- 针对破产 重置玩家数据
function Model_MaJiang:resetPlayerDataByPoChan()
	self:setHasScore( self._orgScore )
	self:setPlayTimes( 0 )
	self:setPlayerWin( 1 )
	self._lianZhuang = nil
end

-- typeNum: 1:普通模式 2:困难模式
function Model_MaJiang:setGameType( typeNum )
	self._gameType = typeNum
end

function Model_MaJiang:getGameType()
	return self._gameType
end

function Model_MaJiang:calAddScoreByResult( resultData )
	assert( resultData," !! resultData is nil !! " )
	local result_data = resultData
    local rate = 1
    if result_data.men_qing then
        rate = rate * 2
    end
    if result_data.tian_hu then
        rate = rate * 8
    end
    if result_data.tian_hu then
        rate = rate * 8
    end
    if result_data.zi_mo then
        rate = rate * 2
    end
    if result_data.gang_num and result_data.gang_num > 0 then
        rate = rate * 2 * result_data.gang_num
    end
    if result_data.add_rate and result_data.add_rate > 0 then
        rate = rate * result_data.add_rate
    end
    if result_data.lian_zhuang and result_data.lian_zhuang > 1 then
        rate = rate * result_data.lian_zhuang
    end
    local add_score = result_data.di_score * rate
    return add_score
end



function Model_MaJiang:playOutCardVoice( cardNum )
	assert( cardNum," !! cardNum is nil  !! " )
	if cardNum <= 9 then
		local path = "mjmp3/boy_"..cardNum.."wan.mp3"
		audio.playSound(path, false)
	else
		local path = ""
		if cardNum == 11 then
			path = "mjmp3/boy_dongfeng.mp3"
		elseif cardNum == 21 then
			path = "mjmp3/boy_nanfeng.mp3"
		elseif cardNum == 31 then
			path = "mjmp3/boy_xifeng.mp3"
		elseif cardNum == 41 then
			path = "mjmp3/boy_beifeng.mp3"
		elseif cardNum == 51 then
			path = "mjmp3/boy_zhong.mp3"
		elseif cardNum == 61 then
			path = "mjmp3/boy_fa.mp3"
		elseif cardNum == 71 then
			path = "mjmp3/boy_bai.mp3"
		end
		if path ~= "" then
			audio.playSound(path, false)
		end
	end
end

return Model_MaJiang