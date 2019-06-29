

local NodePoker = class( "NodePoker",BaseNode )




function NodePoker:ctor( parentPanel,beiIndex )
	self._parentPanel = parentPanel
	NodePoker.super.ctor( self,"NodePoker" )
	local path = sanguo_config.bei_card[beiIndex]
	self._image = ccui.ImageView:create( path,1 )
	self:addChild( self._image )

	local content_size = self._image:getContentSize()
	self:setContentSize( content_size )
	self:setAnchorPoint( cc.p( 0.5,0 ))
	self._image:setPosition( cc.p( content_size.width / 2,content_size.height / 2 ) )

	self._image:setScale( 0.8 )
end



function NodePoker:loadDataUI( numIndex )
	assert( numIndex," !! numIndex is nil !! " )
	self._numIndex = numIndex
end

function NodePoker:showPoker()
	local path = sanguo_config.card[self._numIndex].path
	self._image:loadTexture( path,1 )
end


function NodePoker:addPokerClick()
	G_AddNodeClick( self._image,{
		endedCallBack = function() self:playerOut() end,
		cancelCallBack = function() self:playerCancel() end
	})
end

function NodePoker:removePokerClick()
	self._image:setTouchEnabled( false )
end

function NodePoker:playerOut()
	local can_out = self._parentPanel:checkSelectPokerCanOut( self )
	if not can_out then
		return
	end
	if self._parentPanel._moveAction then
		return
	end

	-- 播放音效
	if G_GetModel("Model_Sound"):isVoiceOpen() then
		audio.playSound("sgmp3/button.mp3", false)
	end

	local select_poker = self._parentPanel:getPlayerSecect()
	if select_poker then
		if self == select_poker then
			-- 出牌
			self._parentPanel:aiOrPlayerSelectOutPoker( self )
		else
			self._parentPanel._moveAction = true
			local move_by = cc.MoveBy:create( 0.2,cc.p( 0,-20 ) )
			select_poker:runAction( move_by )
			local move_by = cc.MoveBy:create( 0.2,cc.p( 0,20 ) )
			local call_set = cc.CallFunc:create( function()
				self._parentPanel._moveAction = nil
			end )
			self:runAction( cc.Sequence:create({ move_by,call_set }) )
			self._parentPanel:setPlayerSecect( self )
		end
	else
		self._parentPanel._moveAction = true
		self._parentPanel:setPlayerSecect( self )
		local move_by = cc.MoveBy:create( 0.2,cc.p( 0,20 ) )
		local call_set = cc.CallFunc:create( function()
			self._parentPanel._moveAction = nil
		end )
		self:runAction( cc.Sequence:create({ move_by,call_set }) )
	end
end

function NodePoker:playerCancel()
	local select_poker = self._parentPanel:getPlayerSecect()
	if select_poker then
		local move_by = cc.MoveBy:create( 0.2,cc.p( 0,-20 ) )
		select_poker:runAction( move_by )
		self._parentPanel:clearPlayerSecect()
	end
end


function NodePoker:getNum()
	return self._numIndex
end












return NodePoker