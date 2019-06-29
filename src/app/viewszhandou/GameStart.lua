

local GameStart = class("GameStart",BaseLayer)

function GameStart:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameStart.super.ctor( self,param.name )
    self:addCsb( "csbzhandou/Start.csb" )

    -- 开始
    self:addNodeClick( self.ButtonPlay,{ 
        endCallBack = function() self:start() end,
    })
    -- 帮助
    self:addNodeClick( self.ButtonHelp,{ 
        endCallBack = function() self:help() end
    })
    -- 设置
    self:addNodeClick( self.ButtonSet,{ 
        endCallBack = function() self:set() end
    })
    -- 商店
    self:addNodeClick( self.ButtonStore,{ 
        endCallBack = function() self:shop() end
    })
end

function GameStart:loadCoin()
    local coin = G_GetModel("Model_ZhanDou"):getInstance():getCoin()
    self.TextCoin:setString(coin)
    -- body
end

function GameStart:onEnter()
    GameStart.super.onEnter( self )
    casecadeFadeInNode( self._csbNode,0.5 )
    -- 播放背景音乐
    G_GetModel("Model_Sound"):playBgMusic()---return ModelRegister:getInstance():getModel( modelName )                                  

    -- 初始化20铜币
    if G_GetModel("Model_ZhanDou"):getCoin() < 20 then
        G_GetModel("Model_ZhanDou"):initCoin()
    end

    local coin = G_GetModel("Model_ZhanDou"):getCoin()
    self:loadCoin()
end

function GameStart:start()
    removeUIFromScene( UIDefine.ZHANDOU_KEY.Start_UI )
    addUIToScene( UIDefine.ZHANDOU_KEY.Play_UI )
end

function GameStart:help()
    addUIToScene( UIDefine.ZHANDOU_KEY.Help_UI )
end


function GameStart:set()
    addUIToScene( UIDefine.ZHANDOU_KEY.Voice_UI )
end

function GameStart:shop()
    addUIToScene( UIDefine.ZHANDOU_KEY.Shop_UI,{ layer = self } )--{ layer = self }购买后需要刷新金币，把这个页面指针给出去，给GameShop
end

return GameStart