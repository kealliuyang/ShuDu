

local NodeShop = class( "NodeShop",BaseNode )

NodeShop.ICON = {
	"image/shop/30jinbi.png",
	"image/shop/60jinbi.png",
	"image/shop/100jinbi.png"
}

-- NodeShop.TITLE = {
-- 	"image/shop/goumaidb.png"
-- }

NodeShop.COIN = {
	30,
	60,
	100
}

NodeShop.QIAN = {
	6,
	12,
	18
}


function NodeShop:ctor( parentPanel,index )
	self._parentPanel = parentPanel
	NodeShop.super.ctor( self,"NodeShop" )
	self:addCsb( "csbzhipai/NodeShop.csb")

	self:loadDataUi( index )

	TouchNode.extends( self.ImageBg,function (event)
		return self:touchCard( event )
	end)
end

function NodeShop:loadDataUi( index )
	assert( index," !! index is nil !! " )
	self._index = index
	self.ImageCoin:loadTexture( NodeShop.ICON[index],1)
	self.TextCoin:setString( NodeShop.COIN[index] )
	self.TextPrice:setString( NodeShop.QIAN[index].."$")
end

function NodeShop:touchCard( event )
	if event.name == "began" then
		return true
	elseif event.name == "moved" then

	elseif event.name == "ended" then 
		self:buyCoin()
	elseif event.name == "outsideend" then
	end
end

function NodeShop:buyCoin()
	addUIToScene( UIDefine.ZHIPAI_KEY.Buy_UI,self._index )
end





return NodeShop