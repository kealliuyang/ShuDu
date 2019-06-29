
local GameOver = class("GameOver",BaseLayer)

function GameOver:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameOver.super.ctor( self,param.name )

    self._param = param

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer )
    self._layer = layer

    self:addCsb( "csbjunshi/Over.csb" )

    -- 关闭
    self:addNodeClick( self.ButtonClose,{ 
        endCallBack = function() self:close() end
    })

    -- 继续
    self:addNodeClick( self.ButtonContinue,{ 
        endCallBack = function() self:continue() end
    })

end

function GameOver:onEnter()
    GameOver.super.onEnter( self )
    casecadeFadeInNode( self.Bg,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
    
    self:loadDataUI()
end

function GameOver:loadDataUI()
    for i = 1,3 do
        self["People"..i]:loadTexture( js_over_people_path[self._param.data.ai_index[i]],1 )
        self["TextScore"..i]:setString( math.abs(self._param.data.ai_coin[i]) )
        if self._param.data.ai_coin[i] > 0 then
            if js_card_lang == 1 then
                self["Text_"..i]:setString("Get")
            else
                self["Text_"..i]:setString("赢")
            end
        else
            if  js_card_lang == 1 then
                self["Text_"..i]:setString("Lose")
            else
                self["Text_"..i]:setString("输")
            end
        end
    end
    self["People4"]:loadTexture( js_over_people_path[self._param.data.player_index],1 )
    self["TextScore4"]:setString( math.abs(self._param.data.player_coin) )
    if self._param.data.player_coin > 0 then
        if js_card_lang == 1 then
            self["Text_4"]:setString("Get")
        else
            self["Text_4"]:setString("赢")
        end
    else
        if js_card_lang == 1 then
            self["Text_4"]:setString("Lose")
        else
            self["Text_4"]:setString("输")
        end
    end
end

function GameOver:continue()
    local index = self._param.data.player_index
    removeUIFromScene( UIDefine.JUNSHI_KEY.Over_UI )
    removeUIFromScene( UIDefine.JUNSHI_KEY.Play_UI,index )
    addUIToScene( UIDefine.JUNSHI_KEY.Play_UI,index )
end

-- 关闭
function GameOver:close()
    removeUIFromScene( UIDefine.JUNSHI_KEY.Over_UI )
    removeUIFromScene( UIDefine.JUNSHI_KEY.Play_UI )
    addUIToScene( UIDefine.JUNSHI_KEY.Start_UI )
end




return GameOver