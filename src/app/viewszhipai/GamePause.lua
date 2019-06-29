

local GamePause = class( "GamePause",BaseLayer )



function GamePause:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePause.super.ctor( self,param.name )
    
    local layer = cc.LayerColor:create(cc.c4b(0,0,0,150))
    self:addChild( layer )
    self._layer = layer

    self._parent = param.data.layer

    self:addCsb( "csbzhipai/Pause.csb" )

    self:addNodeClick( self.ButtonGoOn,{
    	endCallBack = function ()
    		self:close()
    	end
    })
    self:addNodeClick( self.ButtonMusicBg,{
    	endCallBack = function ()
    		self:setMusic()
    	end,
    	scaleAction = false
    })
    self:addNodeClick( self.ButtonSoundBg,{
    	endCallBack = function ()
    		self:setVoice()
    	end,
    	scaleAction = false
    })


    self:loadUi()
end

function GamePause:loadUi()
	local is_open = G_GetModel("Model_Sound"):isMusicOpen()
	if is_open then
		self.ImageMusic:loadTexture( "image/pause/kai.png",1 )
		self.ImageMusic:setPositionX( 34 )
	else
		self.ImageMusic:loadTexture( "image/pause/guan.png",1 )
		self.ImageMusic:setPositionX( 114 )
	end
	is_open = G_GetModel("Model_Sound"):isVoiceOpen()
	if is_open then
		self.ImageEffect:loadTexture( "image/pause/kai.png",1 )
		self.ImageEffect:setPositionX( 34 )
	else
		self.ImageEffect:loadTexture( "image/pause/guan.png",1 )
		self.ImageEffect:setPositionX( 114 )
	end
end

function GamePause:setMusic()
	local model = G_GetModel("Model_Sound")
	local is_open = model:isMusicOpen()
	if is_open then
		self.ImageMusic:loadTexture( "image/pause/guan.png",1 )
		model:setMusicState(model.State.Closed)
		model:stopPlayBgMusic()
		self.ImageMusic:setPositionX( 114 )
	else
		self.ImageMusic:loadTexture( "image/pause/kai.png",1 )
		model:setMusicState(model.State.Open)
		model:playBgMusic()
		self.ImageMusic:setPositionX( 34 )
	end
	-- body
end

function GamePause:setVoice()
	local model = G_GetModel("Model_Sound")
	local is_open = model:isVoiceOpen()
	if is_open then
		self.ImageEffect:loadTexture( "image/pause/guan.png",1 )
		model:setVoiceState(model.State.Closed)
		self.ImageEffect:setPositionX( 114 )
	else
		self.ImageEffect:loadTexture( "image/pause/kai.png",1 )
		model:setVoiceState(model.State.Open)
		self.ImageEffect:setPositionX( 34 )
	end
end

function GamePause:onEnter()
	GamePause.super.onEnter( self )
	casecadeFadeInNode( self.ImagePauseBg,0.5 )
	casecadeFadeInNode( self._layer,0.5,150 )
end

function GamePause:close()
	self._parent:startSchedule()
	removeUIFromScene( UIDefine.ZHIPAI_KEY.Pause_UI)
end




return GamePause