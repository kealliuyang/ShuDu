
local RankCell  = class("RankCell",BaseNode)


function RankCell:ctor( parentPanel )
	self._parentPanel = parentPanel
	RankCell.super.ctor( self,"RankCell" )
	self:addCsb( "csbEliminate/NodeRankCell.csb" )
end

function RankCell:loadDataUi( data,index )
	assert( data," !! data is nil !! ")
	assert( index," !! index is nil !! ")
	self:clearUIState()
	-- bg
	if index == 1 then
		self.Bg1:setVisible( true )
		self.NB_bg1:setVisible( true )
	else
		self.Bg2:setVisible( true )
		self.NB_bg2:setVisible( true )
	end
	-- rank
	self.TextRank:setString(index)
	-- score
	self.TextScore:setString(data.score)
	-- time
	self.TextTime:setString(os.date("%Y.%m.%d %H:%M", data.time))
end

function RankCell:clearUIState()
	self.Bg1:setVisible( false )
	self.Bg2:setVisible( false )
	self.NB_bg1:setVisible( false )
	self.NB_bg2:setVisible( false )
end


return RankCell