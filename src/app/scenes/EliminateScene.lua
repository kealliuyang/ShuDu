
--
-- Author: 	刘阳
-- Date: 	2018-11-07 11:04:00
-- Desc:	主场景


cc.FileUtils:getInstance():addSearchPath("res/csbEliminate")

local UIManager = import("app.framework.UIManager")

local EliminateScene = class("EliminateScene",function()
	return display.newScene("EliminateScene")
end)

function EliminateScene:ctor()
	self:loadAppFile()
	
	local _t = os.clock()
	print("plist 声音 加载 开始读取 ")
	cc.SpriteFrameCache:getInstance():addSpriteFrames("csbEliminate/PlistEli1.plist")
	audio.preloadSound("elimp3/click.mp3")
    audio.preloadSound("elimp3/game_over.mp3")
    audio.preloadSound("elimp3/in.mp3")
    audio.preloadSound("elimp3/most.mp3")
    audio.preloadSound("elimp3/move.mp3")
    audio.preloadSound("elimp3/put.mp3")
    audio.preloadSound("elimp3/xiaochu.mp3")
    audio.preloadSound("elimp3/xiaochu1.mp3")
    audio.preloadMusic("elimp3/bgmusic.mp3")
    print("Model 加载读取完毕!所需秒:"..(os.clock() - _t))

	self._uiManager = UIManager.new( self )
	self:init()
end

function EliminateScene:loadAppFile()
	import("app.viewseliminate.Block.block_config")
	import("app.viewseliminate.Block.advanced_config")
end

function EliminateScene:init()
	-- 需要延迟执行 不然此时( display.getRunningScene() 取不到值 )
	local delay = cc.DelayTime:create(0.1)
	local call = cc.CallFunc:create( function()
		-- 创建StartUi
		addUIToScene( UIDefine.ELIMI_KEY.Start_UI )
		-- 打开背景音乐
		G_GetModel("Model_Sound"):playBgMusic()
	end )
	local seq = cc.Sequence:create({ delay,call })
	self:runAction(seq)
end



function EliminateScene:getSceneName()
	return "EliminateScene"
end

function EliminateScene:getUIManager()
	return self._uiManager
end




return EliminateScene