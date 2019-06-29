
local HelpCell  = class("HelpCell",BaseNode)


function HelpCell:ctor( parentPanel )
	self._parentPanel = parentPanel
	HelpCell.super.ctor( self,"HelpCell" )
	self:addCsb( "csblaba/NodeTable.csb" )
end

function HelpCell:loadDataUi( data,index )
	assert( data," !! data is nil !! ")
	assert( index," !! index is nil !! ")
	self:clearUiState()
	
	for i = 1,4 do
		self["Text_"..i]:setString( data[i] )
	end

	self.ImageHeng1:setVisible( index == 9 )
	self.ImageShu1:setVisible( false )
	self.ImageShu5:setVisible( false )
end

function HelpCell:clearUiState()
	
end


return HelpCell