
--[[
    基础构造的node
]]

local BaseNode = class("BaseNode",function()
	return cc.Node:create()
end )


-- 构造函数
function BaseNode:ctor( name )
    self:setName( name )
    -- 开启onEnter onExit事件
	self:init()
    -- 添加监听消息
    self._eventListener = {}
end

function BaseNode:init()
    self:enableNodeEvents()
end

function BaseNode:addCsb( fileName,zOrder )
    assert( fileName," !! fileName is nil !! ")
    if self._csbNode then
        return
    end
    self._csbNode = CSBUtil.readNodeCSB( fileName,self )
    
    if zOrder then
        self:addChild( self._csbNode,zOrder )
    else
        self:addChild( self._csbNode )
    end
end

-- 子类需要从写
function BaseNode:addListener()

end

-- 注册消息
function BaseNode:addMsgListener( eventName,listener )
    if self._eventListener[eventName] then
        return
    end
    self._eventListener[eventName] = eventName
    EventManager:getInstance():addInnerListener( eventName,listener )
end

function BaseNode:removeListener()
    for k,v in pairs( self._eventListener ) do
        EventManager:getInstance():removeInnerListener( v )
        self._eventListener[k] = nil
    end
end

function BaseNode:onEnter()
    self:addListener()
end

function BaseNode:onExit()
    self:removeListener()
end


-- 定时器(只允许存在一个定时器)
function BaseNode:schedule(func, time)
    if not self.scheduleNode then 
        self.scheduleNode = cc.Node:create()
        self:addChild(self.scheduleNode)
        self.scheduleNode:runAction(cc.RepeatForever:create( cc.Sequence:create(
            cc.DelayTime:create(time),
            cc.CallFunc:create(func)
            ) 
        ))
    end
end
function BaseNode:stopSchedule()
    if self.scheduleNode then
        self.scheduleNode:pause()
    end
end
function BaseNode:startSchedule()
    if self.scheduleNode then 
        self.scheduleNode:resume()
    end
end
function BaseNode:unSchedule()
    if self.scheduleNode then
        self.scheduleNode:stopAllActions()
        self.scheduleNode:removeFromParent()
        self.scheduleNode = nil
    end
end


rawset(_G, "BaseNode", BaseNode)
