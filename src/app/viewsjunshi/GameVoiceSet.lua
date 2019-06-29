


local GameVoiceSet = class("GameVoiceSet",BaseLayer)



function GameVoiceSet:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameVoiceSet.super.ctor( self,param.name )

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 200))
    self:addChild( layer,1 )
    self._layer = layer

    self:addCsb( "csbjunshi/VoiceSet.csb",2 )

    -- 关闭
    self:addNodeClick( self.ButtonClose,{ 
        endCallBack = function() self:close() end
    })
    -- 设置音乐
    self:addNodeClick( self.ButtonMusic,{ 
        endCallBack = function() self:setMusic() end,
        scaleAction = false
    })
    -- 设置声音
    self:addNodeClick( self.ButtonVoice,{ 
        endCallBack = function() self:setVoice() end,
        scaleAction = false
    })

    self:loadUi()
end

function GameVoiceSet:loadUi()
    local is_open = G_GetModel("Model_Sound"):isMusicOpen()
    if is_open then
        self.ImageMusic:loadTexture( "image/set/kai.png",1 )
        self.ImageMusic:setPositionX( 66 )
    else
        self.ImageMusic:loadTexture( "image/set/guan.png",1 )
        self.ImageMusic:setPositionX( 136 )
    end
    is_open = G_GetModel("Model_Sound"):isVoiceOpen()
    if is_open then
        self.ImageEffect:loadTexture( "image/set/kai.png",1 )
        self.ImageEffect:setPositionX( 66 )
    else
        self.ImageEffect:loadTexture( "image/set/guan.png",1 )
        self.ImageEffect:setPositionX( 136 )
    end
end

function GameVoiceSet:setMusic()
    local model = G_GetModel("Model_Sound")
    local is_open = model:isMusicOpen()
    if is_open then
        -- 关闭音乐
        self.ImageMusic:loadTexture( "image/set/guan.png",1 )
        model:setMusicState(model.State.Closed)
        model:stopPlayBgMusic()
        self.ImageMusic:setPositionX( 136 )
    else
        -- 打开音乐
        self.ImageMusic:loadTexture( "image/set/kai.png",1 )
        model:setMusicState(model.State.Open)
        model:playBgMusic()
        self.ImageMusic:setPositionX( 66 )
    end
end

function GameVoiceSet:setVoice()
    local model = G_GetModel("Model_Sound")
    local is_open = model:isVoiceOpen()
    if is_open then
        -- 关闭音效
        self.ImageEffect:loadTexture( "image/set/guan.png",1 )
        model:setVoiceState(model.State.Closed)
        self.ImageEffect:setPositionX( 136 )
    else
        self.ImageEffect:loadTexture( "image/set/kai.png",1 )
        model:setVoiceState(model.State.Open)
        self.ImageEffect:setPositionX( 66 )
    end
end


function GameVoiceSet:onEnter()
    GameVoiceSet.super.onEnter( self )
    casecadeFadeInNode( self.Bg,0.5 )
    casecadeFadeInNode( self._layer,0.5,200 )
end


function GameVoiceSet:close()
	removeUIFromScene( UIDefine.JUNSHI_KEY.Voice_UI )
end




return GameVoiceSet