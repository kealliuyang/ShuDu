
local RankCell  = class("RankCell",BaseNode)


function RankCell:ctor( parentPanel )
	self._parentPanel = parentPanel
	RankCell.super.ctor( self,"RankCell" )
	self:addCsb( "csbtwentyfour/NodeRankCell.csb" )
end

function RankCell:loadDataUi( data,index )
	assert( data," !! data is nil !! ")
	assert( index," !! index is nil !! ")
	self:clearUiState()
	-- index
	if index <= 3 then
		self.ImageNum:setVisible( true )
		self.ImageNum:loadTexture("image/6/"..index..".png",1 )
	else
		self.TextNum:setVisible( true )
		self.TextNum:setString( index )
	end
	-- score
	self.TextScore:setString(formatMinuTimeStr(data.score,":"))
	-- time
	self.TextDate:setString(os.date("%Y.%m.%d", data.time))
	-- hour
	self.TextHour:setString(os.date("%H:%M:%S", data.time))
end

function RankCell:clearUiState()
	self.ImageNum:setVisible( false )
	self.TextNum:setVisible( false )
end

return RankCell