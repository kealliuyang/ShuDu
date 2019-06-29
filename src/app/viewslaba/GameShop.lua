
local NodeShop = import( ".NodeShop" )						--引用.NodeShop
local GameShop = class( "GameShop",BaseLayer )


function GameShop:ctor( param )
	assert( param," !! param is nil !! ")
	assert( param.name," !! param.name is nil !! " )
	GameShop.super.ctor( self,param.name )

	local layer = cc.LayerColor:create( cc.c4b( 0,0,0,200 ))
	self:addChild( layer )
	self._layer = layer

	self:addCsb( "csblaba/Shop.csb" )

	self:addNodeClick( self.ButtonClose,{
		endCallBack = function() self:close() end
	})
	-- body
	self:loadUi()
end

function GameShop:loadUi()
	for i=1,3 do
		local node = NodeShop.new( self,i )
		self["Panel"..i]:addChild( node )
	end
end




function GameShop:onEnter()
	GameShop.super.onEnter( self )
	casecadeFadeInNode( self.ImageShopbg,0.5)
	casecadeFadeInNode( self._layer,0.5,200 )
end




function GameShop:close()
	removeUIFromScene( UIDefine.LABA_KEY.Shop_UI )
	-- body
end


return GameShop