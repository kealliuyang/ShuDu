
-- 玩家手牌的node
local HandCard 	 		= import("app.viewsmajiang.Card.HandCard")
local OutCard           = import("app.viewsmajiang.Card.OutCard")
local PengCard  		= import("app.viewsmajiang.Card.PengCard")
local PlayerNode 		= class("PlayerNode",BaseNode)

function PlayerNode:ctor( gameLayer,managerData )
	assert( gameLayer, " !! gameLayer is nil !! " )
	assert( managerData, " !! managerData is nil !! " )
	PlayerNode.super.ctor( self,"PlayerNode" )
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
	self._handStartPos = cc.p( self._gameLayer.MyCardNode:getPosition() )
	-- 出牌区的起点位置
	self._outStartPos = { x = self._handStartPos.x + 100,y = self._handStartPos.y + 150 }
	-- 是否可以出牌的标志
	self._canOutHandCard = false
end



-- ##################### 牌局开始的发牌动画 #####################################
-- 发牌的动画(2张一组)
function PlayerNode:sendCardAction( data )
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
function PlayerNode:handNodesMove( data )
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
			local move_by = cc.MoveBy:create(action_time,cc.p(move_x,0))
			v:runAction( move_by )

			-- 1:设置原始位置
			local org_pos = v:getOrgPosition()
			org_pos.x = org_pos.x + move_x
			v:setOrgPosition( org_pos )
		end
	end
	return action_time
end
-- 单个牌发到手中的动画 并创建handNode
function PlayerNode:sendOneCardInHandAction( cardNum )
	assert( cardNum," !! cardNum is nil !! " )
	-- 创建要移动的sp
	local sp = ccui.ImageView:create("image/2/pai/small_gai.png",1)
	self:addChild( sp )
	sp:setPosition(display.cx,display.cy)
	-- 计算sp要移动的终点位置
	local pos_index = self:getCardPosIndex( self._handNodes,cardNum )
	local card_width = self:getHandCardWidth()
	local end_pos = { 
		x = self._handStartPos.x + (pos_index-1) * card_width, 
		y = self._handStartPos.y
	}
	-- 创建
	local card_node = self:createHandNode( cardNum,end_pos )
	card_node:setVisible( false )
	-- 开始执行动画
	local move_to = cc.MoveTo:create( 0.2,end_pos )
	local show_hand_node = cc.CallFunc:create( function()
		card_node:setVisible( true )
	end )
	local remove = cc.RemoveSelf:create()
	local seq = cc.Sequence:create({ move_to,show_hand_node,remove})
	sp:runAction( seq )
end
-- 创建玩家手牌的node
function PlayerNode:createHandNode( cardNum,position )
	assert( cardNum," !! cardNum is nil !! " )
	assert( position," !! position is nil !! " )
	local card_node = HandCard.new(1,cardNum,self._gameLayer)
	self:addChild( card_node )
	card_node:setPosition( position )

	-- 2:设置原始位置(必须的 有用)
	card_node:setOrgPosition( position )

	-- 写入handNodes
	table.insert( self._handNodes,card_node )
	return card_node
end
--[[
	-- 获取当前牌在手牌中的位置
	handNodes -- 当前所有手牌的node
]]
function PlayerNode:getCardPosIndex( handNodes,cardNum )
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





-- ####################### 针对ai出牌的逻辑 #####################################
--[[
	aiOutCardNum:ai出的牌
]]
function PlayerNode:checkAIOutLogic( aiOutCardNum )
	assert( aiOutCardNum," !! aiOutCardNum is nil !! " )
	-- 判断是否胡牌
	local is_hu = self._managerData:checkHu( aiOutCardNum,self._managerData._playerHandData )
	if is_hu then
		-- 发送消息 player胡牌
		EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_PLAYER_HU,aiOutCardNum )
		-- return
	end
	-- 判断是否可以碰
	local is_peng = self._managerData:canPeng( aiOutCardNum,true )
	if is_peng then
		-- 判断是否可以杠
		local is_gang = self._managerData:canGang( aiOutCardNum,true,2 )
		if is_gang then
			EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_PLAYER_GANG,aiOutCardNum,3 )
		end
		-- 发送给界面 显示碰
		EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_PLAYER_PENG,aiOutCardNum )
		-- return
	end
	-- 玩家自己摸牌
	if not is_hu and not is_peng then
		EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_MO_CARD,1 )
	end
end
-- #############################################################################



-- ##################### 摸牌的逻辑 #####################################
--[[
	摸牌 当摸完一张牌后 需要检查是否能或者杠
]]
function PlayerNode:createMoNode()
	-- 从管理数据model中获取摸牌的数据
	local num = self._managerData:moCard( true )
	if num > 0 then
		local card_node = HandCard.new(1,num,self._gameLayer)
		self:addChild( card_node )
		self._moNode = card_node

		local mo_pos = {
			x = self._handStartPos.x + 900,
			y = self._handStartPos.y + 100
		}
		card_node:setPosition( mo_pos )

		-- 3:设置原始位置
		local org_pos = clone( mo_pos )
		org_pos.y = org_pos.y - 100
		card_node:setOrgPosition( org_pos )

		local move_by1 = cc.MoveBy:create(0.2,cc.p(0,-120))
		local move_by2 = cc.MoveBy:create(0.1,cc.p(0,20))
		local check_call = cc.CallFunc:create( function()
			-- 检查状态 是否可以胡或者杠
			self:moCardLogic( num,1 )
		end )
		local seq = cc.Sequence:create({ move_by1,move_by2,check_call })
		card_node:runAction( seq )
	end
end
function PlayerNode:moCardLogic( moCardNum )
	assert( moCardNum," !! moCardNum is nil !! " )
	-- 1:判断胡
	-- 判断是否胡牌
	local is_hu = self._managerData:checkHu( moCardNum,self._managerData._playerHandData )
	if is_hu then
		-- 发送消息 player胡牌
		EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_PLAYER_HU,moCardNum )
		-- return
	end
	-- 2:判断有没有可以暗杠的牌
	local is_an_gang,gang_num = self:checkAnGang( moCardNum )
	if is_an_gang then
		EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_PLAYER_GANG,gang_num,1 )
		return
	end
	-- 3:判断有没有明杠
	local is_ming_gang,gang_num = self:checkMingGang( moCardNum )
	if is_ming_gang then
		EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_PLAYER_GANG,gang_num,2 )
		return
	end
	-- 4:选择出牌
	if not is_hu then
		self._canOutHandCard = true
	end
end
-- #####################################################################



-- ##################### 杠牌的逻辑 #####################################
--[[
	cardNum:  要杠的牌
	gangType: 1:自己摸暗杠 2:自己摸明杠 3:AI点杠 
]]
function PlayerNode:gangCard( cardNum,gangType )
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




-- ##################### 碰牌的逻辑 #####################################
--[[
	cardNum:要碰的牌
]]
function PlayerNode:pengCard( cardNum )
	assert( cardNum," !! cardNum is nil !! " )
	-- 1:创建碰牌的nodes
	self:createPengNodes( cardNum )
	-- 2:写入碰牌数据
	self._managerData:insertPlayerGangPengData( cardNum,2 )
	-- 2:要碰的牌从手牌中先移除
	local remove_num = 0
	for i = #self._handNodes,1,-1 do
		if self._handNodes[i]:getNum() == cardNum then
			self._handNodes[i]:removeFromParent()
			table.remove( self._handNodes,i )
			-- 从手牌中移除数据
			self._managerData:removePlayerHandCard( cardNum )
			remove_num = remove_num + 1
			if remove_num == 2 then
				break
			end
		end
	end
	-- 3:剩余的手牌从新设置位置
	self:resetHandNodesPosition( cardNum,remove_num )
	-- 4:player出牌
	self._canOutHandCard = true
end
--[[
	创建碰牌的nodes
	cardNum:要碰的牌
]]
function PlayerNode:createPengNodes( cardNum )
	assert( cardNum," !! cardNum is nil !! " )
	-- 添加node到碰牌杠牌区域
	local nums = table.nums(self._managerData:calHashCard(self._managerData._playerGangPengData))
	local start_pos = clone( self._handStartPos )
	local space = nums * 20
	start_pos.x = start_pos.x + nums * 3 * self:getPengCardWidth() + space
	for i = 1,3 do
		local peng_card = PengCard.new(1,cardNum,self._gameLayer)
		self:addChild( peng_card )
		peng_card:setTag( 10000 + cardNum + i )
		local card_pos = clone(start_pos)
		card_pos.x = card_pos.x + (i-1) * self:getPengCardWidth()
		peng_card:setPosition( card_pos )
	end
end
--[[
	碰牌出牌
]]
function PlayerNode:pengOutHandCard( handNode )
	assert( handNode," !! handNode is nil !! " )
	assert( self._moNode == nil ," !! self._moNode must be nil !! " )
	local out_num = handNode:getNum()
	local pos_x = handNode:getOrgPosition().x
	local clear_call = function()
		self._selectHandNode = nil
		-- 从手牌中移除当前数据
		self._managerData:removePlayerHandCard( out_num )
		-- 手牌移动
		local call_notice = function()
			-- 通知AI 玩家已经出牌
			EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_AI_TURN,out_num )
		end
		self:moveHandNodesWhenOneHandMoveOut( handNode,pos_x,call_notice )
	end
	self:moveHandNodeAndCreateOutNode( handNode,clear_call )
end
-- #####################################################################




-- ##################### 暗杠的逻辑 #####################################
--[[
	判断暗杠 此时一定是摸牌
	moCardNum:此时摸的牌
]]
function PlayerNode:checkAnGang( moCardNum )
	assert( moCardNum," !! moCardNum is nil !! " )
	local source = clone( self._managerData._playerHandData )
	table.insert( source,moCardNum )
	local hx_hand_card = self._managerData:calHashCard( source )
	local nums = {}
	for k,v in pairs(hx_hand_card) do
		if v == 4 then
			table.insert( nums,k )
		end
	end
	table.sort( nums,function( a,b ) return a > b end )
	if #nums > 0 then
		return true,nums[1]
	end
	return false
end
--[[
	创建暗杠的nodes 并处理相关数据
	cardNum:要暗杠的数字
]]
function PlayerNode:createAnGangNodes( cardNum )
	assert( cardNum," !! cardNum is nil !! ")
	assert( self._moNode," !! self._moNode is nil !! " )

	-- 1:创建杠牌的nodes
	self:createGangNodes( cardNum,1 )
	-- 写入杠牌数据
	self._managerData:insertPlayerGangPengData( cardNum,1 )

	-- 2:要杠的牌从手牌中先移除
	local remove_num = 0
	for i = #self._handNodes,1,-1 do
		if self._handNodes[i]:getNum() == cardNum then
			self._handNodes[i]:removeFromParent()
			table.remove( self._handNodes,i )
			-- 从手牌中移除数据
			self._managerData:removePlayerHandCard( cardNum )
			remove_num = remove_num + 1
		end
	end

	-- 3:剩余的手牌从新设置位置
	self:resetHandNodesPosition( cardNum,remove_num )

	-- 4:针对moNode的操作(分2种情况 1:暗杠的牌全是手中的牌 2：暗杠的牌有摸牌)
	if self._moNode:getNum() == cardNum then
		self._moNode:removeFromParent()
		self._moNode = nil
		-- player 再摸一张牌
		EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_MO_CARD,1 )
	else
		-- 需要将摸牌插入到手牌中
		local call_back = function()
			-- 插入手牌数据
			self._managerData:insertPlayerHandData( self._moNode:getNum() )
			-- moNode插入手牌nodes
			table.insert( self._handNodes,self._moNode )
			-- 摸牌执行插入动画
			self._moNode = nil
			-- player 再摸一张牌
			EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_MO_CARD,1 )
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
function PlayerNode:checkMingGang( moCardNum )
	assert( moCardNum," !! moCardNum is nil !! " )
	local player_peng_gang = self._managerData:calHashCard( self._managerData._playerGangPengData )
	-- 1:先判断摸牌是否是明杠
	if player_peng_gang[moCardNum] and player_peng_gang[moCardNum] == 3 then
		return true,moCardNum
	end
	-- 2:再判断手牌中是否有明杠的牌
	for i,v in ipairs( self._managerData._playerHandData ) do
		if player_peng_gang[v] and player_peng_gang[v] == 3 then
			return true,v
		end
	end
	return false
end
--[[
	创建明杠的nodes 并处理相关数据 此时一定是摸牌
	cardNum:要明杠的数字
]]
function PlayerNode:createMingGangNodes( cardNum )
	assert( cardNum," !! cardNum is nil !! ")
	assert( self._moNode," !! self._moNode is nil !! " )
	-- 1:创建杠牌的node
	local peng_card = self:getChildByTag( 10000 + cardNum + 2 )
	if peng_card then
		local peng_card_gang = PengCard.new(2,cardNum,self._gameLayer)
		self:addChild( peng_card_gang )
		local card_pos = cc.p( peng_card:getPosition() )
		card_pos.y = card_pos.y + 8
		peng_card_gang:setPosition( card_pos )
		peng_card_gang:setZOrder(10)
	end
	-- 写入杠牌数据
	self._managerData:insertPlayerGangPengDataByMingGang( cardNum )
	-- 2:针对moNode的操作
	if self._moNode:getNum() == cardNum then
		-- 杠牌是摸牌
		self._moNode:removeFromParent()
		self._moNode = nil
		-- 3:player再摸一张牌
		EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_MO_CARD,1 )
	else
		-- 杠牌是手中牌
		-- 1:要杠的牌从手牌中先移除
		local remove_num = 0
		for i = #self._handNodes,1,-1 do
			if self._handNodes[i]:getNum() == cardNum then
				self._handNodes[i]:removeFromParent()
				table.remove( self._handNodes,i )
				-- 从手牌中移除数据
				self._managerData:removePlayerHandCard( cardNum )
				remove_num = remove_num + 1
			end
		end
		-- 2:剩余的手牌从新设置位置
		self:resetHandNodesPosition( cardNum,remove_num,true )

		-- 需要将摸牌插入到手牌中
		local call_back = function()
			-- 插入手牌数据
			self._managerData:insertPlayerHandData( self._moNode:getNum() )
			-- moNode插入手牌nodes
			table.insert( self._handNodes,self._moNode )
			-- 摸牌执行插入动画
			self._moNode = nil
			-- player 再摸一张牌
			EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_MO_CARD,1 )
		end
		self:inertMoCardToHandCardAction( call_back )
	end
end
-- #####################################################################



-- ##################### 点杠的逻辑 #####################################
--[[
	cardNum:要杠的牌
]]
function PlayerNode:createDianGangNodes( cardNum )
	assert( cardNum," !! cardNum is nil !! " )
	-- 1:创建杠牌的nodes
	self:createGangNodes( cardNum,3 )
	-- 写入杠牌数据
	self._managerData:insertPlayerGangPengData( cardNum,1 )
	-- 2:要杠的牌从手牌中先移除
	local remove_num = 0
	for i = #self._handNodes,1,-1 do
		if self._handNodes[i]:getNum() == cardNum then
			self._handNodes[i]:removeFromParent()
			table.remove( self._handNodes,i )
			-- 从手牌中移除数据
			self._managerData:removePlayerHandCard( cardNum )
			remove_num = remove_num + 1
		end
	end
	-- 3:剩余的手牌从新设置位置
	self:resetHandNodesPosition( cardNum,remove_num )
	-- 4:player再摸一张牌
	EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_MO_CARD,1 )
end
-- #####################################################################







-- ##################### 通用的逻辑 #####################################
--[[
	创建杠牌的nodes
	cardNum:要杠的牌
	gangType: 1:暗杠 2:明杠 3:点杠
]]
function PlayerNode:createGangNodes( cardNum,gangType )
	assert( cardNum," !! cardNum is nil !! " )
	assert( gangType == 1 or gangType == 2 or gangType == 3," !! gangType must be 1 or 2 or 3 !! " )
	-- 添加node到碰牌杠牌区域
	local nums = table.nums(self._managerData:calHashCard(self._managerData._playerGangPengData))
	local start_pos = clone( self._handStartPos )
	local space = nums * 20
	start_pos.x = start_pos.x + nums * 3 * self:getPengCardWidth() + space
	for i = 1,3 do
		local peng_card = PengCard.new(1,cardNum,self._gameLayer)
		self:addChild( peng_card )
		local card_pos = clone(start_pos)
		card_pos.x = card_pos.x + (i-1) * self:getPengCardWidth()
		peng_card:setPosition( card_pos )

		-- 暗杠
		if gangType == 1 then
			peng_card:setAnGang()
		end

		if i == 2 then
			local peng_card_g = PengCard.new(2,cardNum,self._gameLayer)
			self:addChild( peng_card_g )
			card_pos.y = card_pos.y + 8
			peng_card_g:setPosition( card_pos )
			peng_card_g:setZOrder(10)
		end
	end
end
--[[
	从新设置手牌的位置
	cardNum:移除的node的数字
	removeNum:移除的个数
]]
function PlayerNode:resetHandNodesPosition( cardNum,removeNum,notNeedMove )
	assert( cardNum," !! cardNum is nil !! " )
	assert( removeNum," !! removeNum is nil !! " )
	-- 去掉杠牌后 其余的牌先向前移动 (填补碰/杠之后的空白区域 必须是大于碰/杠的牌)
	for i,v in ipairs( self._handNodes ) do
		if v:getNum() > cardNum then
			local card_width = self:getHandCardWidth()
			local move_dis = card_width * removeNum
			local posx = v:getPositionX()
			posx = posx - move_dis
			v:setPositionX( posx )

			-- 4:设置原始位置
			local org_pos = v:getOrgPosition()
			org_pos.x = org_pos.x - move_dis
			v:setOrgPosition( org_pos )
		end
	end
	-- notNeedMove 针对明杠 不需要移动
	if not notNeedMove then
		-- 集体向后移动
		local move_dis = 0 + 3 * self:getPengCardWidth() + 20
		for i,v in ipairs( self._handNodes ) do
			local posx = v:getPositionX()
			v:setPositionX( posx + move_dis )
			-- local move_by = cc.MoveBy:create(0.2,cc.p(move_dis,0))
			-- v:runAction( move_by )

			-- 5:设置原始位置
			local org_pos = v:getOrgPosition()
			org_pos.x = org_pos.x + move_dis
			v:setOrgPosition( org_pos )
		end
	end
end

--[[
	摸牌要插入手牌的动画
]]
function PlayerNode:inertMoCardToHandCardAction( callBack )
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
		x = self:getFirstHandNodePositionX() + (pos_index-1) * card_width, 
		y = self._handStartPos.y
	}
	local jump_to = cc.JumpTo:create(action_time + 0.2,end_pos,100,1)
    local call_back = cc.CallFunc:create( function()

    	-- 7:设置原始位置
   		self._moNode:setOrgPosition( end_pos )

   		callBack()
    end )
    local seq = cc.Sequence:create({ delay_time,jump_to,call_back })
    self._moNode:runAction( seq )
end
-- 获取手牌中第一张牌的位置
function PlayerNode:getFirstHandNodePositionX()
	local first_posx = nil
	-- 针对全部碰或者杠之后 没有手牌的时候
	if #self._handNodes == 0 then
		local nums = table.nums(self._managerData:calHashCard(self._managerData._playerGangPengData))
		local start_pos = clone( self._handStartPos )
		local space = nums * 20
		first_posx = start_pos.x + nums * 3 * self:getPengCardWidth() + space
		return first_posx
	end

	for k,v in ipairs( self._handNodes ) do
		if first_posx == nil then
			first_posx = v:getPositionX()
		else
			if v:getPositionX() < first_posx then
				first_posx = v:getPositionX()
			end
		end
	end
	return first_posx
end

--[[
	创建出牌区的node
]]
function PlayerNode:createOutNode( cardNum )
	assert( cardNum," !! cardNum is nil !! " )
	local out_node = OutCard.new(1,cardNum,self._gameLayer)
	self:addChild( out_node )
	table.insert( self._outNodes,out_node )
	-- 将出牌数据写入
	self._managerData:insertPlayerOutData( cardNum )
	return out_node
end

function PlayerNode:getPengCardWidth()
	return 40
end
-- #####################################################################










-- ##################### 玩家点击操作的逻辑 ##############################
--[[
	-- 点击node 选择要出牌的node
]]
function PlayerNode:touchHandNode( handNode )
	assert( handNode," !! handNode is nil !! " )
	local action_time = 0.1
	if self._selectHandNode == nil then
		-- 选中
		self._canOutHandCard = false
		local move_by = cc.MoveBy:create(action_time,cc.p(0,20))
		local call_select = cc.CallFunc:create( function()
			self._selectHandNode = handNode
			self._canOutHandCard = true
		end )
		local seq = cc.Sequence:create({ move_by,call_select } )
		handNode:runAction( seq )

		-- -- 选中
		-- self._selectHandNode = handNode
		-- self._canOutHandCard = true
		-- local pos_y = handNode:getPositionY()
		-- handNode:setPositionY( pos_y + 20 )
	else
		if self._selectHandNode == handNode then
			-- -- 取消选中
			-- self._canOutHandCard = false
			-- local move_by = cc.MoveBy:create(action_time,cc.p(0,-20))
			-- local call_select = cc.CallFunc:create( function()
			-- 	self._canOutHandCard = true
			-- 	self._selectHandNode = nil
			-- end )
			-- local seq = cc.Sequence:create({ move_by,call_select } )
			-- handNode:runAction( seq )

			-- 直接出牌
			self._gameLayer:outCard()
		else
			-- 从新选中
			-- 之前的回到原位
			self._canOutHandCard = false
			local move_by1 = cc.MoveBy:create(action_time,cc.p(0,-20))
			local call_select = cc.CallFunc:create( function()
				self._selectHandNode = handNode
				self._canOutHandCard = true
			end )
			local seq = cc.Sequence:create({ move_by1,call_select } )
			self._selectHandNode:runAction( seq )
			-- 新的选中的上移
			local move_by2 = cc.MoveBy:create(action_time,cc.p(0,20))
			handNode:runAction( move_by2 )

			-- -- 从新选中
			-- -- 之前的回到原位
			-- local pos_y = self._selectHandNode:getPositionY()
			-- self._selectHandNode:setPositionY( pos_y - 20 )
			-- -- 新的选中的上移
			-- local pos_y = handNode:getPositionY()
			-- handNode:setPositionY( pos_y + 20 )
			-- self._selectHandNode = handNode
			-- self._canOutHandCard = true
		end
	end
end
--[[
	-- 点击node 出牌
]]
function PlayerNode:touchOutHandNode()
	if not self._selectHandNode then
		return
	end
	self._canOutHandCard = false

	-- 播放音效
	G_GetModel("Model_MaJiang"):playOutCardVoice( self._selectHandNode:getNum() )

	-- 分为2种情况出牌 1:摸牌出牌 2:碰牌出牌
	if self._moNode then
		-- 1:摸牌出牌
		self:moOutHandCard( self._selectHandNode )
	else
		-- 2:碰牌出牌
		self:pengOutHandCard( self._selectHandNode )
	end
end
--[[
	摸牌出牌
	注意对 self._moNode 和 self._selectHandNode 的清空设置
]]
function PlayerNode:moOutHandCard( handNode )
	assert( handNode," !! handNode is nil !! " )
	assert( self._moNode," !! self._moNode is nil !! " )
	if self._moNode == handNode then
		-- 如果出的是摸牌 有以下几点 
		-- 1:将摸牌移动到出牌区域 然后创建出牌区的node
		-- 2:清空 self._moNode 和 self._selectHandNode
		-- 3:出牌数据的处理
		local clear_call = function()
			self._moNode = nil
			self._selectHandNode = nil
			-- 通知AI 玩家已经出牌
			EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_AI_TURN,handNode:getNum() )
		end
		self:moveHandNodeAndCreateOutNode( handNode,clear_call )
	else
		-- 如果出的是手牌 有以下几点 
		-- 1:将手牌移动到出牌区 并将手牌从手牌的node数组中移除 创建出牌区的node
		-- 2:将手牌的node插入到手牌区
		-- 3:手牌和出牌数据的处理
		local player_out_num = handNode:getNum()
		local pos_x = handNode:getOrgPosition().x
		local clear_call = function()
			self._selectHandNode = nil
			-- 从手牌中移除当前数据
			self._managerData:removePlayerHandCard( handNode:getNum() )
			-- 摸牌插入
			local insert_call = function()
				local call_back = function()
					-- 插入手牌数据
					self._managerData:insertPlayerHandData( self._moNode:getNum() )
					-- moNode插入手牌nodes
					table.insert( self._handNodes,self._moNode )
					-- 摸牌执行插入动画
					self._moNode = nil
					-- 通知AI 玩家已经出牌
					EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_AI_TURN,player_out_num )
				end
				self:inertMoCardToHandCardAction( call_back )
			end
			-- 手牌移动
			self:moveHandNodesWhenOneHandMoveOut( handNode,pos_x,insert_call )
		end
		self:moveHandNodeAndCreateOutNode( handNode,clear_call )
	end
end
--[[将手牌或者摸牌的node移动到出牌的区域 并创建OutNode]]
function PlayerNode:moveHandNodeAndCreateOutNode( handNode,callBack )
	assert( handNode," !! handNode is nil !! " )
	assert( callBack," !! callBack is nil !! " )
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

--[[ 
	当出了一张牌 其余手牌的移动动画
	handNode:要从手牌中移除的node指针
	posX:handNode的初始位置 用于其余的node移动
]]
function PlayerNode:moveHandNodesWhenOneHandMoveOut( handNode,posX,callBack )
	assert( handNode," !! handNode is nil !! ")
	-- 将选中的node从手牌中移除
	for k,v in ipairs( self._handNodes ) do
		if v == handNode then
			table.remove( self._handNodes,k )
			break
		end
	end
	-- 其余手牌的移动动画(当出了一张手牌)
	for k,v in ipairs( self._handNodes ) do
		if v:getPositionX() > posX then
			local move_dis = -self:getHandCardWidth()
			local move_by = cc.MoveBy:create(0.1,cc.p(move_dis,0))
			v:runAction( move_by )

			-- 6:设置原始位置
			local org_pos = v:getOrgPosition()
			org_pos.x = org_pos.x + move_dis
			v:setOrgPosition( org_pos )
		end
	end
	if callBack then
		local delay_time = cc.DelayTime:create(0.25)
		local call_back = cc.CallFunc:create( callBack )
		local seq = cc.Sequence:create({ delay_time,call_back })
		self:runAction( seq )
	end
end
-- #####################################################################



-- ##################### 玩家胡牌之后 明牌 ##############################
-- 玩家胡牌之后 明牌
function PlayerNode:huPaiChangeMingPai()
	local first_pos = {}
	first_pos.x = self:getFirstHandNodePositionX()
	first_pos.y = self._handStartPos.y

	-- 隐藏手中的node
	for i,v in ipairs( self._handNodes ) do
		v:setVisible( false )
	end
	-- self._handNodes = {}

	local data = clone(self._managerData._playerHandData)
	table.sort( data )
	for i,v in ipairs( data ) do
		local peng_card = PengCard.new(1,v,self._gameLayer)
		local card_pos = clone( first_pos )
		card_pos.x = card_pos.x + (i-1) * self:getPengCardWidth()
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


--[[
	获取要移动到出牌区的位置
]]
function PlayerNode:getMoveOutCardsPosition()
	local nums = #self._outNodes
	local dis = nums * self:getOutCardWidth()
	local position = {
		x = self._outStartPos.x + dis,
		y = self._outStartPos.y
	}
	return position
end
--[[
	当玩家的牌被ai杠或者碰了 移除该node 移除该数据
]]
function PlayerNode:removeOutNodeWhenAIGangOrPeng( cardNum )
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
	self._managerData:removePlayerOutCard( cardNum )
end



function PlayerNode:addOutCardTips( outNode )
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
function PlayerNode:hideOutCardTips()
	if self._outCardTips then
		self._outCardTips:setVisible( false )
	end
end


--[[
	添加倒计时的node
]]
function PlayerNode:addCountTimeNode()
	local count_node = CountTimeNode.new()
	self:addChild( count_node )
	count_node:setPosition(display.cx,display.cy)
	count_node:setTag(1253)
end
--[[移除倒计时的node]]
function PlayerNode:removeCountTimeNode()
	local count_node = self:getChildByTag(1253)
	if count_node then
		count_node:removeFromParent()
	end
end


function PlayerNode:getOutCardWidth()
	return 43
end

function PlayerNode:getHandCardWidth()
	return 63
end



function PlayerNode:printPlayerData()
	dump( self._managerData._playerHandData,"--------------------> _playerHandData = " )
	dump( self._managerData._playerOutData,"--------------------> _playerOutData = " )
	dump( self._managerData._playerGangPengData,"--------------------> _playerGangPengData = " )
end


return PlayerNode