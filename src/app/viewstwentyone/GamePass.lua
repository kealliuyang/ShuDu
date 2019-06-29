
local GamePass = class("GamePass",BaseLayer)

function GamePass:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePass.super.ctor( self,param.name )

    self._param = param

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer )
    self._layer = layer

    self:addCsb( "csbtwentyone/Pass.csb" )

    -- 关闭
    self:addNodeClick( self.ButtonBack,{ 
        endCallBack = function() self:close() end
    })

    self.TextScore:setString( self._param.data.score )
end


function GamePass:onEnter()
    GamePass.super.onEnter( self )
    casecadeFadeInNode( self.Bg,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
end

-- 关闭
function GamePass:close()
    removeUIFromScene( UIDefine.TWENTYONE_KEY.Pass_UI )
    removeUIFromScene( UIDefine.TWENTYONE_KEY.Play_UI )
    addUIToScene( UIDefine.TWENTYONE_KEY.Start_UI )
end




return GamePass