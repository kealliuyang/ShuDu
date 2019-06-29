
local LevelCell = import(".LevelCell")
local MainCell  = class("MainCell",BaseNode)


function MainCell:ctor( parentPanel )
	self._parentPanel = parentPanel
	MainCell.super.ctor( self,"MainCell" )
	self:addCsb( "csb/NodeSelect.csb" )
end

function MainCell:loadDataUi( data )
	assert( data," !! data is nil !! ")
	self:clearUiState()

	for i = 1,3 do
		if data[i] then
			self["LevelPanel"..i]:setVisible( true )
			local cell = self["LevelPanel"..i]:getChildByTag( 222 )
			if not cell then
				cell = LevelCell.new( self )
				cell:setTag( 222 )
				self["LevelPanel"..i]:addChild( cell )
			end
			cell:loadDataUi( data[i] )
		end
	end
end

function MainCell:openGameLayer( index )
	local cell = self["LevelPanel"..index]:getChildByTag( 222 )
	if self["LevelPanel"..index]:isVisible() and cell then
		cell:openGameLayer()
	end
end

function MainCell:clearUiState()
	for i = 1,3 do
		self["LevelPanel"..i]:setVisible( false )
	end
end




return MainCell