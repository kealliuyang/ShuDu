

-- ai手牌的node
local HandCard 	 		= import("app.viewsmajiang.Card.HandCard")
local OutCard           = import("app.viewsmajiang.Card.OutCard")
local PengCard  		= import("app.viewsmajiang.Card.PengCard")
local AINode 	 		= class("AINode",BaseNode)

function AINode:ctor( gameLayer,managerData )
	assert( gameLayer, " !! gameLayer is nil !! ")
	AINode.super.ctor( self,"AINode" )
	self._gameLayer = gameLayer
	self._managerData = managerData
	-- 手牌的nodes
	self._handNodes = {}
	-- 出牌的nodes
	self._outNodes = {}
	-- 碰牌 杠牌的nodes
	self._pengGangNodes = {}
	-- 摸牌的node
	self._moNode = nil
	-- 手牌的起点位置
	self._handStartPos = cc.p( self._gameLayer.OtherCardNode:getPosition() )
	-- 出牌区的起点位置
	self._outStartPos = { x = self._handStartPos.x - 100,y = self._handStartPos.y - 150 }
end




-- ##################### 牌局开始的发牌动画 #####################################
-- 发牌的动画(2张一组)
function AINode:sendCardAction( data )
	assert( data," !! data is nil !! " )
	-- 其余牌的先移动 空出位置
	self:handNodesMove( data )
	-- 发牌
	for i,v in ipairs( data ) do
		self:sendOneCardInHandAction( v )
	end
end
--[[
	手牌移动的动画 为插入牌做准备
	data: 形如这样的数据格式 发牌是{ 1,2 } 摸牌是{8}
	返回 执行动画的时间
]]
function AINode:handNodesMove( data )
	assert( data," !! data is nil !! " )
	local action_time = 0.2
	for i,v in ipairs( self._handNodes ) do
		local num = v:getNum()
		local move_pos = 0
		-- 计算要移动的位置
		if num > data[1] then
			move_pos = move_pos + 1
		end
		if data[2] and num > data[2] then
			move_pos = move_pos + 1
		end
		local card_width = self:getHandCardWidth()
		local move_x = card_width * move_pos
		if move_pos > 0 then
			local move_by = cc.MoveBy:create(action_time,cc.p(-move_x,0))
			v:runAction( move_by )
		end
	end
	return action_time
end

-- 单个牌发到手中的动画 并创建handNode
function AINode:sendOneCardInHandAction( cardNum )
	assert( cardNum," !! cardNum is nil !! " )
	-- 创建要移动的sp
	local sp = ccui.ImageView:create("image/2/pai/small_gai.png",1)
	self:addChild( sp )
	sp:setPosition(display.cx,display.cy)
	-- 计算sp要移动的终点位置
	local pos_index = self:getCardPosIndex( self._handNodes,cardNum )
	local card_width = self:getHandCardWidth()
	local end_pos = { 
		x = self._handStartPos.x - (pos_index-1) * card_width, 
		y = self._handStartPos.y
	}
	local card_node = self:createHandNode( cardNum,end_pos )
	card_node:setVisible( false )
	local move_to = cc.MoveTo:create( 0.2,end_pos )
	local show_hand_node = cc.CallFunc:create( function()
		card_node:setVisible( true )
	end )
	local remove = cc.RemoveSelf:create()
	local seq = cc.Sequence:create({ move_to,show_hand_node,remove})
	sp:runAction( seq )
end
-- 创建玩家手牌的node
function AINode:createHandNode( cardNum,position )
	assert( cardNum," !! cardNum is nil !! " )
	assert( position," !! position is nil !! " )
	local card_node = HandCard.new(2,cardNum,self._gameLayer)
	self:addChild( card_node )
	card_node:setPosition( position )
	-- 写入handNodes
	table.insert( self._handNodes,card_node )
	return card_node
end
--[[
	-- 获取当前牌在手牌中的位置
	handNodes -- 当前所有手牌的node
]]
function AINode:getCardPosIndex( handNodes,cardNum )
	assert( handNodes," !! handNodes is nil !! " )
	assert( cardNum," !! cardNum is nil !! " )
	local pos_index = -1
	local nums = {}
	for i,v in ipairs( handNodes ) do
		local num = v:getNum()
		table.insert(nums,num)
	end
	table.sort(nums)
	for i,v in ipairs(nums) do
		if v > cardNum then
			pos_index = i
			break
		end
	end
	if pos_index == -1 then
		pos_index = #nums + 1
	end
	return pos_index
end
-- #############################################################################




-- ####################### 针对玩家出牌的逻辑 #####################################
--[[
	playerOutCardNum:ai出的牌
]]
function AINode:checkPlayerOutLogic( playerOutCardNum )
	assert( playerOutCardNum," !! playerOutCardNum is nil !! " )
	-- 1:判断是否胡牌
	local is_hu = self._managerData:checkHu( playerOutCardNum,self._managerData._aiHandData )
	if is_hu then
		-- 发送消息 ai胡牌
		EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_GAMEOVER,2 )
		return
	end
	-- 2:判断是否可以杠(点杠)
	local is_dian_gang,gang_num = self:checkDianGang( playerOutCardNum )
	if is_dian_gang then
		-- 发送消息 点杠
		EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_AI_GANG,gang_num,3 )
		return
	end
	-- 3:判断是否可以碰
	local is_peng,out_num = self:checkPeng( playerOutCardNum )
	if is_peng then
		EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_AI_PENG,playerOutCardNum,out_num )
		return
	end
	-- 4:ai自己摸牌
	EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_MO_CARD,2 )
end
-- #############################################################################




-- ##################### 摸牌的逻辑 #####################################
--[[
	摸牌 当摸完一张牌后
]]
function AINode:createMoNode()
	-- 从管理数据model中获取摸牌的数据
	local num = self._managerData:moCard( false )
	if num > 0 then
		local card_node = HandCard.new(2,num,self._gameLayer)
		self:addChild( card_node )
		self._moNode = card_node

		local mo_pos = {
			x = self._handStartPos.x - 900,
			y = self._handStartPos.y - 100
		}
		card_node:setPosition( mo_pos )

		local move_by1 = cc.MoveBy:create(0.2,cc.p(0,120))
		local move_by2 = cc.MoveBy:create(0.1,cc.p(0,-20))
		local check_call = cc.CallFunc:create( function()
			-- 检查状态 是否可以胡或者杠
			self:moCardLogic( num,1 )
		end )
		local seq = cc.Sequence:create({ move_by1,move_by2,check_call })
		card_node:runAction( seq )
	end
end
--[[
	摸牌完成后的逻辑
]]
function AINode:moCardLogic( moCardNum )
	assert( moCardNum," !! moCardNum is nil !! " )
	-- 1:检查是否胡牌
	local is_hu = self._managerData:checkHu( moCardNum,self._managerData._aiHandData )
	if is_hu then
		-- 发送消息 ai胡牌
		EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_GAMEOVER,2 )
		return
	end
	-- 2:判断有没有可以暗杠的牌
	local is_an_gang,gang_num = self:checkAnGang( moCardNum )
	if is_an_gang then
		-- 发送消息 暗杠
		EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_AI_GANG,gang_num,1 )
		return
	end
	-- 3:判断有没有可以明杠的牌
	local is_ming_gang,gang_num = self:checkMingGang( moCardNum )
	if is_ming_gang then
		-- 发送消息 明杠
		EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_AI_GANG,gang_num,2 )
		return
	end
	-- 4:选择出牌
	local choose_out_card = self:chooseCardOutByMo( moCardNum )
	EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_AI_OUT_CARD,choose_out_card,1 )
end
-- #####################################################################





-- ##################### 杠牌的逻辑 #####################################
--[[
	cardNum:  要杠的牌
	gangType: 1:自己摸暗杠 2:自己摸明杠 3:玩家点杠 
]]
function AINode:gangCard( cardNum,gangType )
	assert( cardNum," !! cardNum is nil !! " )
	assert( gangType == 1 or gangType == 2 or gangType == 3," !! gangType must be 1 or 2 or 3 !! " )

	if gangType == 1 then
		-- 1:暗杠
		self:createAnGangNodes( cardNum )
	elseif gangType == 2 then
		-- 2:明杠
		self:createMingGangNodes( cardNum )
	elseif gangType == 3 then
		-- 3:点杠
		self:createDianGangNodes( cardNum )
	end
end
-- #####################################################################



-- ##################### 暗杠的逻辑 #####################################
--[[
	判断暗杠 此时一定是摸牌
	moCardNum:此时摸的牌
]]
function AINode:checkAnGang( moCardNum )
	assert( moCardNum," !! moCardNum is nil !! " )
	local source = clone( self._managerData._aiHandData )
	table.insert( source,moCardNum )
	local ai_hand_card = self._managerData:calHashCard( source )
	local nums = {}
	for k,v in pairs(ai_hand_card) do
		if v == 4 then
			table.insert( nums,k )
		end
	end
	if #nums == 0 then
		return false
	end
	table.sort(nums,function(a,b) return a > b end )
	-- 先暗杠非万字的牌
	for i,v in ipairs(nums) do
		if v > 9 then
			return true,v
		end
	end
	-- 针对需要杠万字牌的逻辑
	local is_ting = self._managerData:checkTing( self._managerData._aiHandData )
	for i,v in ipairs(nums) do
		-- 构造没有此杠牌的数组
		local temp_ai_card = {}
		for a,b in ipairs( source ) do
			if b ~= v then
				table.insert( temp_ai_card,b )
			end
		end
		table.sort( temp_ai_card )
		-- 逻辑 先判断手牌是否有听
		if is_ting then
			-- 杠了之后 必须听牌 才杠
			local is_temp_ting = self._managerData:checkTing( temp_ai_card )
			if is_temp_ting then
				return true,v
			end
		else
			-- 当此杠牌和其余的牌能组成听牌的时候 就不杠; 否则 直接杠
			local cc_temp_ting = false
			for o,p in ipairs( temp_ai_card ) do
				local cc_temp = clone( temp_ai_card )
				table.remove( cc_temp,i )
				for j = 1,4 do
					table.insert( cc_temp,v )
				end
				cc_temp_ting = self._managerData:checkTing( cc_temp )
			end
			if not cc_temp_ting then
				return true,v
			end
		end
	end
	return false
end
--[[
	创建暗杠的nodes 并处理相关数据
	cardNum:要暗杠的数字
]]
function AINode:createAnGangNodes( cardNum )
	assert( cardNum," !! cardNum is nil !! ")
	assert( self._moNode," !! self._moNode is nil !! " )

	-- 1:创建杠牌的nodes
	self:createGangNodes( cardNum,1 )
	-- 写入杠牌数据
	self._managerData:insertAIGangPengData( cardNum,1 )

	-- 2:要杠的牌从手牌中先移除
	local remove_num = 0
	for i = #self._handNodes,1,-1 do
		if self._handNodes[i]:getNum() == cardNum then
			self._handNodes[i]:removeFromParent()
			table.remove( self._handNodes,i )
			-- 从手牌中移除数据
			self._managerData:removeAIHandData( cardNum )
			remove_num = remove_num + 1
		end
	end

	-- 3:剩余的手牌从新设置位置
	self:resetHandNodesPosition( cardNum,remove_num )

	-- 4:针对moNode的操作(分2种情况 1:暗杠的牌全是手中的牌 2：暗杠的牌有摸牌)
	if self._moNode:getNum() == cardNum then
		self._moNode:removeFromParent()
		self._moNode = nil
		-- ai 再摸一张牌
		EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_MO_CARD,2 )
	else
		-- 需要将摸牌插入到手牌中
		local call_back = function()
			-- 插入手牌数据
			self._managerData:insertAIHandData( self._moNode:getNum() )
			-- moNode插入手牌nodes
			table.insert( self._handNodes,self._moNode )
			-- 摸牌执行插入动画
			self._moNode = nil
			-- ai 再摸一张牌
			EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_MO_CARD,2 )
		end
		self:inertMoCardToHandCardAction( call_back )
	end
end
-- #####################################################################



-- ##################### 明杠的逻辑 #####################################
--[[
	判断明杠 此时一定是摸牌
	moCardNum:此时摸的牌
	返回值:返回要明杠的牌
]]
function AINode:checkMingGang( moCardNum )
	assert( moCardNum," !! moCardNum is nil !! " )
	local ai_peng_gang = self._managerData:calHashCard( self._managerData._aiGangPengData )
	-- 1:要明杠的牌是摸的那张牌
	-- 明杠是这样的逻辑 如果是摸牌是明杠的那张牌 先判断摸牌是否直接明杠 然后再判断手牌中是否明杠
	if ai_peng_gang[moCardNum] and ai_peng_gang[moCardNum] == 3 then
		-- 非万字 直接明杠
		if moCardNum > 9 then
			return true,moCardNum 
		end
		-- 如果是万字 分2种情况
		-- 1:如果手牌已经听牌 直接杠
		local hand_ting = self._managerData:checkTing( self._managerData._aiHandData )
		if hand_ting then
			return true,moCardNum
		end
		-- 2：如果没有听 如果与现有的手牌不能组合为听牌 也直接杠
		local source = clone( self._managerData._aiHandData )
		local can_ting = false
		for i,v in ipairs( source ) do
			local temp_source = clone( source )
			table.remove( temp_source,i )
			table.insert( temp_source,moCardNum )
			local temp_ting = self._managerData:checkTing( temp_source )
			if temp_ting then
				can_ting = true
				break
			end
		end
		if not can_ting then
			return true,moCardNum
		end
	end
	-- 2:要明杠的牌不是摸的那张牌 ( 去除当前要明杠的牌 检查能否听 能听就杠 )
	local source = clone( self._managerData._aiHandData )
	table.insert( source,moCardNum )
	table.sort( source,function(a,b) return a > b end )
	for i,v in ipairs( source ) do
		if ai_peng_gang[v] and ai_peng_gang[v] == 3 then
			-- 去除当前要明杠的牌 检查能否听 能听就杠
			local temp_source = clone( source )
			table.remove( temp_source,i )
			local temp_ting = self._managerData:checkTing( temp_source )
			if temp_ting then
				return true,v
			end
		end
	end
	return false
end
--[[
	创建明杠的nodes 并处理相关数据 此时一定是摸牌
	cardNum:要明杠的数字
]]
function AINode:createMingGangNodes( cardNum )
	assert( cardNum," !! cardNum is nil !! ")
	assert( self._moNode," !! self._moNode is nil !! " )
	-- 1:创建杠牌的node
	local peng_card = self:getChildByTag( 10000 + cardNum + 2 )
	if peng_card then
		local peng_card_gang = PengCard.new(2,cardNum,self._gameLayer)
		self:addChild( peng_card_gang )
		table.insert( self._pengGangNodes,peng_card_gang )
		local card_pos = cc.p( peng_card:getPosition() )
		card_pos.y = card_pos.y + 8
		peng_card_gang:setPosition( card_pos )
		peng_card_gang:setZOrder(10)
	end
	-- 写入杠牌数据
	self._managerData:insertAIGangPengDataByMingGang( cardNum )
	-- 2:针对moNode的操作
	if self._moNode:getNum() == cardNum then
		-- 杠牌是摸牌
		self._moNode:removeFromParent()
		self._moNode = nil
		-- 3:ai再摸一张牌
		EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_MO_CARD,2 )
	else
		-- 杠牌是手中牌
		-- 1:要杠的牌从手牌中先移除
		local remove_num = 0
		for i = #self._handNodes,1,-1 do
			if self._handNodes[i]:getNum() == cardNum then
				self._handNodes[i]:removeFromParent()
				table.remove( self._handNodes,i )
				-- 从手牌中移除数据
				self._managerData:removeAIHandData( cardNum )
				remove_num = remove_num + 1
			end
		end
		-- 2:剩余的手牌从新设置位置
		self:resetHandNodesPosition( cardNum,remove_num,true )

		-- 需要将摸牌插入到手牌中
		local call_back = function()
			-- 插入手牌数据
			self._managerData:insertAIHandData( self._moNode:getNum() )
			-- moNode插入手牌nodes
			table.insert( self._handNodes,self._moNode )
			-- 摸牌执行插入动画
			self._moNode = nil
			-- ai 再摸一张牌
			EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_MO_CARD,2 )
		end
		self:inertMoCardToHandCardAction( call_back )
	end
end
-- #####################################################################



-- ##################### 点杠的逻辑 #####################################
--[[
	判断是否要点杠
	playerOutNum:玩家的出牌
]]
function AINode:checkDianGang( playerOutNum )
	assert( playerOutNum," !! playerOutNum is nil !! " )
	local ai_hand_card = self._managerData:calHashCard( self._managerData._aiHandData )
	if ai_hand_card[playerOutNum] and ai_hand_card[playerOutNum] == 3 then
		-- 非万字 直接点杠
		if playerOutNum > 9 then
			return true,playerOutNum
		end
		-- 如果是万字(如果已经听牌 杠了之后还能听牌 就杠 如果不能听牌，碰了之后还是不能听牌 就杠)
		local is_ting = self._managerData:checkTing( self._managerData._aiHandData )
		if is_ting then
			-- 如果已经听牌 杠了之后还能听牌 就杠
			local temp_hand = clone( self._managerData._aiHandData )
			for i = #temp_hand,1,-1 do
				if temp_hand[i] == playerOutNum then
					table.remove( temp_hand,i )
				end
			end
			local temp_ting = self._managerData:checkTing(temp_hand)
			if temp_ting then
				return true,playerOutNum
			end
		else
			-- 如果不能听牌，碰了之后还是不能听牌 就杠
			local temp_hand = clone( self._managerData._aiHandData )
			local remove_num = 0
			for i = #temp_hand,1,-1 do
				if temp_hand[i] == playerOutNum then
					table.remove( temp_hand,i )
					remove_num = remove_num + 1
				end
				if remove_num == 2 then
					break
				end
			end
			local can_ting = false
			for i,v in ipairs(temp_hand) do
				local cc_temp_hand = clone( temp_hand )
				table.remove( cc_temp_hand,i )
				local cc_temp_ting = self._managerData:checkTing( cc_temp_hand )
				if cc_temp_ting then
					can_ting = true
					break
				end
			end
			if not can_ting then
				return true,playerOutNum
			end
		end
	end
	return false
end
--[[
	创建点杠的nodes 并处理相关数据
	cardNum:要点杠的数字
]]
function AINode:createDianGangNodes( cardNum )
	assert( cardNum," !! cardNum is nil !! " )
	-- 1:创建杠牌的nodes
	self:createGangNodes( cardNum,3 )
	-- 写入杠牌数据
	self._managerData:insertAIGangPengData( cardNum,1 )
	-- 2:要杠的牌从手牌中先移除
	local remove_num = 0
	for i = #self._handNodes,1,-1 do
		if self._handNodes[i]:getNum() == cardNum then
			self._handNodes[i]:removeFromParent()
			table.remove( self._handNodes,i )
			-- 从手牌中移除数据
			self._managerData:removeAIHandData( cardNum )
			remove_num = remove_num + 1
		end
	end
	-- 3:剩余的手牌从新设置位置
	self:resetHandNodesPosition( cardNum,remove_num )
	-- 4:发送消息 ai 再摸一张牌
	EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_MO_CARD,2 )
end
-- #####################################################################



-- ##################### 碰牌的逻辑 #####################################
--[[
	playerOutNum:要碰的牌
	返回值:碰了之后要出的牌
]]
function AINode:checkPeng( playerOutNum )
	assert( playerOutNum, " !! playerOutNum is nil !! " )
	local ai_hand_card = self._managerData:calHashCard( self._managerData._aiHandData )
	if ai_hand_card[playerOutNum] and ai_hand_card[playerOutNum] >= 2 then
		-- 构造碰牌之后的新数据
		local temp_hand = clone( self._managerData._aiHandData )
		local remove_num = 0
		for i = #temp_hand,1,-1 do
			if temp_hand[i] == playerOutNum then
				table.remove( temp_hand,i )
				remove_num = remove_num + 1
			end
			if remove_num == 2 then
				break
			end
		end
		-- 如果没有听 直接碰
		local is_ting = self._managerData:checkTing( self._managerData._aiHandData )
		if not is_ting then
			local ai_out_num = self:chooseCardOutBySource( temp_hand )
			return true,ai_out_num
		end

		-- 如果听了 检查碰之后的胡牌数目 碰了之后的胡牌数大于没有碰的胡牌数 就碰
		-- 获取没有碰之前的胡牌数
		local hu_result_org = self._managerData:getHuResult( self._managerData._aiHandData )
		local hu_num_org = self._managerData:getHuPaiNumsByResult( hu_result_org,self._managerData._aiHandData )
		-- 获取碰了之后的胡牌数
		local hu_peng_result = {}
		for i,v in ipairs( temp_hand ) do
			local temp_source = clone( temp_hand )
			-- 移除当前
			table.remove( temp_source,i )
			local result = self._managerData:getHuResult( temp_source )
			-- 有能胡的牌
			if #result > 0 then
				local meta = {}
				meta.result = result
				meta.cardnum = v
				meta.hunum = self._managerData:getHuPaiNumsByResult( result,self._managerData._aiHandData )
				-- 计算当前还有几张可以胡 (从牌堆中和自己手牌中计算)
				table.insert(hu_peng_result,meta)
			end
		end
		-- 排序
		table.sort( hu_peng_result,function( a,b )
			if a.hunum ~= b.hunum then
				return a.hunum > b.hunum
			end
			return a.cardnum > b.cardnum
		end )
		-- 如果碰了之后的胡牌数大于没有碰的胡牌数 就碰
		if #hu_peng_result > 0 and hu_peng_result[1].hunum > hu_num_org then
			return true,hu_peng_result[1].cardnum
		end
	end
	return false
end
--[[
	创建碰牌的nodes
	cardNum:要碰的牌
	outNum:碰之后要出的牌
]]
function AINode:createPengNodes( cardNum,outNum )
	assert( cardNum," !! cardNum is nil !! " )
	assert( outNum," !! outNum is nil !! " )
	-- 1:添加node到碰牌杠牌区域
	local nums = table.nums(self._managerData:calHashCard(self._managerData._aiGangPengData))
	local start_pos = clone( self._handStartPos )
	local space = nums * 20
	start_pos.x = start_pos.x - nums * 3 * self:getPengCardWidth() - space
	for i = 1,3 do
		local peng_card = PengCard.new(2,cardNum,self._gameLayer)
		self:addChild( peng_card )
		table.insert( self._pengGangNodes,peng_card )
		peng_card:setTag( 10000 + cardNum + i )
		local card_pos = clone(start_pos)
		card_pos.x = card_pos.x - (i-1) * self:getPengCardWidth()
		peng_card:setPosition( card_pos )
	end
	-- 2:写入碰牌数据
	self._managerData:insertAIGangPengData( cardNum,2 )
	-- 2:要碰的牌从手牌中先移除
	local remove_num = 0
	for i = #self._handNodes,1,-1 do
		if self._handNodes[i]:getNum() == cardNum then
			self._handNodes[i]:removeFromParent()
			table.remove( self._handNodes,i )
			-- 从手牌中移除数据
			self._managerData:removeAIHandData( cardNum )
			remove_num = remove_num + 1
			if remove_num == 2 then
				break
			end
		end
	end
	-- 3:剩余的手牌从新设置位置
	self:resetHandNodesPosition( cardNum,remove_num )
	-- 4:AI出牌
	EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_AI_OUT_CARD,outNum,2 )
end
--[[
	碰牌后的出牌
	cardNum:要出的牌
]]
function AINode:outHandCardByPeng( cardNum )
	assert( cardNum," !! cardNum is nil !! " )
	local handNode = nil
	for i,v in ipairs( self._handNodes ) do
		if v:getNum() == cardNum then
			handNode = v
			break
		end
	end
	assert( handNode," !! handNode is nil !! " )
	local pos_x = handNode:getPositionX()
	local clear_call = function()
		-- 从手牌中移除当前数据
		self._managerData:removeAIHandData( handNode:getNum() )
		-- 手牌移动
		local call_back_notice = function()
			-- 通知玩家 AI已经出牌
			EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_PLAYER_TURN,cardNum )
		end
		self:moveHandNodesWhenOneHandMoveOut( handNode,pos_x,call_back_notice )
	end
	self:moveHandNodeAndCreateOutNode( handNode,clear_call )
end
-- #####################################################################




-- ################# 选择出牌的逻辑和AI出牌的逻辑 ########################
--[[
	ai根据手牌和摸牌组成的牌中选择一张出牌
	moCardNum:自己摸的牌
]] 
function AINode:chooseCardOutByMo( moCardNum )
	assert( moCardNum," !! moCardNum is nil !! " )
	local source = clone( self._managerData._aiHandData )
	table.insert( source,moCardNum )
	return self:chooseCardOutBySource( source )
end
-- 根据当前的牌选择一张出牌
function AINode:chooseCardOutBySource( source )
	assert( source," !! source is nil !! ")
	table.sort( source )
	-- 出一张 检查是否能听牌
	local hu_result = {}
	for i,v in ipairs( source ) do
		local temp_source = clone( source )
		-- 移除当前
		table.remove( temp_source,i )
		local result = self._managerData:getHuResult( temp_source )
		-- 有能胡的牌
		if #result > 0 then
			local meta = {}
			meta.result = result
			meta.cardnum = v
			meta.hunum = self._managerData:getHuPaiNumsByResult( result,source )
			-- 计算当前还有几张可以胡 (从牌堆中和自己手牌中计算)
			table.insert(hu_result,meta)
		end
	end
	-- 排序
	table.sort( hu_result,function( a,b )
		if a.hunum ~= b.hunum then
			return a.hunum > b.hunum
		end
		return a.cardnum > b.cardnum
	end )

	-- 如果能听
	if #hu_result > 0 then
		-- 取胡牌多的
		return hu_result[1].cardnum
	else
		-- 不能听
		-- 优先出单个的 且不是万字的牌
		local ai_hand_card = self._managerData:calHashCard( source )
		local singel = {}
		for k,v in pairs( ai_hand_card ) do
			if v == 1 then
				table.insert( singel,k )
				if k > 9 then
					return k
				end
			end
		end
		-- 单个万字的牌
		if #singel > 0 then
			-- 1:此牌没有连牌
			for i,v in ipairs(singel) do
				local has_shunzi = self._managerData:checkShunZiByCard( source,v )
				if not has_shunzi then
					return v
				end
			end
			-- 2:此牌在出牌中已经有1张以上
			for i,v in ipairs(singel) do
				local times = self._managerData:getTimesFromOutCards( v )
				if times > 1 then
					return v
				end
			end
			-- 3:随便选一张
			return singel[random(1,#singel)]
		else
			-- 没有单个的牌
			-- 1:此牌在出牌中已经有1张以上
			for i,v in ipairs(source) do
				local times = self._managerData:getTimesFromOutCards( v )
				if times > 1 then
					return v
				end
			end
			-- 2:随便选一张
			return source[random(1,#source)]
		end
	end
end
--[[
	自己摸牌的出牌逻辑
	outCardNum:要出的牌的数字
]]
function AINode:outCardNodeByMo( outCardNum )
	assert( outCardNum," !! outCardNum is nil !! " )
	assert( self._moNode, " !! self._moNode is nil !! " )
	
	-- 两种情况 1:出牌是摸牌 2:出牌是手牌
	if self._moNode:getNum() == outCardNum then
		self:outMoCard( self._moNode )
	else
		local hand_node = nil
		-- 查找选中的手牌node 赋值
		for i,v in ipairs( self._handNodes ) do
			if v:getNum() == outCardNum then
				hand_node = v
				break
			end
		end
		self:outHandCardByMo( hand_node )
	end
end
--[[
	摸的那张牌出牌
]]
function AINode:outMoCard( handNode )
	assert( handNode," !! handNode is nil !! " )
	assert( self._moNode," !! self._moNode is nil !! " )
	-- 如果出的是摸牌 有以下几点 
	-- 1:将摸牌移动到出牌区域 然后创建出牌区的node
	-- 2:清空 self._moNode
	-- 3:出牌数据的处理
	local clear_call = function()
		-- 通知Player 玩家已经出牌
		EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_PLAYER_TURN,handNode:getNum() )
		self._moNode = nil
	end
	self:moveHandNodeAndCreateOutNode( handNode,clear_call )
end
--[[
	手牌出牌
	handNode:出牌的node
]]
function AINode:outHandCardByMo( handNode )
	assert( handNode," !! handNode is nil !! " )
	assert( self._moNode," !! self._moNode is nil !! " )
	-- 如果出的是手牌 有以下几点 
	-- 1:将手牌移动到出牌区 并将手牌从手牌的node数组中移除 创建出牌区的node
	-- 2:将手牌的node插入到手牌区
	-- 3:手牌和出牌数据的处理
	local out_num = handNode:getNum()
	local pos_x = handNode:getPositionX()
	local clear_call = function()
		-- 从手牌中移除当前数据
		self._managerData:removeAIHandData( handNode:getNum() )
		-- 手牌移动
		local insert_call = function()
			local call_back_notice = function()
				-- 插入手牌数据
				self._managerData:insertAIHandData( self._moNode:getNum() )
				-- moNode插入手牌nodes
				table.insert( self._handNodes,self._moNode )
				-- 通知玩家 AI已经出牌
				EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_PLAYER_TURN,out_num )
				-- 清除
				self._moNode = nil
			end
			-- 摸牌插入
			self:inertMoCardToHandCardAction( call_back_notice )
		end
		self:moveHandNodesWhenOneHandMoveOut( handNode,pos_x,insert_call )
	end
	self:moveHandNodeAndCreateOutNode( handNode,clear_call )
end
--[[
	将手牌或者摸牌的node移动到出牌的区域 并创建OutNode
]]
function AINode:moveHandNodeAndCreateOutNode( handNode,callBack )
	assert( handNode," !! handNode is nil !! " )
	assert( callBack," !! callBack is nil !! " )
	handNode:setZOrder( 200 )
	local end_pos = self:getMoveOutCardsPosition()
	local move_to = cc.MoveTo:create( 0.5,end_pos )
	local add_outnode = cc.CallFunc:create( function()
		local out_node = self:createOutNode( handNode:getNum() )
		out_node:setPosition( end_pos )
		-- 添加tips
		self:addOutCardTips( out_node )
	end )
	-- 清空状态
	local call_clear = cc.CallFunc:create( callBack )
	local remove = cc.RemoveSelf:create()
	local seq = cc.Sequence:create({ move_to,add_outnode,call_clear,remove })
	handNode:runAction( seq )
end
-- #####################################################################




-- ##################### 玩家胡牌之后 明牌 ##############################
-- 玩家胡牌之后 明牌
function AINode:huPaiChangeMingPai()
	local first_pos = {}
	first_pos.x = self:getFirstHandNodePositionX()
	first_pos.y = self._handStartPos.y

	-- 隐藏手中的node
	for i,v in ipairs( self._handNodes ) do
		v:setVisible( false )
	end
	
	-- 暗杠牌显示明牌
	for i,v in ipairs( self._pengGangNodes ) do
		if v.getAnMark and v:getAnMark() then
			v:showAnGang()
		end
	end

	local data = clone(self._managerData._aiHandData)
	table.sort( data )
	for i,v in ipairs( data ) do
		local peng_card = PengCard.new(2,v,self._gameLayer)
		local card_pos = clone( first_pos )
		card_pos.x = card_pos.x - (i-1) * self:getPengCardWidth()
		peng_card:setPosition( card_pos )
		self:addChild( peng_card )
	end

	-- 如果有手牌
	if self._moNode then
		self._moNode:setVisible( false )
		local num = self._moNode:getNum()
		local card_pos = cc.p(self._moNode:getPosition())
		local peng_card = PengCard.new(2,num,self._gameLayer)
		peng_card:setPosition( card_pos )
		self:addChild( peng_card )
	end
end
-- #####################################################################




-- ##################### 通用的逻辑 #####################################
--[[
	创建杠牌的nodes
	cardNum:要杠的牌
	gangType: 1:暗杠 2:明杠 3:点杠
]]
function AINode:createGangNodes( cardNum,gangType )
	assert( cardNum," !! cardNum is nil !! " )
	assert( gangType == 1 or gangType == 2 or gangType == 3," !! gangType must be 1 or 2 or 3 !! " )
	-- 添加node到碰牌杠牌区域
	local nums = table.nums(self._managerData:calHashCard(self._managerData._aiGangPengData))
	local start_pos = clone( self._handStartPos )
	local space = nums * 20
	start_pos.x = start_pos.x - nums * 3 * self:getPengCardWidth() - space
	for i = 1,3 do
		local peng_card = PengCard.new(2,cardNum,self._gameLayer)
		self:addChild( peng_card )
		table.insert( self._pengGangNodes,peng_card )
		local card_pos = clone(start_pos)
		card_pos.x = card_pos.x - (i-1) * self:getPengCardWidth()
		peng_card:setPosition( card_pos )

		-- 暗杠
		if gangType == 1 then
			peng_card:setAnGang()
		end

		if i == 2 then
			local peng_card_g = PengCard.new(2,cardNum,self._gameLayer)
			self:addChild( peng_card_g )
			table.insert( self._pengGangNodes,peng_card_g )
			card_pos.y = card_pos.y + 8
			peng_card_g:setPosition( card_pos )
			peng_card_g:setZOrder(10)

			if gangType == 1 then
				peng_card_g:setAnGang()
			end
		end
	end
end
--[[
	摸牌要插入手牌的动画
]]
function AINode:inertMoCardToHandCardAction( callBack )
	assert( self._moNode," !! self._moNode is nil !! " )
	assert( callBack," !! callBack is nil !! " )
	-- 分2步 2步同时进行 其余的手牌移动 摸牌插入手牌
	-- 其余手牌移动 空出位置
	local action_time = self:handNodesMove( { self._moNode:getNum() } )
	-- 移动完之后 执行插入动画
	local delay_time = cc.DelayTime:create( action_time + 0.02 )
	local pos_index = self:getCardPosIndex( self._handNodes,self._moNode:getNum() )
	local card_width = self:getHandCardWidth()
	local end_pos = {
		x = self:getFirstHandNodePositionX() - (pos_index-1) * card_width, 
		y = self._handStartPos.y
	}
	local jump_to = cc.JumpTo:create(action_time + 0.5,end_pos,-100,1)
    local call_back = cc.CallFunc:create(callBack)
    local seq = cc.Sequence:create({ delay_time,jump_to,call_back })
    self._moNode:runAction( seq )
end
--[[
	从新设置手牌的位置
	cardNum:移除的node的数字
	removeNum:移除的个数
]]
function AINode:resetHandNodesPosition( cardNum,removeNum,notNeedMove )
	assert( cardNum," !! cardNum is nil !! " )
	assert( removeNum," !! removeNum is nil !! " )
	-- 去掉杠牌/碰牌后 其余的牌先向前移动 (填补碰/杠之后的空白区域 必须是大于碰/杠的牌)
	for i,v in ipairs( self._handNodes ) do
		if v:getNum() > cardNum then
			local card_width = self:getHandCardWidth()
			local move_dis = card_width * removeNum
			local posx = v:getPositionX()
			posx = posx + move_dis
			v:setPositionX( posx )
		end
	end
	-- notNeedMove 针对明杠 不需要移动
	if not notNeedMove then
		-- 集体向后移动
		local move_dis = 0 - 3 * self:getPengCardWidth() - 20
		for i,v in ipairs( self._handNodes ) do
			local posx = v:getPositionX()
			v:setPositionX( posx + move_dis )
			-- local move_by = cc.MoveBy:create(0.2,cc.p(move_dis,0))
			-- v:runAction( move_by )
		end
	end
end
-- 获取手牌中第一张牌的位置
function AINode:getFirstHandNodePositionX()
	local first_posx = nil

	-- 针对全部碰或者杠之后 没有手牌的时候
	if #self._handNodes == 0 then
		local nums = table.nums(self._managerData:calHashCard(self._managerData._aiGangPengData))
		local start_pos = clone( self._handStartPos )
		local space = nums * 20
		first_posx = start_pos.x - nums * 3 * self:getPengCardWidth() - space
		return first_posx
	end

	for k,v in ipairs( self._handNodes ) do
		if first_posx == nil then
			first_posx = v:getPositionX()
		else
			if v:getPositionX() > first_posx then
				first_posx = v:getPositionX()
			end
		end
	end
	return first_posx
end
--[[
	获取要移动到出牌区的位置
]]
function AINode:getMoveOutCardsPosition()
	local nums = #self._outNodes
	local dis = nums * self:getOutCardWidth()
	local position = {
		x = self._outStartPos.x - dis,
		y = self._outStartPos.y
	}
	return position
end
--[[
	创建出牌区的node
]]
function AINode:createOutNode( cardNum )
	assert( cardNum," !! cardNum is nil !! " )
	local out_node = OutCard.new(2,cardNum,self._gameLayer)
	self:addChild( out_node )
	table.insert( self._outNodes,out_node )
	-- 将出牌数据写入
	self._managerData:insertAIOutData( cardNum )
	return out_node
end
--[[
	移除出牌区的某个node
	cardNum:要移除的某个数字
]]
function AINode:removeOutNode( cardNum )
	assert( cardNum," !! cardNum is nil !! ")
	-- 玩家的出牌区移除node (从后面向前)
	for i = #self._outNodes,1,-1 do
		if self._outNodes[i]:getNum() == cardNum then
			self._outNodes[i]:removeFromParent()
			table.remove( self._outNodes,i )
			break
		end
	end
	-- 从出牌区移除数据
	self._managerData:removeAIOutCard( cardNum )
end
--[[
	创建出牌的tips
]]
function AINode:addOutCardTips( outNode )
	assert( outNode," !! outNode is nil !! " )
	if self._outCardTips == nil then
		self._outCardTips = ccui.ImageView:create("image/2/outpointer.png",1)
		self:addChild( self._outCardTips )
		local move_by1 = cc.MoveBy:create(1,cc.p(0,15))
		local move_by2 = cc.MoveBy:create(1,cc.p(0,-15))
		local seq = cc.Sequence:create({move_by1,move_by2})
		local rep = cc.RepeatForever:create( seq )
		self._outCardTips:runAction(rep)
	end
	local pos = cc.p( outNode:getPosition() )
	pos.x = pos.x
	pos.y = pos.y + 50
	self._outCardTips:setPosition( pos )
	self._outCardTips:setVisible( true )
	self._outCardTips:setZOrder( 100 )
end
--[[
	隐藏出牌的tips
]]
function AINode:hideOutCardTips()
	if self._outCardTips then
		self._outCardTips:setVisible( false )
	end
end
--[[ 
	当出了一张牌 其余手牌的移动动画
	handNode:要从手牌中移除的node指针
	posX:handNode的初始位置 用于其余的node移动
]]
function AINode:moveHandNodesWhenOneHandMoveOut( handNode,posX,callBack )
	assert( handNode," !! handNode is nil !! ")
	assert( posX," !! posX is nil !! ")
	-- 将选中的node从手牌中移除
	for k,v in ipairs( self._handNodes ) do
		if v == handNode then
			table.remove( self._handNodes,k )
			break
		end
	end
	-- 其余手牌的移动动画(当出了一张手牌)
	for k,v in ipairs( self._handNodes ) do
		if v:getPositionX() < posX then
			local move_dis = self:getHandCardWidth()
			local move_by = cc.MoveBy:create(0.1,cc.p(move_dis,0))
			v:runAction( move_by )
		end
	end
	if callBack then
		local delay_time = cc.DelayTime:create(0.25)
		local call_back = cc.CallFunc:create( callBack )
		local seq = cc.Sequence:create({ delay_time,call_back })
		self:runAction( seq )
	end
end

function AINode:getHandCardWidth()
	if AI_MING_PAI then
		return 63
	else
		return 55
	end
end

function AINode:getOutCardWidth()
	return 43
end

function AINode:getPengCardWidth()
	return 40
end
-- #####################################################################




function AINode:printAIData()
	dump( self._managerData._aiHandData,"--------------------> _aiHandData = " )
	dump( self._managerData._aiOutData,"--------------------> _aiOutData = " )
	dump( self._managerData._aiGangPengData,"--------------------> _aiGangPengData = " )
end



return AINode
