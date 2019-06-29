
local RankCell  = class("RankCell",BaseNode)


function RankCell:ctor( parentPanel )
	self._parentPanel = parentPanel
	RankCell.super.ctor( self,"RankCell" )
	self:addCsb( "csblaohuji/RankCell.csb" )
end

function RankCell:loadDataUi( data,index )
	assert( data," !! data is nil !! ")
	assert( index," !! index is nil !! ")
	self:clearUiState()
	-- index
	if index <= 3 then
		self.ImageIndex:setVisible( true )
		self.ImageIndex:loadTexture("image/rank/"..index..".png",1 )
	else
		self.TextIndex:setVisible( true )
		self.TextIndex:setString( index )
	end
	-- score
	self.TextNum:setString(data.score)
	-- time
	self.TextTime:setString(os.date("%Y.%m.%d %H:%M", data.time))
end

function RankCell:clearUiState()
	self.ImageIndex:setVisible( false )
	self.TextIndex:setVisible( false )
end


return RankCell