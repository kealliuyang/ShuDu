
local GamePause = class("GamePause",BaseLayer)


function GamePause:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePause.super.ctor( self,param.name )

    self._param = param

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer,1 )
    self._layer = layer

    self:addCsb( "csbEliminate/LayerGamePause.csb",2 )
    -- home
    self:addNodeClick( self.ButtonHome,{ 
        endCallBack = function() self:home() end
    })
    -- back
    self:addNodeClick( self.ButtonBack,{ 
        endCallBack = function() self:back() end
    })
    -- continue
    self:addNodeClick( self.ButtonContinue,{ 
        endCallBack = function() self:continue() end
    })
end


function GamePause:onEnter()
    GamePause.super.onEnter( self )
    casecadeFadeInNode( self.MidPanel,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
end


function GamePause:home()
    if self._param.data.ui == "GamePlay" then
        -- 发送消息 存储数据
        EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_EL_GENERAL_CONTINUE_DATA )
        removeUIFromScene( UIDefine.ELIMI_KEY.Play_UI )
    elseif self._param.data.ui == "GameAdvanced" then
        -- 发送消息 存储数据
        EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_EL_ADVANCED_CONTINUE_DATA )
        removeUIFromScene( UIDefine.ELIMI_KEY.Advanced_UI )
    end
    
	removeUIFromScene( UIDefine.ELIMI_KEY.GamePause_UI )
	addUIToScene( UIDefine.ELIMI_KEY.Start_UI )
end

function GamePause:back()
    -- 发送消息
    EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_EL_REPLAY )
    EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_EL_CONTINUE_PLAY )
    removeUIFromScene( UIDefine.ELIMI_KEY.GamePause_UI )
end

function GamePause:continue()
    -- 发送消息
    EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_EL_CONTINUE_PLAY )
    removeUIFromScene( UIDefine.ELIMI_KEY.GamePause_UI )
end


return GamePause