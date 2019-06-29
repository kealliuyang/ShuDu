
local RankCell  = class("RankCell",BaseNode)


function RankCell:ctor( parentPanel )
	self._parentPanel = parentPanel
	RankCell.super.ctor( self,"RankCell" )
	self:addCsb( "csbtwentyone/NodeRank.csb" )
end

function RankCell:loadDataUi( data,index )
	assert( data," !! data is nil !! ")
	assert( index," !! index is nil !! ")
	self:clearUiState()
	-- index
	if index <= 3 then
		self.Bg:loadTexture("image/rank/paimingdb.png",1 )
		self.IconSp:setVisible( true )
		self.IconSp:loadTexture("image/rank/paiming"..index..".png",1 )
	else
		self.Bg:loadTexture("image/rank/paimingdbtong.png",1 )
		self.IconIndex:setVisible( true )
		self.TextIndex:setString( index )
	end
	-- score
	self.TextScore:setString(data.score)
	-- time
	self.TextTime:setString(os.date("%Y.%m.%d %H:%M", data.time))
end

function RankCell:clearUiState()
	self.IconSp:setVisible( false )
	self.IconIndex:setVisible( false )
end


return RankCell