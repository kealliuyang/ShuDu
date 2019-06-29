

local GameStart = class("GameStart",BaseLayer)

function GameStart:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameStart.super.ctor( self,param.name )
    self:addCsb( "csbsanguo/Start.csb" )

    -- 开始
    self:addNodeClick( self.ButtonStart,{ 
        endCallBack = function() self:start() end,
    })
    -- 帮助
    self:addNodeClick( self.ButtonHelp,{ 
        endCallBack = function() self:help() end,
    })
    -- 排行榜
    -- self:addNodeClick( self.ButtonRank,{ 
    --     endCallBack = function() self:rank() end,
    -- })
    -- 设置
    self:addNodeClick( self.ButtonSet,{ 
        endCallBack = function() self:set() end
    })
    -- 商店
    self:addNodeClick( self.ButtonShop,{ 
        endCallBack = function() self:shop() end
    })
end

function GameStart:loadCoin()
    local coin = G_GetModel("Model_SanGuo"):getInstance():getCoin()
    self.TextCoin:setString(coin)
    -- body
end

function GameStart:onEnter()
    GameStart.super.onEnter( self )
    casecadeFadeInNode( self._csbNode,0.5 )

    -- 播放背景音乐
    G_GetModel("Model_Sound"):playBgMusic()---return ModelRegister:getInstance():getModel( modelName )
                                            --上面是ModelRegister:getInstance():getModel( modelName ):playBgMusic()怎么串起的？
    -- 初始化50铜币
    local coin = G_GetModel("Model_SanGuo"):getCoin()
    --注销，输完不再送金币
    -- if coin <= 0 then
    --     G_GetModel("Model_SanGuo"):initCoin()
    -- end

    self:loadCoin()
end

function GameStart:start()
    local coin = G_GetModel("Model_SanGuo"):getInstance():getCoin()
    if coin < 10 then
        addUIToScene( UIDefine.SANGUO_KEY.Shop_UI,{ layer = self } )
    else
        removeUIFromScene( UIDefine.SANGUO_KEY.Start_UI )
        addUIToScene( UIDefine.SANGUO_KEY.Play_UI )
    end
	-- removeUIFromScene( UIDefine.SANGUO_KEY.Start_UI )
	-- addUIToScene( UIDefine.SANGUO_KEY.Play_UI )
end

function GameStart:help()
    addUIToScene( UIDefine.SANGUO_KEY.Help_UI )
end

-- function GameStart:rank()
--     addUIToScene( UIDefine.ZHIPAI_KEY.Rank_UI )
-- end

function GameStart:set()
    addUIToScene( UIDefine.SANGUO_KEY.Voice_UI )
end

function GameStart:shop()
    addUIToScene( UIDefine.SANGUO_KEY.Shop_UI,{ layer = self } )--{ layer = self }购买后需要刷新金币，把这个页面指针给出去，给GameShop
end

return GameStart