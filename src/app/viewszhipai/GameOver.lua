
local GameOver = class("GameOver",BaseLayer)

function GameOver:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameOver.super.ctor( self,param.name )

    self._param = param

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer )
    self._layer = layer

    self:addCsb( "csbzhipai/Over.csb" )

    -- 关闭
    self:addNodeClick( self.ButtonOk,{ 
        endCallBack = function() self:close() end
    })

    self.TextScore:setString( self._param.data.score )
end


function GameOver:onEnter()
    GameOver.super.onEnter( self )
    casecadeFadeInNode( self.ImageOverBg,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
end


-- 关闭
function GameOver:close()
    removeUIFromScene( UIDefine.ZHIPAI_KEY.Over_UI )
    removeUIFromScene( UIDefine.ZHIPAI_KEY.Play_UI )
    addUIToScene( UIDefine.ZHIPAI_KEY.Start_UI )
end




return GameOver