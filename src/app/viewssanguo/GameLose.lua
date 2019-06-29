
local GameLose = class("GameLose",BaseLayer)

function GameLose:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameLose.super.ctor( self,param.name )

    self._param = param

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer )
    self._layer = layer

    self:addCsb( "csbsanguo/Loser.csb" )

    -- 关闭
    self:addNodeClick( self.ButtonReturn,{ 
        endCallBack = function() self:close() end
    })
    -- 再来一局
    self:addNodeClick( self.ButtonGoOn,{ 
        endCallBack = function() self:again() end
    })
end


function GameLose:onEnter()
    GameLose.super.onEnter( self )

    casecadeFadeInNode( self._csbNode,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))

    if G_GetModel("Model_Sound"):isVoiceOpen() then
        audio.playSound("sgmp3/lost.mp3", false)
    end
end





function GameLose:again()
    local coin = G_GetModel("Model_SanGuo"):getInstance():getCoin()
    if coin < 10 then
        removeUIFromScene( UIDefine.SANGUO_KEY.Lose_UI )
        removeUIFromScene( UIDefine.SANGUO_KEY.Play_UI )
        addUIToScene( UIDefine.SANGUO_KEY.Start_UI )
    else
        removeUIFromScene( UIDefine.SANGUO_KEY.Lose_UI )
        removeUIFromScene( UIDefine.SANGUO_KEY.Play_UI )
        addUIToScene( UIDefine.SANGUO_KEY.Play_UI )
    end
    -- removeUIFromScene( UIDefine.SANGUO_KEY.Lose_UI )
    -- removeUIFromScene( UIDefine.SANGUO_KEY.Play_UI )
    -- addUIToScene( UIDefine.SANGUO_KEY.Play_UI )
end

-- 关闭
function GameLose:close()
    removeUIFromScene( UIDefine.SANGUO_KEY.Lose_UI )
    removeUIFromScene( UIDefine.SANGUO_KEY.Play_UI )
    addUIToScene( UIDefine.SANGUO_KEY.Start_UI )
end



return GameLose