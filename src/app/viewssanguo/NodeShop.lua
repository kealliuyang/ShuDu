
-- local NodeShop = class( "NodeShop",BaseLayer )-----用这个不能关闭？？？BaseNode有的方法BaseLayer不是都有吗?29,30行，运行就能看到，关闭被挡住了。
local NodeShop = class( "NodeShop",BaseNode )


NodeShop.ICON = {------------------------为什么不能用self.ICON?????self定义必须在方法里面定义，不然lua不认识。
	"image/shop/100jinbi.png",
	"image/shop/200jinbi.png",
	"image/shop/300jinbi.png",
}

NodeShop.Copper = {
	100,200,300
}

NodeShop.RMB = {
	6,12,18
}





function NodeShop:ctor( parentPanel,index )
	self._parentPanel = parentPanel
	NodeShop.super.ctor( self,"NodeShop")
	self:addCsb( "res/csbsanguo/NodeShop.csb" )

	self._startLayer = parentPanel._startLayer

	-- local layer = cc.LayerColor:create( cc.c4b( 255,0,0,150 ) )
	-- self:addChild( layer )

	self:loadDataUi( index )
	--------------------------------------------------TouchNode.extends系统提供？封装的，直接用，在framework里面
	TouchNode.extends( self.Bg,function ( event )------function这个在这里为什么这样用，表示参数是方法同时还返回其他方法？的原因？必须这么写
		return self:touchCard( event )
		-- body
	end)
end

function NodeShop:loadDataUi( index )
	assert( index," !! index is nil !! " )
	self._index = index
	self.ImageCoin:loadTexture( self.ICON[index],1 )
	self.TextCopper:setString( self.Copper[index] )
	self.TextRmb:setString( self.RMB[index] )
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
	-- addUIToScene( UIDefine.SANGUO_KEY.Buy_UI,self._index )---没有传指针时候正确的
	addUIToScene( UIDefine.SANGUO_KEY.Buy_UI,{ _index = self._index , layer = self._startLayer } )
end



return NodeShop