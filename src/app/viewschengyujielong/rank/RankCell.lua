
local RankCell  = class("RankCell",BaseNode)


function RankCell:ctor( parentPanel )
	self._parentPanel = parentPanel
	RankCell.super.ctor( self,"RankCell" )
	self:addCsb( "csbchengyujielong/NodeRank.csb" )
end

function RankCell:loadDataUi( data,index )
	assert( data," !! data is nil !! ")
	assert( index," !! index is nil !! ")
	self:clearUiState()
	-- index
	if index <= 3 then
		self.Bg:loadTexture( "image/rank/paidi"..index..".png",1 )
		self.BgIndex:loadTexture("image/rank/rank"..index..".png",1 )
		self.BgGuanKa:loadTexture("image/rank/fenshu db.png",1)
		self.TextIndex:setVisible( false )
		self.BgScore:loadTexture("image/rank/fenshu db.png",1)
	else
		self.Bg:loadTexture( "image/rank/paidi.png",1 )
		self.BgIndex:loadTexture("image/rank/yuan.png",1 )
		self.BgGuanKa:loadTexture("image/rank/fenshu db hui.png",1)
		self.BgScore:loadTexture("image/rank/fenshu db hui.png",1)
		self.TextIndex:setVisible( true )
	end

	self.TextIndex:setString( index )

	self.TextGuKa:setString( data.level )

	-- score
	self.TextScore:setString( data.score )
	-- time
	self.TextTime:setString( os.date("%Y.%m.%d", data.time) )
end

function RankCell:clearUiState()
	self.BgIndex:ignoreContentAdaptWithSize( true )
end


return RankCell