
local LevelUnit = import(".LevelUnit")
local MainCell  = class("MainCell",BaseNode)


function MainCell:ctor( parentPanel )
	self._parentPanel = parentPanel
	self._rootPanel = self._parentPanel._parentPanel
	MainCell.super.ctor( self,"MainCell" )
	self:addCsb( "csbtwentyfour/NodeLevelCell.csb" )
end

function MainCell:loadDataUi( data,level )
	assert( data," !! data is nil !! ")
	assert( level," !! level is nil !! ")
	self._mData = data
	self._level = level
	for i = 1,20 do
		if data[i] then
			local level_unit = self["RootPanel"]:getChildByTag( i )
			if not level_unit then
				level_unit = LevelUnit.new( self )
				level_unit:setTag( i )
				self["RootPanel"]:addChild( level_unit )
				local size = level_unit:getDesignSize()
				local row,col = self:calPos( i )
				local x_pos = (col - 1) * size.width + (col - 1) * 7 
				local y_pos = (row - 1) * size.height + (row - 1) * 28
				level_unit:setPosition(cc.p( x_pos,y_pos ))
			end
			level_unit:loadDataUi( data[i],level,i )
		end
	end
end


function MainCell:calPos( index )
	assert( index > 0," !! index must > 0 !! ")
	local rows,cols = 5,4
	local row = rows - math.ceil( index / cols) + 1
	local col = ( index % cols )
	if col == 0 then
		col = 4
	end
	return row,col
end

function MainCell:getTouchLevelUnit( touchPoint )
	assert( self._level," !! self._level is nil !! ")
	if self._level ~= self._rootPanel._currentLv then
		return false
	end

	local cur_level,cur_point = G_GetModel("Model_TwentyFour"):getLevelAndPoint()
	for a = 1,20 do
        local level_unit = self["RootPanel"]:getChildByTag( a )
        if level_unit then
        	local boxRect = level_unit.RootPanel:getBoundingBox()
            local localPoint = level_unit.RootPanel:getParent():convertToNodeSpace(touchPoint)
            local is_touch = cc.rectContainsPoint(boxRect, localPoint)
            if is_touch then
            	-- 检查有没有权限打开
				if cur_level > self._level then
					return true,self._level,a
				elseif cur_level == self._level then
					if cur_point + 1 >= a then
						return true,self._level,a
					else
						return false
					end
				else
					return false
				end
            end
        end
    end
    return false
end


return MainCell