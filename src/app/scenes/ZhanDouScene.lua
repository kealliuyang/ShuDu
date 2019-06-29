
--
-- Author: 	刘智勇
-- Date: 	2019-06-22
-- Desc:	战斗场景


cc.FileUtils:getInstance():addSearchPath("res/csbzhandou")


local UIManager = import("app.framework.UIManager")

local ZhanDouScene = class("ZhanDouScene",function()
	return display.newScene("ZhanDouScene")
end)


function ZhanDouScene:ctor()
	self:enableNodeEvents()
	self:loadAppFile()
	self._uiManager = UIManager.new( self )
end



function ZhanDouScene:loadAppFile()
	import("app.viewszhandou.config.zhandou_config")
end



function ZhanDouScene:onEnter()
	-- 创建LoadingUI
	addUIToScene( UIDefine.ZHANDOU_KEY.Loading_UI )
end

function ZhanDouScene:getSceneName()
	return "ZhanDouScene"
end

function ZhanDouScene:getUIManager()
	return self._uiManager
end



return ZhanDouScene