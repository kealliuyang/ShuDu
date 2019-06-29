

local GameVoiceSet = class( "GameVoiceSet",BaseLayer )


function GameVoiceSet:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameVoiceSet.super.ctor( self,param.name )
    
    local layer = cc.LayerColor:create(cc.c4b(0,0,0,200))
    self:addChild( layer )
    self._layer = layer

    self:addCsb( "csbsanguo/Set.csb" )

    self:addNodeClick( self.ButtonClose,{
    	endCallBack = function ()
    		self:close()
    	end
    })
    self:addNodeClick( self.ButtonMusic,{
    	endCallBack = function ()
    		self:setMusic()
    	end,
    	scaleAction = false
    })
    self:addNodeClick( self.ButtonVoice,{
    	endCallBack = function ()
    		self:setVoice()
    	end,
    	scaleAction = false
    })


    self:loadUi()
end

function GameVoiceSet:loadUi()
	local is_open = G_GetModel("Model_Sound"):isMusicOpen()
	if is_open then
		self.ImageMusic:loadTexture( "image/set/kaiguan.png",1 )
		self.ImageMusic:setPositionX( 37 )
	else
		self.ImageMusic:loadTexture( "image/set/kaiguan.png",1 )
		self.ImageMusic:setPositionX( 246 )
	end
	is_open = G_GetModel("Model_Sound"):isVoiceOpen()
	if is_open then
		self.ImageVoice:loadTexture( "image/set/kaiguan.png",1 )
		self.ImageVoice:setPositionX( 37 )
	else
		self.ImageVoice:loadTexture( "image/set/kaiguan.png",1 )
		self.ImageVoice:setPositionX( 246 )
	end
end

function GameVoiceSet:setMusic()
	local model = G_GetModel("Model_Sound")-------这里转的次数比较懵，怎么这样写？
	local is_open = model:isMusicOpen()
	if is_open then
		self.ImageMusic:loadTexture( "image/set/kaiguan.png",1 )--loadTexture(),plist里面的图需要用这个方法？就是这个方法。
		model:setMusicState(model.State.Closed)------设置成关，怎么这样写？取model_sound的State的Close
		model:stopPlayBgMusic()
		self.ImageMusic:setPositionX( 246 )
	else
		self.ImageMusic:loadTexture( "image/set/kaiguan.png",1 )
		model:setMusicState(model.State.Open)
		model:playBgMusic()
		self.ImageMusic:setPositionX( 37 )
	end
	-- body
end

function GameVoiceSet:setVoice()
	local model = G_GetModel("Model_Sound")
	local is_open = model:isVoiceOpen()
	if is_open then
		self.ImageVoice:loadTexture( "image/set/kaiguan.png",1 )
		model:setVoiceState(model.State.Closed)
		self.ImageVoice:setPositionX( 246 )
	else
		self.ImageVoice:loadTexture( "image/set/kaiguan.png",1 )
		model:setVoiceState(model.State.Open)
		self.ImageVoice:setPositionX( 37 )
	-- body
	end
end

function GameVoiceSet:onEnter()
	GameVoiceSet.super.onEnter( self )
	casecadeFadeInNode( self.Bg,0.5 )
	casecadeFadeInNode( self._layer,0.5,150 )
	-- body
end

function GameVoiceSet:close()
	removeUIFromScene( UIDefine.SANGUO_KEY.Voice_UI)
	-- body
end




return GameVoiceSet