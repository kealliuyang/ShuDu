
--
-- Author: 	刘阳
-- Date: 	2019-03-30
-- Desc:	老虎机主场景

cc.FileUtils:getInstance():addSearchPath("res/csblaohuji")
cc.FileUtils:getInstance():addSearchPath("res/csblaohuji/lhjmp3")


local UIManager = import("app.framework.UIManager")

local LaoHuJiScene = class("LaoHuJiScene",function()
	return display.newScene("LaoHuJiScene")
end)


function LaoHuJiScene:ctor()
	self:enableNodeEvents()
	self:loadAppFile()
	self._uiManager = UIManager.new( self )
end


function LaoHuJiScene:loadAppFile()
	import("app.viewslaohuji.config.lhj_config")
end


function LaoHuJiScene:onEnter()
	-- 需要延迟执行 不然此时( display.getRunningScene() 取不到值 )
	local delay = cc.DelayTime:create(0.1)
	local call = cc.CallFunc:create( function()
		-- 创建LoadingUI
		addUIToScene( UIDefine.LAOHUJI_KEY.Loading_UI )
	end )
	local seq = cc.Sequence:create({ delay,call })
	self:runAction(seq)
end

function LaoHuJiScene:getSceneName()
	return "LaoHuJiScene"
end

function LaoHuJiScene:getUIManager()
	return self._uiManager
end


return LaoHuJiScene