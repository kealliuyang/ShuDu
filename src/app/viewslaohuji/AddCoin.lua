
local AddCoin = class("AddCoin",BaseLayer)




function AddCoin:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    AddCoin.super.ctor( self,param.name )

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 200))
    self:addChild( layer,1 )

    self:addCsb( "csblaohuji/AddCoin.csb",2 )

    -- 添加金币的按钮
    for i = 1,5 do
        self:addNodeClick( self["Button"..i],{ 
            endCallBack = function() self:addCoin( i ) end
        })
    end
    -- 关闭
    self:addNodeClick( self.ButtonClose,{ 
        endCallBack = function() self:close() end
    })
end


function AddCoin:onEnter()
    AddCoin.super.onEnter( self )
    UIScaleShowAction( self.Bg )
end

function AddCoin:addCoin( index )
    local has_coin = G_GetModel("Model_LaoHuJi"):getCoin()
    local add_coin = 0 
    if index == 1 then
        add_coin = 500
    elseif index == 2 then
        add_coin = 5000
    elseif index == 3 then
        add_coin = 10000
    elseif index == 4 then
        add_coin = 100
    elseif index == 5 then
        add_coin = -has_coin
    end
    -- 添加金币
    G_GetModel("Model_LaoHuJi"):saveCoin( has_coin + add_coin )
    EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_LAOHUJI_RESETSTART )
end


function AddCoin:close()
	removeUIFromScene( UIDefine.LAOHUJI_KEY.AddCoin_UI )
end



return AddCoin