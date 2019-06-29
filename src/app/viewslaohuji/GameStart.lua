
local GameStart = class("GameStart",BaseLayer)

function GameStart:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameStart.super.ctor( self,param.name )
    self:addCsb( "csblaohuji/Hall.csb" )

    -- 动物城
    self:addNodeClick( self.ButtonAnimal,{ 
        endCallBack = function() self:start(2) end
    })
    -- 水果机
    self:addNodeClick( self.ButtonFruits,{ 
        endCallBack = function() self:start(1) end
    })
    -- 海底世界
    self:addNodeClick( self.ButtonSeabed,{ 
        endCallBack = function() self:start(3) end
    })
    -- 设置
    self:addNodeClick( self.ButtonSet,{ 
        endCallBack = function() self:set() end
    })
    -- 帮助
    self:addNodeClick( self.ButtonHelp,{ 
        endCallBack = function() self:help() end
    })
    -- 成就
    self:addNodeClick( self.ButtonAchievement,{ 
        endCallBack = function() self:achievement() end
    })
    -- 排名
    self:addNodeClick( self.ButtonRank,{ 
        endCallBack = function() self:rank() end
    })

    -- 添加金币
    self.ButtonAddCoin:setVisible( lhj_mode_test )
    if lhj_mode_test then
        self:addNodeClick( self.ButtonAddCoin,{ 
            endCallBack = function() self:addCoin() end
        })
    end

    self:loadUIData()
end


function GameStart:onEnter()
    GameStart.super.onEnter( self )
    casecadeFadeInNode( self.MidPanel,0.5 )
end

function GameStart:addListener()
    self:addMsgListener( InnerProtocol.INNER_EVENT_LAOHUJI_RESETSTART,function( event )
        self:loadUIData()
    end )
end

function GameStart:loadUIData()
    local coin = G_GetModel("Model_LaoHuJi"):getCoin()
    self.TextCoin:setString( coin )
    -- 动物城是否解锁
    local open_animal = G_GetModel("Model_LaoHuJi"):isAnimalOpen()
    self.SuoAnimal:setVisible( not open_animal )
    -- 海底世界是否解锁
    local open_seabed = G_GetModel("Model_LaoHuJi"):isSeabedOpen()
    self.SuoSeabed:setVisible( not open_seabed )
end

function GameStart:start( mode )
    G_GetModel("Model_LaoHuJi"):setGameType( mode )
    if mode == 2 then
        -- 判断动物城是否解锁
        local is_open  = G_GetModel("Model_LaoHuJi"):isAnimalOpen()
        if not is_open then
            local data = { coin = lhj_unlock_animal, parent = self }
            addUIToScene( UIDefine.LAOHUJI_KEY.UnLock_UI,data )
            return
        end
    end

    if mode == 3 then
        -- 判断动物城是否解锁
        local is_open  = G_GetModel("Model_LaoHuJi"):isSeabedOpen()
        if not is_open then
            local data = { coin = lhj_unlock_seabed, parent = self }
            addUIToScene( UIDefine.LAOHUJI_KEY.UnLock_UI,data )
            return
        end
    end

    removeUIFromScene( UIDefine.LAOHUJI_KEY.Start_UI )
    addUIToScene( UIDefine.LAOHUJI_KEY.Play_UI )
end

function GameStart:rank()
    addUIToScene( UIDefine.LAOHUJI_KEY.Rank_UI )
end

function GameStart:set()
    addUIToScene( UIDefine.LAOHUJI_KEY.Voice_UI )
end

function GameStart:help()
    addUIToScene( UIDefine.LAOHUJI_KEY.Help_UI )
end

function GameStart:achievement()
    addUIToScene( UIDefine.LAOHUJI_KEY.Achievement_UI )
end

function GameStart:addCoin()
    addUIToScene( UIDefine.LAOHUJI_KEY.AddCoin_UI )
end

return GameStart