

local CharUnit = class("CharUnit",BaseNode)



function CharUnit:ctor( parentPanel,row,col )
	assert( parentPanel," !! parentPanel is nil !! " )
	assert( row," !! row is nil !! " )
	assert( col," !! col is nil !! " )
	CharUnit.super.ctor( self,"CharUnit" )
	self:addCsb( "csbchengyujielong/Unit.csb" )
	self._parentPanel = parentPanel
	self._orgRow = row
	self._orgCol = col
	self.RootPanel:setTouchEnabled( true )
	self.RootPanel:onTouch( function( event )
		self:touchCallBack( event )
	end )

	self.Text:setLocalZOrder( 1 )
	self._isPass = false
end


function CharUnit:loadUi( char )
	self._char = char
	self.Text:setString( char )
	self:andOutLine()
end


function CharUnit:touchCallBack( event )
	if self._isPass then
		return
	end
	local sender = event.target
	if event.name == "began" then
		local began_pos = sender:getTouchBeganPosition()
	elseif event.name == "moved" then
		local move_pos = sender:getTouchMovePosition()
		local node_pos = self:getParent():convertToNodeSpace( move_pos )
		self:setPosition( node_pos )
		self.Text:setLocalZOrder( 10 )
	elseif event.name == "ended" or event.name == "cancelled" then
		local end_pos = sender:getTouchEndPosition()
		local node_pos = self:getParent():convertToNodeSpace( end_pos )
		self:setPosition( node_pos )
		self:putDown()
		self.Text:setLocalZOrder( 1 )
	end
end

function CharUnit:putDown()
	self._parentPanel:putCharUnit( self )
end

function CharUnit:getOrgRowAndCol()
	return self._orgRow,self._orgCol
end

function CharUnit:setOrgRowAndCol( row,col )
	self._orgRow = row
	self._orgCol = col
end

function CharUnit:getIsPass()
	return self._isPass
end

function CharUnit:setPassDone( value )
	if value ~= nil then
		self._isPass = value
		return
	end
	self._isPass = true
end

function CharUnit:getChar()
	return self._char
end

function CharUnit:andOutLine()
	local lineColor = cc.c4b(100,70,38,255)
	if self.Text.enableOutline then
		self.Text:enableOutline( lineColor,2 )
	end
end

function CharUnit:changeTextColor()
	self.Text:setTextColor(cc.c4b( 68,174,68,255 ))
end

return CharUnit