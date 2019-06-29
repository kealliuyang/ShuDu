
--
-- Author: 	刘阳
-- Date: 	2019-04-27
-- Desc:	成语接龙场景


cc.FileUtils:getInstance():addSearchPath("res/csbchengyujielong")


local UIManager = import("app.framework.UIManager")

local ChengYuScene = class("ChengYuScene",function()
	return display.newScene("ChengYuScene")
end)


function ChengYuScene:ctor()
	self:loadAppFile()
	self._uiManager = UIManager.new( self )
	self:init()
end



function ChengYuScene:loadAppFile()
	import("app.viewschengyujielong.config.cyjl_config")
end



function ChengYuScene:init()
	-- 需要延迟执行 不然此时( display.getRunningScene() 取不到值 )
	local delay = cc.DelayTime:create(0.1)
	local call = cc.CallFunc:create( function()
		-- 设置音量
		local musicVolume,effectVolume = G_GetModel("Model_Sound"):getVolume()
		audio.setMusicVolume(musicVolume)
		audio.setSoundsVolume(effectVolume)
		-- 创建LoadingUI
		addUIToScene( UIDefine.CHENGYUJIELONG_KEY.Loading_UI )
	end )
	local seq = cc.Sequence:create({ delay,call })
	self:runAction(seq)
end

function ChengYuScene:getSceneName()
	return "ChengYuScene"
end

function ChengYuScene:getUIManager()
	return self._uiManager
end



return ChengYuScene