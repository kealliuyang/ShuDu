

local GameSet = class("GameSet",BaseLayer)



function GameSet:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameSet.super.ctor( self,param.name )

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 200))
    self:addChild( layer,1 )

    self:addCsb( "csb/LayerSet.csb",2 )

    -- 关闭
    self:addNodeClick( self.ButtonClose,{ 
        endCallBack = function() self:close() end
    })
    -- 设置音乐
    self:addNodeClick( self.CheckBoxMusic,{ 
        endCallBack = function() self:setMusic() end,
        scaleAction = false
    })
    -- 设置声音
    self:addNodeClick( self.CheckBoxVoice,{ 
        endCallBack = function() self:setVoice() end,
        scaleAction = false
    })

    self:loadUi()
end

function GameSet:loadUi()
    local is_open = G_GetModel("Model_Sound"):isMusicOpen()
    if is_open then
        self.CheckBoxMusic:loadTexture( "image/set/ON.png",1 )
    else
        self.CheckBoxMusic:loadTexture( "image/set/OFF.png",1 )
    end
    is_open = G_GetModel("Model_Sound"):isVoiceOpen()
    if is_open then
        self.CheckBoxVoice:loadTexture( "image/set/ON.png",1 )
    else
        self.CheckBoxVoice:loadTexture( "image/set/OFF.png",1 )
    end
end

function GameSet:setMusic()
    local model = G_GetModel("Model_Sound")
    local is_open = model:isMusicOpen()
    if is_open then
        -- 关闭音乐
        self.CheckBoxMusic:loadTexture( "image/set/OFF.png",1 )
        model:setMusicState(model.State.Closed)
        model:stopPlayBgMusic()
    else
        -- 打开音乐
        self.CheckBoxMusic:loadTexture( "image/set/ON.png",1 )
        model:setMusicState(model.State.Open)
        model:playBgMusic()
    end
end

function GameSet:setVoice()
    local model = G_GetModel("Model_Sound")
    local is_open = model:isVoiceOpen()
    if is_open then
        -- 关闭音效
        self.CheckBoxVoice:loadTexture( "image/set/OFF.png",1 )
        model:setVoiceState(model.State.Closed)
    else
        self.CheckBoxVoice:loadTexture( "image/set/ON.png",1 )
        model:setVoiceState(model.State.Open)
    end
end


function GameSet:onEnter()
    GameSet.super.onEnter( self )
    UIScaleShowAction( self.MidPanel )
end


function GameSet:close()
	removeUIFromScene( UIDefine.UI_KEY.Set_UI )
end




return GameSet