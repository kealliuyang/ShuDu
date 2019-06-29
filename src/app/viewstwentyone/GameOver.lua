
local GameOver = class("GameOver",BaseLayer)

function GameOver:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameOver.super.ctor( self,param.name )

    self._param = param

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer )
    self._layer = layer

    self:addCsb( "csbtwentyone/Over.csb" )

    -- 关闭
    self:addNodeClick( self.ButtonNo,{ 
        endCallBack = function() self:close() end
    })

    -- 继续
    self:addNodeClick( self.ButtonYes,{ 
        endCallBack = function() self:continue() end
    })

    self.TextScore:setString( self._param.data.score )
end


function GameOver:onEnter()
    GameOver.super.onEnter( self )
    casecadeFadeInNode( self.Bg,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
end

function GameOver:continue()
    removeUIFromScene( UIDefine.TWENTYONE_KEY.Over_UI )
    removeUIFromScene( UIDefine.TWENTYONE_KEY.Play_UI )
    addUIToScene( UIDefine.TWENTYONE_KEY.Play_UI )
end

-- 关闭
function GameOver:close()
    removeUIFromScene( UIDefine.TWENTYONE_KEY.Over_UI )
    removeUIFromScene( UIDefine.TWENTYONE_KEY.Play_UI )
    addUIToScene( UIDefine.TWENTYONE_KEY.Start_UI )
end




return GameOver