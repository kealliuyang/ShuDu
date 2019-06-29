

local NodePoker = class( "NodePoker",BaseNode )


function NodePoker:ctor( parentPanel,numIndex )
	assert( parentPanel," !! parentPanel is nil !! " )
	assert( numIndex," !! numIndex is nil !! " )
	NodePoker.super.ctor( self,"NodePoker" )

	self._parentPanel = parentPanel
	self._numIndex = numIndex
	self._numCard = zhandou_config.num_config[self._numIndex]

	local path = zhandou_config.bei_card
	self._imageBack = ccui.ImageView:create( path,1 )
	self:addChild( self._imageBack )

	local content_size = self._imageBack:getContentSize()
	self:setContentSize( content_size )
	self._imageBack:setPosition( cc.p( content_size.width / 2,content_size.height / 2 ) )

	local path = zhandou_config.poker_config[self._numIndex]
	self._imageFont = ccui.ImageView:create( path,1 )
	self:addChild( self._imageFont )
	self._imageFont:setPosition( cc.p( content_size.width / 2,content_size.height / 2 ) )
	self._imageFont:setVisible( false )
end

-- function NodePoker:loadDataUI( numIndex )
-- 	assert( numIndex," !! numIndex is nil !! " )
-- 	self._numIndex = numIndex
-- 	self._numCard = zhandou_config.num_config[self._numIndex]
-- end

function NodePoker:showPoker()
	self._imageFont:setVisible( true )
	self._imageBack:setVisible( false )
end

function NodePoker:getNum()
	return self._numCard
end

function NodePoker:getIndex()
	return self._numIndex
end

function NodePoker:showObtAniUseScaleTo()
	self._imageFont:getVirtualRenderer():getSprite():setFlipX(true)
	local pBackSeq = cc.Sequence:create({cc.DelayTime:create(0.1),cc.Hide:create(),cc.DelayTime:create(0.1),cc.Hide:create()})
	local pScaleBack = cc.ScaleTo:create(0.2,-1,1)
	local pSpawnBack = cc.Spawn:create({ pBackSeq,pScaleBack })
	self._imageBack:runAction(pSpawnBack)
	local pFrontSeq = cc.Sequence:create({cc.DelayTime:create(0.1),cc.Show:create(),cc.DelayTime:create(0.1),cc.Show:create()})
	local pScaleFront = cc.ScaleTo:create(0.2,-1,1)
	local pSpawnFront = cc.Spawn:create({ pFrontSeq,pScaleFront })
	self._imageFont:runAction(pSpawnFront)
end


function NodePoker:addPokerClick()
	self._toListener = TouchNode.extends( self._imageFont, function(event)
		return self:touchCard( event ) 
	end,true )
end

function NodePoker:removePokerClick()
	if self._toListener then
		local dispater = cc.Director:getInstance():getEventDispatcher()
		dispater:removeEventListener( self._toListener )
		self._toListener = nil
	end
end

function NodePoker:touchCard( event )
	if not self._parentPanel._canPlayGame then
		return
	end

	if self._moveActionMark then
		return
	end

	if event.name == "began" then
		self._startPos = cc.p(event.x,event.y)
		self:getParent():setLocalZOrder( 100 )
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
		self:putCard()
	elseif event.name == "outsideend" then
		self:putCard()
	end
end

function NodePoker:putCard()
	local can_put = self._parentPanel:playerOutCard( self )
	if not can_put then
		-- 回到原位
		self._moveActionMark = true
		local move_to = cc.MoveTo:create( 0.5,cc.p(0,0) )
		local call_set = cc.CallFunc:create( function()
			self:getParent():setLocalZOrder( 0 )
			self._moveActionMark = nil
		end )
		self:runAction( cc.Sequence:create({ move_to,call_set }) )
	end
end

return NodePoker