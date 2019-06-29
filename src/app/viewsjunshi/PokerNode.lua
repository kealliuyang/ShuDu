

local PokerNode = class("PokerNode",BaseNode)


function PokerNode:ctor( parentPanel,mType )
	self._parentPanel = parentPanel
	PokerNode.super.ctor( self,"PokerNode" )
	self:addCsb( "csbjunshi/NodePoker.csb" )

	self._mType = mType

	if mType and mType == "player" then
		G_AddNodeClick( self.ImagePokerDi,{
			endedCallBack = function() self:touchEnd() end,
			cancelCallBack = function() self:cancelEnd() end
		})
	end
end


function PokerNode:loadDataUI( num )
	assert( num," !! num is nil !! " )
	self:clearUiState()
	self._num = num

	if self._mType == "ai" then
		self.ImagePokerDi:loadTexture( js_card_path_config[1],1 )
		return
	end

	if self._num == 7 then
		self.ImageZhuan1:setVisible( true )
		self.ImageZhuan2:setVisible( true )
	else
		self.IconPeople:setVisible( true )

		local people_path = js_card_people_path[ self._num ]
		self.IconPeople:loadTexture( people_path,1 )
		
		if self._num <= 6 then
			self.ImageNum:setVisible( true )
			self.ImageNum:loadTexture( js_card_image_num_path[ self._num ],1 )
		end

		if self._num == 8 then
			self.ImageJunshi:setVisible( true )
			self.ImageJunshi:setVisible( true )
		end
	end
end

function PokerNode:touchEnd()
	-- audio.playSound("jsmp3/button.mp3", false)
	self._parentPanel:playerOutCard( self )
end

function PokerNode:cancelEnd()
	self._parentPanel:clearPlayerSelect()
end


function PokerNode:getNum()
	return self._num
end


function PokerNode:clearUiState()
	self.IconPeople:setVisible( false )
	self.ImageZhuan1:setVisible( false )
	self.ImageZhuan2:setVisible( false )
	self.ImageNum:setVisible( false )
	self.ImageJunshi:setVisible( false )
end






return PokerNode