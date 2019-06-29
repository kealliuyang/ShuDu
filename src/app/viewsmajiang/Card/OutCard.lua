

local OutCard = class("OutCard",BaseNode)

--[[
	mode: 1->自己的出牌 2->机器人的出牌
]]
function OutCard:ctor( mode,num,gameLayer )
	assert( mode," !! mode is nil !! ")
	assert( num," !! num is nil !! ")
	assert( gameLayer, " !! gameLayer is nil !! ")
	OutCard.super.ctor( self,"OutCard" )
	self:addCsb( "csbmajiang/Card2.csb" )

	self._mode = mode
	self._num = num
	self._gameLayer = gameLayer

	self.CardNum:loadTexture(mj_out_path_config[num],1)
end

function OutCard:getNum()
	return self._num
end


return OutCard