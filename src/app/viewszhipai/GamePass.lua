

local GamePass = class("GamePass",BaseLayer)




function GamePass:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePass.super.ctor( self,param.name )

    self._param = param
    self._nextLevel = param.data.level

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer )
    self._layer = layer

    self:addCsb( "csbzhipai/Pass.csb" )

    -- 关闭
    self:addNodeClick( self.ButtonNextLevel,{ 
        endCallBack = function() self:close() end
    })
end


function GamePass:onEnter()
    GamePass.super.onEnter( self )
    casecadeFadeInNode( self.ImagePassBg,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
end

-- 关闭
function GamePass:close()
    local next_level = self._nextLevel
    removeUIFromScene( UIDefine.ZHIPAI_KEY.Pass_UI )
    removeUIFromScene( UIDefine.ZHIPAI_KEY.Play_UI )
    addUIToScene( UIDefine.ZHIPAI_KEY.Play_UI,{ level = next_level } )
end




















return GamePass