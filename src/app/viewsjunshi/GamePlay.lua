
local PokerNode = import(".PokerNode")

local GamePlay = class("GamePlay",BaseLayer)


function GamePlay:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePlay.super.ctor( self,param.name )

    self._playerPeopleIndex = param.data

    self:addCsb( "csbjunshi/Play.csb" )
    self:addNodeClick( self["ButtonClose"],{ 
        endCallBack = function() self:close() end
    })

    self:addNodeClick( self["ButtonHelp"],{ 
        endCallBack = function() addUIToScene( UIDefine.JUNSHI_KEY.Help_UI ) end
    })
end

function GamePlay:onEnter()
	GamePlay.super.onEnter( self )
	-- 打开game背景音乐
	G_GetModel("Model_Sound"):playBgMusic()
	-- 初始化数据
	self:loadUIData()
	-- 初始化人物
	self:loadAiPlayerIcon()
	-- 字体闪烁动画
	self:loadNoticeAction()
	-- 进入游戏
	self:enterAction()
end

function GamePlay:loadUIData()
	self._allCardData = self:initCardData()

	-- 存储 ai和player牌的 pokerNode 
	self._aiPlayerPoker = {
		[1] = {},
		[2] = {},
		[3] = {},
		[4] = {}
	}
	-- ai和player node
	self._aiPlayerNode = {
		[1] = self.AINode1,
		[2] = self.AINode2,
		[3] = self.AINode3,
		[4] = self.PlayerNode
	}
	-- ai和player的位置
	self._aiPlayerPosition = {
		[1] = self.CardPos1:getParent():convertToWorldSpace(cc.p( self.CardPos1:getPosition() )),
		[2] = self.CardPos2:getParent():convertToWorldSpace(cc.p( self.CardPos2:getPosition() )),
		[3] = self.CardPos3:getParent():convertToWorldSpace(cc.p( self.CardPos3:getPosition() )),
		[4] = self.PlayerCardPos:getParent():convertToWorldSpace(cc.p( self.PlayerCardPos:getPosition() ))
	}

	-- 牌桌上的node
	self._outCardNode = {}

	-- 出牌的方向 1：顺时针 2：逆时针
	self._dir = 1
	-- 当前该谁出牌
	self._pointer = 1

	-- ai的赢钱数
	self._aiInitCoin = 300
	self._aiGetCoin = { self._aiInitCoin,self._aiInitCoin,self._aiInitCoin }
	-- 玩家的赢数
	self._playerGetCoin = 0

	-- ai的牌间距
	self._aiCardSpace = 35

	-- 牌堆数
	self.TextPaiNum:setString( #self._allCardData )
	self.TextDeng:setVisible( false )
	self.TextScore:setVisible( false )

	-- 玩家钱数
	self:loadPlayerCoin()
	-- ai的钱数
	self:loadAiCoin()
end

function GamePlay:loadPlayerCoin()
	self.PlayerTextCoin:setString( G_GetModel("Model_JunShi"):getCoin() )
end

function GamePlay:loadAiCoin()
	for i = 1,3 do
		self["AITextCoin"..i]:setString( self._aiGetCoin[i] )
	end
end

function GamePlay:loadAiPlayerIcon()
	-- 初始化玩家人物的icon
	self.PlayerIcon:loadTexture( js_select_people_path[self._playerPeopleIndex],1 )
	self.PlayerIcon:ignoreContentAdaptWithSize( true )
	-- ai的人物icon
	local ai_random = getRandomArray( 1,6 )
	local ai_people = {}
	for i,v in ipairs( ai_random ) do
		if v ~= self._playerPeopleIndex then
			table.insert( ai_people,v )
		end
	end
	self._aiPeopleIndex = {}
	for i = 1,3 do
		self._aiPeopleIndex[i] = ai_people[i]
		self["AIIcon"..i]:loadTexture( js_select_people_path[ai_people[i]],1 )
	end
end

function GamePlay:loadNoticeAction()
	local blink = cc.Blink:create(2,1)
	local rep = cc.RepeatForever:create( blink )
	self.ImageHelp:runAction( rep )
end

function GamePlay:stopNoticeAction()
	if self.ImageHelp:isVisible() then
		self.ImageHelp:stopAllActions()
		self.ImageHelp:setVisible( false )
	end
end

-- 游戏进入动画
function GamePlay:enterAction()
	self:sendCardByBeganGame()
end
-- 开始发牌的动画
function GamePlay:sendCardByBeganGame()
	local send_random_seq = {
		{1,2,3,4},
		{2,3,4,1},
		{3,4,1,2},
		{4,1,2,3}
	}

	local actions = {}
	local send_seq = send_random_seq[random( 1,#send_random_seq )]
	-- local send_seq = send_random_seq[1]

	for i = 1,3 do
		for k,v in ipairs( send_seq ) do
			local delay_time = cc.DelayTime:create( 0.3 )
			local send_card = cc.CallFunc:create( function()
				self:sendCardAction( v ) 
			end )
			table.insert( actions,delay_time )
			table.insert( actions,send_card )

			if i == 3 and k == #send_seq then
				local delay_time2 = cc.DelayTime:create( 1 )
				local send_card_done = cc.CallFunc:create( function()
					-- 发牌结束 可以开始游戏了
					self:moCard()
				end )
				table.insert( actions,delay_time2 )
				table.insert( actions,send_card_done )
			end
		end
	end
	local seq = cc.Sequence:create( actions )
	self:runAction( seq )
	-- 初始化
	self._pointer = send_seq[1]
end
-- 发牌动画
function GamePlay:sendCardAction( seatPos )
	assert( seatPos," !! seatPos is nil !! " )

	local end_point = clone( self._aiPlayerPosition[ seatPos ] )
	end_point.x = end_point.x + (#self._aiPlayerPoker[seatPos]) * self._aiCardSpace

	local start_point = cc.p( self.PokerNode:getPosition() )
	-- 创建一个背的牌 执行动画
	local poker_img = ccui.ImageView:create(js_card_path_config[1],1)
	self._csbNode:addChild( poker_img,100 )
	poker_img:setPosition( start_point )
	poker_img:setScale( 0.5 )
	local move_to = cc.MoveTo:create( 0.5,end_point )
	local scale_to = cc.ScaleTo:create( 0.5,1 )
	local rotate_by = cc.RotateBy:create( 0.5, -360 )
	local spawn = cc.Spawn:create({ move_to,scale_to,rotate_by })
	local call_back = cc.CallFunc:create( function()
		self:createCardToAiOrPlayer( seatPos )
	end )
	local paidui_change_num = cc.CallFunc:create( function()
		self.TextPaiNum:setString( #self._allCardData )
	end )
	local remove = cc.RemoveSelf:create()
	
	local seq = cc.Sequence:create({ spawn,call_back,paidui_change_num,remove })
	poker_img:runAction( seq )
end

function GamePlay:createCardToAiOrPlayer( seatPos )
	assert( seatPos," !! seatPos is nil !! " )

	local card_num = self:getCardFromPaiDui()

	local parent = self._aiPlayerNode[seatPos]
	local poker_card = nil
	if seatPos == 4 then
		poker_card = PokerNode.new( self,"player" )
		parent:addChild( poker_card )
		poker_card:loadDataUI( card_num )
	else
		-- poker_card = ccui.ImageView:create(js_card_path_config[1],1)
		-- parent:addChild( poker_card )

		poker_card = PokerNode.new( self,"ai" )
		parent:addChild( poker_card )
		poker_card:loadDataUI( card_num )
	end

	local end_point = clone( self._aiPlayerPosition[ seatPos ] )
	end_point.x = end_point.x + (#self._aiPlayerPoker[seatPos]) * self._aiCardSpace

	local node_pos = parent:convertToNodeSpace( end_point )
	poker_card:setPosition( node_pos )
	local move_by = cc.MoveBy:create( 0.2,cc.p( 0,-20 ) )
	poker_card:runAction( move_by )

	table.insert( self._aiPlayerPoker[seatPos],poker_card )
end

function GamePlay:initCardData()
	local cards = {}
	local card_index = getRandomArray( 1,38 )
	for i,v in ipairs( card_index ) do
		local card = js_num_config[v]
		table.insert( cards,card )
	end
	return cards
end


function GamePlay:getCardFromPaiDui()
	local card = self._allCardData[1]
	table.remove( self._allCardData,1 )
	return card
end

-- 摸牌
function GamePlay:moCard()
	-- 摸一张牌(检查牌区是否还有牌)
	if #self._allCardData > 0 then
		-- 创建手指
		self:createPointer()
		performWithDelay( self,function()
			-- 发牌
			self:sendCardAction( self._pointer )
			-- 如果是ai 2秒后 出一张牌
			if self._pointer ~= 4 then
				performWithDelay( self,function()
					self:aiOutCard()
				end,1 )
			else
				-- 玩家出牌
			end
		end,0.2 )
	else
		-- 判断所有玩家是否还有牌
		local has = false
		for i = 1,4 do
			if #self._aiPlayerPoker[i] > 0 then
				has = true
				break
			end
		end
		if has then
			-- 直接出牌
			if self._pointer ~= 4 then
				if #self._aiPlayerPoker[self._pointer] > 0 then
					-- 创建手指
					self:createPointer()
					performWithDelay( self,function()
						self:aiOutCard()
					end,1 )
				else
					self:aiOutCard()
				end
			else
				-- 玩家出牌
				if #self._aiPlayerPoker[self._pointer] > 0 then
					-- 创建手指
					self:createPointer()
				end
			end
		else
			-- 游戏结束
			self:gameOver()
		end
	end
end

-- 出牌
function GamePlay:aiOutCard()
	-- 检查是否还有牌
	if #self._aiPlayerPoker[self._pointer] == 0 then
		self:changePointer()
		self:moCard()
		return
	end
	-- 执行出牌动画
    local poker_node,index,is_junshi,zhuan_num = self:aiSelectCard()
	local poker_num = poker_node:getNum()
	local world_pos = poker_node:getParent():convertToWorldSpace( cc.p( poker_node:getPosition() ) )
	-- 移除该poker_node
	poker_node:removeFromParent()
	table.remove( self._aiPlayerPoker[self._pointer],index )
	-- 重置该ai剩余的牌的位置
	self:resetPokerPostion( self._pointer )

	self:createPokerCardToOutCard( self._pointer,poker_num,world_pos )
end


function GamePlay:aiSelectCard()
	local out_num = self:getOutCardNum()
	-- 1:检查能否组成12点
	for i,v in ipairs( self._aiPlayerPoker[self._pointer] ) do
		local num = v:getNum()
		if num ~= 7 and num ~= 8 then
			if num + out_num == 12 then
				return v,i
			end
		end
	end
	-- 2:优先出转换卡
	for i,v in ipairs( self._aiPlayerPoker[self._pointer] ) do
		local num = v:getNum()
		if num == 7 then
			return v,i
		end
	end
	-- 3:找出与out_num之和小于12的最大的牌
	local c_data = {}
	for i,v in ipairs( self._aiPlayerPoker[self._pointer] ) do
		local num = v:getNum()
		if num ~= 8 and num + out_num < 12 then
			table.insert( c_data,{ node = v,index = i } )
		end
	end
	if #c_data > 0 then
		table.sort( c_data,function(a,b)
			if a.node:getNum() ~= b.node:getNum() then
				return a.node:getNum() > b.node:getNum()
			end
		end )
		return c_data[1].node,c_data[1].index
	end
	-- 4:当全部与out_num之和都大于12点的时候 检查有没有军师卡 
	for i,v in ipairs( self._aiPlayerPoker[self._pointer] ) do
		local num = v:getNum()
		if num == 8 then
			return v,i
		end
	end
	-- 出第一张
	return self._aiPlayerPoker[self._pointer][1],1
end

-- 根据座位创建一张牌到出牌区
function GamePlay:createPokerCardToOutCard( seatPos,cardNum,createWorldPos )
	assert( seatPos," !! seatPos is nil !! " )
	assert( cardNum," !! cardNum is nil !! " )
	assert( createWorldPos," !! createWorldPos is nil !! " )

	-- 立即隐藏手指
	self:hidePointer()

	-- 创建poker_card
    local poker_card = PokerNode.new( self,"out" )
    poker_card:loadDataUI( cardNum )
	self.OutCardNode:addChild( poker_card )

	-- local pos = clone( self._aiPlayerPosition[seatPos] )
	local node_pos = self.OutCardNode:convertToNodeSpace( createWorldPos )
	poker_card:setPosition( node_pos )

	-- 插入self._outCardNode
	table.insert( self._outCardNode,poker_card )

	-- 刚创建的pokercard执行移动动作到出牌区位置
	local end_pos = { x = 0,y = 0 }
	end_pos.x = end_pos.x + #self._outCardNode * 40
	local move_to = cc.MoveTo:create( 0.5,end_pos )
	local cal_result = cc.CallFunc:create( function()

		audio.playSound("jsmp3/button.mp3", false)

		local out_num = self:getOutCardNum()
		self.TextDeng:setVisible( true )
		self.TextScore:setVisible( true )
		self.TextScore:setString( out_num )
	end )
	local delay_time = cc.DelayTime:create( 1 )
	local call_next = cc.CallFunc:create( function()
		self:calResultByOutCardDone( cardNum,poker_card )
	end )

	local seq = cc.Sequence:create( { move_to,cal_result,delay_time,call_next } )
	poker_card:runAction( seq )
end

-- 根据座位 重置改玩家的手牌位置
function GamePlay:resetPokerPostion( seatPos )
	assert( seatPos," !! seatPos is nil !! " )
	for i,v in ipairs( self._aiPlayerPoker[seatPos] ) do
		local end_point = clone( self._aiPlayerPosition[ seatPos ] )
		end_point.x = end_point.x + ( i - 1 ) * self._aiCardSpace
		end_point.y = end_point.y - 20
		local node_pos = v:getParent():convertToNodeSpace( end_point )

		if node_pos.x ~= v:getPositionX() then
			local move_by = cc.MoveBy:create( 0.2,cc.p( node_pos.x - v:getPositionX(),0 ) )
			v:runAction( move_by )
		end
	end
end

-- 出牌完成 计算结果 积分
function GamePlay:calResultByOutCardDone( cardNum,pokerCard )
	assert( cardNum," !! cardNum is nil !! " )
	assert( pokerCard," !! pokerCard is nil !! " )
	-- 1:判断当前的牌是不是转换卡
	if cardNum == 7 then
		-- 播放转换动画
		local call_back = function()
			self:changeDir()
			self:changePointer()
			self:moCard()
		end
		self:zhuanHuanAction( call_back )
	else
		if cardNum == 8 then
			local out_num = self:getOutCardNum()
			local change_num = 12 - out_num
			if change_num > 6 then
				change_num = 6
			end
			self:junshiChangeAction( pokerCard,change_num )
		else
			self:calOutCardResult()
	    end
	end
end

-- 计算出牌区的结果
function GamePlay:calOutCardResult()
	-- 计算结果
	local out_num = self:getOutCardNum()
	if out_num < 12 then
		self:changePointer()
		self:moCard()
	elseif out_num == 12 then
		-- 加钱动画
		self:addCoinAction( self._pointer )
		audio.playSound("jsmp3/getcoin.mp3", false)

		-- 玩家加钱
		if self._pointer == 4 then
			G_GetModel("Model_JunShi"):setCoin( #self._outCardNode )
			self._playerGetCoin = self._playerGetCoin + #self._outCardNode
			self:loadPlayerCoin()
		else
			-- ai的加钱
			self._aiGetCoin[self._pointer] = self._aiGetCoin[self._pointer] + #self._outCardNode
			self:loadAiCoin()
		end

		self:changePointer()
		-- 移除出牌区的所有node
		self:clearOutNode()
		self:moCard()
	else
		-- 扣钱动画
		self:reduceCoinAction( self._pointer )
		audio.playSound("jsmp3/lostcoin.mp3", false)

		-- 玩家扣钱
		if self._pointer == 4 then
			G_GetModel("Model_JunShi"):setCoin( -(#self._outCardNode) )
			self:loadPlayerCoin()
			self._playerGetCoin = self._playerGetCoin - #self._outCardNode
			if G_GetModel("Model_JunShi"):getCoin() <= 0 then
				-- 游戏结束
				self:gameOver()
				return
			end
		else
			self._aiGetCoin[self._pointer] = self._aiGetCoin[self._pointer] - #self._outCardNode
			self:loadAiCoin()
		end

		self:changePointer()
		-- 移除出牌区的所有node
		self:clearOutNode()
		self:moCard()
	end
end

function GamePlay:zhuanHuanAction( callBack )
	local layer = cc.LayerColor:create( cc.c4b(0,0,0,150) )
	self:addChild( layer,50 )
	local zhuan_image = ccui.ImageView:create("image/game/change.png",1)
	self:addChild( zhuan_image,100 )
	zhuan_image:setPosition( display.cx,display.cy )
	zhuan_image:setScale( 0.5 )
	local scale_to = cc.ScaleTo:create( 0.5,1 )
	local rotate_by = cc.RotateBy:create( 1,360 )
	local call_back = cc.CallFunc:create( callBack )
	local remove_layer = cc.CallFunc:create( function()
		layer:removeFromParent()
	end )
	local remove = cc.RemoveSelf:create()
	local seq = cc.Sequence:create({ scale_to,rotate_by,call_back,remove_layer,remove })
	zhuan_image:runAction( seq )
end

function GamePlay:addCoinAction( seatPos )
	assert( seatPos," !! seatPos is nil  !! " )
	local point1 = cc.p(display.cx,display.cy)
    local point3 = cc.p( self._aiPlayerNode[seatPos]:getPosition() )
    local point2 = cc.p( (point3.x - point1.x) / 2,(point3.y - point1.y) / 2 )

    local sp_icon = ccui.ImageView:create( "image/game/tq.png" , 1)
    for i = 1,25 do
        local sp = sp_icon:clone()
        sp:setPosition(point1.x,point1.y)
        local bez = { point1,point2,point3 }
        local time = math.random( 100, 150 ) / 100;
        local bt = cc.BezierTo:create(time, bez)
        local fade_to = cc.FadeOut:create( 0.2 )
        local scale_to = cc.ScaleTo:create( 0.2,0.2 )
        local spawn = cc.Spawn:create( {fade_to,scale_to} )
        local remove = cc.RemoveSelf:create()
        local seq = cc.Sequence:create( { bt,spawn,remove } )
        sp:runAction( seq )
        if i == 25 then
        	local label = ccui.TextBMFont:create( "+"..(#self._outCardNode),"image/game/NB_WIN.fnt" )
        	self:addChild( label,200 )
        	label:setPosition( self._aiPlayerPosition[seatPos] )
        	local move_by1 = cc.MoveBy:create( 1,cc.p( 0,50 ) )
        	local label_remove = cc.RemoveSelf:create()
        	local seq_label = cc.Sequence:create({ move_by1,label_remove })
        	label:runAction( seq_label )
        end
        self:addChild(sp,100)
    end
end

function GamePlay:reduceCoinAction( seatPos )
	assert( seatPos," !! seatPos is nil  !! " )
	local label = ccui.TextBMFont:create( "-"..(#self._outCardNode),"image/game/NB_LOSE.fnt" )
	self:addChild( label,200 )
	label:setPosition( self._aiPlayerPosition[seatPos] )
	local move_by1 = cc.MoveBy:create( 1,cc.p( 0,50 ) )
	local label_remove = cc.RemoveSelf:create()
	local seq_label = cc.Sequence:create({ move_by1,label_remove })
	label:runAction( seq_label )
end

function GamePlay:junshiChangeAction( poker,num )
	local move_by1 = cc.MoveBy:create( 0.5,cc.p( 0, 20 ) )
	local move_by2 = cc.MoveBy:create( 0.5,cc.p( 0,-20 ) )
	local call = cc.CallFunc:create( function()
		if self._pointer == 4 then
			-- 玩家需要打开选择界面
			addUIToScene( UIDefine.JUNSHI_KEY.Choose_UI,{ 
				call_back = function( chooseNum )
					poker:loadDataUI( chooseNum )
					local out_num = self:getOutCardNum()
					self.TextScore:setString( out_num )
					performWithDelay( self,function()
						self:calOutCardResult()
					end,1 )
				end
			} )
		else
			poker:loadDataUI( num )
			local out_num = self:getOutCardNum()
			self.TextScore:setString( out_num )
			performWithDelay( self,function()
				self:calOutCardResult()
			end,1 )
		end
	end )
	local seq = cc.Sequence:create({ move_by1,move_by2,call })
	poker:runAction( seq )
end

-- 改变指向
function GamePlay:changePointer()
	if self._dir == 1 then
		if self._pointer == 4 then
			self._pointer = 1
		else
			self._pointer = self._pointer + 1
		end
	else
		if self._pointer == 1 then
			self._pointer = 4
		else
			self._pointer = self._pointer - 1
		end
	end

	if self._pointer == 4 then
		self._setPokerMark = nil
	end
	self._playerSelectPoker = nil
end

function GamePlay:createPointer()
	if self._pointImage == nil then
		self._pointImage = ccui.ImageView:create( "image/game/jiantou.png",1 )
		self:addChild( self._pointImage )
	end
	self._pointImage:setVisible( true )
	self._pointImage:stopAllActions()
	local pos = clone( self._aiPlayerPosition[self._pointer] )
	if self._pointer == 1 then
		self._pointImage:setRotation(-180)
		pos.x = pos.x + 180
		pos.y = pos.y - 50
		self._pointImage:setPosition( pos )
		local move_by1 = cc.MoveBy:create( 0.5,cc.p( -20,0 ) )
		local move_by2 = cc.MoveBy:create( 0.5,cc.p( 20,0 ) )
		local seq = cc.Sequence:create({ move_by1,move_by2 })
		local rep = cc.RepeatForever:create( seq )
		self._pointImage:runAction( rep )
	elseif self._pointer == 2 then
		self._pointImage:setRotation(-90)
		pos.x = pos.x - 100
		pos.y = pos.y - 150
		self._pointImage:setPosition( pos )
		local move_by1 = cc.MoveBy:create( 0.5,cc.p( 0,20 ) )
		local move_by2 = cc.MoveBy:create( 0.5,cc.p( 0,-20 ) )
		local seq = cc.Sequence:create({ move_by1,move_by2 })
		local rep = cc.RepeatForever:create( seq )
		self._pointImage:runAction( rep )
	elseif self._pointer == 3 then
		self._pointImage:setRotation(0)
		pos.x = pos.x - 100
		pos.y = pos.y - 50
		self._pointImage:setPosition( pos )
		local move_by1 = cc.MoveBy:create( 0.5,cc.p( 20,0 ) )
		local move_by2 = cc.MoveBy:create( 0.5,cc.p( -20,0 ) )
		local seq = cc.Sequence:create({ move_by1,move_by2 })
		local rep = cc.RepeatForever:create( seq )
		self._pointImage:runAction( rep )
	elseif self._pointer == 4 then
		self._pointImage:setRotation(90)
		pos.x = pos.x
		pos.y = pos.y + 100
		self._pointImage:setPosition( pos )
		local move_by1 = cc.MoveBy:create( 0.5,cc.p( 0,-20 ) )
		local move_by2 = cc.MoveBy:create( 0.5,cc.p( 0,20 ) )
		local seq = cc.Sequence:create({ move_by1,move_by2 })
		local rep = cc.RepeatForever:create( seq )
		self._pointImage:runAction( rep )
	end
end

function GamePlay:hidePointer()
	if self._pointImage then
		self._pointImage:setVisible( false )
	end
end

function GamePlay:changeDir()
	if self._dir == 1 then
		self._dir = 2
	else
		self._dir = 1
	end
end

function GamePlay:clearOutNode()
	for i,v in ipairs( self._outCardNode ) do
		v:removeFromParent()
	end
	self.TextDeng:setVisible( false )
	self.TextScore:setVisible( false )
	self._outCardNode = {}
end

function GamePlay:getOutCardNum()
	local total = 0
	for i,v in ipairs( self._outCardNode ) do
		if v:getNum() ~= 7 and v:getNum() ~= 8 then
			total = total + v:getNum()
		end
	end
	return total
end

function GamePlay:playerOutCard( poker )
	if self._pointer ~= 4 then
		return
	end
	if self._setPokerMark then
		return
	end
	self:stopNoticeAction()
	self._setPokerMark = true
	if self._playerSelectPoker == nil then
		self._playerSelectPoker = poker
		local move_by = cc.MoveBy:create( 0.2,cc.p(0,20) )
		local call_set_mark = cc.CallFunc:create( function()
			self._setPokerMark = nil
		end )
		poker:runAction( cc.Sequence:create({ move_by,call_set_mark}) )
	elseif self._playerSelectPoker ~= poker then
		local move_by = cc.MoveBy:create( 0.2,cc.p(0,20) )
		poker:runAction( move_by )
		local move_by2 = cc.MoveBy:create( 0.2,cc.p(0,-20) )
		local call_set = cc.CallFunc:create( function()
			self._playerSelectPoker = poker
			self._setPokerMark = nil
		end )
		self._playerSelectPoker:runAction( cc.Sequence:create({ move_by2,call_set }) )
	else
		-- 出牌
		local poker_num = poker:getNum()
		local world_pos = poker:getParent():convertToWorldSpace( cc.p( poker:getPosition() ) )
		for i,v in ipairs( self._aiPlayerPoker[self._pointer] ) do
			if v == poker then
				table.remove( self._aiPlayerPoker[self._pointer],i )
				-- 移除该poker_node
				poker:removeFromParent()
				break
			end
		end
		-- 重置该ai剩余的牌的位置
		self:resetPokerPostion( self._pointer )

		self:createPokerCardToOutCard( self._pointer,poker_num,world_pos )
	end
end

function GamePlay:getPlayerSelect()
	return self._playerSelectPoker
end

function GamePlay:clearPlayerSelect()
	if self._pointer ~= 4 then
		return
	end
	if self._setPokerMark then
		return
	end
	if self._playerSelectPoker then
		local move_by = cc.MoveBy:create( 0.2,cc.p(0,-20) )
		local call_set = cc.CallFunc:create( function()
			self._playerSelectPoker = nil
		end )
		local seq = cc.Sequence:create({ move_by,call_set })
		self._playerSelectPoker:runAction( seq )
	end
end

function GamePlay:gameOver()
	local ai_coin = {}
	for i,v in ipairs( self._aiGetCoin ) do
		local cc = v - self._aiInitCoin
		table.insert( ai_coin,cc )
	end
	local data = {
		ai_index = clone( self._aiPeopleIndex ),
		player_index = self._playerPeopleIndex,
		ai_coin = ai_coin,
		player_coin = self._playerGetCoin
	}
	if self._playerGetCoin > 0 then
		G_GetModel("Model_JunShi"):saveRecordList( self._playerGetCoin,self._playerPeopleIndex )
	end
	addUIToScene( UIDefine.JUNSHI_KEY.Over_UI,data )
end

function GamePlay:close()
	removeUIFromScene( UIDefine.JUNSHI_KEY.Play_UI )
    addUIToScene( UIDefine.JUNSHI_KEY.Start_UI )
end


return GamePlay