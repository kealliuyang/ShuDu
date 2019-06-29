
local RankCell  = class("RankCell",BaseNode)


function RankCell:ctor( parentPanel )
	self._parentPanel = parentPanel
	RankCell.super.ctor( self,"RankCell" )
	self:addCsb( "csbmajiang/RankCell.csb" )
end

function RankCell:loadDataUi( data,index )
	assert( data," !! data is nil !! ")
	assert( index," !! index is nil !! ")
	self:clearUiState()
	-- index
	if index <= 3 then
		self.BgIndex:loadTexture("image/4/"..index..".png",1 )
	end
	self.TextIndex:setString( index )
	-- score
	self.TextGold:setString(data.score)
	-- time
	self.TextTime:setString(os.date("%Y.%m.%d %H:%M", data.time))
end

function RankCell:clearUiState()
	
end

return RankCell