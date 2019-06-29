
local GameStart = class("GameStart",BaseLayer)

function GameStart:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameStart.super.ctor( self,param.name )
    self:addCsb( "csbtwentyfour/LayerGameStart.csb" )

    -- 冒险
    self:addNodeClick( self.ButtonAdventure,{ 
        endCallBack = function() self:adventure() end
    })
    -- 竞技
    self:addNodeClick( self.ButtonCompetitive,{ 
        endCallBack = function() self:competitive() end
    })
    -- 记录
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
    casecadeFadeInNode( self.MidPanel,0.5 )
end

function GameStart:adventure()
	removeUIFromScene( UIDefine.TWENTYFOUR_KEY.Start_UI )
	addUIToScene( UIDefine.TWENTYFOUR_KEY.Level_UI )
end

function GameStart:competitive()
    removeUIFromScene( UIDefine.TWENTYFOUR_KEY.Start_UI )
    addUIToScene( UIDefine.TWENTYFOUR_KEY.Advanced_UI )
end

function GameStart:rank()
    addUIToScene( UIDefine.TWENTYFOUR_KEY.Rank_Main_UI )
end

function GameStart:set()
    addUIToScene( UIDefine.TWENTYFOUR_KEY.Set_UI )
end

return GameStart