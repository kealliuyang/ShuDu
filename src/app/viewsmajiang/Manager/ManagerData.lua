

local ManagerData = class("ManagerData")



function ManagerData:ctor()
	-- 所有的牌
    self._allCard   = {}
    -- player手牌
    self._playerHandData = {}
    -- player出牌
    self._playerOutData = {}
    -- player 杠牌 碰牌
    self._playerGangPengData = {}
    -- player摸的牌
    self._playerMoCard = 0
    -- ai手牌
    self._aiHandData = {}
    -- ai出牌
    self._aiOutData = {}
    -- ai 杠牌 碰牌
    self._aiGangPengData = {}
    -- ai的摸牌
    self._aiMoCard = 0
end

--[[
	继续游戏的数据
]]
function ManagerData:initContinueGameCardData( continueData )
	-- assert( continueData, " !! continueData is nil  !! " )
	-- self._allCard = continueData._allCard
	-- self._playerHandData = continueData._playerHandData
	-- self._playerOutData = continueData._playerOutData
	-- self._playerGangPengData = continueData._playerGangPengData
end

--[[
	新的一局 初始化数据
	isPlayerWin:true  玩家赢  玩家先发牌摸牌
				false AI赢    AI先发牌摸牌
]]
function ManagerData:initNewGameCardData( isPlayerWin )
	self._allCard = clone(G_GetModel("Model_MaJiang"):getAllCard())
	local game_type = G_GetModel("Model_MaJiang"):getGameType()
	if game_type == 1 then
		-- 普通模式
		if isPlayerWin then
			self._playerHandData = self:getNewGameSendCardData(1)
			self._aiHandData = self:getNewGameSendCardData(2)
		else
			self._aiHandData = self:getNewGameSendCardData(2)
			self._playerHandData = self:getNewGameSendCardData(1)
		end
	else
		-- 困难模式
		self:getHandGameSendCardDara()
	end
end
-- 新局 普通模式 获取发牌的初始数据
function ManagerData:getNewGameSendCardData( mode )
	local source = {}
	for i = 1,13 do
		local index = random(1,#self._allCard)
		local num = self._allCard[index]
		table.insert( source,num )
		-- 移除
		for j = #self._allCard,1,-1 do
			if j == index then
				table.remove( self._allCard,j )
				break
			end
		end
	end
	table.sort( source )
	return source

	-- -- test
	-- local source = {}
	-- if mode == 1 then
	-- 	-- player
	-- 	source = { 8,3,9,8,31,31,41,41,41,51,51,61,21 }
	-- else
	-- 	-- ai
	-- 	source = { 1,1,1,2,2,2,6,6,6,71,71,71,61 }
	-- end
	-- for i,v in ipairs( source ) do
	-- 	for a = #self._allCard,1,-1 do
	-- 		if v == self._allCard[a] then
	-- 			table.remove( self._allCard,a )
	-- 			break
	-- 		end
	-- 	end
	-- end

	-- return source
end

-- 新局 困难模式 获取发牌的初始数据
function ManagerData:getHandGameSendCardDara()
	-- 困难模式 ai至少2-3张牌是2到4张
	local source = {}
	local nums = clone( G_GetModel("Model_MaJiang"):getCardNums() )
	
	local select_num = random(2,3)
	local select_card = {}
	for i = 1,select_num do
		local index = random(1,#nums)
		table.insert( select_card,nums[index] )
		for j = #nums,1,-1 do
			if j == index then
				table.remove( nums,j )
				break
			end
		end
	end

	for i,v in ipairs( select_card ) do
		local rep_num = random(2,4)
		for a = 1,rep_num do
			table.insert( source,v )
		end
	end

	for i,v in ipairs( source ) do
		for j = #self._allCard,1,-1 do
			if v == self._allCard[j] then
				table.remove( self._allCard,j )
				break
			end
		end
	end

	local left = 13 - #source
	for i = 1,left do
		local index = random(1,#self._allCard)
		local num = self._allCard[index]
		table.insert( source,num )
		-- 移除
		for j = #self._allCard,1,-1 do
			if j == index then
				table.remove( self._allCard,j )
				break
			end
		end
	end
	self._aiHandData = source
	table.sort( self._aiHandData )
	self._playerHandData = self:getNewGameSendCardData(1)
end

-- 将13张牌拆分为7对(最后一个是单个) 用于执行发牌动画
function ManagerData:getSevenAry( source )
	assert( source," !! source is nil !! " )
	assert( #source == 13," !! length must be 13 !! ")
	local array = clone( source )
	local result = {}
	for i = 1,7 do
		local meta = {}
		if i == 7 then
			local num = self:getRandomFromAry( array )
			table.insert( meta,num )
		else
			local num1 = self:getRandomFromAry( array )
			table.insert( meta,num1 )
			local num2 = self:getRandomFromAry( array )
			table.insert( meta,num2 )
		end
		table.sort( meta )
		table.insert( result,meta )
	end
	return result
end
function ManagerData:getRandomFromAry( array )
	assert( array," !! array is nil !! " )
	local index = random(1,#array)
	local num = array[index]
	for i = #array,1,-1 do
		if i == index then
			table.remove(array,i)
			break
		end
	end
	return num
end







-- (player或者ai)从牌堆里面摸一张牌
function ManagerData:moCard( isPlayerMo )
	if #self._allCard <= 0 then
		-- 发送消息 游戏结束
		EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_GAMEOVER,0 )
		return 0
	end
	local index = random(1,#self._allCard)

	-- -- test
	-- if self._testfirst == nil then
	-- 	for i,v in ipairs(self._allCard) do
	-- 		if v == 11 then
	-- 			index = i
	-- 			self._testfirst = 1
	-- 			break
	-- 		end
	-- 	end
	-- else
	-- 	if self._testfirst == 1 then
	-- 		for i,v in ipairs(self._allCard) do
	-- 			if v == 9 then
	-- 				index = i
	-- 				self._testfirst = 2
	-- 				break
	-- 			end
	-- 		end
	-- 	elseif self._testfirst == 2 then
	-- 		for i,v in ipairs(self._allCard) do
	-- 			if v == 7 then
	-- 				index = i
	-- 				self._testfirst = 3
	-- 				break
	-- 			end
	-- 		end
	-- 	elseif self._testfirst == 3 then
	-- 		for i,v in ipairs(self._allCard) do
	-- 			if v == 5 then
	-- 				index = i
	-- 				self._testfirst = 4
	-- 				break
	-- 			end
	-- 		end
	-- 	end
	-- end

	-- if not isPlayerMo then
	-- 	if self._testfirst == nil then
	-- 		for i,v in ipairs(self._allCard) do
	-- 			if v == 1 then
	-- 				index = i
	-- 				self._testfirst = 1
	-- 				break
	-- 			end
	-- 		end
	-- 	elseif self._testfirst == 1 then
	-- 		for i,v in ipairs(self._allCard) do
	-- 			if v == 2 then
	-- 				index = i
	-- 				self._testfirst = 2
	-- 				break
	-- 			end
	-- 		end
	-- 	elseif self._testfirst == 2 then
	-- 		for i,v in ipairs(self._allCard) do
	-- 			if v == 6 then
	-- 				index = i
	-- 				self._testfirst = 3
	-- 				break
	-- 			end
	-- 		end
	-- 	elseif self._testfirst == 3 then
	-- 		for i,v in ipairs(self._allCard) do
	-- 			if v == 71 then
	-- 				index = i
	-- 				self._testfirst = 4
	-- 				break
	-- 			end
	-- 		end
	-- 	end
	-- end

	local num = self._allCard[index]
	-- 从牌堆里面移除这一张牌
	table.remove( self._allCard,index )
	-- 设置数据
	if isPlayerMo then
		self._playerMoCard = num
	else
		self._aiMoCard = num
	end
	return num
end
-- 计算是否可以杠
--[[
	cardNum:要杠的数字
	isPlayer:true 计算玩家是否能杠 false 计算ai能否杠
	from: cardNum的来源 1:自己摸的牌 2:对方出的牌
	返回值:gangType: 1:自己摸暗杠 2:自己摸明杠 3:玩家点杠 
]]
function ManagerData:canGang( cardNum,isPlayer,from )
	assert( cardNum," !! cardNum is nil !! " )
	assert( from == 1 or from == 2," !! from must be 1 or 2 !! " )
	if isPlayer then
		local result = self:calHashCard( self._playerHandData )
		if result[cardNum] and result[cardNum] == 3 then
			local gang_type = 0
			if from == 1 then
				-- 自己暗杠
				gang_type = 1
			else
				-- 玩家点杠
				gang_type = 3
			end
			return true,gang_type
		end
		-- 检查碰牌区域
		if from == 1 then
			local peng = self:calHashCard( self._playerGangPengData )
			if peng[cardNum] and peng[cardNum] == 3 then
				return true,2
			end
		end
	else
		local result = self:calHashCard( self._aiHandData )
		if result[cardNum] and result[cardNum] == 3 then
			local gang_type = 0
			if from == 1 then
				-- 自己暗杠
				gang_type = 1
			else
				-- 玩家点杠
				gang_type = 3
			end
			return true,gang_type
		end
		-- 检查碰牌区域
		if from == 1 then
			local peng = self:calHashCard( self._aiGangPengData )
			if peng[cardNum] and peng[cardNum] == 3 then
				return true,2
			end
		end
	end

	return false
end
--[[
	计算是否可以碰
	cardNum:要碰的数字
	isPalyer:true 计算玩家是否能碰 false 计算ai能否碰
]]
function ManagerData:canPeng( cardNum,isPlayer )
	assert( cardNum," !! cardNum is nil !! " )
	if isPlayer then
		local result = self:calHashCard( self._playerHandData )
		if result[cardNum] and result[cardNum] >= 2 then
			return true
		end
	else
		local result = self:calHashCard( self._aiHandData )
		if result[cardNum] and result[cardNum] >= 2 then
			return true
		end
	end
	return false
end
-- 根据cardNum 检查source里面是否有该牌的顺子
function ManagerData:checkShunZiByCard( source,cardNum )
	assert( source," !! source is nil !! " )
	assert( cardNum," !! cardNum is nil !! ")
	if cardNum > 9 then
		return false
	end

	local hash_card = self:calHashCard( source )
	if cardNum == 1 then
		if hash_card[2] and hash_card[2] > 0 
			and hash_card[3] and hash_card[3] > 0 then
			return true
		end
	end
	if cardNum == 9 then
		if hash_card[7] and hash_card[7] > 0 
			and hash_card[8] and hash_card[8] > 0 then
			return true
		end
	end
	if hash_card[cardNum - 1] and hash_card[cardNum - 1] > 0 
		and hash_card[cardNum + 1] and hash_card[cardNum + 1] > 0 then
		return true
	end
	return false
end


--[[
	检查牌里面是否有可以暗杠的牌
	handSource:手牌
]]
function ManagerData:hasAnGangBySource( handSource )
	assert( handSource," !! handSource is nil !! ")
	local result = self:calHashCard( handSource )
	local gang_cards = {}
	for card,num in pairs( result ) do
		if num == 4 then
			table.insert(gang_cards,card)
		end
	end
	return gang_cards
end
--[[
	检查牌里面是否有可以明杠的牌
	handSource:手牌
	gangPengSource:杠牌和碰牌
]]
function ManagerData:hasMingGangBySource( handSource,gangPengSource )
	assert( handSource," !! handSource is nil !! " )
	assert( gangPengSource," !! gangPengSource is nil !! " )
	local result_hand = self:calHashCard( handSource )
	local result_gangpeng = self:calHashCard( handSource,gangPengSource )
	for card,num in pairs( result_gangpeng ) do
		if num == 3 and result_hand[card] == 1 then
			return true,card
		end
	end
	return false
end
















-- 将数据写入玩家的手牌
function ManagerData:insertPlayerHandData( cardNum )
	assert( cardNum," !! cardNum is nil !! " )
	table.insert( self._playerHandData,cardNum )
	table.sort( self._playerHandData )
end
-- 将数据从玩家手牌移除
function ManagerData:removePlayerHandCard( cardNum )
	assert( cardNum," !! cardNum is nil !! ")
	for i,v in ipairs( self._playerHandData ) do
		if v == cardNum then
			table.remove( self._playerHandData,i )
			break
		end
	end
end
-- 将数据写入到玩家出牌区
function ManagerData:insertPlayerOutData( cardNum )
	assert( cardNum," !! cardNum is nil !! " )
	table.insert( self._playerOutData,cardNum )
end
-- 将数据从玩家出牌区移除
function ManagerData:removePlayerOutCard( cardNum )
	assert( cardNum," !! cardNum is nil !! ")
	for i = #self._playerOutData,1,-1 do
		if self._playerOutData[i] == cardNum then
			table.remove( self._playerOutData,i )
			break
		end
	end
end
-- 写入杠牌或者碰牌数据 opType 1:杠 2:碰
function ManagerData:insertPlayerGangPengData( cardNum,opType )
	assert(cardNum," !! cardNum is nil !! ")
	assert(opType == 1 or opType == 2," !! opType must be 1 or 2 !! ")
	local repNum = 0
	if opType == 1 then
		repNum = 4
	elseif opType == 2 then
		repNum = 3
	end
	for i = 1,repNum do
		table.insert( self._playerGangPengData,cardNum )
	end
end
-- 针对明杠 写入一个杠牌数据
function ManagerData:insertPlayerGangPengDataByMingGang( cardNum )
	assert(cardNum," !! cardNum is nil !! ")
	table.insert( self._playerGangPengData,cardNum )
end








-- 将数据写入到ai的手牌
function ManagerData:insertAIHandData( cardNum )
	assert( cardNum," !! cardNum is nil !! " )
	table.insert( self._aiHandData,cardNum )
	table.sort( self._aiHandData )
end
-- 从ai手牌中移除数据
function ManagerData:removeAIHandData( cardNum )
	assert( cardNum," !! cardNum is nil !! ")
	for i,v in ipairs( self._aiHandData ) do
		if v == cardNum then
			table.remove( self._aiHandData,i )
			break
		end
	end
end
-- 将数据写入到ai的出牌区
function ManagerData:insertAIOutData( cardNum )
	assert( cardNum," !! cardNum is nil !! " )
	table.insert( self._aiOutData,cardNum )
end
-- 将数据从玩家出牌区移除
function ManagerData:removeAIOutCard( cardNum )
	assert( cardNum," !! cardNum is nil !! ")
	for i = #self._aiOutData,1,-1 do
		if self._aiOutData[i] == cardNum then
			table.remove( self._aiOutData,i )
			break
		end
	end
end
-- 写入杠牌或者碰牌数据 opType 1:杠 2:碰
function ManagerData:insertAIGangPengData( cardNum,opType )
	assert(cardNum," !! cardNum is nil !! ")
	assert(opType == 1 or opType == 2," !! opType must be 1 or 2 !! ")
	local repNum = 0
	if opType == 1 then
		repNum = 4
	elseif opType == 2 then
		repNum = 3
	end
	for i = 1,repNum do
		table.insert( self._aiGangPengData,cardNum )
	end
end
-- 针对明杠 写入一个杠牌数据
function ManagerData:insertAIGangPengDataByMingGang( cardNum )
	assert(cardNum," !! cardNum is nil !! ")
	table.insert( self._aiGangPengData,cardNum )
end























--[[
	计算当前的手牌能不能胡
	cardNum:ai的出牌或者自己的摸牌
	source:自己的手牌
]]
function ManagerData:checkHu( cardNum,source )
	assert( cardNum," !! cardNum is nil !! " )
	assert( source," !! source is nil !! " )
	-- 构造新的手牌数组
	local new_source = clone( source )
	table.insert( new_source,cardNum )
	table.sort( new_source )

	-- 步骤1 从上述数组中找到一对做"将",并从数组中移除
	local hash_card = self:calHashCard( new_source )
	local jiang = {}
	for k,v in pairs( hash_card ) do
		if v >= 2 then
			table.insert( jiang,k )
		end
	end
	local remove_jiang = {}
	for i,v in ipairs( jiang ) do
		local left = clone( new_source )
		local temp = 0
		for a = #left,1,-1 do
			if left[a] == v and temp < 2 then
				table.remove( left,a )
				temp = temp + 1
			end
		end
		table.insert( remove_jiang,left )
	end

	-- 步骤2 每组进行检查
	for i,v in ipairs( remove_jiang ) do
		local can = self:checkHuBySource(v)
		if can then
			return true
		end
	end
	return false
end
function ManagerData:calHashCard( source )
	local result = {}
	for i,v in ipairs( source ) do
		if result[v] == nil then
			result[v] = 1
		else
			result[v] = result[v] + 1
		end
	end
	return result
end
-- 是否胡牌
function ManagerData:checkHuBySource( source )
	-- 1:余牌数量为0 则返回 "能胡牌"
	if #source == 0 then
		return true
	end
	-- 2:判断前三张是否相同
	if source[1] == source[2] and source[1] == source[3] then
		-- 相同 移除前三张
		for i = #source,1,-1 do
			if i <= 3 then
				table.remove(source,i)
			end
		end
		-- 递归再次验证
		return self:checkHuBySource(source)
	else
		-- 不同 判断是否存在顺子
		local num1 = source[1]
		local num2 = num1 + 1
		local num3 = num1 + 2
		if self:checkHasNumBySource( source,num2 ) and self:checkHasNumBySource( source,num3 ) then
			-- 移除这三张牌
			local has1,index1 = self:checkHasNumBySource( source,num1 )
			table.remove( source,index1 )
			local has2,index2 = self:checkHasNumBySource( source,num2 )
			table.remove( source,index2 )
			local has3,index3 = self:checkHasNumBySource( source,num3 )
			table.remove( source,index3 )
			-- 递归再次验证
			return self:checkHuBySource(source)
		end
	end
	return false
end
-- 检查是否有某张牌
function ManagerData:checkHasNumBySource( source,num )
	if num > 9 then
		return false
	end
	for i,v in ipairs(source) do
		if v == num then
			return true,i
		end
	end
	return false
end
-- 获取能胡的牌
function ManagerData:getHuResult( source )
	local result = {}
	for i = 1,9 do
		local can = self:checkHu(i,source)
		if can then
			table.insert( result,i )
		end
	end
	local oo = { 11,21,31,41,51,61,71 }
	for i,v in ipairs(oo) do
		local can = self:checkHu(v,source)
		if can then
			table.insert( result,v )
		end
	end
	return result
end
-- 获取当前牌在牌堆中出现的次数( 玩家的出牌,杠牌和碰牌 ai的出牌,杠牌和碰牌 )
function ManagerData:getTimesFromOutCards( cardNum )
	assert( cardNum," !! cardNum is nil !! " )

	local times = 0
	for i,v in ipairs( self._aiOutData ) do
		if v == cardNum then
			times = times + 1
		end
	end
	for i,v in ipairs( self._playerOutData ) do
		if v == cardNum then
			times = times + 1
		end
	end
	for i,v in ipairs( self._aiGangPengData ) do
		if v == cardNum then
			times = times + 1
		end
	end
	for i,v in ipairs( self._playerGangPengData ) do
		if v == cardNum then
			times = times + 1
		end
	end
	return times
end
-- 根据胡牌的结果 计算可以胡牌的个数 (从牌堆中和自己手牌中计算)
function ManagerData:getHuPaiNumsByResult( huResult,handSource )
	assert( huResult," !! huResult is nil !! ")
	assert( handSource," !! handSource is nil !! ")
	local nums = 0
	for i,v in ipairs( huResult ) do
		-- 牌堆的个数
		local times = self:getTimesFromOutCards( v )
		-- 自己手牌的个数
		local hand_num = 0
		for a,b in ipairs(handSource) do
			if b == v then
				hand_num = hand_num + 1
			end
		end
		local left = 4 - hand_num - times
		nums = nums + left
	end
	assert( nums >= 0," !! nums must be > 0 !! " )
	return nums
end
-- 是否已经听牌
function ManagerData:checkTing( source )
	for i = 1,9 do
		local can = self:checkHu(i,source)
		if can then
			return true
		end
	end
	local oo = { 11,21,31,41,51,61,71 }
	for i,v in ipairs(oo) do
		local can = self:checkHu(v,source)
		if can then
			return true
		end
	end
	return false
end

return ManagerData