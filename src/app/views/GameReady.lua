

local GameReady = class("GameReady",BaseLayer)



function GameReady:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameReady.super.ctor( self,param.name )
    self:addCsb( "csb/LayerRead.csb" )

    self:initAction()
end


function GameReady:initAction()
	self.Text_1:setScale( 0 )
	local scale_to = cc.ScaleTo:create(0.2,1)
	local delay1 = cc.DelayTime:create(0.5)
	local call_go = cc.CallFunc:create( function()
		self.Text_1:setString( "Go" )
	end )
	local delay2 = cc.DelayTime:create(0.5)
	local close_call = cc.CallFunc:create( function()
		removeUIFromScene( UIDefine.UI_KEY.Ready_UI )
	end )
	local seq = cc.Sequence:create({scale_to,delay1,call_go,delay2,close_call})
	self.Text_1:runAction(seq)
end







return GameReady