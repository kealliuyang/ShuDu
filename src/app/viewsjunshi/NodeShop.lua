
local NodeShop  = class("NodeShop",BaseNode)


NodeShop.ICON = {
	"image/shop/30tongbi.png",
	"image/shop/60tongbi.png",
	"image/shop/100tongbi.png"
}

NodeShop.TITLE = {
	"image/shop/30tb.png",
	"image/shop/60tb.png",
	"image/shop/100tb.png"
}

NodeShop.COIN = {
	30,
	60,
	100
}

NodeShop.QIAN = {
	6,
	12,
	18
}

function NodeShop:ctor( parentPanel,index )
	self._parentPanel = parentPanel
	NodeShop.super.ctor( self,"NodeShop" )
	self:addCsb( "csbjunshi/NodeShop.csb" )

	self:loadDataUi( index )

    TouchNode.extends( self.Bg, function(event)
		return self:touchCard( event ) 
	end )
end

function NodeShop:loadDataUi( index )
	assert( index," !! index is nil !! ")
	self._index = index
	self.Icon:loadTexture( NodeShop.ICON[index],1 )
	self.ImageCoin:loadTexture( NodeShop.TITLE[index],1 )
	self.TextQian:setString( NodeShop.QIAN[index].."$")
end


function NodeShop:touchCard( event )
	if event.name == "began" then
        return true
    elseif event.name == "moved" then
		
    elseif event.name == "ended" then
    	self:buyCoin()
    	audio.playSound("jsmp3/button.mp3", false)
    elseif event.name == "outsideend" then
    	
    end
end




function NodeShop:buyCoin()
	addUIToScene( UIDefine.JUNSHI_KEY.Buy_UI,self._index )
end



function NodeShop:clearUiState()
	
end

return NodeShop