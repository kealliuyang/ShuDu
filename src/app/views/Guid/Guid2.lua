

local Guid2 = class("Guid2",BaseLayer)


function Guid2:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    self._param = param
    Guid2.super.ctor( self,param.name )
    self:addCsb( "csb/LayerGuid2.csb",1 )

    -- 下一步
    self:addNodeClick( self["Box"],{ 
        endCallBack = function( touchPoint ) self:nextStep( touchPoint ) end,
        scaleAction = false
    })

    -- 添加剪裁node
    self:addClipNode()
end

function Guid2:addClipNode()
    local clip_node = cc.ClippingNode:create()
    self:addChild( clip_node,0 )
    clip_node:setInverted(true)
    clip_node:setAlphaThreshold(0)
    local layerColor = cc.LayerColor:create(cc.c4b(0,0,0,200))
    clip_node:addChild(layerColor,1)
    local node = cc.Node:create()
	local box = ccui.ImageView:create("image/bg/Box_4.png")
    box:setAnchorPoint(cc.p(0,0))
    node:addChild(box)
    local pos = self["Box"]:getParent():convertToWorldSpace(cc.p(self["Box"]:getPosition()))
    box:setPosition(pos)
    clip_node:setStencil(node)
end

function Guid2:nextStep( touchPoint )
    -- 发送引导消息
    EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_GUID_2,touchPoint )
    
    removeUIFromScene( UIDefine.UI_KEY.Guid2_UI )
    addUIToScene( UIDefine.UI_KEY.Guid3_UI )
end

return Guid2