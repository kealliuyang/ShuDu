
local BlockNode = class("BlockNode",BaseNode)


function BlockNode:ctor( configIndex,imageIndex )
	BlockNode.super.ctor( self,"BlockNode" )
    self:setCascadeOpacityEnabled(true)
    self._configIndex = configIndex
    self._imageIndex = imageIndex
    self._boxList_N = {}
    self._boxList_H = {}
	self:initNode()
end


function BlockNode:initNode()
    local width_num,height_num = 0,0
    self._configData = {}
    -- 找出该元素的最大长度
    local image_index = self._imageIndex
    if not self._imageIndex then
        image_index = random(1,#eli_block_image_path_n)
        self._imageIndex = image_index
    end
    self._imagePath_N = eli_block_image_path_n[image_index]
    self._imagePath_H = eli_block_image_path_h[image_index]

    local index = nil
    if self._configIndex then
        index = self._configIndex
    else
        local len = #eli_block_config
        index = random(1,len)
    end
    self._configIndex = index

    local data = eli_block_config[index]
    self._configData = data
    for i,v in ipairs(data) do
        local temp_width_num = 0
        for a,b in ipairs(v) do
            if b > 0 then
                temp_width_num = temp_width_num + 1
            end
        end
        if temp_width_num > width_num then
            width_num = temp_width_num
        end
    end
    height_num = #data

    local space = 2 -- 间隙为2个像素
    
    local box_width = ccui.ImageView:create(self._imagePath_N,1):getContentSize().width
    local node_size = cc.size( width_num * box_width + (width_num - 1) * space,height_num * box_width + (height_num - 1) * space )
    self:setContentSize( node_size )
    self:setAnchorPoint(cc.p(0.5,0.5))

    for i = 1,height_num do
    	for j = 1,width_num do
    		if self._configData[i][j] > 0 then
                -- n
	    		local box1 = ccui.ImageView:create(self._imagePath_N,1)
                box1:setAnchorPoint(cc.p(0.5,0.5))
				self:addChild(box1)
				local x_pos = (j - 1) * (box_width + space) + (box_width + space) / 2
				local y_pos = (i - 1) * (box_width + space) + (box_width + space) / 2
				box1:setPosition(cc.p(x_pos,y_pos))
                box1:setTag(i*10 + j)
                self._boxList_N[i*10 + j] = box1
                -- h
                local box2 = ccui.ImageView:create(self._imagePath_H,1)
                box2:setAnchorPoint(cc.p(0.5,0.5))
                self:addChild(box2)
                box2:setPosition(cc.p(x_pos,y_pos))
                box2:setTag(i*1000 + j)
                self._boxList_H[i*1000 + j] = box2
                box2:setVisible( false )
			end
    	end
    end
end

function BlockNode:getConfigData()
    return self._configData
end

function BlockNode:changeBoxToH()
    self:hiddenBlock()
    for k,v in pairs(self._boxList_H) do
        v:setVisible( true )
    end
end

function BlockNode:BoxHToScale( scaleValue )
    for k,v in pairs(self._boxList_H) do
        v:setScale( scaleValue )
    end
end

function BlockNode:changeBoxToN()
    self:hiddenBlock()
    for k,v in pairs(self._boxList_N) do
        v:setVisible( true )
    end
end

function BlockNode:hiddenBlock()
    for k,v in pairs(self._boxList_N) do
        v:setVisible( false )
    end
    for k,v in pairs(self._boxList_H) do
        v:setVisible( false )
    end
end

function BlockNode:getImageIndex()
    return self._imageIndex
end

function BlockNode:getConfigIndex()
    return self._configIndex
end

return BlockNode