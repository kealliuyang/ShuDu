
local GameOver = class("GameOver",BaseLayer)


function GameOver:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameOver.super.ctor( self,param.name )

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer,1 )
    self._layer = layer

    self:addCsb( "csbEliminate/LayerGameOver.csb",2 )
    self._param = param
    -- home
    self:addNodeClick( self.ButtonHome,{ 
        endCallBack = function() self:home() end
    })
    -- back
    self:addNodeClick( self.ButtonBack,{ 
        endCallBack = function() self:back() end
    })
    -- midpanel
    self:addNodeClick( self.MidPanel,{ 
        beganCallBack = function( touchPoint ) self:hideLayer( touchPoint ) end,
        endCallBack = function( touchPoint ) self:showLayer( touchPoint ) end,
        scaleAction = false,
        palyVoice = false
    })

    self:loadDataUi()
end


function GameOver:onEnter()
    GameOver.super.onEnter( self )
    casecadeFadeInNode( self.MidPanel,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
end

function GameOver:loadDataUi()
	self.TextScore:setString( self._param.data.score )
	-- 存贮分数
    if self._param.data.ui == "GamePlay" then
	   G_GetModel("Model_Eliminate"):saveGeneralRecordList(self._param.data.score)
    elseif self._param.data.ui == "GameAdvanced" then
        G_GetModel("Model_Eliminate"):saveAdvancedRecordList(self._param.data.score)
    end
end

function GameOver:home()
    if self._param.data.ui == "GamePlay" then
	   removeUIFromScene( UIDefine.ELIMI_KEY.Play_UI )
    elseif self._param.data.ui == "GameAdvanced" then
       removeUIFromScene( UIDefine.ELIMI_KEY.Advanced_UI )
    end
	removeUIFromScene( UIDefine.ELIMI_KEY.GameOver_UI )
	addUIToScene( UIDefine.ELIMI_KEY.Start_UI )
end

function GameOver:back()
	-- 发送消息
    EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_EL_REPLAY )
    removeUIFromScene( UIDefine.ELIMI_KEY.GameOver_UI )
end

function GameOver:hideLayer( touchPoint )
    local localPoint = self.Bg:getParent():convertToNodeSpace(touchPoint)
    if not cc.rectContainsPoint(self.Bg:getBoundingBox(), localPoint) then
        self._layer:setVisible( false )
        self.MidPanel:setOpacity(0)
    end
end

function GameOver:showLayer( touchPoint )
    local localPoint = self.Bg:getParent():convertToNodeSpace(touchPoint)
    if not cc.rectContainsPoint(self.Bg:getBoundingBox(), localPoint) then
        self._layer:setVisible( true )
        self.MidPanel:setOpacity(255)
    end
end


return GameOver