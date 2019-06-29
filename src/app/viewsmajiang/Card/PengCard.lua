

local PengCard = class("PengCard",BaseNode)

--[[
	mode: 1->自己的牌 2->机器人的牌
]]
function PengCard:ctor( mode,num,gameLayer )
	assert( mode," !! mode is nil !! ")
	assert( num," !! num is nil !! ")
	assert( gameLayer, " !! gameLayer is nil !! ")
	PengCard.super.ctor( self,"PengCard" )
	self:addCsb( "csbmajiang/Card3.csb" )

	self._mode = mode
	self._num = num
	self._gameLayer = gameLayer

	self.CardNum:loadTexture(mj_out_path_config[num],1)
end

function PengCard:getNum()
	return self._num
end

-- 暗杠
function PengCard:setAnGang()
	self.Bg:loadTexture( "image/2/pai/small_gai.png",1 )
	self.CardNum:setVisible( false )
	self._anMark = true 
end

function PengCard:getAnMark()
	return self._anMark
end

function PengCard:showAnGang()
	self.Bg:loadTexture( "image/2/pai/small_tang.png",1 )
	self.CardNum:setVisible( true )
end


return PengCard