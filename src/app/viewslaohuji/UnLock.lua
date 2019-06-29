
local UnLock = class("UnLock",BaseLayer)




function UnLock:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    UnLock.super.ctor( self,param.name )

    self.param = param

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 200))
    self:addChild( layer,1 )

    self:addCsb( "csblaohuji/UnLock.csb",2 )

    -- 是
    self:addNodeClick( self.ButtonYes,{ 
        endCallBack = function() self:unlockLevel() end
    })
    -- 否
    self:addNodeClick( self.ButtonNo,{ 
        endCallBack = function() self:close() end
    })

    self:loadUIData( param.data.coin )
end

function UnLock:loadUIData( coin )
	local str = string.format("是否花费%s金币解锁",coin)
	self.Text_1:setString( str )
end

function UnLock:onEnter()
    UnLock.super.onEnter( self )
    UIScaleShowAction( self.Bg )
end

function UnLock:unlockLevel()
    local has_coin = G_GetModel("Model_LaoHuJi"):getCoin()
    if has_coin < self.param.data.coin then
        G_ShowTips("金币不足")
        return
    end

    if self.param.data.coin == lhj_unlock_animal then
        -- 解锁动物城
        G_GetModel("Model_LaoHuJi"):saveAnimalOpen()
    end

    if self.param.data.coin == lhj_unlock_seabed then
        -- 解锁动物城
        G_GetModel("Model_LaoHuJi"):saveSeabedOpen()
    end

    -- 扣除金币
    G_GetModel("Model_LaoHuJi"):saveCoin( has_coin - self.param.data.coin )
    self.param.data.parent:loadUIData()
    self:close()
end


function UnLock:close()
	removeUIFromScene( UIDefine.LAOHUJI_KEY.UnLock_UI )
end



return UnLock