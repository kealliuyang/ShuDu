

local GameLoading = class("GameLoading",BaseLayer)



function GameLoading:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameLoading.super.ctor( self,param.name )
    self:addCsb( "csblaba/Loading.csb" )

    self._plist = {
		"csblaba/Plist1.plist",
		"csblaba/Plist2.plist",
		"csblaba/Plist3.plist",
		"csblaba/Plist4.plist",
		"csblaba/Plist5.plist"
	}
	self._music = {
		"labamp3/bgmusic.mp3",
	}
	self._sound = {
		"labamp3/button.mp3",
		"labamp3/machine.mp3",
		"labamp3/noreward.mp3",
		"labamp3/reward.mp3",
	}


	-- 进度条动画
	self._index = 0
	self._total = 50
	self:setLoadingBar()

	schedule( self.LoadingBar, function()
		self._index = self._index + 1
		self:setLoadingBar()
		if self._index >= self._total then
			self.LoadingBar:stopAllActions()
			-- 创建StartUi
			performWithDelay( self,function()
				addUIToScene( UIDefine.LABA_KEY.Start_UI )
				removeUIFromScene( UIDefine.LABA_KEY.Loading_UI )
			end,0.5 )
		end
	end,0.02)
end

function GameLoading:setLoadingBar()
	local rate = math.floor( self._index / self._total * 100 )
	self.LoadingBar:setPercent( rate )
end

function GameLoading:loadPlist()
	local index = 1
	self:schedule( function()
		cc.SpriteFrameCache:getInstance():addSpriteFrames( self._plist[index] )
		index = index + 1
		self._index = self._index + 1
		if index > #self._plist then
			self:unSchedule()
			self:loadMusic()
		end
	end,0.02 )
end

function GameLoading:loadMusic()
	local index = 1
	self:schedule( function()
		audio.preloadMusic( self._music[index] )
		index = index + 1
		self._index = self._index + 1
		if index > #self._music then
			self:unSchedule()
			self:loadEffect()
		end
	end,0.02 )
end

function GameLoading:loadEffect()
	local index = 1
	self:schedule( function()
		audio.preloadSound( self._sound[index] )
		index = index + 1
		self._index = self._index + 1
		if index > #self._sound then
			self:unSchedule()
		end
	end,0.02 )
end

function GameLoading:onEnter()
	GameLoading.super.onEnter( self )
	self:loadPlist()
end




return GameLoading