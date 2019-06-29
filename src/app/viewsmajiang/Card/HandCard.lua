

local HandCard = class("HandCard",BaseNode)


--[[
	mode: 1->自己的手牌 2->机器人的手牌
]]
function HandCard:ctor( mode,num,gameLayer )
	assert( mode," !! mode is nil !! ")
	assert( num," !! num is nil !! ")
	assert( gameLayer, " !! gameLayer is nil !! ")
	HandCard.super.ctor( self,"HandCard" )
	self:addCsb( "csbmajiang/Card1.csb" )

	self._mode = mode
	self._num = num
	self._gameLayer = gameLayer
	assert( self._gameLayer._playerNode," !! self._gameLayer._playerNode is nil !! ")
	self._playerNode = self._gameLayer._playerNode

	self:clearUiState()
	if mode == 1 then
		self.BgMy:setVisible( true )
		self.CardNum:setVisible( true )
		self.CardNum:loadTexture(mj_hand_path_config[num],1)
	else
		if AI_MING_PAI then
			self.BgMy:setVisible( true )
			self.CardNum:setVisible( true )
			self.CardNum:loadTexture(mj_hand_path_config[num],1)
		else
			self.BgOther:setVisible( true )
		end
	end

	-- 添加触摸
	if mode == 1 then
		TouchNode.extends( self.BgMy, function(event)
			-- audio.playSound("mjmp3/btn.mp3", false)
			return self:touchCard( event ) 
		end,true )
	end

	self._orgLocalZOrder = self:getLocalZOrder()
end

function HandCard:getPlayerCardSize()
	local size = self.BgMy:getContentSize()
	size.width = size.width - 10
	return size
end
function HandCard:getAICardSize()
	local size = self.BgMy:getContentSize()
	size.width = size.width - 10
	return size
end

function HandCard:getNum()
	return self._num
end

function HandCard:getAiCardSize()
	return self.BgOther:getContentSize()
end

function HandCard:touchCard( event )
	if self._mode ~= 1 then
		return
	end

	if not self:canOutHandCard() then
		return
	end

	if self._gameLayer._gameOver then
		return
	end

	if event.name == "began" then
		self._beganPos = cc.p(event.x,event.y)
		self._startPos = cc.p(event.x,event.y)
		self:setLocalZOrder(10000)

		self._touchMark = true
		-- 取消之前的选中
		if self._playerNode._selectHandNode and self._playerNode._selectHandNode ~= self then
			self:cancelSelectNode()
		end

        return true
    elseif event.name == "moved" then
		local now_pos = cc.p(event.x,event.y)
		local dis_x = now_pos.x - self._startPos.x
		local dis_y = now_pos.y - self._startPos.y
		local my_pos = cc.p(self:getPosition())
		self:setPositionX( my_pos.x + dis_x )
		self:setPositionY( my_pos.y + dis_y )
		self._startPos = cc.p(event.x,event.y)
    elseif event.name == "ended" then
    	-- if self._moveMark then
    	-- 	local now_pos = cc.p(event.x,event.y)
    	-- 	if now_pos.y - self._beganPos.y > 50 then
	    -- 		-- 出牌
	    -- 		self:select()
	    -- 		local delay = cc.DelayTime:create(0.2)
	    -- 		local call = cc.CallFunc:create( function()
	    -- 			self._gameLayer:outCard()
	    -- 		end )
	    -- 		local seq = cc.Sequence:create({ delay,call })
	    -- 		self:runAction( seq )

	    -- 		-- -- 出牌
	    -- 		-- self:select()
	    -- 		-- self._gameLayer:outCard()
	    -- 	else
	    -- 		-- 回到原位
	    -- 		self:setLocalZOrder( self._orgLocalZOrder )
	    -- 		local move_to = cc.MoveTo:create(0.1,self._orgPos)
	    -- 		self:runAction(move_to)
	    -- 	end
	    -- 	self._moveMark = nil
    	-- else
    	-- 	self:select()
    	-- end
    	-- self:select()

    	local now_pos = cc.p(event.x,event.y)
    	if now_pos.y - self._beganPos.y > 50 then
    		-- 直接出牌
    		self._playerNode._selectHandNode = self
    		self._gameLayer:outCard()
    	else
    		-- 选中该牌
    		if self._playerNode._selectHandNode == nil then
    			self:selectNode()
    		else
    			-- 直接出牌
    			self:outCardNode()
    		end
    	end
    	self._touchMark = nil
    elseif event.name == "outsideend" then
    	if not self._touchMark then
    		return
    	end
    	-- 直接出牌
    	self:outCardNode()
    	self._touchMark = nil

		-- -- 出牌
		-- if self._moveMark then
		-- 	self._moveMark = nil
		-- 	self:select()
		-- 	local delay = cc.DelayTime:create(0.2)
		-- 	local call = cc.CallFunc:create( function()
		-- 		self._gameLayer:outCard()
		-- 	end )
		-- 	local seq = cc.Sequence:create({ delay,call })
		-- 	self:runAction( seq )
		-- end
    end
end

-- 是否可以出牌
function HandCard:canOutHandCard()
	return self._gameLayer._playerNode._canOutHandCard
end
-- 选中
function HandCard:select()
	-- self._gameLayer._playerNode:touchHandNode( self )
end








-- 取消已经选中的handnode
function HandCard:cancelSelectNode()
	if self._playerNode._selectHandNode then
		local handNode = self._playerNode._selectHandNode
		local orgPos = handNode:getOrgPosition()
		self._playerNode._selectHandNode = nil
		-- self._playerNode._selectHandNode:setPositionY( self._orgPos.y )
		local move_to = cc.MoveTo:create(0.1,orgPos)
		handNode:runAction( move_to )
	end
end
-- 选中该牌
function HandCard:selectNode()
	self._playerNode._selectHandNode = self
	-- self:setPositionY( self._orgPos.y + 20 )
	local move_to = cc.MoveTo:create(0.1,cc.p( self._orgPos.x,self._orgPos.y + 20))
	self._playerNode._selectHandNode:runAction( move_to )
end
-- 出牌
function HandCard:outCardNode()
	self:stopAllActions()
	self._playerNode._selectHandNode = self
    self._gameLayer:outCard()
end















function HandCard:setOrgPosition( position )
	assert( position," !! position is nil !! " )
	self._orgPos = position
end

function HandCard:getOrgPosition()
	return self._orgPos
end

function HandCard:clearUiState()
	self.BgMy:setVisible( false )
	self.CardNum:setVisible( false )
	self.BgOther:setVisible( false )
	self.BgMask:setVisible( false )
end


return HandCard