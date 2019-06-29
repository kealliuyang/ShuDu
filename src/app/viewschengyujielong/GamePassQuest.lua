

local GamePassQuest = class("GamePassQuest",BaseLayer)


function GamePassQuest:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePassQuest.super.ctor( self,param.name )

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer )
    self._layer = layer


    self._param = param
    self:addCsb( "csbchengyujielong/GamePassQuest.csb" )

    self:addNodeClick( self.ButtonNextLevel,{ 
        endCallBack = function() self:next() end
    })

    self:loadUiData()
end

function GamePassQuest:onEnter()
    GamePassQuest.super.onEnter( self )
    casecadeFadeInNode( self._csbNode,0.5 )

    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
end


function GamePassQuest:loadUiData()
	self.TextChengYuScore:setString( self._param.data.chengyu_score )
	self.TextTimeScore:setString( self._param.data.time_score )
	self.TextTotalScore:setString( self._param.data.score )
end



function GamePassQuest:next()
	G_GetModel("Model_ChengYuJieLong"):setLevel()
	self._param.data.parent:resetLoadUiData()
	removeUIFromScene( UIDefine.CHENGYUJIELONG_KEY.PassQuest_UI )
end






return GamePassQuest