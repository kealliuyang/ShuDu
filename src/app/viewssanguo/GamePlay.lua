

local NodePoker = import(".NodePoker")

local GamePlay = class("GamePlay",BaseLayer)


function GamePlay:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePlay.super.ctor( self,param.name )

    self:addCsb( "csbsanguo/Play.csb" )

    self:addNodeClick( self["ButtonClose"],{ 
        endCallBack = function() self:close() end
    })

    -- 打开商店
    self:addNodeClick( self["BgCoin"],{ 
        endCallBack = function() 
        	addUIToScene( UIDefine.SANGUO_KEY.Shop_UI,{ layer = self } ) 
        end
    })

    -- 打开音效
    self:addNodeClick( self["ButtonMusic"],{ 
        endCallBack = function() 
        	addUIToScene( UIDefine.SANGUO_KEY.Voice_UI,{ layer = self } ) 
        end
    })

    -- 隐藏方向
    for i = 1,4 do
    	self["ImageDir"..i]:setVisible( false )
    end
end


function GamePlay:onEnter()
	GamePlay.super.onEnter( self )
	casecadeFadeInNode( self._csbNode,0.5 )
	-- 初始化数据
	self:loadCoin()
	-- 初始化牌
	self._allPokerData = getRandomArray( 1,104 )
	self._allPokerNode = {}
	-- 创建所有的牌
	self:createBeiCard()
	-- 发牌动画
	performWithDelay( self,function()
		self:sendCardAction()
	end,0.7 )
end


function GamePlay:loadCoin()
    local coin = G_GetModel("Model_SanGuo"):getInstance():getCoin()
    self.TextCoin:setString(coin)
end

function GamePlay:createBeiCard()
	local bei_num = random(1,4)
	for i = 1,104 do
		local poker = NodePoker.new( self,bei_num )
		self.NodeAllPoker:addChild( poker )
		poker:setRotation( -135 ) 
		poker:setPosition( cc.p( random(-5,5),random(-5,5) ) )
		poker:loadDataUI( self._allPokerData[i] )
		self._allPokerNode[i] = poker
	end
end

function GamePlay:sendCardAction()
	local send_random_seq = {
		{1,2,3,4},
		{2,3,4,1},
		{3,4,1,2},
		{4,1,2,3}
	}
	local seq_num = random( 1,#send_random_seq )
	local send_seq = send_random_seq[seq_num]
	-- 出牌点
	self._centerPos = cc.p( display.cx,display.cy - 90 )
	-- 第一个出牌的人
	self._pointer = send_seq[1]
	-- 方向 1:顺时针 2:逆时针
	self._dir = 1
	-- 当前出牌的索引值
	self._curOutPokerIndex = 0

	-- 是否需要再摸牌的标志
	self._moAgain = nil
	-- 当前的卡牌是否是玉溪卡的标志
	self._yuxiMark = nil


	local actions = {}
	for i = 1,7 do
		for k,v in ipairs( send_seq ) do
			local delay_time = cc.DelayTime:create( 0.2 )
			local call_send = cc.CallFunc:create( function()
				self:sendOneCardAction( v )
			end )
			table.insert( actions,delay_time )
			table.insert( actions,call_send )
			
			-- 发牌结束 开始游戏
			if i == 7 and k == #send_seq then
				local delay_time2 = cc.DelayTime:create( 0.5 )
				local send_card_done = cc.CallFunc:create( function()
					-- 发牌结束 可以开始游戏了
					self:beganGame()
				end )
				table.insert( actions,delay_time2 )
				table.insert( actions,send_card_done )
			end
		end
	end
	local seq = cc.Sequence:create( actions )
	self.Bg:runAction( seq )
end

function GamePlay:sendOneCardAction( seatPos )
	assert( seatPos," !! seatPos is nl !! " )

	if #self._allPokerNode == 0 then
		return
	end

	-- 播放音效
	if G_GetModel("Model_Sound"):isVoiceOpen() then
		audio.playSound("sgmp3/sendcard.mp3", false)
	end

	local top_poker = self._allPokerNode[#self._allPokerNode]
	table.remove( self._allPokerNode,#self._allPokerNode )

	local dest_node = self["NodeAI"..seatPos]
	local end_world_pos,rotation = self:getCardPosBySeat( seatPos )
	local rotation_diss = rotation - top_poker:getRotation()
	local action_time = 0.2
	local end_node_pos = self.NodeAllPoker:convertToNodeSpace( end_world_pos )
	local move_by = cc.MoveBy:create( 0.1,cc.p( 20,20 ))
	local move_to = cc.MoveTo:create( action_time,end_node_pos )
	local rotation_by = cc.RotateBy:create( action_time,rotation_diss )
	local spawn = cc.Spawn:create({ move_to,rotation_by })
	local call = cc.CallFunc:create( function()
		top_poker:retain()
		top_poker:removeFromParent()
		dest_node:addChild( top_poker )
		top_poker:release()
		-- 玩家扑克添加点击
		if seatPos == 4 then
			top_poker:addPokerClick()
			top_poker:showPoker()
		end
		local node_pos = dest_node:convertToNodeSpace( end_world_pos )
		top_poker:setPosition( node_pos )
		self:aiHandPokerAction( seatPos )
	end )
	local seq = cc.Sequence:create({ move_by,spawn,call })
	top_poker:runAction( seq )
end

-- 将ai手中的牌 平铺
function GamePlay:aiHandPokerAction( seatPos )
	assert( seatPos," !! seatPos is nl !! " )
	local dest_node = self["NodeAI"..seatPos]
	local childs = dest_node:getChildren()
	local nums = #childs
	if nums <= 1 then
		return
	end

	local end_world_pos,rotation = self:getCardPosBySeat( seatPos )
	if seatPos == 1 then
		local start_rotation = rotation - ( nums - 1 ) * 5
		local start_posY = end_world_pos.y + ( nums - 1 ) * 10
		for i = 1,nums do
			local finaly_rotation = start_rotation + ( i - 1) * 10
			local rotation_diss = finaly_rotation - childs[i]:getRotation()
			local rotation_by = cc.RotateBy:create( 0.2,rotation_diss )

			local finaly_posY = start_posY - ( i - 1) * 20
			local pos = clone( end_world_pos )
			pos.y = finaly_posY

			local node_pos = dest_node:convertToNodeSpace( pos )
			local pos_disx = node_pos.x - childs[i]:getPositionX()
			local pos_disy = node_pos.y - childs[i]:getPositionY()
			local move_by = cc.MoveBy:create( 0.2,cc.p( pos_disx,pos_disy ) )
			local spawn = cc.Spawn:create({ move_by,rotation_by })
			childs[i]:runAction( spawn )
		end
	elseif seatPos == 2 then
		local start_rotation = rotation - ( nums - 1 ) * 5
		local start_posX = end_world_pos.x + ( nums - 1 ) * 10
		for i = 1,nums do
			local finaly_rotation = start_rotation + ( i - 1) * 10
			local rotation_diss = finaly_rotation - childs[i]:getRotation()
			local rotation_by = cc.RotateBy:create( 0.2,rotation_diss )

			local finaly_posX = start_posX - ( i - 1) * 20
			local pos = clone( end_world_pos )
			pos.x = finaly_posX

			local node_pos = dest_node:convertToNodeSpace( pos )
			local pos_disx = node_pos.x - childs[i]:getPositionX()
			local pos_disy = node_pos.y - childs[i]:getPositionY()
			local move_by = cc.MoveBy:create( 0.2,cc.p( pos_disx,pos_disy ) )
			local spawn = cc.Spawn:create({ move_by,rotation_by })
			childs[i]:runAction( spawn )
		end
	elseif seatPos == 3 then
		local start_rotation = rotation - ( nums - 1 ) * 5
		local start_posY = end_world_pos.y - ( nums - 1 ) * 10
		for i = 1,nums do
			local finaly_rotation = start_rotation + ( i - 1) * 10
			local rotation_diss = finaly_rotation - childs[i]:getRotation()
			local rotation_by = cc.RotateBy:create( 0.2,rotation_diss )
			local finaly_posY = start_posY + ( i - 1) * 20
			local pos = clone( end_world_pos )
			pos.y = finaly_posY
			local node_pos = dest_node:convertToNodeSpace( pos )
			local pos_disx = node_pos.x - childs[i]:getPositionX()
			local pos_disy = node_pos.y - childs[i]:getPositionY()
			local move_by = cc.MoveBy:create( 0.2,cc.p( pos_disx,pos_disy ) )
			local spawn = cc.Spawn:create({ move_by,rotation_by })
			childs[i]:runAction( spawn )
		end
	elseif seatPos == 4 then
		local start_posX = end_world_pos.x - ( nums - 1 ) * 30
		for i = 1,nums do
			local finaly_posX = start_posX + ( i - 1) * 60
			local pos = clone( end_world_pos )
			pos.x = finaly_posX
			local node_pos = dest_node:convertToNodeSpace( pos )
			local pos_disx = node_pos.x - childs[i]:getPositionX()
			local pos_disy = node_pos.y - childs[i]:getPositionY()
			local move_by = cc.MoveBy:create( 0.2,cc.p( pos_disx,pos_disy ) )
			childs[i]:runAction( move_by )
		end
	end
end


function GamePlay:getCardPosBySeat( seatPos )
	assert( seatPos," !! seatPos is nil !! " )
	local dest_node = self["NodeAI"..seatPos]
	local end_world_pos = dest_node:getParent():convertToWorldSpace( cc.p(dest_node:getPosition()) )
	local rotation = 0
	if seatPos == 1 then
		end_world_pos.x = end_world_pos.x + 5
		rotation = 90
	elseif seatPos == 2 then
		end_world_pos.y = end_world_pos.y - 5
		rotation = 180
	elseif seatPos == 3 then
		end_world_pos.x = end_world_pos.x - 5
		rotation = 270
	elseif seatPos == 4 then
		end_world_pos.y = end_world_pos.y + 5
		rotation = 0
	end
	return end_world_pos,rotation
end


function GamePlay:beganGame()
	-- 从牌堆里面出一张牌
	local top_poker = self._allPokerNode[#self._allPokerNode]
	table.remove( self._allPokerNode,#self._allPokerNode )
	self._curOutPokerIndex = top_poker:getNum()

	-- 显示
	top_poker:showPoker()

	-- 执行动画
	local node_pos =  self.NodeAllPoker:convertToNodeSpace( self._centerPos )
	local move_to = cc.MoveTo:create( 0.5,node_pos )
	local rote_to = cc.RotateTo:create( 0.5,0 )
	local spawn = cc.Spawn:create({ move_to,rote_to })
	local call_dir = cc.CallFunc:create( function()
		-- 重新放入
		top_poker:retain()
		top_poker:removeFromParent()
		self.NodeCenter:addChild( top_poker )
		local node_pos = self.NodeCenter:convertToNodeSpace( self._centerPos )
		top_poker:setPosition( node_pos )
		top_poker:release()

		self:showDirAndPointer()
		-- 开始出牌
		self:outPoker()
	end )
	top_poker:runAction( cc.Sequence:create({ spawn,call_dir }) )
end

-- 出牌
function GamePlay:outPoker()
	-- 1:判断是否为流局
	if #self._allPokerNode == 0 then
		local can = false
		for i = 1,4 do
			if self:checkAIPlayerCanOut( i ) then
				can = true
				break
			end
		end
		if not can then
			-- 游戏结束 流局
			self:gameOver( 3 )
			return
		end
	end

	local cur_data = sanguo_config.card[self._curOutPokerIndex]
	-- 2:判断是否是玉玺卡
	if cur_data.index == 11 and self._yuxiMark then
		local dest_node = self["NodeAI"..self._pointer]
		-- 重置 让下个玩家可以出牌
		self._yuxiMark = nil
		-- 不能出牌 摸2张牌
		local call_mo1 = cc.CallFunc:create( function()
			self:sendOneCardAction( self._pointer )
		end )
		local delay_time1 = cc.DelayTime:create( 0.5 )
		local call_mo2 = cc.CallFunc:create( function()
			self:sendOneCardAction( self._pointer )
		end )
		local delay_time2 = cc.DelayTime:create( 0.5 )
		local call_next = cc.CallFunc:create( function()
			self:changePointer()
			self:showDirAndPointer()
			self:outPoker()
		end )
		local seq = cc.Sequence:create({ call_mo1,delay_time1,call_mo2,delay_time2,call_next })
		dest_node:runAction( seq )
		return
	end

	-- 3:等待玩家出牌
	if self._pointer == 4 then
		self:playerOutPoker()
		return
	end
	-- 4:Ai出牌
	performWithDelay( self,function()
		self:aiOutPoker()
	end,1 )
end

-- AI出牌
function GamePlay:aiOutPoker()
	local dest_node = self["NodeAI"..self._pointer]
	-- AI逻辑
	local can_out,out_poker = self:checkAIPlayerCanOut( self._pointer )
	if out_poker then
		-- 出牌 执行出牌动作逻辑
		self:aiOrPlayerSelectOutPoker( out_poker )
	else
		-- 再摸一张牌
		if not self._moAgain then
			self:sendOneCardAction( self._pointer )
			self._moAgain = true
			performWithDelay( dest_node,function()
				self:aiOutPoker()
			end,0.5 )
		else
			-- 下一个人出牌
			self._moAgain = nil
			self:changePointer()
			self:showDirAndPointer()
			self:outPoker()
		end
	end
end

-- 玩家出牌
function GamePlay:playerOutPoker()
	-- 1:将不能出的牌置灰
	local cur_data = sanguo_config.card[self._curOutPokerIndex]
	local dest_node = self["NodeAI4"]
	local childs = dest_node:getChildren()
	for i,v in ipairs( childs ) do
		local poker_data = sanguo_config.card[v:getNum()]
		-- 1:相同人物 颜色 和 选色卡
		if not ( poker_data.index == cur_data.index or
		   poker_data.color == cur_data.color or
		   poker_data.index == 13 ) then
			graySprite( v._image:getVirtualRenderer():getSprite() )
		end
	end

	local can_out,out_poker = self:checkAIPlayerCanOut( self._pointer )
	if can_out then
		-- 等待玩家出牌
		-- nothing to do here !!
	else
		-- 再摸一张牌
		if not self._moAgain then
			-- 显示摸牌的提示
			self:createPlayerGetCard( function()
				self:sendOneCardAction( self._pointer )
				self._moAgain = true
				performWithDelay( dest_node,function()
					self:playerOutPoker()
				end,0.5 )
			end )
		else
			performWithDelay( dest_node,function()
				-- 恢复
				for i,v in ipairs( childs ) do
					ungraySprite( v._image:getVirtualRenderer():getSprite() )
				end
				-- 下一个人出牌
				self._moAgain = nil
				self:changePointer()
				self:showDirAndPointer()
				self:outPoker()
			end,0.5 )
		end
	end
end


function GamePlay:aiOrPlayerSelectOutPoker( poker )
	assert( poker," !! poker is nil!! " )

	local out_data = sanguo_config.card[poker:getNum()]
	local cur_data = sanguo_config.card[self._curOutPokerIndex]
	
	if not (out_data.index == 13 or out_data.color == cur_data.color or out_data.index == cur_data.index) then
		assert( false," !! error not match !! " )
	end

	-- 重置
	self._moAgain = nil
	local dest_node = self["NodeAI"..self._pointer]
	local out_poker = poker

	-- 执行出牌动作
	if self._pointer == 4 then
		if self._moveAction then
			return
		end
		self._moveAction = true
	else
		poker:showPoker()
	end

	local node_pos = dest_node:convertToNodeSpace( self._centerPos )
	local move_to = cc.MoveTo:create( 0.5,node_pos )
	local rote_to = cc.RotateTo:create( 0.5,random( -10,10) )
	local spawn = cc.Spawn:create({ move_to,rote_to })
	local call_out = cc.CallFunc:create( function()
		-- 重新放入
		out_poker:retain()
		out_poker:removeFromParent()
		self.NodeCenter:addChild( out_poker )
		local node_pos = self.NodeCenter:convertToNodeSpace( self._centerPos )
		out_poker:setPosition( node_pos )
		out_poker:release()

		-- 恢复
		if self._pointer == 4 then
			local childs = dest_node:getChildren()
			for i,v in ipairs( childs ) do
				ungraySprite( v._image:getVirtualRenderer():getSprite() )
			end
			-- 移除该卡牌的点击
			poker:removePokerClick()
			-- 移除选择的指针
			self:clearPlayerSecect()
		end

		-- 判断游戏是否结束
		local childs = dest_node:getChildren()
		if #childs == 0 then
			if self._pointer == 4 then
				self:gameOver( 2 )
			else
				self:gameOver( 1 )
			end
		else
			-- 手中的牌 重新设置位置
			self:aiHandPokerAction( self._pointer )
			local out_data = sanguo_config.card[out_poker:getNum()]
			if out_data.index == 11 then
				-- 重置
				if self._pointer == 4 then
					self._moveAction = nil
				end
				-- 1:判断出的是否不玉溪卡
				self._curOutPokerIndex = out_poker:getNum()
				self._yuxiMark = true
				self:changePointer()
				self:showDirAndPointer()
				self:outPoker()
			elseif out_data.index == 12 then
				-- 2:判断是否是转换卡
				local call_back = function()
					-- 重置
					if self._pointer == 4 then
						self._moveAction = nil
					end
					self._curOutPokerIndex = out_poker:getNum()
					self:changeDir()
					self:changePointer()
					self:showDirAndPointer()
					self:outPoker()
				end
				self:createTurnLayer( call_back )
			elseif out_data.index == 13 then
				-- 3:判断是否为选色卡
				local rote_to = cc.RotateTo:create( 0.2,0 )
				local move_by1 = cc.MoveBy:create( 0.5,cc.p( 0,50 ))
				local move_by2 = cc.MoveBy:create( 0.2,cc.p( 0,-50 ))
				local call_set = cc.CallFunc:create( function()
					if self._pointer ~= 4 then
						-- ai 随机选择一个颜色
						local color_num_index = 96 + random(1,4) * 2
						out_poker:loadDataUI( color_num_index )
						out_poker:showPoker()
						self._curOutPokerIndex = color_num_index
						self:changePointer()
						self:showDirAndPointer()
						self:outPoker()
					else
						-- 玩家 选择颜色
						addUIToScene( UIDefine.SANGUO_KEY.Select_UI,{ callBack = function( colorNumIndex )
							-- 重置
							if self._pointer == 4 then
								self._moveAction = nil
							end
							out_poker:loadDataUI( colorNumIndex )
							out_poker:showPoker()
							self._curOutPokerIndex = colorNumIndex
							self:changePointer()
							self:showDirAndPointer()
							self:outPoker()
						end } )
					end
				end )
				local seq = cc.Sequence:create({ rote_to,move_by1,move_by2,call_set })
				out_poker:runAction( seq )
			else
				-- 重置
				if self._pointer == 4 then
					self._moveAction = nil
				end
				self._curOutPokerIndex = out_poker:getNum()
				self:changePointer()
				self:showDirAndPointer()
				self:outPoker()
			end
		end
	end )
	out_poker:runAction( cc.Sequence:create({ spawn,call_out}) )
end

-- 检查玩家选择的牌能否出
function GamePlay:checkSelectPokerCanOut( poker )
	assert( poker," !! poker is nil !! " )
	if self._pointer ~= 4 then
		return false
	end
	local poker_data = sanguo_config.card[poker:getNum()]
	if poker_data.index == 13 then
		return true
	end
	local cur_data = sanguo_config.card[self._curOutPokerIndex]
	if  poker_data.index == cur_data.index or
		poker_data.color == cur_data.color then
		return true
    end
    return false
end

-- 检查玩家能否出牌
function GamePlay:checkAIPlayerCanOut( seatPos )
	assert( seatPos," !! seatPos is nil !! " )
	local dest_node = self["NodeAI"..seatPos]
	local cur_data = sanguo_config.card[self._curOutPokerIndex]
	local childs = dest_node:getChildren()
	for i,v in ipairs( childs ) do
		local poker_data = sanguo_config.card[v:getNum()]
		-- 1:相同人物
		if cur_data.index == poker_data.index then
			return true,v
		end
		-- 2:相同颜色
		if cur_data.color == poker_data.color then
			return true,v
		end
		-- 3:选色卡
		if poker_data.index == 13 then
			return true,v
		end
	end
	return false
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
end

-- 改变方向
function GamePlay:changeDir()
	if self._dir == 1 then
		self._dir = 2
	else
		self._dir = 1
	end
end

function GamePlay:showDirAndPointer()
	-- 重置
	for i = 1,4 do
		self["ImageDir"..i]:stopAllActions()
		self["ImageDir"..i]:setVisible( true )
		self["ImageDir"..i]:setRotation( 0 )
		self["ImageDir"..i]:loadTexture( "image/play/ni1.png",1 )
	end
	if self._dir == 1 then
		self["ImageDir1"]:setRotation( 90 )
		self["ImageDir2"]:setRotation( 180 )
		self["ImageDir3"]:setRotation( 270 )
		self["ImageDir4"]:setRotation( 360 )
		self["ImageDir"..self._pointer]:loadTexture( "image/play/ni2.png",1 )
	else
		self["ImageDir1"]:setRotation( 270 )
		self["ImageDir2"]:setRotation( 0 )
		self["ImageDir3"]:setRotation( 90 )
		self["ImageDir4"]:setRotation( 180 )
		local dir_index = self._pointer + 1
		if dir_index > 4 then
			dir_index = 1
		end
		self["ImageDir"..dir_index]:loadTexture( "image/play/ni2.png",1 )
	end
end

function GamePlay:createTurnLayer( callBack )
	local layer = cc.LayerColor:create( cc.c4b( 0,0,0,150 ) )
	self:addChild( layer,10 )
	local img = ccui.ImageView:create( "image/play/change.png",1 )
	self:addChild( img,20 )
	img:setPosition( display.cx,display.cy )
	local ratote_by = cc.RotateBy:create( 2,360 )
	local call = cc.CallFunc:create( function()
		layer:removeFromParent()
		if callBack then
			callBack()
		end
	end )
	local remove = cc.RemoveSelf:create()
	local seq = cc.Sequence:create({ ratote_by,call,remove })
	img:runAction( seq )
end

function GamePlay:createPlayerGetCard( callBack )
	local layer = cc.LayerColor:create( cc.c4b( 0,0,0,150 ) )
	self:addChild( layer,10 )
	local img = ccui.ImageView:create( "image/play/yun1.png",1 )
	self:addChild( img,20 )
	img:setPosition( display.cx,display.cy )
	local text = ccui.Text:create()
	text:setString("需要摸一张牌")
	text:setFontName("image/sanguo.ttf")
	text:setFontSize( 40 )
	text:setColor( cc.c3b(139,105,20) )
	self:addChild( text,21 )
	text:setPosition( display.cx,display.cy )

	img:setScale( 0.2 )
	text:setVisible( false )
	
	local scale_to1 = cc.ScaleTo:create( 0.2,1.2 )
	local scale_to2 = cc.ScaleTo:create( 0.1,1 )
	local delay_time1 = cc.DelayTime:create( 1 )
	local call_set = cc.CallFunc:create( function()
		text:setVisible( true )
	end )
	local delay_time2 = cc.DelayTime:create( 2 )
	local call_remove = cc.CallFunc:create( function()
		callBack()
		layer:removeFromParent()
		text:removeFromParent()
	end )
	local remove = cc.RemoveSelf:create()
	local seq = cc.Sequence:create({ scale_to1,scale_to2,delay_time,call_set,delay_time2,call_remove,remove })
	img:runAction( seq )
end

function GamePlay:gameOver( resultType )
	if resultType == 1 then
		-- ai 赢
		G_GetModel("Model_SanGuo"):setCoin( -10 )
		addUIToScene( UIDefine.SANGUO_KEY.Lose_UI )
	elseif resultType == 2 then
		-- 玩家赢
		G_GetModel("Model_SanGuo"):setCoin( 10 )
		addUIToScene( UIDefine.SANGUO_KEY.Win_UI )
	elseif resultType == 3 then
		-- 流局
		addUIToScene( UIDefine.SANGUO_KEY.LiuJu_UI )
	end
end

function GamePlay:setPlayerSecect( poker )
	assert( poker," !! poker is nil !! ")
	self._playerSelectPoker = poker
end

function GamePlay:getPlayerSecect()
	return self._playerSelectPoker
end

function GamePlay:clearPlayerSecect()
	self._playerSelectPoker = nil
end

function GamePlay:close()
	removeUIFromScene( UIDefine.SANGUO_KEY.Play_UI )
    addUIToScene( UIDefine.SANGUO_KEY.Start_UI )
end


return GamePlay