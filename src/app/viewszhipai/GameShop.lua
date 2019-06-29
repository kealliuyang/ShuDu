

local NodeShop = import(".NodeShop")
local GameShop = class( "GameShop",BaseLayer )


function GameShop:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameShop.super.ctor( self,param.name )

	local layer = cc.LayerColor:create(cc.c4b(0,0,0,150))
	self:addChild(layer)
	self._layer = layer

	self:addCsb( "csbzhipai/Shop.csb" )

	self:addNodeClick( self.ImageShopClose,{
		endCallBack = function ()
			self:close()			
		end
	})

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
	casecadeFadeInNode( self.ImageShopBg,0.5 )
	casecadeFadeInNode( self._layer,0.5,150 )
end


function GameShop:close()
	removeUIFromScene( UIDefine.ZHIPAI_KEY.Shop_UI)
end


return GameShop