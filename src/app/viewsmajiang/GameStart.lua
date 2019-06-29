
local GameStart = class("GameStart",BaseLayer)

function GameStart:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameStart.super.ctor( self,param.name )
    self:addCsb( "csbmajiang/GameStart.csb" )

    -- 普通
    self:addNodeClick( self.ButtonNormal,{ 
        endCallBack = function() self:start(1) end
    })
    -- 挑战
    self:addNodeClick( self.ButtonCharge,{ 
        endCallBack = function() self:start(2) end
    })
    -- 记录
    self:addNodeClick( self.ButtonRank,{ 
        endCallBack = function() self:rank() end
    })
    -- 设置
    self:addNodeClick( self.ButtonSet,{ 
        endCallBack = function() self:set() end
    })
    -- 帮助
    self:addNodeClick( self.ButtonHelp,{ 
        endCallBack = function() self:help() end
    })
end


function GameStart:onEnter()
    GameStart.super.onEnter( self )
    casecadeFadeInNode( self.MidPanel,0.5 )
end

function GameStart:start( mode )
    removeUIFromScene( UIDefine.MAJIANG_KEY.Start_UI )
    G_GetModel("Model_MaJiang"):setGameType( mode )
    addUIToScene( UIDefine.MAJIANG_KEY.Play_UI )
end

function GameStart:rank()
    addUIToScene( UIDefine.MAJIANG_KEY.Rank_UI )
    
    -- removeUIFromScene( UIDefine.MAJIANG_KEY.Start_UI )
    -- addUIToScene( UIDefine.MAJIANG_KEY.Test_UI )
end

function GameStart:set()
    addUIToScene( UIDefine.MAJIANG_KEY.Voice_UI )
end

function GameStart:help()
    addUIToScene( UIDefine.MAJIANG_KEY.Help_UI )
end

return GameStart