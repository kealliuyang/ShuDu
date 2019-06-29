
local RankCell  = class("RankCell",BaseNode)


function RankCell:ctor( parentPanel )
	self._parentPanel = parentPanel
	RankCell.super.ctor( self,"RankCell" )
	self:addCsb( "csbjunshi/NodeRank.csb" )
end

function RankCell:loadDataUi( data,index )
	assert( data," !! data is nil !! ")
	assert( index," !! index is nil !! ")
	self:clearUiState()
	-- index
	if index <= 3 then
		self.IconIndex:loadTexture("image/rank/paiming"..index..".png",1 )
	else
		self.IconIndex:loadTexture("image/rank/paiming4.png",1 )
	end
	self.TextIndex:setString( index )
	-- score
	self.TextScore:setString( data.score )
	-- time
	self.TextTime:setString(os.date("%Y.%m.%d %H:%M", data.time))
	-- people
	self["ImagePeople"]:loadTexture( js_over_people_path[data.people],1 )
end

function RankCell:clearUiState()
	
end


return RankCell