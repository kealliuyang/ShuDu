
--
-- Author: 	刘智勇
-- Date: 	2019-06-22
-- Desc:	战斗场景


local GameLoading = class( "GameLoading",BaseLayer )

function GameLoading:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameLoading.super.ctor( self,param.name )

	self:addCsb( "csbzhandou/Loading.csb" )

	self._plist = {
		"csbzhandou/Plist1.plist",
		"csbzhandou/Plist2.plist",
		"csbzhandou/Plist3.plist"
	}
	self._music = {
		"zdmp3/bg.mp3"
	}
	self._sound = {
		"zdmp3/button.mp3"
	}

end

function GameLoading:loadPlist()
	local index = 1
	self:schedule( function()
		cc.SpriteFrameCache:getInstance():addSpriteFrames( self._plist[index] )---getInstance,自定义了？cc.?
		index = index + 1
		if index > #self._plist then
			self:unSchedule()
			self:loadMusic()
		end
	end,0.02)
end

function GameLoading:loadMusic()
	local index = 1
	self:schedule( function ()
		audio.preloadMusic( self._music[index] )
		index = index + 1
		if index > #self._music then
			self:unSchedule()
			self:loadEffect()
		end
	end,0.02)
end
function GameLoading:loadEffect()
	local index = 1
	self:schedule( function ()
		audio.preloadSound( self._sound[index] )
		index = index + 1
		if index > #self._sound then
			self:unSchedule()
			removeUIFromScene( UIDefine.ZHANDOU_KEY.Loading_UI )
			addUIToScene( UIDefine.ZHANDOU_KEY.Start_UI )
		end
	end,0.02)
end


function GameLoading:onEnter()
	GameLoading.super.onEnter( self )
	self:loadPlist()
end

return GameLoading