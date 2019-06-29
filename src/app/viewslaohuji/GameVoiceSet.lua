

local GameVoiceSet = class("GameVoiceSet",BaseLayer)



function GameVoiceSet:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameVoiceSet.super.ctor( self,param.name )

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 200))
    self:addChild( layer,1 )

    self:addCsb( "csblaohuji/Set.csb",2 )

    -- 关闭
    self:addNodeClick( self.ButtonClose,{ 
        endCallBack = function() self:close() end
    })
    -- 设置音乐
    self:addNodeClick( self.ButtonYinYue,{ 
        endCallBack = function() self:setMusic() end,
        scaleAction = false
    })
    -- 设置声音
    self:addNodeClick( self.ButtonYinXiao,{ 
        endCallBack = function() self:setVoice() end,
        scaleAction = false
    })

    self:loadUi()
end

function GameVoiceSet:loadUi()
    local is_open = G_GetModel("Model_Sound"):isMusicOpen()
    if is_open then
        self.ButtonYinYue:loadTexture( "image/set/kai.png",1 )
    else
        self.ButtonYinYue:loadTexture( "image/set/guan.png",1 )
    end
    is_open = G_GetModel("Model_Sound"):isVoiceOpen()
    if is_open then
        self.ButtonYinXiao:loadTexture( "image/set/kai.png",1 )
    else
        self.ButtonYinXiao:loadTexture( "image/set/guan.png",1 )
    end
end

function GameVoiceSet:setMusic()
    local model = G_GetModel("Model_Sound")
    local is_open = model:isMusicOpen()
    if is_open then
        -- 关闭音乐
        self.ButtonYinYue:loadTexture( "image/set/guan.png",1 )
        model:setMusicState(model.State.Closed)
        model:stopPlayBgMusic()
    else
        -- 打开音乐
        self.ButtonYinYue:loadTexture( "image/set/kai.png",1 )
        model:setMusicState(model.State.Open)
        model:playBgMusic()
    end
end

function GameVoiceSet:setVoice()
    local model = G_GetModel("Model_Sound")
    local is_open = model:isVoiceOpen()
    if is_open then
        -- 关闭音效
        self.ButtonYinXiao:loadTexture( "image/set/guan.png",1 )
        model:setVoiceState(model.State.Closed)
    else
        self.ButtonYinXiao:loadTexture( "image/set/kai.png",1 )
        model:setVoiceState(model.State.Open)
    end
end


function GameVoiceSet:onEnter()
    GameVoiceSet.super.onEnter( self )
    casecadeFadeInNode( self.MidPanel,0.5 )
end


function GameVoiceSet:close()
	removeUIFromScene( UIDefine.LAOHUJI_KEY.Voice_UI )
end




return GameVoiceSet