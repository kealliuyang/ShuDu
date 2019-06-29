

local PokerNode  = class("PokerNode",BaseNode)

function PokerNode:ctor( parentPanel )
	self._parentPanel = parentPanel
	PokerNode.super.ctor( self,"PokerNode" )
	self:addCsb( "csbtwentyfour/NodePoker.csb" )
end



function PokerNode:loadUiData(num)
	assert(num,"!! num is nil !!")
	self:clearUiState()
	self.TextNum:setScale(1)
	
	self._numStr = tostring(num)
	self._orgNum = num

	self._fenzi = num
	self._fenmu = 1

	-- 随机背景色
	local ran_num = random(1,10)
	local block = ran_num % 2 == 0
	self.BgBlock:setVisible( block )
	self.BgRed:setVisible( not block )
	-- num
	self.TextNum:setString( num )
	local path = "image/3/poker/NB_black.fnt"
	if not block then
		path = "image/3/poker/NB_red.fnt"
	end
	self.TextNum:setFntFile( path )
	-- 花色
	if block then
		local random_s = random(1,10)
		if random_s % 2 == 0 then
			self.ImageFColor:loadTexture("image/3/poker/b_black_1.png",1)
		else
			self.ImageFColor:loadTexture("image/3/poker/b_black_3.png",1)
		end
	else
		local random_s = random(1,10)
		if random_s % 2 == 0 then
			self.ImageFColor:loadTexture("image/3/poker/b_red_2.png",1)
		else
			self.ImageFColor:loadTexture("image/3/poker/b_red_4.png",1)
		end
	end
end

function PokerNode:setSelectBg( value )
	self.BgSelect:setVisible( value )
end

-- function PokerNode:getNum()
-- 	return self._num
-- end

function PokerNode:setNumStr( numStr )
	self._numStr = numStr
	self.TextNum:setString( self._numStr )

	if string.find( self._numStr,"/") then
		self.TextNum:setScale(0.6)
	else
		self.TextNum:setScale(1)
	end
end

function PokerNode:getOrgNum()
	return self._orgNum
end

function PokerNode:getFenMu()
	assert( self._fenmu," !! self._fenmu is nil !! ")
	return self._fenmu
end

function PokerNode:setFenMu( fenMu )
	assert( fenMu," !! fenMu is nil !! ")
	self._fenmu = fenMu
end

function PokerNode:getFenZi()
	assert( self._fenzi," !! self._fenzi is nil !! ")
	return self._fenzi
end

function PokerNode:setFenZi( fenZi )
	assert( fenZi," !! fenZi is nil !! ")
	self._fenzi = fenZi
end

function PokerNode:clearUiState()
	self.BgBlock:setVisible( false )
	self.BgRed:setVisible( false )
	self.BgSelect:setVisible( false )
end


return PokerNode