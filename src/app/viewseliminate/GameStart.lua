
local GameStart = class("GameStart",BaseLayer)

function GameStart:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameStart.super.ctor( self,param.name )
    self:addCsb( "csbEliminate/LayerGameStart.csb" )

    -- 方块
    self:addNodeClick( self.ButtonGeneral,{ 
        endCallBack = function() self:start() end
    })
    -- 六边形
    self:addNodeClick( self.ButtonAdvanced,{ 
        endCallBack = function() self:advanced() end
    })
    -- 记录
    self:addNodeClick( self.ButtonRank,{ 
        endCallBack = function() self:rank() end
    })
end

function GameStart:onEnter()
    GameStart.super.onEnter( self )
    casecadeFadeInNode( self.MidPanel,0.5 )
end

function GameStart:start()
	removeUIFromScene( UIDefine.ELIMI_KEY.Start_UI )
	addUIToScene( UIDefine.ELIMI_KEY.Play_UI )
end

function GameStart:advanced()
    removeUIFromScene( UIDefine.ELIMI_KEY.Start_UI )
    addUIToScene( UIDefine.ELIMI_KEY.Advanced_UI )
end

function GameStart:rank()
    addUIToScene( UIDefine.ELIMI_KEY.Record_UI )
end


return GameStart