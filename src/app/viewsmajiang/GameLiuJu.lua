
local GameLiuJu = class("GameLiuJu",BaseLayer)

function GameLiuJu:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameLiuJu.super.ctor( self,param.name )

    self._param = param

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer )
    self._layer = layer

    self:addCsb( "csbmajiang/GameLiuJu.csb" )

    -- 关闭
    self:addNodeClick( self.ButtonClose,{ 
        endCallBack = function() self:close() end
    })
    -- 再来一局
    self:addNodeClick( self.ButtonAgain,{ 
        endCallBack = function() self:again() end
    })
end


function GameLiuJu:onEnter()
    GameLiuJu.super.onEnter( self )
    casecadeFadeInNode( self.MidPanel,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
end

function GameLiuJu:again()
    removeUIFromScene( UIDefine.MAJIANG_KEY.LiuJu_UI )
    removeUIFromScene( UIDefine.MAJIANG_KEY.Play_UI )
    addUIToScene( UIDefine.MAJIANG_KEY.Play_UI )
end

-- 关闭
function GameLiuJu:close()
    removeUIFromScene( UIDefine.MAJIANG_KEY.LiuJu_UI )
    removeUIFromScene( UIDefine.MAJIANG_KEY.Play_UI )
    addUIToScene( UIDefine.MAJIANG_KEY.Start_UI )
end




return GameLiuJu