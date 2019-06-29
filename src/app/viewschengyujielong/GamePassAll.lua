



local GamePassAll = class("GamePassAll",BaseLayer)


function GamePassAll:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer )
    self._layer = layer


    GamePassAll.super.ctor( self,param.name )
    self:addCsb( "csbchengyujielong/GamePassAll.csb" )

    self:addNodeClick( self.ButtonReStart,{ 
        endCallBack = function() self:reStart() end
    })

    self:loadUiData()
end


function GamePassAll:onEnter()
    GamePassAll.super.onEnter( self )
    casecadeFadeInNode( self._csbNode,0.5 )

    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
end

function GamePassAll:loadUiData()
end

function GamePassAll:reStart()
	G_GetModel("Model_ChengYuJieLong"):clearData()
	removeUIFromScene( UIDefine.CHENGYUJIELONG_KEY.PassAll_UI )
	removeUIFromScene( UIDefine.CHENGYUJIELONG_KEY.Play_UI )
	addUIToScene( UIDefine.CHENGYUJIELONG_KEY.Start_UI )
end




return GamePassAll