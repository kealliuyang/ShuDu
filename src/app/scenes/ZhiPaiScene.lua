
--
-- Author: 	刘阳
-- Date: 	2019-06-02
-- Desc:	纸牌场景


cc.FileUtils:getInstance():addSearchPath("res/csbzhipai")


local UIManager = import("app.framework.UIManager")

local ZhiPaiScene = class("ZhiPaiScene",function()
	return display.newScene("ZhiPaiScene")
end)


function ZhiPaiScene:ctor()
	self:enableNodeEvents()
	self:loadAppFile()
	self._uiManager = UIManager.new( self )
end



function ZhiPaiScene:loadAppFile()
	import("app.viewszhipai.config.zhipai_config")
end



function ZhiPaiScene:onEnter()
	-- 创建LoadingUI
	addUIToScene( UIDefine.ZHIPAI_KEY.Loading_UI )
end

function ZhiPaiScene:getSceneName()
	return "ZhiPaiScene"
end

function ZhiPaiScene:getUIManager()
	return self._uiManager
end



return ZhiPaiScene