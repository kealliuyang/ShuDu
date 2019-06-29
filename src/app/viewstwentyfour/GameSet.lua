

local GameSet = class("GameSet",BaseLayer)



function GameSet:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameSet.super.ctor( self,param.name )

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 200))
    self:addChild( layer,1 )
    self._layer = layer 

    self:addCsb( "csbtwentyfour/LayerGameVoiceSet.csb",2 )

    -- 关闭
    self:addNodeClick( self.ButtonClose,{ 
        endCallBack = function() self:close() end
    })
    
    -- 音乐
    self.SliderYinYue:onEvent( function( event ) self:yinYueChange( event ) end )
    -- 音效
    self.SliderYinXiao:onEvent( function( event ) self:yinXiaoChange( event ) end )

    self:loadUi()
end

function GameSet:loadUi()
    local musicVolume,effectVolume = G_GetModel("Model_Sound"):getVolume()
    self.SliderYinYue:setPercent( musicVolume * 100 )
    self.SliderYinXiao:setPercent( effectVolume * 100 )
end

function GameSet:yinYueChange( event )
    local percent = self.SliderYinYue:getPercent()
    local volue = 0.001
    if percent > 0 then
        volue = percent / 100
    end
    audio.setMusicVolume(volue)
end

function GameSet:yinXiaoChange( event )
    local percent = self.SliderYinXiao:getPercent()
    local volue = 0.001
    if percent > 0 then
        volue = percent / 100
    end
    audio.setSoundsVolume(volue)
end


function GameSet:onEnter()
    GameSet.super.onEnter( self )
    casecadeFadeInNode( self._layer,0.5,200 )
    casecadeFadeInNode( self.MidPanel,0.5 )
end


function GameSet:close()
    local percent1 = self.SliderYinYue:getPercent()
    local percent2 = self.SliderYinXiao:getPercent()
    local v_music = percent1 / 100
    local v_voice = percent2 / 100
    G_GetModel("Model_Sound"):saveVolume( v_music,v_voice )
	removeUIFromScene( UIDefine.TWENTYFOUR_KEY.Set_UI )
end


return GameSet