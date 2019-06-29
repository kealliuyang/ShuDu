


local GameSet = class("GameSet",BaseLayer)



function GameSet:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameSet.super.ctor( self,param.name )

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 200))
    self:addChild( layer,1 )
    self._layer = layer

    self:addCsb( "csbEliminate/LayerGameSet.csb",2 )

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

function GameSet:loadUi()
    local is_open = G_GetModel("Model_Sound"):isMusicOpen()
    if is_open then
        self.ButtonMusic:loadTexture( "image/set/on.png",0 )
    else
        self.ButtonMusic:loadTexture( "image/set/off.png",0 )
    end
    is_open = G_GetModel("Model_Sound"):isVoiceOpen()
    if is_open then
        self.ButtonVoice:loadTexture( "image/set/on.png",0 )
    else
        self.ButtonVoice:loadTexture( "image/set/off.png",0 )
    end
end

function GameSet:setMusic()
    local model = G_GetModel("Model_Sound")
    local is_open = model:isMusicOpen()
    if is_open then
        -- 关闭音乐
        self.ButtonMusic:loadTexture( "image/set/off.png",0 )
        model:setMusicState(model.State.Closed)
        model:stopPlayBgMusic()
    else
        -- 打开音乐
        self.ButtonMusic:loadTexture( "image/set/on.png",0 )
        model:setMusicState(model.State.Open)
        model:playBgMusic()
    end
end

function GameSet:setVoice()
    local model = G_GetModel("Model_Sound")
    local is_open = model:isVoiceOpen()
    if is_open then
        -- 关闭音效
        self.ButtonVoice:loadTexture( "image/set/off.png",0 )
        model:setVoiceState(model.State.Closed)
    else
        self.ButtonVoice:loadTexture( "image/set/on.png",0 )
        model:setVoiceState(model.State.Open)
    end
end


function GameSet:onEnter()
    GameSet.super.onEnter( self )
    casecadeFadeInNode( self.MidPanel,0.5 )
    casecadeFadeInNode( self._layer,0.5,200 )
end


function GameSet:close()
	removeUIFromScene( UIDefine.ELIMI_KEY.Set_UI )
end




return GameSet