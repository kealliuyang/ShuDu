

local GameStart = class("GameStart",BaseLayer)

function GameStart:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameStart.super.ctor( self,param.name )
    self:addCsb( "csbjunshi/Start.csb" )

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
    -- 商店
    self:addNodeClick( self.ButtonShop,{ 
        endCallBack = function() self:shop() end
    })
end

function GameStart:onEnter()
    GameStart.super.onEnter( self )
    casecadeFadeInNode( self._csbNode,0.5 )
    -- 打开login背景音乐
    if G_GetModel("Model_Sound"):isMusicOpen() then
        audio.playMusic("jsmp3/login.mp3",true)
    end

    -- 初始化30铜币
    local coin = G_GetModel("Model_JunShi"):getCoin()
    if coin <= 0 then
        G_GetModel("Model_JunShi"):initCoin()
    end
end

function GameStart:start()
	removeUIFromScene( UIDefine.JUNSHI_KEY.Start_UI )
	addUIToScene( UIDefine.JUNSHI_KEY.Select_UI )
end

function GameStart:help()
    addUIToScene( UIDefine.JUNSHI_KEY.Help_UI )
end

function GameStart:rank()
    addUIToScene( UIDefine.JUNSHI_KEY.Rank_UI )
end

function GameStart:set()
    addUIToScene( UIDefine.JUNSHI_KEY.Voice_UI )
end

function GameStart:shop()
    addUIToScene( UIDefine.JUNSHI_KEY.Shop_UI )
end

return GameStart