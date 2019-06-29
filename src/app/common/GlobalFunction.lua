
--
-- Author: 	刘阳
-- Date: 	2017-11-07
-- Desc:    一些通用方法的接口

--[[
	uiParam:对应 UIDefine.UI_KEY 里面的参数
	data:要传递给要创建的layer的参数
]]
local function addUIToScene( uiParam,data )
	assert( uiParam," !! uiParam is nil !! ")
	assert( type(uiParam) == "table", " !! uiParam type is error !! ")
	assert( uiParam.layer," !! uiParam.layer is nil !! ")
	assert( uiParam.name," !! uiParam.name is nil !! ")
	assert( uiParam.flag," !! uiParam.flag is nil !! ")

	local uiManager = display.getRunningScene():getUIManager()
	assert( uiManager," !! uiManager is nil !! ")

	local param = { name = uiParam.name,data = data }
	local layer = uiParam.layer.new( param )
	uiManager:addLayer( layer,uiParam.flag )
	return layer
end

local function removeUIFromScene( uiParam )
	assert( uiParam," !! uiParam is nil !! ")
	assert( type(uiParam) == "table", " !! uiParam type is error !! ")
	assert( uiParam.layer," !! uiParam.layer is nil !! ")
	assert( uiParam.name," !! uiParam.name is nil !! ")
	assert( uiParam.flag," !! uiParam.flag is nil !! ")
	local uiManager = display.getRunningScene():getUIManager()
	assert( uiManager," !! uiManager is nil !! ")
	uiManager:removeLayer( uiParam.name,uiParam.flag )
end

local function getUIFromScene( uiParam )
	assert( uiParam," !! uiParam is nil !! ")
	assert( type(uiParam) == "table", " !! uiParam type is error !! ")
	assert( uiParam.layer," !! uiParam.layer is nil !! ")
	assert( uiParam.name," !! uiParam.name is nil !! ")
	assert( uiParam.flag," !! uiParam.flag is nil !! ")
	local uiManager = display.getRunningScene():getUIManager()
	assert( uiManager," !! uiManager is nil !! ")
	local layer = uiManager:getLayer( uiParam.name,uiParam.flag )
	return layer
end

--[[ 将一维数组转化为二维数组 ]]
local function getMatrixDataByColumn( finalData,sourceData,columCount )
	assert( finalData, " !! finalData is nil !! ")
	assert( type( finalData ) == "table", " !! finalData type must be table !! " )
	assert( sourceData, " !! sourceData is nil !! ")
	assert( columCount, " !! columCount is nil !! ")
	assert( columCount > 0, " !! columCount must > 0 !! ")

	local totalNum  = #sourceData
	local columnNum = columCount
	local rowNum = math.ceil( totalNum / columnNum )
	for i = 1,rowNum do
		local row = {}
		table.insert( finalData,row )

		if i < rowNum then
			for j = 1,columnNum do
				local data = sourceData[ ( i - 1 ) * columnNum + j ]
				table.insert( row,data )
			end
		else
			local cl = totalNum % columnNum

			if cl == 0 then
				cl = columnNum
			end

			for j = 1,cl do
				local data = sourceData[ ( i - 1 ) * columnNum + j ]
				table.insert( row,data )
			end
		end
	end
end

local function G_GetModel( modelName )
	assert( modelName," !! modelName is nil !! ")
	return ModelRegister:getInstance():getModel( modelName )
end

local function formatTimeStr( second,formatStr )
    assert( second," !! second is nil !! ")
    local str = ""
    local days, hours, minutes, seconds = getFormatTime( second )
    if days > 0 then
        str = str..days..formatStr
    end
    if hours > 0 then
        str = str..hours..formatStr
    end
    if minutes >= 0 then
        str = str..string.format("%02d",minutes)..formatStr
    end
    if seconds >= 0 then
        str = str..string.format("%02d",seconds)
    end
    return str
end

local function formatMinuTimeStr( second,formatStr )
    assert( second," !! second is nil !! ")
    local str = ""
    local total_minutes = 0
    local days, hours, minutes, seconds = getFormatTime( second )
    if days > 0 then
        total_minutes = days * 24 * 60
    end
    if hours > 0 then
        total_minutes = total_minutes + hours * 60
    end
    if minutes >= 0 then
        total_minutes = total_minutes + minutes
    end
    str = str..string.format("%02d",total_minutes)..formatStr
    if seconds >= 0 then
        str = str..string.format("%02d",seconds)
    end
    return str
end

local function UIScaleShowAction( node )
	assert( node," !! node is nil !! " )
	node:setScale(0.9)
	local scale_to1 = cc.ScaleTo:create(0.1,1.2)
	local scale_to2 = cc.ScaleTo:create(0.1,1)
	local seq = cc.Sequence:create({scale_to1,scale_to2})
	node:runAction(seq)
end

local function dynamicUpdateNum( labelNode,addNum,beforeNum,endFunc )
	assert( labelNode," !! labelNode is nil !! ")
    assert( addNum," !! addNum is nil !! ")
    assert( beforeNum," !! beforeNum is nil !! ")
    local meta = addNum / 5
    local before = beforeNum
    local after  = before + addNum
	labelNode:runAction(cc.RepeatForever:create( cc.Sequence:create(
        cc.DelayTime:create(0.1),
        cc.CallFunc:create(function()
        	local stop = false
	        before = before + meta
	        if meta > 0 then
	            if before >= after then
	                stop = true
	            end
	        elseif meta < 0 then
	            if before <= after then
	                stop = true
	            end
	        else
	            stop = true
	        end

	        if stop == true then
	            labelNode:setString(tostring(math.floor(after)))
	            labelNode:stopAllActions()
	            if endFunc then
	            	endFunc()
	            end
	        else
	        	labelNode:setString(tostring(math.floor(before)))
	        end
        end)
        )
    ))
end

-- 变暗
local function darkSprite(sprite, value)
    local darkGLProgramState = SFShader.getDarkGLProgramState(value)
    sprite:setGLProgramState(darkGLProgramState)
end

-- 变白
-- r, g, b 为浮点类型
local function whiteSprite(sprite, value)
    if not value then value = 100.0 end
    local whiteGLProgramState = SFShader.getWhiteGLProgramState(value)
    sprite:setGLProgramState(whiteGLProgramState)
end

-- 变红
local function redSprite(sprite)
    local whiteGLProgramState = SFShader.getRedGLProgramState()
    sprite:setGLProgramState(whiteGLProgramState)
end

-- 变灰
local function graySprite(sprite)
    local grayGLProgramState = SFShader.getGrayGLProgramState(0.3, 0.3, 0.3)
    sprite:setGLProgramState(grayGLProgramState)
end

-- 恢复
local function ungraySprite(sprite)
    local normalGLProgram = cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")
    local glProgramState = cc.GLProgramState:getOrCreateWithGLProgram(normalGLProgram)  
    sprite:setGLProgramState(glProgramState)
end

-- 外发光
local function strokeSprite(sprite, color)
    if not color then color = cc.c3b(255, 241, 191) end
    local grayGLProgramState = SFShader.getStrokeProgramState(0.01, color, 0.4)
    sprite:setGLProgramState(grayGLProgramState)    
end

-- 去掉外发光
local function unstrokeSprite(sprite)
    local normalGLProgram = cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")
    sprite:setGLProgram(normalGLProgram)
end

-- 连级淡入 包括子孙
local function casecadeFadeInNode(node, fadeInTime,opacity)
    -- 递归修改标志位
    local function setChildsCascade(n)
        local cc_array = n:getChildren()
        for i = 1, #cc_array do
            local children = cc_array[i]
            children:setCascadeOpacityEnabled(true)
            children:setCascadeColorEnabled(true)
            -- children:setOpacity(0)
            setChildsCascade(children)
        end
    end
    node:setCascadeOpacityEnabled(true)
    node:setCascadeColorEnabled(true)
    node:setOpacity(0)
    setChildsCascade(node)
    if opacity then
    	node:runAction(cc.FadeTo:create(fadeInTime,opacity))
    else
    	node:runAction(cc.FadeIn:create(fadeInTime))
    end
end

local function G_ShowTips( str )
	assert( str," !! str is nil !! " )
	local scene = display.getRunningScene()
	if scene and scene:getSceneName() == "LaoHuJiScene" then
		local tips = scene:getChildByTag( 456814 )
		if tips == nil then
			tips = require("app.viewslaohuji.Tips").new()
			tips:setTag( 456814 )
			scene:addChild( tips,900001 )
		end
		tips:stopAllActions()
		tips:setPosition( cc.p( display.cx,display.cy + 100 ) )
		tips:setVisible( true )
		tips:loadUIData( str )
		local move_by = cc.MoveBy:create( 2,cc.p( 0,100 ) )
		local call_vi = cc.CallFunc:create( function()
			tips:setVisible( false )
		end )
		local seq = cc.Sequence:create({ move_by,call_vi })
		tips:runAction( seq )
	end
end

local function G_AddNodeClick( node,param )
	assert( node," !! node is nil !! " )
	node:setTouchEnabled( true )
	node:onTouch( function( event )
		if event.name == "began" then
			if param.beganCallBack then
				param.beganCallBack()
			end
		elseif event.name == "moved" then
			if param.movedCallBack then
				param.movedCallBack()
			end
		elseif event.name == "ended" then
			if param.endedCallBack then
				param.endedCallBack()
			end
		elseif event.name == "cancelled" then
			if param.cancelCallBack then
				param.cancelCallBack()
			end
		end
	end )
end


rawset(_G, "addUIToScene", addUIToScene)
rawset(_G, "removeUIFromScene", removeUIFromScene)
rawset(_G, "getMatrixDataByColumn", getMatrixDataByColumn)
rawset(_G, "G_GetModel", G_GetModel)
rawset(_G, "formatTimeStr", formatTimeStr)
rawset(_G, "UIScaleShowAction", UIScaleShowAction)
rawset(_G, "darkSprite", darkSprite)
rawset(_G, "whiteSprite", whiteSprite)
rawset(_G, "redSprite", redSprite)
rawset(_G, "graySprite", graySprite)
rawset(_G, "ungraySprite", ungraySprite)
rawset(_G, "strokeSprite", strokeSprite)
rawset(_G, "unstrokeSprite", unstrokeSprite)
rawset(_G, "casecadeFadeInNode", casecadeFadeInNode)
rawset(_G, "dynamicUpdateNum", dynamicUpdateNum)
rawset(_G, "formatMinuTimeStr", formatMinuTimeStr)
rawset(_G, "G_ShowTips", G_ShowTips)
rawset(_G, "G_AddNodeClick", G_AddNodeClick)