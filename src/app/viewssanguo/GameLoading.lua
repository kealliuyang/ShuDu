

-- local GameLoading = class("GameLoading",BaseLayer)



-- function GameLoading:ctor( param )
--     assert( param," !! param is nil !! ")
--     assert( param.name," !! param.name is nil !! ")
--     GameLoading.super.ctor( self,param.name )

--     self:addCsb( "csbsanguo/Loading.csb" )

--     self._plist = {
-- 		"csbsanguo/Plist1.plist",
-- 		"csbsanguo/Plist2.plist",
-- 		"csbsanguo/Plist3.plist"
-- 	}
-- 	self._music = {
-- 		"sgmp3/bg.mp3",
-- 	}
-- 	self._sound = {
-- 		"sgmp3/button.mp3",
-- 		"sgmp3/lost.mp3",
-- 		"sgmp3/win.mp3",
-- 		"sgmp3/sendcard.mp3",
-- 	}
-- end


-- function GameLoading:loadPlist()
-- 	local index = 1
-- 	self:schedule( function()
-- 		cc.SpriteFrameCache:getInstance():addSpriteFrames( self._plist[index] )
-- 		index = index + 1
-- 		if index > #self._plist then
-- 			self:unSchedule()
-- 			self:loadMusic()
-- 		end
-- 	end,0.02 )
-- end

-- function GameLoading:loadMusic()
-- 	local index = 1
-- 	self:schedule( function()
-- 		audio.preloadMusic( self._music[index] )
-- 		index = index + 1
-- 		if index > #self._music then
-- 			self:unSchedule()
-- 			self:loadEffect()
-- 		end
-- 	end,0.02 )
-- end

-- function GameLoading:loadEffect()
-- 	local index = 1
-- 	self:schedule( function()
-- 		audio.preloadSound( self._sound[index] )
-- 		index = index + 1
-- 		if index > #self._sound then
-- 			self:unSchedule()
-- 			removeUIFromScene( UIDefine.SANGUO_KEY.Loading_UI )
-- 			addUIToScene( UIDefine.SANGUO_KEY.Start_UI )
-- 		end
-- 	end,0.02 )
-- end

-- function GameLoading:onEnter()
-- 	GameLoading.super.onEnter( self )
-- 	self:loadPlist()
-- end




-- return GameLoading




local GameLoading = class( "GameLoading",BaseLayer )

function GameLoading:ctor( param )
	assert( param," !! param is nil !! " )
	assert( param.name," !! param.name is nil !! " )
	GameLoading.super.ctor( self,param.name )

	self:addCsb( "csbsanguo/Loading.csb" )

	self._plist = {
		"csbsanguo/Plist1.plist",
		"csbsanguo/Plist2.plist",
		"csbsanguo/Plist3.plist",
		"csbsanguo/Plist4.plist"
	}
	self._music = {
		"sgmp3/bg.mp3"
	}
	self._sound = {
		"sgmp3/button.mp3",
		"sgmp3/lost.mp3",
		"sgmp3/win.mp3",
		"sgmp3/sendcard.mp3"
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
		----------------------这里0.02秒执行一次，如果没加载完就第二次执行，会出什么问题么？
	end,0.02)-----------cocos是单线程，如果没执行完，那么就等着执行完，如果0.01秒就执行完了，那么等够0.02再执行
end
function GameLoading:loadMusic()
	local index = 1
	self:schedule( function ()---------是否所有这样的方法，都能schedule( self,function() end)两种写法？一个是自己写，一个是引擎提供
		audio.preloadMusic( self._music[index] )----preloadMusic和preloadSound只是音乐长度不同的区别吗？都是MP3呢？读取编码不同。加载方式不同。
		index = index + 1
		if index > #self._music then
			self:unSchedule()
			self:loadEffect()
		end
	end,0.02)
	-- body
end
function GameLoading:loadEffect()
	local index = 1
	self:schedule( function ()
		audio.preloadSound( self._sound[index] )
		index = index + 1
		if index > #self._sound then
			self:unSchedule()
			-- self:GameStart:new()
			removeUIFromScene( UIDefine.SANGUO_KEY.Loading_UI )
			addUIToScene( UIDefine.SANGUO_KEY.Start_UI )
		end
		-- body
	end,0.02)
	-- body
end


function GameLoading:onEnter()
	GameLoading.super.onEnter( self )----这句有什么用？最上层是个空的方法，这句注销也运行正常？
	self:loadPlist()
	-- body
end

return GameLoading