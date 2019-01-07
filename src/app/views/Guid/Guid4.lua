

local Guid4 = class("Guid4",BaseLayer)


function Guid4:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    self._param = param
    Guid4.super.ctor( self,param.name )

    local layerColor = cc.LayerColor:create(cc.c4b(0,0,0,200))
    self:addChild(layerColor,0)

    self:addCsb( "csb/LayerGuid4.csb",1 )

    -- 下一步
    self:addNodeClick( self["ButtonOk"],{ 
        endCallBack = function() self:nextStep() end
    })

end


function Guid4:nextStep()
    -- 存储新手引导通过
    G_GetModel("Model_Player"):setPassGuid()
    removeUIFromScene( UIDefine.UI_KEY.Guid4_UI )

    -- 发送消息
    EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_GUID_4 )
end

return Guid4