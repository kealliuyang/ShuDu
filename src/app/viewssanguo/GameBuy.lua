

local GameBuy = class( "GameBuy",BaseLayer )

GameBuy.Copper = {
	100,200,300
}

GameBuy.RMB = {
	6,12,18
}


function GameBuy:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
	GameBuy.super.ctor( self,param.name )

	self._param = param
	self._index = param.data._index
	self._NodeLayer = param.data.layer

	local layer = cc.LayerColor:create(cc.c4b(0,0,0,150))
    self:addChild( layer )
    self._layer = layer

	self:addCsb( "csbsanguo/Buy.csb" )
	self:addNodeClick( self.ButtonClose,{
		endCallBack = function ()
			self:close()			
		end
	})
	self:addNodeClick( self.ButtonNo,{
		endCallBack = function ()
			self:close()			
		end
	})
	self:addNodeClick( self.ButtonYes,{
		endCallBack = function ()
			self:buy()			
		end
	})
end

function GameBuy:onEnter()
	GameBuy.super.onEnter( self )
	casecadeFadeInNode( self.Bg,0.5 )
	casecadeFadeInNode( self._layer,0.5,150 )

	self.TextBuy:setString( "是否花费"..GameBuy.RMB[self._index].."购买"..GameBuy.Copper[self._index].."铜币" )
end

function GameBuy:buy()
	-- 调用sdk

	-- 这里用于测试 请在调用完sdk后 回调 buyCoinCallBack
	self:buyCoinCallBack()
end
function GameBuy:buyCoinCallBack()
	local add_coin = self.Copper[self._index]
	G_GetModel("Model_SanGuo"):setCoin( add_coin )
	self._NodeLayer:loadCoin()
	self:close()
end

function GameBuy:close()
	removeUIFromScene( UIDefine.SANGUO_KEY.Buy_UI)
end



return GameBuy