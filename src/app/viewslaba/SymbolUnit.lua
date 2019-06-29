

--
-- Author: 	刘阳
-- Date: 	2019-04-30
-- Desc:	信号块

local SymbolUnit = class("SymbolUnit",BaseNode)

function SymbolUnit:ctor( size )
	SymbolUnit.super.ctor( self )
	self:setContentSize( size )
	self:addCsb( "csblaba/NodeElement.csb" )

	local element_size = self.NodeElement:getContentSize()
	self._csbNode:setPosition( (size.width - element_size.width) / 2,( size.height - element_size.height) / 2 )
end


function SymbolUnit:loadUIdata( nSymbolID )
	assert( nSymbolID," !! nSymbolID is nil !! " )
	self:clearUiState()
	self._nSymbolID = nSymbolID
	-- self.Icon:loadTexture( laba_config.element_path[nSymbolID],1 )
	self["Icon"..nSymbolID]:setVisible( true )
end



function SymbolUnit:getSymbolSize()
	return self._imageUnit:getContentSize()
end

function SymbolUnit:getNSymbolID()
	return self._nSymbolID
end


function SymbolUnit:clearUiState()
	for i = 1,9 do
		self["Icon"..i]:setVisible( false )
	end
end

-- 设置下一个信号的指针
function SymbolUnit:setNextSymbolUnit( symbolUnit )
	assert( symbolUnit," !! symbolUnit is nil !! " )
	self._nextSymbolUnit = symbolUnit
end

function SymbolUnit:getNextSymbolUnit()
	return self._nextSymbolUnit
end


return SymbolUnit