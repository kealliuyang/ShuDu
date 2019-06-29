

local GameAdvancedResult = class("GameAdvancedResult",BaseLayer)


function GameAdvancedResult:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameAdvancedResult.super.ctor( self,param.name )
    self:addCsb( "csbtwentyfour/LayerGameResult1.csb" )
    self._param = param
    -- 返回
    self:addNodeClick( self.ButtonBack,{ 
        endCallBack = function() self:back() end
    })
    self:loadUiData()
end

function GameAdvancedResult:onEnter()
	local fade_time = 0.5
    GameAdvancedResult.super.onEnter( self )
    -- casecadeFadeInNode( self.MidPanel,0.5 )
    -- action
    self.Bg2:setVisible(false)
    self.IconPeople:setVisible(false)
    self.TextScore:setVisible(false)
    self.TextBestScore:setVisible(false)
    self.ImageNewScore:setVisible(false)
    
    local delay1 = cc.DelayTime:create(0.3)
    local call_back1 = cc.CallFunc:create( function()
    	self.Bg2:setVisible(true)
    	self.Bg2:setOpacity(0)
    end )
    local fade_to = cc.FadeTo:create(0.5,255)
    local call_icon = cc.CallFunc:create( function()
    	self.IconPeople:setVisible( true )
    	self.IconPeople:setScale(0)
    	local scale_to = cc.ScaleTo:create(0.4,1)
    	local rotate_by = cc.RotateBy:create(0.4,360*3)
    	local spawn = cc.Spawn:create({ scale_to,rotate_by })
    	self.IconPeople:runAction( spawn )
    end )

    local delay2 = cc.DelayTime:create(1)
    local call_back3 = cc.CallFunc:create( function()
        self.TextScore:setVisible( true )
    end )
    local delay3 = cc.DelayTime:create(0.5)
    local call_back4 = cc.CallFunc:create( function()
        self.TextBestScore:setVisible( true )
    end )
    local delay4 = cc.DelayTime:create(0.5)
    local call_back5 = cc.CallFunc:create( function()
        -- 是否显示
        self.ImageNewScore:setVisible( self._param.data.newScore )
    end )

    local seq = cc.Sequence:create({ delay1,call_back1,
        fade_to,call_icon,delay2,call_back3,delay3,call_back4,delay4,call_back5 })
    self.Bg2:runAction( seq )
end

function GameAdvancedResult:loadUiData()
	self.TextScore:setString( formatMinuTimeStr( self._param.data.score,":" ) )
	local max_score = G_GetModel("Model_TwentyFour"):getMaxScore()
	self.TextBestScore:setString(formatMinuTimeStr(max_score,":"))
end



function GameAdvancedResult:back()
	removeUIFromScene( UIDefine.TWENTYFOUR_KEY.Advanced_Result_UI )
    addUIToScene( UIDefine.TWENTYFOUR_KEY.Advanced_UI )
end


return GameAdvancedResult