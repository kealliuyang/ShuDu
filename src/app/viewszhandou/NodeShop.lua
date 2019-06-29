
-- -- local NodeShop = class( "NodeShop",BaseLayer )-----用这个不能关闭？？？BaseNode有的方法BaseLayer不是都有吗?29,30行，运行就能看到，关闭被挡住了。
-- local NodeShop = class( "NodeShop",BaseNode )


-- NodeShop.coin = {
-- 	"image/shop/30jb.png",
-- 	"image/shop/60jb.png",
-- 	"image/shop/100jb.png"
-- }
-- NodeShop.gold = {
-- 	30,60,100
-- }
-- NodeShop.dollar = {
-- 	1,2,3
-- }





-- function NodeShop:ctor( parentPanel,index )
-- 	self._parentPanel = parentPanel
-- 	NodeShop.super.ctor( self,"NodeShop")
-- 	self:addCsb( "res/csbzhandou/NodeShop.csb" )

-- 	self._startLayer = parentPanel._startLayer

-- 	-- local layer = cc.LayerColor:create( cc.c4b( 255,0,0,150 ) )
-- 	-- self:addChild( layer )

-- 	self:loadDataUi( index )
-- 	--------------------------------------------------TouchNode.extends系统提供？封装的，直接用，在framework里面
-- 	TouchNode.extends( self.Bg,function ( event )------function这个在这里为什么这样用，表示参数是方法同时还返回其他方法？的原因？必须这么写
-- 		return self:touchCard( event )
-- 		-- body
-- 	end)
-- end

-- function NodeShop:loadDataUi( index )
-- 	assert( index," !! index is nil !! " )
-- 	self._index = index
-- 	self.ImageCoin:loadTexture( self.coin[index],1 )
-- 	self.TextGold:setString( self.gold[index] )
-- 	self.TextDollar:setString( self.dollar[index] )
-- end

-- function NodeShop:touchCard( event )
-- 	if event.name == "began" then
-- 		return true
-- 	elseif event.name == "moved" then

-- 	elseif event.name == "ended" then
-- 		self:buyCoin()
-- 	elseif event.name == "outsideend" then
-- 	end
-- end

-- function NodeShop:buyCoin()
-- 	-- addUIToScene( UIDefine.SANGUO_KEY.Buy_UI,self._index )---没有传指针时候正确的
-- 	addUIToScene( UIDefine.ZHANDOU_KEY.Buy_UI,{ _index = self._index , layer = self._startLayer } )
-- end



-- return NodeShop

























local NodeShop = class( "NodeShop",BaseNode )

NodeShop.coin = {
	"image/shop/30jb.png",
	"image/shop/60jb.png",
	"image/shop/100jb.png"
}
NodeShop.gold = {
	30,60,100
}
NodeShop.dollar = {
	"1$","2$","3$"
}

function NodeShop:ctor( parentPanel,index )

	self._start = parentPanel._start
	self._index = index
	
	NodeShop.super.ctor( self,"NodeShop")
	self:addCsb( "csbzhandou/NodeShop.csb" )

	self.TextGold:setString( self.gold[index] )
	self.ImageCoin:loadTexture( self.coin[index],1 )
	self.TextDollar:setString( self.dollar[index] )

	TouchNode.extends( self.Bg,function ( event )
		return self:touchCard( event )
	end)

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
	addUIToScene( UIDefine.ZHANDOU_KEY.Buy_UI,{_start = self._start,_index = self._index} )
end

return NodeShop