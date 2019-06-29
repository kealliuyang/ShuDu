
local ChooseCard = class("ChooseCard",BaseLayer)

function ChooseCard:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    ChooseCard.super.ctor( self,param.name )

    self._param = param

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer )
    self._layer = layer

    self:addCsb( "csbjunshi/SelectCard.csb" )

    for i = 1,6 do
        self:addNodeClick( self["Button"..i],{ 
            endCallBack = function() self:selectCard( i ) end
        })
    end
end


function ChooseCard:onEnter()
    ChooseCard.super.onEnter( self )
    casecadeFadeInNode( self.Bg,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
end

-- 关闭
function ChooseCard:selectCard( num )
    self._param.data.call_back( num )
    removeUIFromScene( UIDefine.JUNSHI_KEY.Choose_UI )
end




return ChooseCard