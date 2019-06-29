
--
-- Author: 	刘阳
-- Date: 	2019-06-02
-- Desc:	纸牌场景


cc.FileUtils:getInstance():addSearchPath("res/csbsanguo")


local UIManager = import("app.framework.UIManager")

local SanGuoScene = class("SanGuoScene",function()
	return display.newScene("SanGuoScene")
end)


function SanGuoScene:ctor()
	self:enableNodeEvents()
	self:loadAppFile()
	self._uiManager = UIManager.new( self )
end



function SanGuoScene:loadAppFile()
	import("app.viewssanguo.config.sanguo_config")
end



function SanGuoScene:onEnter()
	-- 创建LoadingUI
	addUIToScene( UIDefine.SANGUO_KEY.Loading_UI )
end

function SanGuoScene:getSceneName()
	return "SanGuoScene"
end

function SanGuoScene:getUIManager()
	return self._uiManager
end



return SanGuoScene