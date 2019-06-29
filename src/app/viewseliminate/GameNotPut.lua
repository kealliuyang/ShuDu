
local GameNotPut = class("GameNotPut",BaseLayer)


function GameNotPut:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameNotPut.super.ctor( self,param.name )
    self._param = param

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer,1 )
    self._layer = layer

    -- bg
    local bg = ccui.ImageView:create("image/game/tips.png")
    self:addChild( bg,2 )
    bg:setPosition(cc.p(display.cx,display.cy + 110))
    self._bg = bg
end


function GameNotPut:onEnter()
    GameNotPut.super.onEnter( self )
    self._layer:setVisible( false )
    self._bg:setVisible( false )
    local delay = cc.DelayTime:create(1)
    local call_back = cc.CallFunc:create( function()
        self._layer:setVisible( true )
        self._bg:setVisible( true )
        casecadeFadeInNode( self._bg,0.5 )
        self._layer:setOpacity(0)
        self._layer:runAction(cc.FadeTo:create(0.5,150))
        -- 播放音效
        audio.playSound("elimp3/game_over.mp3", false)
    end )
    local delay2 = cc.DelayTime:create(3)
    local game_over_call = cc.CallFunc:create( function()
        removeUIFromScene( UIDefine.ELIMI_KEY.GameNotPut_UI )
        -- 进入结果页
        local data = { score = self._param.data.score,ui = self._param.data.ui }
        addUIToScene( UIDefine.ELIMI_KEY.GameOver_UI,data )
    end )
    local seq = cc.Sequence:create({ delay,call_back,delay2,game_over_call })
    self:runAction( seq )
end




return GameNotPut