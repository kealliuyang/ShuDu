

local GameLoading = class("GameLoading",BaseLayer)



function GameLoading:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameLoading.super.ctor( self,param.name )
    self:addCsb( "csblaohuji/Loading.csb" )

    self._plist = {
		"csblaohuji/Plist1.plist",
		"csblaohuji/Plist2.plist"
	}
	self._music = {
		"lhjmp3/game_bg.mp3"
	}
	self._sound = {
		"lhjmp3/btn_bubble.mp3",
		"lhjmp3/game_bet.mp3",
		"lhjmp3/game_big_win.mp3",
		"lhjmp3/game_coin_droping.mp3",
		"lhjmp3/game_lose.mp3",
		"lhjmp3/game_turntable.mp3",
		"lhjmp3/spin_button.mp3"
	}


	-- 进度条动画
	self._index = 0
	self._total = 50
	self:setLoadingBar()
	self:schedule( function()
		self._index = self._index + 1
		self:setLoadingBar()
		if self._index >= self._total then
			self:unSchedule()
			-- 打开背景音乐
			G_GetModel("Model_Sound"):playBgMusic()
			-- 创建StartUi
			addUIToScene( UIDefine.LAOHUJI_KEY.Start_UI )
			removeUIFromScene( UIDefine.LAOHUJI_KEY.Loading_UI )
		end
	end,0.02)
end

function GameLoading:loadRes()
	local _t = os.clock()
	print("plist 声音 加载 开始读取 ")
	-- plist
	for i,v in ipairs( self._plist ) do
		cc.SpriteFrameCache:getInstance():addSpriteFrames( v )
	end
	-- music
	for i,v in ipairs( self._music ) do
		audio.preloadMusic( v )
	end
	-- sound
	for i,v in ipairs( self._sound ) do
		audio.preloadSound( v )
	end
    print("Model 加载读取完毕!所需秒:"..(os.clock() - _t))
end

function GameLoading:setLoadingBar()
	local rate = math.floor( self._index / self._total * 100 )
	self.LoadingBar:setPercent( rate )
	self.Text2:setString( rate.."%" )
end

function GameLoading:onEnter()
	GameLoading.super.onEnter( self )
	local delay = cc.DelayTime:create(0.2)
	local call = cc.CallFunc:create( function()
		self:loadRes()
	end )
	local seq = cc.Sequence:create({ delay,call })
	self:runAction( seq )
end




return GameLoading