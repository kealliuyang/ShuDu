
local GameHelp = class("GameHelp",BaseLayer)

function GameHelp:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameHelp.super.ctor( self,param.name )

    self._param = param

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer )
    self._layer = layer

    self:addCsb( "csbtwentyone/Help.csb" )

    -- 关闭
    self:addNodeClick( self.ButtonClose,{ 
        endCallBack = function() self:close() end
    })
end


function GameHelp:onEnter()
    GameHelp.super.onEnter( self )
    casecadeFadeInNode( self.Bg,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
end

-- 关闭
function GameHelp:close()
    removeUIFromScene( UIDefine.TWENTYONE_KEY.Help_UI )
end




return GameHelp