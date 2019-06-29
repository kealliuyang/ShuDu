

local GameBuy = class( "GameBuy",BaseLayer )

GameBuy.gold = {
	30,60,100
}
GameBuy.dollar = {
	1,2,3
}


function GameBuy:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameBuy.super.ctor( self,param.name )

    -- self._param = param
    -- self._index = param.data._index
    self._start = param.data._start
    self._index = param.data._index

    local layer = cc.LayerColor:create( cc.c4b(0,0,0,150))
    self:addChild( layer )
    self._layer = layer

    self:addCsb( "csbzhandou/Buy.csb" )

    self:addNodeClick( self.ButtonClose,{
    	endCallBack = function ()
    		self:close()
    	end
    })
    self:addNodeClick( self.ButtonYes,{
    	endCallBack = function ()
    		self:yes()
    	end
    })
    self:addNodeClick( self.ButtonNo,{
    	endCallBack = function ()
    		self:close()
    	end
    })
end

function GameBuy:close()
	removeUIFromScene( UIDefine.ZHANDOU_KEY.Buy_UI )
end

function GameBuy:yes()
	-- 调用sdk

	-- 这里用于测试 请在调用完sdk后 回调 buyCoinCallBack
	self:buyCoinCallBack()
end
function GameBuy:buyCoinCallBack()
	local addCoin = self.gold[self._index]
	G_GetModel("Model_ZhanDou"):setCoin( addCoin )
	self._start:loadCoin()
	self:close()
end

return GameBuy