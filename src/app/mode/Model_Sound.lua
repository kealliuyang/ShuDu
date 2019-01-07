

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
		self._musicState = user_default:getIntegerForKey("playerMusicState", 1)
	end
	return self._musicState == 1
end
function Model_Sound:setMusicState( state )
	if self._musicState == state then
		return
	end
	self._musicState = state
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey("playerMusicState", state)
end

-- 音效
function Model_Sound:isVoiceOpen()
	if self._voiceState == nil then
		local user_default = cc.UserDefault:getInstance()
		self._voiceState = user_default:getIntegerForKey("playerVoiceState", 1)
	end
	return self._voiceState == 1
end

function Model_Sound:setVoiceState( state )
	if self._voiceState == state then
		return
	end
	self._voiceState = state
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey("playerVoiceState", state)
end

function Model_Sound:playBgMusic()
	if self:isMusicOpen() then
		audio.playMusic("mp3/music.mp3",true)
	end
end

function Model_Sound:stopPlayBgMusic()
	audio.stopMusic(false)
end

-- 按钮点击播放的音效
function Model_Sound:playVoice()
	local scene_name = display.getRunningScene():getSceneName()
	if scene_name == "MainScene" then
		if self:isVoiceOpen() then
			audio.playSound("mp3/voice.mp3", false)
		end
	elseif scene_name == "EliminateScene" then
		audio.playSound("elimp3/click.mp3", false)
	end
end


return Model_Sound