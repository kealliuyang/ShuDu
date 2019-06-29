

local GameBuy = class("GameBuy",BaseLayer)

GameBuy.COIN = {
	30,
	60,
	100
}

GameBuy.QIAN = {
	6,
	12,
	18
}

function GameBuy:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
	GameBuy.super.ctor( self,param.name )

	self._param = param
	self._index = param.data

	local layer = cc.LayerColor:create(cc.c4b(0,0,0,150))
	self:addChild(layer)
	self._layer = layer

	self:addCsb("csbzhipai/Buy.csb")

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
	casecadeFadeInNode( self.ImageBg,0.5)
	
	self.TextBuy1:setString("是否花费"..self.QIAN[self._index].."元购买")
	self.TextBuy2:setString(self.COIN[self._index].."金币")
end

function GameBuy:buy()
    -- 调用sdk

    -- 这里是用于测试 请在调用完sdk后 回调 buyCoinCallBack 
    self:buyCoinCallBack()
end

function GameBuy:buyCoinCallBack()
	local add_coin = self.COIN[ self._index ]
	G_GetModel("Model_ZhiPai"):setCoin( add_coin )
	self:close()
end

function GameBuy:close()
	removeUIFromScene( UIDefine.ZHIPAI_KEY.Buy_UI)
end

return GameBuy