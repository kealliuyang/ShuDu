

local NodeCard = class( "NodeCard",BaseNode )





function NodeCard:ctor( parentPanel,size )
	self._parentPanel = parentPanel
	NodeCard.super.ctor( self,"NodeCard" )
	self._image = ccui.ImageView:create( "image/poker/bei.png",1 )
	self:addChild( self._image )
	self._image:setPosition( size.width / 2,size.height / 2 )
end



function NodeCard:loadDataUI( numIndex )
	assert( numIndex," !! numIndex is nil !! ")
	self._numIndex = numIndex

	if self._numIndex == 0 then
		self._cardNum = { 0 }
		self._image:loadTexture( "image/poker/bei.png",1 )
	else
		self._cardNum = zhipai_config.num_config[numIndex]
		local path = zhipai_config.poker_config[numIndex]
		self._image:loadTexture( path,1 )
	end
end



function NodeCard:getCardNum()
	return self._cardNum
end


function NodeCard:getNumIndex()
	return self._numIndex
end





return NodeCard