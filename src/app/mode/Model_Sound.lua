

local Model_Sound = class("Model_Sound")

Model_Sound.State = {
	Open = 1,
	Closed = 2
}

function Model_Sound:ctor()
	self:reset()
end

function Model_Sound:reset()
	self._musicState = nil
	self._voiceState = nil
	self._musicVolume = nil
	self._effectVolume = nil
	self._mjmusicVolume = nil
	self._mjeffectVolume = nil
	self._cyjlmusicVolume = nil
	self._cyjleffectVolume = nil
end

function Model_Sound:getInstance()
	if not self._instance then
		self._instance = Model_Sound.new()
	end
	return self._instance
end


-- 背景音乐
function Model_Sound:isMusicOpen()
	if self._musicState == nil then
		local user_default = cc.UserDefault:getInstance()
		local scene_name = display.getRunningScene():getSceneName()
		if scene_name == "MainScene" then
			self._musicState = user_default:getIntegerForKey("playerMusicState", 1)
		elseif scene_name == "EliminateScene" then
			self._musicState = user_default:getIntegerForKey("eliPlayerMusicState", 1)
		elseif scene_name == "LaoHuJiScene" then
			self._musicState = user_default:getIntegerForKey("laohujiMusicState", 1)
		elseif scene_name == "TwentyOneScene" then
			self._musicState = user_default:getIntegerForKey("twentoneMusicState", 1)
		elseif scene_name == "JunShiScene" then
			self._musicState = user_default:getIntegerForKey("junshiMusicState", 1)
		elseif scene_name == "LaBaScene" then
			self._musicState = user_default:getIntegerForKey("labaMusicState", 1)
		elseif scene_name == "ZhiPaiScene" then
			self._musicState = user_default:getIntegerForKey("zhipaiMusicState", 1)
		elseif scene_name == "SanGuoScene" then
			self._musicState = user_default:getIntegerForKey("sanguoMusicState", 1)
		elseif scene_name == "ZhanDouScene" then
			self._musicState = user_default:getIntegerForKey("zhandouMusicState", 1)
		end
	end
	return self._musicState == 1
end
function Model_Sound:setMusicState( state )
	if self._musicState == state then
		return
	end
	self._musicState = state
	local user_default = cc.UserDefault:getInstance()
	local scene_name = display.getRunningScene():getSceneName()
	if scene_name == "MainScene" then
		user_default:setIntegerForKey("playerMusicState", state)
	elseif scene_name == "EliminateScene" then
		user_default:setIntegerForKey("eliPlayerMusicState", state)
	elseif scene_name == "LaoHuJiScene" then
		user_default:setIntegerForKey("laohujiMusicState", state)
	elseif scene_name == "TwentyOneScene" then
		user_default:setIntegerForKey("twentoneMusicState", state)
	elseif scene_name == "JunShiScene" then
		user_default:setIntegerForKey("junshiMusicState", state)
	elseif scene_name == "LaBaScene" then
		user_default:setIntegerForKey("labaMusicState", state)
	elseif scene_name == "ZhiPaiScene" then
		user_default:setIntegerForKey("zhipaiMusicState", state)
	elseif scene_name == "SanGuoScene" then
		user_default:setIntegerForKey("sanguoMusicState", state)
	elseif scene_name == "ZhanDouScene" then
		user_default:setIntegerForKey("zhandouMusicState", state)
	end
end

-- 音效
function Model_Sound:isVoiceOpen()
	if self._voiceState == nil then
		local user_default = cc.UserDefault:getInstance()
		local scene_name = display.getRunningScene():getSceneName()
		if scene_name == "MainScene" then
			self._voiceState = user_default:getIntegerForKey("playerVoiceState", 1)
		elseif scene_name == "EliminateScene" then
			self._voiceState = user_default:getIntegerForKey("eliPlayerVoiceState", 1)
		elseif scene_name == "LaoHuJiScene" then
			self._voiceState = user_default:getIntegerForKey("laohujirVoiceState", 1)
		elseif scene_name == "TwentyOneScene" then
			self._voiceState = user_default:getIntegerForKey("twentoneVoiceState", 1)
		elseif scene_name == "JunShiScene" then
			self._voiceState = user_default:getIntegerForKey("junshiVoiceState", 1)
		elseif scene_name == "LaBaScene" then
			self._voiceState = user_default:getIntegerForKey("labaVoiceState", 1)
		elseif scene_name == "ZhiPaiScene" then
			self._voiceState = user_default:getIntegerForKey("zhipaiVoiceState", 1)
		elseif scene_name == "SanGuoScene" then
			self._voiceState = user_default:getIntegerForKey("sanguoVoiceState", 1)
		elseif scene_name == "ZhanDouScene" then
			self._voiceState = user_default:getIntegerForKey("zhandouVoiceState", 1)
		end

	end
	return self._voiceState == 1
end

function Model_Sound:setVoiceState( state )
	if self._voiceState == state then
		return
	end
	self._voiceState = state
	local user_default = cc.UserDefault:getInstance()
	local scene_name = display.getRunningScene():getSceneName()
	if scene_name == "MainScene" then
		user_default:setIntegerForKey("playerVoiceState", state)
	elseif scene_name == "EliminateScene" then
		user_default:setIntegerForKey("eliPlayerVoiceState", state)
	elseif scene_name == "LaoHuJiScene" then
		user_default:setIntegerForKey("laohujirVoiceState", state)
	elseif scene_name == "TwentyOneScene" then
		user_default:setIntegerForKey("twentoneVoiceState", state)
	elseif scene_name == "JunShiScene" then
		user_default:setIntegerForKey("junshiVoiceState", state)
	elseif scene_name == "LaBaScene" then
		user_default:setIntegerForKey("labaVoiceState", state)
	elseif scene_name == "ZhiPaiScene" then
		user_default:setIntegerForKey("zhipaiVoiceState", state)
	elseif scene_name == "SanGuoScene" then
		user_default:setIntegerForKey("sanguoVoiceState", state)
	elseif scene_name == "ZhanDouScene" then
		user_default:setIntegerForKey("zhandouVoiceState", state)
	end
end

function Model_Sound:playBgMusic()
	local scene_name = display.getRunningScene():getSceneName()
	if scene_name == "MainScene" then
		if self:isMusicOpen() then
			audio.playMusic("mp3/music.mp3",true)
		end
	elseif scene_name == "EliminateScene" then
		if self:isMusicOpen() then
			audio.playMusic("elimp3/bgmusic.mp3",true)
		end
	elseif scene_name == "TwentyFourScene" then
		audio.playMusic("tfmp3/bgmusic.mp3",true)
	elseif scene_name == "MaJiangScene" then
		audio.playMusic("mjmp3/bg_game.mp3",true)
	elseif scene_name == "LaoHuJiScene" then
		if self:isMusicOpen() then
			audio.playMusic("lhjmp3/game_bg.mp3",true)
		end
	elseif scene_name == "ChengYuScene" then
		audio.playMusic("cyjlmp3/bg.mp3",true)
	elseif scene_name == "TwentyOneScene" then
		if self:isMusicOpen() then
			audio.playMusic("tomp3/dating.mp3",true)
		end
	elseif scene_name == "JunShiScene" then
		if self:isMusicOpen() then
			audio.playMusic("jsmp3/game.mp3",true)
		end
	elseif scene_name == "LaBaScene" then
		if self:isMusicOpen() then
			audio.playMusic("labamp3/bgmusic.mp3",true)
		end
	elseif scene_name == "ZhiPaiScene" then
		if self:isMusicOpen() then
			audio.playMusic("zpmp3/mainScene.mp3",true)
		end
	elseif scene_name == "SanGuoScene" then
		if self:isMusicOpen() then
			audio.playMusic("sgmp3/bg.mp3",true)
		end
	elseif scene_name == "ZhanDouScene" then
		if self:isMusicOpen() then
			audio.playMusic("zdmp3/bg.mp3",true)
		end
	end
end

function Model_Sound:stopPlayBgMusic()
	local scene_name = display.getRunningScene():getSceneName()
	if scene_name == "MainScene" then
		audio.stopMusic(false)
	elseif scene_name == "EliminateScene" then
		audio.stopMusic(false)
	elseif scene_name == "TwentyFourScene" then
		audio.stopMusic(false)
	elseif scene_name == "LaoHuJiScene" then
		audio.stopMusic(false)
	elseif scene_name == "TwentyOneScene" then
		audio.stopMusic(false)
	elseif scene_name == "JunShiScene" then
		audio.stopMusic(false)
	elseif scene_name == "LaBaScene" then
		audio.stopMusic(false)
	elseif scene_name == "ZhiPaiScene" then
		audio.stopMusic(false)
	elseif scene_name == "SanGuoScene" then
		audio.stopMusic(false)
	elseif scene_name == "ZhanDouScene" then
		audio.stopMusic(false)
	end
end

-- 按钮点击播放的音效
function Model_Sound:playVoice( voicePath )
	local scene_name = display.getRunningScene():getSceneName()
	if scene_name == "MainScene" then
		if self:isVoiceOpen() then
			audio.playSound("mp3/voice.mp3", false)
		end
	elseif scene_name == "EliminateScene" then
		if self:isVoiceOpen() then
			audio.playSound("elimp3/click.mp3", false)
		end
	elseif scene_name == "TwentyFourScene" then
		if voicePath == nil then
			audio.playSound("tfmp3/btn.mp3", false)
		else
			audio.playSound(voicePath, false)
		end
	elseif scene_name == "MaJiangScene" then
		audio.playSound("mjmp3/btn.mp3", false)
	elseif scene_name == "LaoHuJiScene" then
		if self:isVoiceOpen() then
			audio.playSound("lhjmp3/btn_bubble.mp3", false)
		end
	elseif scene_name == "ChengYuScene" then
		audio.playSound("cyjlmp3/button_s.mp3", false)
	elseif scene_name == "TwentyOneScene" then
		if self:isVoiceOpen() then
			audio.playSound("tomp3/selectpoker.mp3", false)
		end
	elseif scene_name == "JunShiScene" then
		if self:isVoiceOpen() then
			audio.playSound("jsmp3/button.mp3", false)
		end
	elseif scene_name == "LaBaScene" then
		if self:isVoiceOpen() then
			audio.playSound("labamp3/button.mp3", false)
		end
	elseif scene_name == "ZhiPaiScene" then
		if self:isVoiceOpen() then
			audio.playSound("zpmp3/btn_bubble.mp3", false)
		end
	elseif scene_name == "SanGuoScene" then
		if self:isVoiceOpen() then
			audio.playSound("sgmp3/button.mp3", false)
		end
	elseif scene_name == "ZhanDouScene" then
		if self:isVoiceOpen() then
			audio.playSound("zdmp3/button.mp3", false)
		end
	end
end

-- 保存音量大小( 只针对24点 )
function Model_Sound:getVolume()
	local scene_name = display.getRunningScene():getSceneName()
	if scene_name == "TwentyFourScene" then
		if self._musicVolume == nil then
			local user_default = cc.UserDefault:getInstance()
			self._musicVolume = user_default:getFloatForKey("tfMusicVolume", 1.0)
		end
		if self._effectVolume == nil then
			local user_default = cc.UserDefault:getInstance()
			self._effectVolume = user_default:getFloatForKey("tfEffectVolume", 1.0)
		end
		return self._musicVolume,self._effectVolume
	elseif scene_name == "MaJiangScene" then
		if self._mjmusicVolume == nil then
			local user_default = cc.UserDefault:getInstance()
			self._mjmusicVolume = user_default:getFloatForKey("mjMusicVolume", 1.0)
		end
		if self._mjeffectVolume == nil then
			local user_default = cc.UserDefault:getInstance()
			self._mjeffectVolume = user_default:getFloatForKey("mjEffectVolume", 1.0)
		end
		return self._mjmusicVolume,self._mjeffectVolume
	elseif scene_name == "ChengYuScene" then
		if self._cyjlmusicVolume == nil then
			local user_default = cc.UserDefault:getInstance()
			self._cyjlmusicVolume = user_default:getFloatForKey("cyjlMusicVolume", 1.0)
		end
		if self._cyjleffectVolume == nil then
			local user_default = cc.UserDefault:getInstance()
			self._cyjleffectVolume = user_default:getFloatForKey("cyjlEffectVolume", 1.0)
		end
		return self._cyjlmusicVolume,self._cyjleffectVolume
	end
	return 1.0,1.0
end

function Model_Sound:saveVolume( musicVolume,effectVolume )
	local scene_name = display.getRunningScene():getSceneName()
	if scene_name == "TwentyFourScene" then
		if self._musicVolume ~= musicVolume then
			self._musicVolume = musicVolume
			local user_default = cc.UserDefault:getInstance()
			user_default:setFloatForKey("tfMusicVolume", musicVolume)
		end
		if self._effectVolume ~= effectVolume then
			self._effectVolume = effectVolume
			local user_default = cc.UserDefault:getInstance()
			user_default:setFloatForKey("tfEffectVolume", effectVolume)
		end
	elseif scene_name == "MaJiangScene" then
		if self._mjmusicVolume ~= musicVolume then
			self._mjmusicVolume = musicVolume
			local user_default = cc.UserDefault:getInstance()
			user_default:setFloatForKey("mjMusicVolume", musicVolume)
		end
		if self._mjeffectVolume ~= effectVolume then
			self._mjeffectVolume = effectVolume
			local user_default = cc.UserDefault:getInstance()
			user_default:setFloatForKey("mjEffectVolume", effectVolume)
		end
	elseif scene_name == "ChengYuScene" then
		if self._cyjlmusicVolume ~= musicVolume then
			self._cyjlmusicVolume = musicVolume
			local user_default = cc.UserDefault:getInstance()
			user_default:setFloatForKey("cyjlMusicVolume", musicVolume)
		end
		if self._cyjleffectVolume ~= effectVolume then
			self._cyjleffectVolume = effectVolume
			local user_default = cc.UserDefault:getInstance()
			user_default:setFloatForKey("cyjlEffectVolume", effectVolume)
		end
	end
end

return Model_Sound