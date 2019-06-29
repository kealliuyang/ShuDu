
local NodeShop = import( "app.viewszhandou.NodeShop" )
local GameShop = class( "GameShop",BaseLayer )


function GameShop:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameShop.super.ctor( self,param.name )

    self._start = param.data.layer

    local layer = cc.LayerColor:create( cc.c4b(0,0,0,150))
    self:addChild( layer )
    self._layer = layer


    self:addCsb( "csbzhandou/Shop.csb" )

    -- local coin = {
    -- 	"image/shop/30jb.png",
    -- 	"image/shop/60jb.png",
    -- 	"image/shop/100jb.png"
    -- }
    self:addNodeClick(self.ButtonClose,{
    	endCallBack = function ()
    		self:close()
    	end
    })

    -- for i=1,3 do
    	
    -- end

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
	casecadeFadeInNode( self._layer,0.5,150 )
	casecadeFadeInNode( self.Bg,0.5 )
end

function GameShop:close()
	removeUIFromScene( UIDefine.ZHANDOU_KEY.Shop_UI )
end

return GameShop