
--
-- Author: 刘阳
-- Date: 2018-10-15
-- desc: 读取csb的工具类

local CSBUtil = {}

function CSBUtil.readLayerCSB(csbFilePath, owner)
	assert( csbFilePath," !! csbFilePath is nil !! ")
	assert( owner," !! owner is nil !! ")
    -- 读取csb
    local csb_node = cc.CSLoader:createNode(csbFilePath)
    CSBUtil.addOwnerVariable( owner,csb_node )
    csb_node:setContentSize(display.size)
    ccui.Helper:doLayout(csb_node)
    return csb_node
end

function CSBUtil.readNodeCSB(csbFilePath, owner)
	assert( csbFilePath," !! csbFilePath is nil !! ")
	assert( owner," !! owner is nil !! ")
    -- 读取csb
    local csb_node = cc.CSLoader:createNode(csbFilePath)
    CSBUtil.addOwnerVariable( owner,csb_node )
    return csb_node
end

function CSBUtil.addOwnerVariable( owner,node )
	local childs = node:getChildren()
	if #childs > 0 then
		for i,v in ipairs(childs) do
			local name = v:getName()
			if name and string.trim( name ) ~= "" then
				if owner[name] then
					assert( false," !! csb文件中存在同名的node name = "..name.." !!" )
				end
				owner[name] = v
			end
			CSBUtil.addOwnerVariable( owner,v )
		end
	end
end


function CSBUtil.addAndRunAction( csbFilePath,owner )
	local view = cc.CSLoader:createNode(csbFilePath)
	local action = cc.CSLoader:createTimeline(csbFilePath)
	owner:addChild(view,100)
	view:runAction(action)
	action:gotoFrameAndPlay(0,60, false)

	-- local rootNode = cc.CSLoader:createNode("csbmajiang/action/win.csb")
    -- self:addChild(rootNode,2)
    -- rootNode:setPosition( 638,336 )

    -- local action = cc.CSLoader:createTimeline("csbmajiang/action/win.csb")
    -- rootNode:runAction(action)
    -- action:gotoFrameAndPlay(0,60,false)
end

rawset(_G, "CSBUtil", CSBUtil)