
local GameStart = class("GameStart",BaseLayer)

function GameStart:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameStart.super.ctor( self,param.name )
    self:addCsb( "csbEliminate/LayerGameStart.csb" )

    -- 方块
    self:addNodeClick( self.ButtonGeneral,{ 
        endCallBack = function() self:start(1) end
    })
    -- 困难
    self:addNodeClick( self.ButtonHard,{ 
        endCallBack = function() self:start(2) end
    })
    -- 六边形
    self:addNodeClick( self.ButtonAdvanced,{ 
        endCallBack = function() self:advanced() end
    })
    -- 记录
    self:addNodeClick( self.ButtonRank,{ 
        endCallBack = function() self:rank() end
    })
    self:addNodeClick( self.ButtonSet,{ 
        endCallBack = function() self:set() end
    })
end

function GameStart:onEnter()
    GameStart.super.onEnter( self )
    casecadeFadeInNode( self.MidPanel,0.5 )
end

function GameStart:start( mode )
	removeUIFromScene( UIDefine.ELIMI_KEY.Start_UI )
    local data = { mode = mode }
	addUIToScene( UIDefine.ELIMI_KEY.Play_UI,data )
end

function GameStart:advanced()
    removeUIFromScene( UIDefine.ELIMI_KEY.Start_UI )
    addUIToScene( UIDefine.ELIMI_KEY.Advanced_UI )
end

function GameStart:rank()
    addUIToScene( UIDefine.ELIMI_KEY.Record_UI )
end

function GameStart:set()
    addUIToScene( UIDefine.ELIMI_KEY.Set_UI )
end

return GameStart