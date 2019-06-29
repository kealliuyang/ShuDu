
local UIManager = class("UIManager")


function UIManager:ctor( scene )
	assert( scene," !! scene is nil !! " )

	self._scene = scene
	self._nodeList = {}

	-- 创建层组
	for k,v in pairs( UIDefine.LayerFlag ) do
		self:createUiGroup( v.name,v.order )
	end
end


-- 创建UI层组
function UIManager:createUiGroup( flag,zOrder )
	assert( flag," !! flag is nil !! ")
	local node = cc.Node:create()
    node:setName(flag)
    self._scene:addChild(node,zOrder)
    self._nodeList[flag] = node
end

--[[
	layer:要创建的ui的layer
	flag:用来标记要放入哪一个层组
]]
function UIManager:addLayer( layer,flag )
	assert( layer," !! layer is nil !! ")
	local node = self._nodeList[flag]
	assert( node," !! node is nil !! ")
	node:addChild( layer )
end

function UIManager:removeLayer( name,flag )
	assert( name," !! name is nil !! " )
	local node = self._nodeList[flag]
	assert( node," !! node is nil !! ")
	local layer = node:getChildByName(name)
	assert( layer," !! layer is nil !! ")
	layer:removeFromParent()
end

-- 注:layer可能是nil
function UIManager:getLayer( name,flag )
	assert( name," !! name is nil !! " )
	local node = self._nodeList[flag]
	assert( node," !! node is nil !! ")
	local layer = node:getChildByName(name)
	return layer
end


return UIManager