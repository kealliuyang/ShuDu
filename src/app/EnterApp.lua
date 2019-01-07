
local EnterApp = class("EnterApp")
local MainScene = import("app.scenes.MainScene")

function EnterApp:ctor()
	self:loadAppFile()

	if CC_SHOW_FPS then
        cc.Director:getInstance():setDisplayStats(true)
    end
end

-- 加载必要的文件
function EnterApp:loadAppFile()
	import("app.common.EasyFunc")
	import("app.event.InnerProtocol")
	import("app.event.NetProtocol")
	import("app.event.EventManager")
	import("app.base.BaseNode")
	import("app.base.BaseLayer")
	import("app.base.BaseTable")
	import("app.framework.CSBUtil")
	import("app.framework.UIDefine")
	import("app.framework.TouchNode")
	import("app.framework.ModelRegister")
	import("app.common.SFShader")
	import("app.common.GlobalFunction")
	import("app.config.quest_config")

	ModelRegister:getInstance():registAll()
end

function EnterApp:run()
	-- -- 进入主场景
	-- local scene = MainScene.new()
	-- display.runScene(scene)

	-- 进入方块消除主场景
	local scene = require("app.scenes.EliminateScene").new()
	display.runScene(scene)
end




return EnterApp