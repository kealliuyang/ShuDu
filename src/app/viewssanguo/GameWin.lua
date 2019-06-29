
local GameWin = class("GameWin",BaseLayer)

function GameWin:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameWin.super.ctor( self,param.name )

    self._param = param

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer )

    self._layer = layer

    self:addCsb( "csbsanguo/Win.csb" )

    -- 关闭
    self:addNodeClick( self.ButtonReturn,{ 
        endCallBack = function() self:close() end
    })
    -- 再来一局
    self:addNodeClick( self.ButtonGoOn,{ 
        endCallBack = function() self:again() end
    })

    self:loadUIData()
end


function GameWin:onEnter()
    GameWin.super.onEnter( self )
    casecadeFadeInNode( self._csbNode,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
    -- 播放音效
    if G_GetModel("Model_Sound"):isVoiceOpen() then
        audio.playSound("sgmp3/win.mp3", false)
    end
end

function GameWin:loadUIData()
    
end




function GameWin:again()
    removeUIFromScene( UIDefine.SANGUO_KEY.Win_UI )
    removeUIFromScene( UIDefine.SANGUO_KEY.Play_UI )
    addUIToScene( UIDefine.SANGUO_KEY.Play_UI )
end

-- 关闭
function GameWin:close()
    removeUIFromScene( UIDefine.SANGUO_KEY.Win_UI )
    removeUIFromScene( UIDefine.SANGUO_KEY.Play_UI )
    addUIToScene( UIDefine.SANGUO_KEY.Start_UI )
end



return GameWin