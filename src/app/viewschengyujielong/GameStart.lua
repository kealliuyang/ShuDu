

local GameStart = class("GameStart",BaseLayer)

function GameStart:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameStart.super.ctor( self,param.name )
    self:addCsb( "csbchengyujielong/GameStart.csb" )

    -- 开始
    self:addNodeClick( self.ButtonStart,{ 
        endCallBack = function() self:start() end
    })
    -- 帮助
    self:addNodeClick( self.ButtonHelp,{ 
        endCallBack = function() self:help() end
    })
    -- 排行榜
    self:addNodeClick( self.ButtonRank,{ 
        endCallBack = function() self:rank() end
    })
    -- 设置
    self:addNodeClick( self.ButtonSet,{ 
        endCallBack = function() self:set() end
    })
end

function GameStart:onEnter()
    GameStart.super.onEnter( self )
    casecadeFadeInNode( self._csbNode,0.5 )
    -- 打开背景音乐
    G_GetModel("Model_Sound"):playBgMusic()
end

function GameStart:start()
	removeUIFromScene( UIDefine.CHENGYUJIELONG_KEY.Start_UI )
    local data = { mode = mode }
	addUIToScene( UIDefine.CHENGYUJIELONG_KEY.Play_UI,data )
end

function GameStart:help()
    addUIToScene( UIDefine.CHENGYUJIELONG_KEY.Help_UI )
end

function GameStart:rank()
    addUIToScene( UIDefine.CHENGYUJIELONG_KEY.Rank_UI )
end

function GameStart:set()
    addUIToScene( UIDefine.CHENGYUJIELONG_KEY.Voice_UI )
end

return GameStart