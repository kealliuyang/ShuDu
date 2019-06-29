

local NodePoker = import(".NodePoker")
local GamePlay  = class("GamePlay",BaseLayer)


function GamePlay:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePlay.super.ctor( self,param.name )
    self:addCsb( "csbzhandou/Play.csb" )

    self:addNodeClick( self["ButtonReplace"],{ 
        endCallBack = function() self:replaceCard() end
    })

    self:addNodeClick( self["ImagePlay"],{ 
        endCallBack = function() self:clickPlay() end
    })

    self:addNodeClick( self["touchOutPanel"],{ 
        endCallBack = function() self:clickPlayerMo() end
    })

    self:addNodeClick( self["ButtonQuit"],{ 
        endCallBack = function() self:clickPause() end
    })

    self:addNodeClick( self["ButtonBack"],{ 
        endCallBack = function() self:close() end
    })

    self.ImagePlay:setVisible( false )
    self.NodePoker1:setLocalZOrder( 200 )
    self.NodePoker2:setLocalZOrder( 200 )

    -- 当前游戏总时间
    self._totalTime = 150
    self._time = 0
end


function GamePlay:onEnter()
	GamePlay.super.onEnter( self )
	casecadeFadeInNode( self._csbNode,0.5 )
	-- 初始化数据
	self:loadUiData()
	-- 初始化牌
	self:loadPokerData()
	-- 发牌动画
	self._canPlayGame = false
	self._curPoker1 = nil
	self._curPoker2 = nil
	performWithDelay( self,function()
		self:sendCardAction()
	end,0.5 )
end

function GamePlay:loadUiData()
	-- 金币
	local coin = G_GetModel("Model_ZhanDou"):getCoin()
	self.TextCoin:setString( coin )
	-- 关卡
	self._stage = G_GetModel("Model_ZhanDou"):getStage()
	self.TextStage:setString( self._stage )
	-- 积分
	self.TextScore:setString( G_GetModel("Model_ZhanDou"):getScore() )
	-- 时间
	local str = formatTimeStr( self._totalTime,":" )
	self.TextTime:setString(str)
end

function GamePlay:loadPokerData()
	local pokerData = getRandomArray( 1,52 )
	self._aiPokerNode = {}
	self._playerPokerNode = {}
	-- ai 
	for i = 1,26 do
		local poker = NodePoker.new( self,pokerData[i] )
		self.NodePoker1:addChild( poker )
		poker:setPositionX( i - 1 )
		table.insert( self._aiPokerNode,poker )
	end
	-- player 
	for i = 27,52 do
		local poker = NodePoker.new( self,pokerData[i] )
		self.NodePoker2:addChild( poker )
		poker:setPositionX( i - 26 )
		poker:setLocalZOrder( i )
		table.insert( self._playerPokerNode,poker )
	end
end

function GamePlay:sendCardAction()
	-- ai 发牌
	local actions1 = {}
	for i = 1,4 do
		local delay_time = cc.DelayTime:create( 0.5 )
		local call_send = cc.CallFunc:create( function()
			self:outPokerFromCards( self["AIPanel"..i],1 )
		end )
		table.insert( actions1,delay_time )
		table.insert( actions1,call_send )
	end
	local seq1 = cc.Sequence:create( actions1 )
	self.NodePoker1:runAction( seq1 )
	-- player 发牌
	local actions2 = {}
	for i = 1,4 do
		local delay_time = cc.DelayTime:create( 0.5 )
		local call_send = cc.CallFunc:create( function()
			self:outPokerFromCards( self["PlayerPanel"..i],2 )
		end )
		table.insert( actions2,delay_time )
		table.insert( actions2,call_send )

		if i == 4 then
			local call_pointer = cc.CallFunc:create( function()
				self:pointerAction()
			end )
			local delay_play = cc.DelayTime:create( 1 )
			local call_play = cc.CallFunc:create( function()
				self:playIconAction()
			end )
			local delay_began = cc.DelayTime:create( 2 )
			local call_began = cc.CallFunc:create( function()
				self._canPlayGame = true

				-- 倒计时
			    local str = formatTimeStr( self._totalTime,":" )
			    self.TextTime:setString(str)
			    self:schedule( function()
			        self._time = self._time + 1
			        local left_time = self._totalTime - self._time
			        local str = formatTimeStr( left_time,":" )
			        self.TextTime:setString(str)
			        if left_time <= 0 then
			            self:gameOver(3)
			        end
			    end,1 )

			end )
			table.insert( actions2,call_pointer )
			table.insert( actions2,delay_play )
			table.insert( actions2,call_play )
			table.insert( actions2,delay_began )
			table.insert( actions2,call_began )
		end
	end
	local seq2 = cc.Sequence:create( actions2 )
	self.NodePoker2:runAction( seq2 )
end

function GamePlay:outPokerFromCards( destPanel,sType,isOut )
	assert( destPanel," !! destPanel is nil !! " )
	assert( sType," !! sType is nil !! " )

	if sType == 1 then
		if #self._aiPokerNode == 0 then
			return
		end
	elseif sType == 2 then
		if #self._playerPokerNode == 0 then
			return
		end
	end

	local poker = nil
	local world_pos = destPanel:getParent():convertToWorldSpace( cc.p(destPanel:getPosition()) )
	local node_pos = nil
	if sType == 1 then
		-- ai
		assert( #destPanel:getChildren() == 0," !! childs must == 0 !! " ) 
		poker = self._aiPokerNode[#self._aiPokerNode]
		self._aiPokerNode[#self._aiPokerNode] = nil
		node_pos = self.NodePoker1:convertToNodeSpace( world_pos )
	elseif sType == 2 then
		-- player 
		assert( #destPanel:getChildren() == 0," !! childs must == 0 !! " )
		poker = self._playerPokerNode[#self._playerPokerNode]
		self._playerPokerNode[#self._playerPokerNode] = nil
		node_pos = self.NodePoker2:convertToNodeSpace( world_pos )
	end

	-- 执行翻牌
	poker:showObtAniUseScaleTo()

	local delay_time = cc.DelayTime:create( 0.25 )
	local move_to = cc.MoveTo:create( 0.2,node_pos )
	local call_create = cc.CallFunc:create( function()
		local index = poker:getIndex()
		local new_poker = NodePoker.new( self,index )
		new_poker:showPoker()
		destPanel:addChild( new_poker )
		if isOut then
			new_poker._imageFont:setRotation( random( -10,10 ) )
			local pos = cc.p( new_poker:getPosition() )
			pos.x = pos.x + random( -5,5 )
			pos.y = pos.y + random( -5,5 )
			new_poker:setPosition( pos )

			if sType == 1 then
				self._curPoker1 = new_poker
			elseif sType == 2 then
				self._curPoker2 = new_poker
			end
		else
			new_poker:setTag( 555 )
			-- 为玩家的牌添加点击
			if sType == 2 then
				new_poker:addPokerClick()
			end
		end
	end )
	local remove = cc.RemoveSelf:create()
	local seq = cc.Sequence:create({ delay_time,move_to,call_create,remove })
	poker:runAction( seq )
end

-- 手指的动画
function GamePlay:pointerAction()
	self.ImagePointer:stopAllActions()
	local delay_time = cc.DelayTime:create( 1 )
	local call_pos = cc.CallFunc:create( function()
		local posx = random(380,880)
		self.ImagePointer:setPositionX( posx )
	end )
	local seq = cc.Sequence:create({ delay_time,call_pos })
	local rep = cc.RepeatForever:create( seq )
	self.ImagePointer:runAction( rep )
end

-- play icon 的动画
function GamePlay:playIconAction()
	self.ImagePlay:setVisible( true )
	self.ImagePlay:stopAllActions()
	local scale_to1 = cc.ScaleTo:create( 0.5,1.2 )
	local scale_to2 = cc.ScaleTo:create( 0.5,1 )
	local rep = cc.RepeatForever:create( cc.Sequence:create({ scale_to1,scale_to2 }) )
	self.ImagePlay:runAction( rep )
end

function GamePlay:clickPlay()
	self.ImagePlay:stopAllActions()
	self.ImagePlay:setVisible( false )

	-- 重置
	self._curPoker1 = nil
	self._curPoker2 = nil
	local call_send = function()
		-- ai 先从牌堆里面发牌
		if #self._aiPokerNode > 0 then
			-- 从牌堆发牌
			self:outPokerFromCards( self.OutPanel1,1,true )
			-- ai 开始出牌
			performWithDelay( self,function()
				self:aiOutCard()
			end,1 )
		else
			-- 立即从手牌中出牌
			for i = 1,4 do
				local poker = self["AIPanel"..i]:getChildByTag( 555 )
				if poker then
					assert( #(self.OutPanel1:getChildren()) == 0," !! error child must be 0 !! " )
					self:aiMoveCard( poker,self.OutPanel1,1 )
					break
				end
			end
		end
		-- 玩家 先从牌堆里面发牌
		if #self._playerPokerNode > 0 then
			-- 从牌堆发牌
			self:outPokerFromCards( self.OutPanel2,2,true )
		else
			-- 立即出牌
			for i = 1,4 do
				local poker = self["PlayerPanel"..i]:getChildByTag( 555 )
				if poker then
					assert( #(self.OutPanel2:getChildren()) == 0," !! error child must be 0 !! " )
					self:putCardToDestPanel( poker,self.OutPanel2,2 )
					break
				end
			end
		end
	end
	-- 移除所有的出牌
	if #self["OutPanel1"]:getChildren() > 0 then
		for a = 1,2 do
			local childs = self["OutPanel"..a]:getChildren()
			for i,v in ipairs( childs ) do
				local move_by = cc.MoveBy:create( 0.2,cc.p( display.width,0 ))
				local remove = cc.RemoveSelf:create()
				if a == 2 and i == #childs then
					local call_show = cc.CallFunc:create( function()
						v:removeFromParent()
						call_send()
					end )
					v:runAction( cc.Sequence:create({ move_by,call_show }) )
				else
					v:runAction( cc.Sequence:create({ move_by,remove }) )
				end
			end
		end
	else
		call_send()
	end
end

function GamePlay:aiOutCard()
	local time = 2 - ( self._stage - 1 ) * 0.2

	-- ai出牌的时间最快也是1秒
	if time < 1 then
		time = 1
	end

	self.Bg:stopAllActions()
	performWithDelay( self.Bg,function()
		self:aiLogic()
	end,time )
end

-- ai 的出牌逻辑
function GamePlay:aiLogic()
	assert( self._curPoker1," !! self._curPoker1 is nil !! " )
	assert( self._curPoker2," !! self._curPoker2 is nil !! " )

	-- 检查有没有符合第一张牌的
	local cur1_num = self._curPoker1:getNum()
	local cur2_num = self._curPoker2:getNum()
	for i = 1,4 do
		local poker = self["AIPanel"..i]:getChildByTag( 555 )
		if poker then
			local childs = self["AIPanel"..i]:getChildren()
			assert( #childs <= 1," !! card num is worry !! " )
			local num = poker:getNum()
			if self:checkCanPut( num,cur1_num ) then
				self:aiMoveCard( poker,self.OutPanel1,1 )
				return
			end
			if self:checkCanPut( num,cur2_num ) then
				self:aiMoveCard( poker,self.OutPanel2,2 )
				return
			end
		end
	end
	-- 检查是否需要摸牌
	local need_mo = {}
	for i = 1,4 do
		if not self["AIPanel"..i]:getChildByTag( 555 ) then
			table.insert( need_mo,i )
		end
	end
	
	local childs1 = self.NodePoker1:getChildren()
	if #need_mo > 0 and #childs1 > 0 then
		local actions = {}
		for i,v in ipairs( need_mo ) do
			local call_send = cc.CallFunc:create( function()
				self:outPokerFromCards( self["AIPanel"..v],1 )
			end )
			table.insert( actions,call_send )
			local delay_time = cc.DelayTime:create( 0.5 )
			table.insert( actions,delay_time )

			if i == #need_mo then
				local call_out = cc.CallFunc:create( function()
					-- 继续出牌
					performWithDelay( self,function()
						self:aiOutCard()
					end,0.5 )
				end )
				table.insert( actions,call_out )
			end
		end
		self.NodePoker1:runAction( cc.Sequence:create( actions ) )
	else
		-- 检查是否需要重新点击 play
		if self:isReStartPlayIcon() then
			-- 显示 player icon 重新刷新牌
			self:playIconAction()
		else
			self:aiOutCard()
		end
	end
end

function GamePlay:aiMoveCard( poker,destPanel,outPos )
	assert( poker," !! poker is nil !! " )
	assert( destPanel," !! destPanel is nil !! " )
	assert( outPos," !! outPos is nil !! " )
	-- 创建手指
	local pointer_img = ccui.ImageView:create( "image/play/shou.png",1 )
	poker:addChild( pointer_img )
	local poker_size = poker:getContentSize()
	pointer_img:setPosition( cc.p(poker_size.width / 2,poker_size.height) )
	pointer_img:setRotation(-135)
	self.ImagePointer:setVisible( false )
	

	local start_pos = cc.p( poker:getPosition() )
	poker:getParent():setLocalZOrder( 100 )
	-- 移动牌
	local world_pos = destPanel:getParent():convertToWorldSpace( cc.p(destPanel:getPosition()) )
	local node_pos = poker:getParent():convertToNodeSpace( world_pos )
	local move_to = cc.MoveTo:create( 0.5,node_pos )
	local call_put = cc.CallFunc:create( function()
		local cur_poker = nil
		if outPos == 1 then
			cur_poker = self._curPoker1
		else
			cur_poker = self._curPoker2
		end

		local cur_num = 0
		if cur_poker then
			cur_num = cur_poker:getNum()
		else
			cur_num = poker:getNum() - 1
		end

		if self:checkCanPut( poker:getNum(),cur_num ) then
			-- 放入
			local index = poker:getIndex()
			local new_poker = NodePoker.new( self,index )
			new_poker:showPoker()
			destPanel:addChild( new_poker )
			new_poker._imageFont:setRotation( random( -10,10 ) )
			local pos = cc.p( new_poker:getPosition() )
			pos.x = pos.x + random( -5,5 )
			pos.y = pos.y + random( -5,5 )
			new_poker:setPosition( pos )
			if outPos == 1 then
				self._curPoker1 = new_poker
			else
				self._curPoker2 = new_poker
			end
			-- 移除
			poker:getParent():setLocalZOrder( 0 )
			poker:removeFromParent()

			self.ImagePointer:setVisible( true )
			-- 检查是否游戏结束
			if self:isGameOverByAIWin() then
				-- 游戏结束
				self:gameOver(1)
			else
				if self:isReStartPlayIcon() then
					self:playIconAction()
				else
					self:aiOutCard()
				end
			end
		else
			local move_to2 = cc.MoveTo:create( 0.2,start_pos )
			local call_move = cc.CallFunc:create( function()
				self:aiOutCard()
				pointer_img:removeFromParent()
			end )
			poker:runAction( cc.Sequence:create({ move_to2,call_move}) )
		end
	end )
	local seq = cc.Sequence:create({ move_to,call_put })
	poker:runAction( seq )
end

function GamePlay:isGameOverByAIWin()
	local childs1 = self.NodePoker1:getChildren()
	if #childs1 == 0 then
		for i = 1,4 do
			if self["AIPanel"..i]:getChildByTag( 555 ) then
				return false
			end
		end
		return true
	end
	return false
end

function GamePlay:isGameOverByPlayerWin()
	local childs2 = self.NodePoker2:getChildren()
	if #childs2 == 0 then
		for i = 1,4 do
			if self["PlayerPanel"..i]:getChildByTag( 555 ) then
				return false
			end
		end
		return true
	end
	return false
end

function GamePlay:isReStartPlayIcon()
	if not self._curPoker1 or not self._curPoker2 then
		return
	end

	local cur1_num = self._curPoker1:getNum()
	local cur2_num = self._curPoker2:getNum()

	for i = 1,4 do
		-- 检查ai能否出牌
		local poker = self["AIPanel"..i]:getChildByTag( 555 )
		if poker then
			local num = poker:getNum()
			if self:checkCanPut( num,cur1_num ) then
				return false
			end
			if self:checkCanPut( num,cur2_num ) then
				return false
			end
		end
		-- 检查玩家能否出牌
		local poker = self["PlayerPanel"..i]:getChildByTag( 555 )
		if poker then
			local num = poker:getNum()
			if self:checkCanPut( num,cur1_num ) then
				return false
			end
			if self:checkCanPut( num,cur2_num ) then
				return false
			end
		end
	end
	local childs1 = self.NodePoker1:getChildren()
	local childs2 = self.NodePoker2:getChildren()
	-- ai 是否能摸牌
	if #childs1 > 0 then
		for i = 1,4 do
			local poker = self["AIPanel"..i]:getChildByTag( 555 )
			if not poker then
				return false
			end
		end
	end
	-- 玩家是否能摸牌
	if #childs2 > 0 then
		for i = 1,4 do
			local poker = self["PlayerPanel"..i]:getChildByTag( 555 )
			if not poker then
				return false
			end
		end
	end
	return true
end

function GamePlay:checkCanPut( putNum,destNum )
	assert( putNum," !! putNum is nil !! " )
	assert( destNum," !! destNum is nil !! " )
	if ( putNum == 1 and destNum == 13 ) or ( putNum == 13 and destNum == 1 ) then
		return true
	end
	if putNum == destNum + 1 or putNum == destNum - 1 then
		return true
	end
	return false
end

function GamePlay:clickPlayerMo()
	-- 1:正在发牌
	if self._moMark then
		return
	end
	-- 2:还不能开始
	if not self._canPlayGame then
		return
	end
	-- 3:没有牌了
	if #self._playerPokerNode == 0 then
		return
	end
	-- 4:手牌全都有牌
	local need_put = {}
	for i = 1,4 do
		local childs = self["PlayerPanel"..i]:getChildren()
		if #childs == 0 then
			table.insert( need_put,i )
		end
	end
	if #need_put == 0 then
		return
	end
	-- 发牌
	self._moMark = true
	local actions = {}
	for i,v in ipairs( need_put ) do
		local call_send = cc.CallFunc:create( function()
			self:outPokerFromCards( self["PlayerPanel"..v],2 )
		end )
		table.insert( actions,call_send )

		if i < #need_put then
			local delay_time = cc.DelayTime:create( 0.5 )
			table.insert( actions,delay_time )
		end

		if i == #need_put then
			local delay_time2 = cc.DelayTime:create( 0.5 )
			local call_set_mo = cc.CallFunc:create( function()
				self._moMark = nil
			end )
			table.insert( actions,delay_time2 )
			table.insert( actions,call_set_mo )
		end
	end
	self.NodePoker2:runAction( cc.Sequence:create( actions ) )
end

-- 玩家出牌
function GamePlay:playerOutCard( poker )
	assert( poker," !! poker is nil !! " )
	if not self._curPoker1 or not self._curPoker2 then
		return false
	end
	-- 检查出牌区1
	if self:checkPutDestPanel( poker,self.OutPanel1 ) then
		-- 检查能否放入
		local cur1_num = self._curPoker1:getNum()
		if self:checkCanPut( poker:getNum(),cur1_num ) then
			-- 放入
			self:putCardToDestPanel( poker,self.OutPanel1,1 )
			return true
		else
			-- 回到原位
			return false
		end
	end
	-- 检查出牌区2
	if self:checkPutDestPanel( poker,self.OutPanel2 ) then
		-- 检查能否放入
		local cur2_num = self._curPoker2:getNum()
		if self:checkCanPut( poker:getNum(),cur2_num ) then
			-- 放入
			self:putCardToDestPanel( poker,self.OutPanel2,2 )
			return true
		else
			-- 回到原位
			return false
		end
	end
	return false
end

function GamePlay:checkPutDestPanel( poker,destPanel )
	assert( poker," !! poker is nil !!" )
	assert( destPanel," !! destPanel is nil !!" )
	local poker_box = poker:getBoundingBox()
	local poker_world_pos = poker:getParent():convertToWorldSpace( cc.p( poker:getPosition() ) )
	poker_box.x = poker_world_pos.x
	poker_box.y = poker_world_pos.y
	local bound_box = destPanel:getBoundingBox()
	local out1_world_pos = destPanel:getParent():convertToWorldSpace( cc.p( destPanel:getPosition() ) )
	bound_box.x = out1_world_pos.x
	bound_box.y = out1_world_pos.y
	local rect = cc.rectIntersection(poker_box,bound_box)
	if rect.width > 70 and rect.height > 20 then
		return true
	end
	return false
end

function GamePlay:putCardToDestPanel( poker,destPanel,outPos )
	assert( poker," !! poker is nil !! " )
	assert( destPanel," !! destPanel is nil !! " )
	assert( outPos," !! outPos is nil !! " )
	local index = poker:getIndex()
	local new_poker = NodePoker.new( self,index )
	new_poker:showPoker()
	destPanel:addChild( new_poker )
	-- 设置
	if outPos == 1 then
		self._curPoker1 = new_poker
	else
		self._curPoker2 = new_poker
	end
	-- 执行动作
	local poker_world_pos = poker:getParent():convertToWorldSpace( cc.p( poker:getPosition() ) )
	local node_pos = destPanel:convertToNodeSpace( poker_world_pos )
	new_poker:setPosition( node_pos )

	local end_pos = { x = random( -5,5 ), y = random( -5,5 ) }
	local move_to = cc.MoveTo:create( 0.2,end_pos )
	local call_set = cc.CallFunc:create( function()
		new_poker._imageFont:setRotation( random( -10,10 ) )
		-- 增加积分
		self:rewardScore()
		-- 检查玩家是否赢了
		if self:isGameOverByPlayerWin() then
			self:gameOver( 2 )
		else
			if self:isReStartPlayIcon() then
				self:playIconAction()
			end
		end
	end )
	new_poker:runAction( cc.Sequence:create({ move_to,call_set }) )
	-- 移除
	poker:removeFromParent()
end

function GamePlay:rewardScore()
	local has_card_num = 0
	for i = 1,4 do
		if self["PlayerPanel"..i]:getChildByTag( 555 ) then
			has_card_num = has_card_num + 1
		end
	end
	local socre = 0
	if has_card_num == 0 then
		socre = 100
	elseif has_card_num == 1 then
		socre = 50
	elseif has_card_num == 2 then
		socre = 20
	elseif has_card_num == 3 then
		socre = 10
	end

	G_GetModel("Model_ZhanDou"):setScore( socre )
	-- 刷新
	self.TextScore:setString( G_GetModel("Model_ZhanDou"):getScore() )
end

function GamePlay:gameOver( winType )
	self:unSchedule()
	self.ImagePointer:stopAllActions()

	if self._gameOverMark then
		return
	end
	self._gameOverMark = true

	if winType == 1 then
		-- ai赢
		addUIToScene( UIDefine.ZHANDOU_KEY.Lose_UI )
	elseif winType == 2 then
		-- 玩家赢
		G_GetModel("Model_ZhanDou"):setStage()
		addUIToScene( UIDefine.ZHANDOU_KEY.Win_UI,{ score = G_GetModel("Model_ZhanDou"):getScore() } )
	elseif winType == 3 then
		-- 时间到
		addUIToScene( UIDefine.ZHANDOU_KEY.Lose_UI )
	end
end

function GamePlay:clickPause()
	self:stopSchedule()
	addUIToScene( UIDefine.ZHANDOU_KEY.Pause_UI,{ layer = self } )
end

function GamePlay:close()
	removeUIFromScene( UIDefine.ZHANDOU_KEY.Play_UI )
    addUIToScene( UIDefine.ZHANDOU_KEY.Start_UI )
end

function GamePlay:replaceCard()
	if not self._canPlayGame then
		return
	end
	if self._replaceMark then
		return
	end

	if self.ImagePlay:isVisible() then
		return
	end

	local coin = G_GetModel("Model_ZhanDou"):getCoin()
	if coin < 20 then
		return
	end

	if self:isReStartPlayIcon() then
		return
	end

	G_GetModel("Model_ZhanDou"):setCoin(-20)
	local coin = G_GetModel("Model_ZhanDou"):getCoin()
	self.TextCoin:setString( coin )

	self._replaceMark = true
	for i = 1,4 do
		local poker = self["PlayerPanel"..i]:getChildByTag( 555 )
		if poker then
			local dest_pos = cc.p( self.NodePoker2:getPosition() )
			dest_pos.y = dest_pos.y + 100
			local world_dest_pos = self.NodePoker2:getParent():convertToWorldSpace( dest_pos )
			local node_pos = self["PlayerPanel"..i]:convertToNodeSpace( world_dest_pos )
			poker:removePokerClick()
			local move_to = cc.MoveTo:create( 0.5,node_pos )
			local call_set = cc.CallFunc:create( function()
				local index = poker:getIndex()
				poker:removeFromParent()

				local new_poker = NodePoker.new( self,index )
				new_poker:setPosition( 0,100 )
				self.NodePoker2:addChild( new_poker )
				new_poker:setPositionX( 0 )
				table.insert( self._playerPokerNode,1,new_poker )

				local move_to = cc.MoveTo:create(0.2,cc.p(0,0))
				local call_reset = cc.CallFunc:create( function()
					-- 从新排序
					for a,v in ipairs( self._playerPokerNode ) do
						v:setLocalZOrder( a )
						v:setPositionX( a )
					end
				end )
				new_poker:runAction( cc.Sequence:create({ move_to,call_reset}) )
			end )
			poker:runAction(cc.Sequence:create({ move_to,call_set }))
		end
	end

	

	local actions = {}
	local delay_time1 = cc.DelayTime:create( 1 )
	table.insert( actions,delay_time1 )
	for i = 1,4 do
		local delay_time = cc.DelayTime:create( 0.5 )
		local call_send = cc.CallFunc:create( function()
			self:outPokerFromCards( self["PlayerPanel"..i],2 )
		end )
		table.insert( actions,delay_time )
		table.insert( actions,call_send )

		if i == 4 then
			local delay_time2 = cc.DelayTime:create( 1 )
			table.insert( actions,delay_time2 )
			local call_show = cc.CallFunc:create( function()
				self._replaceMark = nil
			end )
			table.insert( actions,call_show )
		end
	end
	self.NodePoker2:runAction( cc.Sequence:create( actions ) )
end








return GamePlay