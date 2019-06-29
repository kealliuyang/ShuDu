
local NodeShop  = class("NodeShop",BaseNode)


NodeShop.ICON = {
	"image/shop/500jinbi.png",
	"image/shop/1000jinbi.png",
	"image/shop/1500jinbi.png"
}

NodeShop.COIN = {
	500,
	1000,
	1500
}

NodeShop.QIAN = {
	6,
	12,
	18
}

function NodeShop:ctor( parentPanel,index )
	self._parentPanel = parentPanel
	NodeShop.super.ctor( self,"RankCell" )
	self:addCsb( "csbtwentyone/NodeShop.csb" )

	self:loadDataUi( index )

    TouchNode.extends( self.BgQian, function(event)
		return self:touchCard( event ) 
	end )
end

function NodeShop:loadDataUi( index )
	assert( index," !! index is nil !! ")
	self._index = index
	self.Icon:loadTexture( NodeShop.ICON[index],0 )
	self.TextCoin:setString( NodeShop.COIN[index] )
	self.TextQian:setString( "$"..NodeShop.QIAN[index] )
end


function NodeShop:touchCard( event )
	if event.name == "began" then
        return true
    elseif event.name == "moved" then
		
    elseif event.name == "ended" then
    	self:buyCoin()
    	audio.playSound("tomp3/selectpoker.mp3", false)
    elseif event.name == "outsideend" then
    	
    end
end



function NodeShop:buyCoin()
	addUIToScene( UIDefine.TWENTYONE_KEY.Buy_UI,self._index )
end


function NodeShop:clearUiState()
	
end

return NodeShop