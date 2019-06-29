

local GameLoading = class("GameLoading",BaseLayer)



function GameLoading:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameLoading.super.ctor( self,param.name )
    self:addCsb( "csbchengyujielong/GameLoading.csb" )

    self._plist = {
		"csbchengyujielong/Plist1.plist",
		"csbchengyujielong/Plist2.plist"
	}
	self._music = {
		"cyjlmp3/bg.mp3",
		"cyjlmp3/bg1.mp3",
	}
	self._sound = {
		"cyjlmp3/button_s.mp3",
		"cyjlmp3/cy.mp3",
		"cyjlmp3/jdt.mp3"
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
				local pass_guid = G_GetModel("Model_ChengYuJieLong"):isPassGuid()
				if pass_guid then
					addUIToScene( UIDefine.CHENGYUJIELONG_KEY.Start_UI )
				else
					addUIToScene( UIDefine.CHENGYUJIELONG_KEY.Guid1_UI )
				end
				removeUIFromScene( UIDefine.CHENGYUJIELONG_KEY.Loading_UI )
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