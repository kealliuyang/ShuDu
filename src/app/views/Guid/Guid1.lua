

local Guid1 = class("Guid1",BaseLayer)


function Guid1:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    self._param = param
    Guid1.super.ctor( self,param.name )
    self:addCsb( "csb/LayerGuid1.csb",1 )

    -- 下一步
    self:addNodeClick( self["ButtonKnow"],{ 
        endCallBack = function() self:nextStep() end
    })

    -- 添加剪裁node
    self:addClipNode()
end

function Guid1:addClipNode()
    local clip_node = cc.ClippingNode:create()
    self:addChild( clip_node,0 )
    clip_node:setInverted(true) --设置地板可见
    clip_node:setAlphaThreshold(0)--设置透明度Alpha值为0
    local layerColor = cc.LayerColor:create(cc.c4b(0,0,0,200))
    clip_node:addChild(layerColor,1)--在裁剪节点添加一个灰色的透明层
    -- 创建模板，也就是你要在裁剪节点上挖出来的那个”洞“是什么形状的
    local node = cc.Node:create() --创建模版
    -- local box1 = ccui.ImageView:create("image/guid/Box_1.png",1)
    for i = 1,3 do
    	-- local box = cc.LayerColor:create(cc.c4b(255,0,0,255))
        local box = ccui.ImageView:create("image/bg/Box_"..i..".png")
        box:setAnchorPoint(cc.p(0,0))
	    -- box:setContentSize(self["Box"..i]:getContentSize())
	    node:addChild(box)--在模版上添加精灵
	    local pos = self["Box"..i]:getParent():convertToWorldSpace(cc.p(self["Box"..i]:getPosition()))
	    box:setPosition(pos)--设置的坐标正好是在close button的坐标位置上
    end
    clip_node:setStencil(node)--设置模版 
end

function Guid1:nextStep()
	removeUIFromScene( UIDefine.UI_KEY.Guid1_UI )
	addUIToScene( UIDefine.UI_KEY.Guid2_UI )
end

return Guid1