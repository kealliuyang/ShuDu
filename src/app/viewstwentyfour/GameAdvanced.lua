
local GameAdvanced = class("GameAdvanced",BaseLayer)


function GameAdvanced:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameAdvanced.super.ctor( self,param.name )
    self:addCsb( "csbtwentyfour/LayerGameAdvance.csb" )
    -- 返回
    self:addNodeClick( self.ButtonBack,{ 
        endCallBack = function() self:back() end
    })

    self:addNodeClick( self.ButtonStart,{ 
        endCallBack = function() self:start() end,
        voicePath = "tfmp3/reset.mp3"
    })

    self:loadUiData()
end

function GameAdvanced:onEnter()
    GameAdvanced.super.onEnter( self )
    casecadeFadeInNode( self.MidPanel,0.5 )
end

function GameAdvanced:loadUiData()
	local max_score = G_GetModel("Model_TwentyFour"):getMaxScore()
	self.TextTime:setString(formatMinuTimeStr(max_score,":"))
end

function GameAdvanced:start()
	removeUIFromScene( UIDefine.TWENTYFOUR_KEY.Advanced_UI )
    addUIToScene( UIDefine.TWENTYFOUR_KEY.Play_Advanced_UI )
end

function GameAdvanced:back()
    removeUIFromScene( UIDefine.TWENTYFOUR_KEY.Advanced_UI )
    addUIToScene( UIDefine.TWENTYFOUR_KEY.Start_UI )
end

return GameAdvanced