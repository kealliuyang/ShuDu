
--
-- Author: 	刘阳
-- Date: 	2018-11-07 11:04:00
-- Desc:	主场景

local UIManager = import("app.framework.UIManager")

local MainScene = class("MainScene",function()
	return display.newScene("MainScene")
end)

function MainScene:ctor()
	
	local _t = os.clock()
	print("plist 声音 加载 开始读取 ")
	cc.SpriteFrameCache:getInstance():addSpriteFrames("csb/Plist1.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("csb/Plist2.plist")
    audio.preloadMusic("mp3/music.mp3")
    audio.preloadSound("mp3/voice.mp3")
    print("Model 加载读取完毕!所需秒:"..(os.clock() - _t))

	self._uiManager = UIManager.new( self )
	self:init()
end

function MainScene:init()
	-- 需要延迟执行 不然此时( display.getRunningScene() 取不到值 )
	local delay = cc.DelayTime:create(0.1)
	local call = cc.CallFunc:create( function()
		-- 创建StartUi
		addUIToScene( UIDefine.UI_KEY.Start_UI )
		-- 打开背景音乐
		G_GetModel("Model_Sound"):playBgMusic()
	end )
	local seq = cc.Sequence:create({ delay,call })
	self:runAction(seq)
end





function MainScene:getSceneName()
	return "MainScene"
end

function MainScene:getUIManager()
	return self._uiManager
end















return MainScene