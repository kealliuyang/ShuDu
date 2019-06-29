
local GamePoChan = class("GamePoChan",BaseLayer)

function GamePoChan:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePoChan.super.ctor( self,param.name )

    self._param = param

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer )

    self:addCsb( "csbmajiang/GamePoChan.csb" )

    -- 关闭
    self:addNodeClick( self.ButtonClose,{ 
        endCallBack = function() self:close() end
    })
    -- 再来一局
    self:addNodeClick( self.ButtonRestart,{ 
        endCallBack = function() self:restart() end
    })
end


function GamePoChan:onEnter()
    GamePoChan.super.onEnter( self )
end

function GamePoChan:restart()
    removeUIFromScene( UIDefine.MAJIANG_KEY.PoChan_UI )
    removeUIFromScene( UIDefine.MAJIANG_KEY.Play_UI )
    addUIToScene( UIDefine.MAJIANG_KEY.Play_UI )
end

-- 关闭
function GamePoChan:close()
    removeUIFromScene( UIDefine.MAJIANG_KEY.PoChan_UI )
    removeUIFromScene( UIDefine.MAJIANG_KEY.Play_UI )
    addUIToScene( UIDefine.MAJIANG_KEY.Start_UI )
end




return GamePoChan