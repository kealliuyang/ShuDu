
local EnterApp = class("EnterApp")

function EnterApp:ctor()
	-- self:loadAppFile()
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

function EnterApp:create()
	print(">>>>>EnterApp:create<<<<<<")
	self:loadAppFile()
	local scene = require("app.scenes.ZhanDouScene").new()
	return scene
end

function EnterApp:run()
	-- -- 进入主场景
	-- local scene = require("app.scenes.MainScene").new()
	-- display.runScene(scene)

	-- -- 进入方块消除主场景
	-- local scene = require("app.scenes.EliminateScene").new()
	-- display.runScene(scene)

	-- -- 进入24点场景
	-- local scene = require("app.scenes.TwentyFourScene").new()
	-- display.runScene(scene)

	-- -- 进入麻将场景
	-- local scene = require("app.scenes.MaJiangScene").new()
	-- display.runScene(scene)

	-- -- 进入老虎机场景
	-- local scene = require("app.scenes.LaoHuJiScene").new()
	-- display.runScene(scene)

	-- -- 进入成语接龙场景
	-- local scene = require("app.scenes.ChengYuScene").new()
	-- display.runScene(scene)

	-- -- 进入21点场景
	-- local scene = require("app.scenes.TwentyOneScene").new()
	-- display.runScene(scene)

	-- -- 进入军师场景
	-- local scene = require("app.scenes.JunShiScene").new()
	-- display.runScene(scene)

	-- -- 进入拉霸场景
	-- local scene = require("app.scenes.LaBaScene").new()
	-- display.runScene(scene)

	-- -- 进入纸牌场景
	-- local scene = require("app.scenes.ZhiPaiScene").new()
	-- display.runScene(scene)

	-- -- 进入三国场景
	-- local scene = require("app.scenes.SanGuoScene").new()
	-- display.runScene(scene)

	-- -- 进入战斗场景
	-- local scene = require("app.scenes.ZhanDouScene").new()
	-- display.runScene(scene)
end




return EnterApp