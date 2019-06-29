

local UnitCell = class("UnitCell",BaseNode)


function UnitCell:ctor( layer,i,j )
    UnitCell.super.ctor( self,"UnitCell"..i.."_"..j )
    self:addCsb( "csb/NodeCell.csb" )

    self:setContentSize( self.RootPanel:getContentSize() )
    self._parentLayer = layer
    self._index = (i-1)*9 + j
    self._row = i
    self._col = j

    self:loadUi()
end


function UnitCell:loadUi()
	self:clearUiState()
	self:setNormalBg()
end

function UnitCell:setNormalBg()
	local path = "image/game/Box_small_1.png"
	self.BgNormal1:loadTexture( path,1 )
	if self._isFill then
		path = "image/game/Box_small_2.png"
		self.BgNormal1:loadTexture( path,1 )
	end
end

function UnitCell:setCheckBg( value )
	if value then
		local path = "image/game/Box_check.png"
		self.BgNormal1:loadTexture( path,1 )
		self:setBMfntFile("image/number/NB_check.fnt")
		self._check = 1
	else
		if self._check == 1 then
			self:setNormalBg()
			if self._isFill then
				self:setBMfntFile("image/number/NB_fill.fnt")
			else
				self:setBMfntFile("image/number/NB_original.fnt")
			end
			self._check = nil
		end
	end
end

function UnitCell:getDesignSize()
	return self.RootPanel:getContentSize()
end

function UnitCell:setNum( num )
	if num ~= "" then
		self._num = num
	end
	self.TextNum:setString( num )
end

function UnitCell:getNum()
	return self._num
end

function UnitCell:getRow()
	return self._row
end

function UnitCell:getCol()
	return self._col
end

function UnitCell:setNeedFill()
	self._isFill = true
	self:setBMfntFile("image/number/NB_fill.fnt")
	local path = "image/game/Box_small_2.png"
	self.BgNormal1:loadTexture( path,1 )
end

function UnitCell:setBMfntFile( path )
	self.TextNum:setFntFile( path )
end

-- 当用提示的时候 显示紫色的颜色
function UnitCell:setTipsBMfnt()
	self:setBMfntFile("image/number/NB_check.fnt")
end


function UnitCell:fillNumAction()
	self.TextNum:stopAllActions()
	self.TextNum:setScale(5)
	local scale_to = cc.ScaleTo:create(0.1,1.5)
	self.TextNum:runAction(scale_to)
end

function UnitCell:clearUiState()
	
end

return UnitCell