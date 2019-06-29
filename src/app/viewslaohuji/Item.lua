

local Item = class( "Item",BaseNode )



function Item:ctor()
	Item.super.ctor( self,"Item" )
	self:addCsb( "csblaohuji/Item.csb" )
end


function Item:loadUIData( data )
	assert( data," !! data is nil !! " )
	self:clearUiState()
	local mode = G_GetModel("Model_LaoHuJi"):getGameType()
	local item_img = nil
	if mode == 1 then
		item_img = lhj_fruits_item_img
	elseif mode == 2 then
		item_img = lhj_animal_item_img
	elseif mode == 3 then
		item_img = lhj_seabed_item_img
	end
	self.Icon:loadTexture( item_img[data.index],1 )
	self.TextRate:setVisible( data.rate > 1 )
	self.TextRate:setString( "x"..data.rate )
end



function Item:getDesignSize()
	return self.Bg:getContentSize()
end

function Item:lightAction()
	self.Light:setVisible( true )
	self.Light:setOpacity( 255 )
	local fade_out = cc.FadeOut:create( 0.8 )
	local call_back = cc.CallFunc:create( function()
		self.Light:setVisible( false )
	end )
	local seq = cc.Sequence:create({ fade_out,call_back })
	self.Light:runAction( seq )
end

function Item:clearUiState()
	self.Light:setVisible( false )
end








return Item