
--
-- Author: 	刘阳
-- Date: 	2018-11-07 11:04:00
-- Desc:	主场景


cc.FileUtils:getInstance():addSearchPath("res/csbtwentyfour")

local UIManager = import("app.framework.UIManager")

local TwentyFourScene = class("TwentyFourScene",function()
	return display.newScene("TwentyFourScene")
end)

function TwentyFourScene:ctor()
	self:loadAppFile()
	
	local _t = os.clock()
	print("plist 声音 加载 开始读取 ")
	cc.SpriteFrameCache:getInstance():addSpriteFrames("csbtwentyfour/Plist1.plist")
	audio.preloadMusic("tfmp3/bgmusic.mp3")
	audio.preloadSound("tfmp3/btn.mp3")
	audio.preloadSound("tfmp3/card.mp3")
	audio.preloadSound("tfmp3/combine.mp3")
	audio.preloadSound("tfmp3/reset.mp3")
	audio.preloadSound("tfmp3/success.mp3")
	audio.preloadSound("tfmp3/wrong.mp3")
    print("Model 加载读取完毕!所需秒:"..(os.clock() - _t))

	self._uiManager = UIManager.new( self )
	self:init()
end

function TwentyFourScene:loadAppFile()
	import("app.viewstwentyfour.config.lang_config")
	import("app.viewstwentyfour.config.quest_config")
end

function TwentyFourScene:init()
	-- 需要延迟执行 不然此时( display.getRunningScene() 取不到值 )
	local delay = cc.DelayTime:create(0.1)
	local call = cc.CallFunc:create( function()
		-- 创建StartUi
		addUIToScene( UIDefine.TWENTYFOUR_KEY.Start_UI )
		-- 打开背景音乐
		G_GetModel("Model_Sound"):playBgMusic()
	end )
	local seq = cc.Sequence:create({ delay,call })
	self:runAction(seq)
end



function TwentyFourScene:getSceneName()
	return "TwentyFourScene"
end

function TwentyFourScene:getUIManager()
	return self._uiManager
end




return TwentyFourScene