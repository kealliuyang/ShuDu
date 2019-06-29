
local RankCell  = class("RankCell",BaseNode)


function RankCell:ctor( parentPanel )
	self._parentPanel = parentPanel
	RankCell.super.ctor( self,"RankCell" )
	self:addCsb( "csbzhipai/NodeRank.csb" )
end

function RankCell:loadDataUi( data,index )
	assert( data," !! data is nil !! ")
	assert( index," !! index is nil !! ")
	self:clearUiState()
	-- index
	if index <= 3 then
		self.ImageRanking:setVisible( true )
		self.ImageRanking:loadTexture("image/rank/paiming"..index..".png",1 )
	end
	self.TextRanking:setString( index )

	self.TextPass:setString( data.level )
	-- score
	self.TextScore:setString( data.score )
	-- time
	self.TextDate:setString(os.date("%Y.%m.%d %H:%M", data.time))
end

function RankCell:clearUiState()
	self.ImageRanking:setVisible( false )
end


return RankCell