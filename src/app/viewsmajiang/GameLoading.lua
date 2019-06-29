

local GameLoading = class("GameLoading",BaseLayer)



function GameLoading:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameLoading.super.ctor( self,param.name )
    self:addCsb( "csbmajiang/GameLoading.csb" )

    self._plist = {
		"csbmajiang/Plist1.plist"
	}
	self._music = {
		"mjmp3/bg_game.mp3"
	}
	self._sound = {
		"mjmp3/boy_1wan.mp3",
		"mjmp3/boy_2wan.mp3",
		"mjmp3/boy_3wan.mp3",
		"mjmp3/boy_4wan.mp3",
		"mjmp3/boy_5wan.mp3",
		"mjmp3/boy_6wan.mp3",
		"mjmp3/boy_7wan.mp3",
		"mjmp3/boy_8wan.mp3",
		"mjmp3/boy_9wan.mp3",
		"mjmp3/boy_ac_gang.mp3",
		"mjmp3/boy_ac_hu.mp3",
		"mjmp3/boy_ac_peng.mp3",
		"mjmp3/boy_bai.mp3",
		"mjmp3/boy_beifeng.mp3",
		"mjmp3/boy_dongfeng.mp3",
		"mjmp3/boy_fa.mp3",
		"mjmp3/boy_nanfeng.mp3",
		"mjmp3/boy_xifeng.mp3",
		"mjmp3/boy_zhong.mp3",
		"mjmp3/btn.mp3",
		"mjmp3/ef_lose.mp3",
		"mjmp3/ef_win.mp3"
	}

	self.ResLoadingBar:setVisible( false )
	self.BgResLoadingBar:setVisible( false )
	self.TextProess:setVisible( false )
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
	self.ResLoadingBar:setPercent( rate )
	self.TextProess:setString( rate.."%" )
end

function GameLoading:onEnter()
	GameLoading.super.onEnter( self )
	local delay = cc.DelayTime:create(0.2)
	local call = cc.CallFunc:create( function()
		self:loadRes()
		-- 打开背景音乐
		G_GetModel("Model_Sound"):playBgMusic()
		-- 创建StartUi
		addUIToScene( UIDefine.MAJIANG_KEY.Start_UI )
		removeUIFromScene( UIDefine.MAJIANG_KEY.Loading_UI )
	end )
	local seq = cc.Sequence:create({ delay,call })
	self:runAction( seq )
end




return GameLoading