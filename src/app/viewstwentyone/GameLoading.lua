

local GameLoading = class("GameLoading",BaseLayer)



function GameLoading:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameLoading.super.ctor( self,param.name )
    self:addCsb( "csbtwentyone/Loading.csb" )

    self._plist = {
		"csbtwentyone/Plist1.plist",
		"csbtwentyone/Plist2.plist",
		"csbtwentyone/Plist3.plist"
	}
	self._music = {
		"tomp3/dating.mp3",
	}
	self._sound = {
		"tomp3/selectpoker.mp3",
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
			-- 创建StartUi
			performWithDelay( self,function()
				addUIToScene( UIDefine.TWENTYONE_KEY.Start_UI )
				removeUIFromScene( UIDefine.TWENTYONE_KEY.Loading_UI )
			end,0.5 )
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