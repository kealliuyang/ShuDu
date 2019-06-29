
local PoChan = class("PoChan",BaseLayer)




function PoChan:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    PoChan.super.ctor( self,param.name )

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 200))
    self:addChild( layer,1 )

    self:addCsb( "csblaohuji/PoChan.csb",2 )
    -- 关闭
    self:addNodeClick( self.ButtonClose,{ 
        endCallBack = function() self:close() end
    })

    self:loadUIData()
end

function PoChan:loadUIData()
	local str = string.format("你已经破产,返回大厅从新获得%s金币",lhj_default_coin)
	self.TextDesc:setString( str )
end

function PoChan:onEnter()
    PoChan.super.onEnter( self )
    casecadeFadeInNode( self.Bg,0.5 )
end


function PoChan:close()
	removeUIFromScene( UIDefine.LAOHUJI_KEY.PoChan_UI )
end



return PoChan