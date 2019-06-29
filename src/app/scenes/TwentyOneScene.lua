
--
-- Author: 	刘阳
-- Date: 	2019-05-04
-- Desc:	21点主场景


cc.FileUtils:getInstance():addSearchPath("res/csbtwentyone")

local UIManager = import("app.framework.UIManager")


local TwentyOneScene = class("TwentyOneScene",function()
	return display.newScene("TwentyOneScene")
end)


function TwentyOneScene:ctor()
	self:loadAppFile()
	self._uiManager = UIManager.new( self )
	self:init()
end


function TwentyOneScene:loadAppFile()
	import("app.viewstwentyone.config.twenty_one_poker_config")
end


function TwentyOneScene:init()
	-- 需要延迟执行 不然此时( display.getRunningScene() 取不到值 )
	local delay = cc.DelayTime:create(0.1)
	local call = cc.CallFunc:create( function()
		-- 创建LoadingUI
		addUIToScene( UIDefine.TWENTYONE_KEY.Loading_UI )
	end )
	local seq = cc.Sequence:create({ delay,call })
	self:runAction(seq)
end



function TwentyOneScene:getSceneName()
	return "TwentyOneScene"
end

function TwentyOneScene:getUIManager()
	return self._uiManager
end







return TwentyOneScene