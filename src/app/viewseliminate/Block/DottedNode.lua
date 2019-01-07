
local DottedNode = class("DottedNode",BaseNode)



function DottedNode:ctor()
	DottedNode.super.ctor( self,"DottedNode" )
	self._boxList_N = {}
	self:initNode()
end

function DottedNode:initNode()
    local width_num = 5
    local height_num = 5
    self._imagePath_N = "image/game/general/Dotted-box1.png"

    local box_width = ccui.ImageView:create(self._imagePath_N,1):getContentSize().width
    local node_size = cc.size( width_num * box_width,height_num * box_width)
    self:setContentSize( node_size )
    self:setAnchorPoint(cc.p(0,0))

    for i = 1,height_num do
    	for j = 1,width_num do
    		local box1 = ccui.ImageView:create(self._imagePath_N,1)
            box1:setAnchorPoint(cc.p(0,0))
			self:addChild(box1)
			local x_pos = (j - 1) * (box_width + 2)
			local y_pos = (i - 1) * (box_width + 2)
			box1:setPosition(cc.p(x_pos,y_pos))
            box1:setTag(i*10 + j)
            self._boxList_N[i*10 + j] = box1
    	end
    end
end

function DottedNode:showBlockByConfig( config )
	assert( config," !! config is nil !! ")
	for i,v in ipairs(config) do
        for a,b in ipairs(v) do
            if b > 0 then
                self._boxList_N[i*10 + a]:setVisible( true )
            end
        end
    end
end

function DottedNode:hiddenBlock()
    for k,v in pairs(self._boxList_N) do
        v:setVisible( false )
    end
end

return DottedNode