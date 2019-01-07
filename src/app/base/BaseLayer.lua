
--[[
    基础构造的layer
]]

local BaseLayer = class("BaseLayer",BaseNode )

function BaseLayer:ctor( name )
    self:setContentSize(cc.size( display.width,display.height ))
    self:registTouchEvent()
    BaseLayer.super.ctor(self,name)

    self._nodeClickRegist = {}
end

function BaseLayer:onEnter()
    BaseLayer.super.onEnter( self )
end

function BaseLayer:onExit()
    BaseLayer.super.onExit( self )
end


--[[
    以下四个方法是处理触摸的点击
]]
function BaseLayer:registTouchEvent()
    self.listener = cc.EventListenerTouchOneByOne:create()
    self.listener:setSwallowTouches(true)
    self.listener:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.listener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.listener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    -- self.listener:registerScriptHandler(handler(self, self.onTouchCancelled), cc.Handler.EVENT_TOUCH_CANCELLED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener, self)
end
function BaseLayer:onTouchBegan( touch, event )
    local touchPoint = touch:getLocation()
    local localPoint = self:getParent():convertToNodeSpace(touchPoint)
    local boxRect = self:getBoundingBox()
    if cc.rectContainsPoint(boxRect, localPoint) then
        if not self:isVisible() then
            return false
        end
        -- 处理注册的按钮的监听
        for k,v in ipairs(self._nodeClickRegist) do
            if v.node:isVisible() and cc.rectContainsPoint(v.node:getBoundingBox(), localPoint) then
                self.__touchNodeMarkName = v.node:getName()
                -- 设置scale
                if v.param.scaleAction then
                    v.node:setScale(0.95)
                end

                -- 如果设置了在触摸外也能响应 但开始点击的时候必须在node的里面
                if v.param.touchOutside then
                    v.param.touchOutBegan = true
                end

                -- 播放音效
                if v.param.palyVoice then
                    G_GetModel("Model_Sound"):playVoice()
                end
                if v.param.beganCallBack then
                    v.param.beganCallBack( touchPoint )
                end
                if v.param.swallowTouche then
                    break
                end
            end
        end    
        return true
    end
    return false
end
function BaseLayer:onTouchMoved( touch, event )
    -- 处理注册的按钮的监听
    for k,v in ipairs(self._nodeClickRegist) do
        if v.node:isVisible() and v.param.moveCallBack then
            local touchPoint = touch:getLocation()
            local localPoint = self:getParent():convertToNodeSpace(touchPoint)
            if cc.rectContainsPoint(v.node:getBoundingBox(), localPoint) then
                v.param.moveCallBack( touchPoint )
                -- 吞噬
                if v.param.swallowTouche then
                    break
                end
            elseif v.param.touchOutside and v.param.touchOutBegan then
                v.param.moveCallBack( touchPoint )
                -- 吞噬
                if v.param.swallowTouche then
                    break
                end
            end
        end
    end
end
function BaseLayer:onTouchEnded( touch, event )
    -- 恢复scale
    for i,v in ipairs( self._nodeClickRegist ) do
        if v.param.scaleAction then
            v.node:setScale(1)
        end
    end


    -- 处理注册的按钮的监听
    for k,v in ipairs(self._nodeClickRegist) do
        if v.node:isVisible() and v.param.endCallBack and self.__touchNodeMarkName and self.__touchNodeMarkName == v.node:getName() then
            local touchPoint = touch:getLocation()
            local localPoint = self:getParent():convertToNodeSpace(touchPoint)
            if cc.rectContainsPoint(v.node:getBoundingBox(), localPoint) then
                v.param.endCallBack( touchPoint )
                -- -- 播放音效
                -- if v.param.palyVoice then
                --     G_GetModel("Model_Sound"):playVoice()
                -- end

                -- 吞噬
                if v.param.swallowTouche then
                    break
                end
            elseif v.param.touchOutside and v.param.touchOutBegan then
                v.param.endCallBack( touchPoint )
                -- 去掉这个标志
                if v.param.touchOutBegan then
                    v.param.touchOutBegan = nil
                end
                -- 吞噬
                if v.param.swallowTouche then
                    break
                end
            end
        end
    end
    
    self.__touchNodeMarkName = nil
end

--[[
    为layer里面的控件注册点击事件 先注册的先触发触摸监听
    node:layer里面的控件
    param = {
        beganCallBack = function() end, -- 触摸开始的处理
        moveCallBack = function() end,  -- 触摸中的处理
        endCallBack = function() end,   -- 触摸结束后的处理
        scaleAction = true,             -- 默认true 触摸按钮的放大缩小反应
        swallowTouche = true,           -- 默认true 吞噬监听 (如果按钮的功能是关闭界面 必须为true)
        palyVoice = true,               -- 默认true 播放音效
        touchOutside = false,           -- 默认false 表示在区域外也响应
    }
]]
function BaseLayer:addNodeClick( node,param )
    assert( node," !! node is nil !! ")
    assert( param," !! param is nil !! ")
    if param.beganCallBack == nil and param.moveCallBack == nil and param.endCallBack == nil then
        assert( false," !! node callback is nil !! " )
        return
    end

    -- 按钮默认开启放大缩小
    if param.scaleAction == nil then
        param.scaleAction = true
    end

    -- 默认吞噬监听
    if param.swallowTouche == nil then
        param.swallowTouche = true
    end

    -- 默认播放点击音效
    if param.palyVoice == nil then
        param.palyVoice = true
    end

    local node_size = node:getContentSize()
    if node_size.width <= 0 or node_size.height <= 0 then
        assert( false," !! node_size condition is error !! " )
        return
    end
    local name = node:getName()

    if name == nil or string.trim( name ) == "" then
        assert( false," !! name condition is error !! " )
        return
    end

    for i,v in ipairs(self._nodeClickRegist) do
        if v.name == name then
            assert( false," !! node callback is register !! " )
            return
        end
    end

    local callBackParam = {}
    callBackParam.node = node
    callBackParam.param = param
    callBackParam.name = name
    table.insert(self._nodeClickRegist,callBackParam)
end

function BaseLayer:removeNodeClick( node )
    assert( node," !! node is nil !! " )
end


rawset(_G, "BaseLayer", BaseLayer)
