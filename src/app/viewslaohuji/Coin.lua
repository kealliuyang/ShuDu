
local Coin = class("Coin",BaseNode )


function Coin:ctor()
	Coin.super.ctor( self )

	local sp = ccui.ImageView:create("image/coin/jinbi1.png",1)
	self:addChild( sp )
	self._sp = sp
end


function Coin:changeAction()
	local actions_changes = {}
	for i = 1,6 do
		local delay_time = cc.DelayTime:create( 0.1 )
		local change_call = cc.CallFunc:create(function()
			self._sp:loadTexture("image/coin/jinbi"..i..".png",1)
		end )
		table.insert( actions_changes,delay_time )
		table.insert( actions_changes,change_call )
	end
	local seq_change = cc.Sequence:create( actions_changes )
	local rep = cc.RepeatForever:create( seq_change )
	self._sp:runAction( rep )
end









return Coin