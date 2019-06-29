
--
-- Author: 	刘阳
-- Date: 	2019-02-14 11:04:00
-- Desc:	麻将主场景

cc.FileUtils:getInstance():addSearchPath("res/csbmajiang")
cc.FileUtils:getInstance():addSearchPath("res/csbmajiang/mjmp3")


local UIManager = import("app.framework.UIManager")

local MaJiangScene = class("MaJiangScene",function()
	return display.newScene("MaJiangScene")
end)


function MaJiangScene:ctor()
	self:loadAppFile()

	self._uiManager = UIManager.new( self )
	self:init()
end


function MaJiangScene:loadAppFile()
	import("app.viewsmajiang.config.path_config")
	-- import("app.viewstwentyfour.config.quest_config")
end


function MaJiangScene:init()
	-- 需要延迟执行 不然此时( display.getRunningScene() 取不到值 )
	local delay = cc.DelayTime:create(0.1)
	local call = cc.CallFunc:create( function()
		-- 设置音量
		local musicVolume,effectVolume = G_GetModel("Model_Sound"):getVolume()
		audio.setMusicVolume(musicVolume)
		audio.setSoundsVolume(effectVolume)
		-- 创建LoadingUI
		addUIToScene( UIDefine.MAJIANG_KEY.Loading_UI )
	end )
	local seq = cc.Sequence:create({ delay,call })
	self:runAction(seq)
end

function MaJiangScene:getSceneName()
	return "MaJiangScene"
end

function MaJiangScene:getUIManager()
	return self._uiManager
end


return MaJiangScene