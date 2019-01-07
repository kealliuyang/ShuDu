
local AdvancedNode = class("AdvancedNode",BaseNode)



function AdvancedNode:ctor( configIndex,imageIndex )
	AdvancedNode.super.ctor( self,"AdvancedNode" )
    self:setCascadeOpacityEnabled(true)
    self._configIndex = configIndex
    self._imageIndex = imageIndex
    self._boxList_N = {}
    self._boxList_H = {}
	self:initNode()
end


function AdvancedNode:initNode()
    local index = self._configIndex
    if not self._configIndex then
        local len = #eli_advanced_config
        index = random(1,len)
        self._configIndex = index
    end
    local data = eli_advanced_config[index]
    self._configData = data

    local image_index = self._imageIndex
    if not self._imageIndex then
        image_index = random(1,#eli_advanced_image_path_n)
        self._imageIndex = image_index
    end
    self._imagePath_N = eli_advanced_image_path_n[image_index]
    self._imagePath_H = eli_advanced_image_path_h[image_index]

    local cell_width = 66		-- 单个cell的宽
	local cell_height = 66		-- 单个cell的高
	local cell_space = 4 		-- 每个单元格的间距
	local container_space = 60	-- 每行的间距

	-- 创建node 设置大小
	local size_width = self._configData.width * ( cell_width + cell_space )
	local size_height = self._configData.height * container_space
	local size = cc.size( size_width,size_height )
	self:setContentSize( size )
	self:setAnchorPoint(cc.p(0.5,0.5))

	for i,v in ipairs( self._configData.blocks ) do
		-- n
		local box1 = ccui.ImageView:create(self._imagePath_N,1)
		box1:setAnchorPoint(cc.p(0.5,0.5))
		self:addChild( box1 )
		local x_pos = v.x * ( cell_width + cell_space ) + cell_width / 2
		local y_pos = v.y * container_space + cell_height / 2
		box1:setPosition( cc.p( x_pos,y_pos ) )
		box1:setTag(i*10)
        self._boxList_N[i*10] = box1
		-- h
		local box2 = ccui.ImageView:create(self._imagePath_H,1)
        box2:setAnchorPoint(cc.p(0.5,0.5))
        self:addChild(box2)
        box2:setPosition(cc.p(x_pos,y_pos))
        box2:setTag(i*1000)
        self._boxList_H[i*1000] = box2
        box2:setVisible( false )
	end
end


function AdvancedNode:getConfigData()
    return self._configData
end

function AdvancedNode:changeBoxToH()
    self:hiddenBlock()
    for k,v in pairs(self._boxList_H) do
        v:setVisible( true )
    end
end

function AdvancedNode:changeBoxToN()
    self:hiddenBlock()
    for k,v in pairs(self._boxList_N) do
        v:setVisible( true )
    end
end

function AdvancedNode:BoxHToScale( scaleValue )
    for k,v in pairs(self._boxList_H) do
        v:setScale( scaleValue )
    end
end

function AdvancedNode:hiddenBlock()
    for k,v in pairs(self._boxList_N) do
        v:setVisible( false )
    end
    for k,v in pairs(self._boxList_H) do
        v:setVisible( false )
    end
end

function AdvancedNode:getImageIndex()
    return self._imageIndex
end

function AdvancedNode:getConfigIndex()
    return self._configIndex
end

function AdvancedNode:getFirstBox()
	return self._boxList_N[10]
end

function AdvancedNode:getNeedSpace( needCaltype,i,j )
    if needCaltype == 1 then
        return self:getNeedSpaceNineIndex(i,j)
    elseif needCaltype == 2 then
        return self:getNeedSpaceTenIndex(i,j)
    end
end

function AdvancedNode:getNeedSpaceNineIndex( i,j )
    local start = { i = i,j = j }
    local dd = {}
    local j_five_flag = nil
    table.insert(dd,start)
    for i = 1,3 do
        local meta = {}
        if start.i >= 5 then
            meta.i = start.i + i
            meta.j = start.j
        else
            meta.i = start.i + i
            if not j_five_flag and meta.i == 5 then
                j_five_flag = start.j + i
            end
            if start.i + i > 5 then
                meta.j = j_five_flag
            else
                meta.j = start.j + i
            end
        end
        table.insert(dd,meta)
    end
    return dd
end

function AdvancedNode:getNeedSpaceTenIndex( i,j )
    local start = { i = i,j = j }
    local dd = {}
    local j_five_flag = nil
    table.insert(dd,start)
    for i = 1,3 do
        local meta = {}
        if start.i >= 5 then
            meta.i = start.i + i
            meta.j = start.j - i
        else
            meta.i = start.i + i
            if not j_five_flag and meta.i == 5 then
                j_five_flag = start.j
            end
            if start.i + i > 5 then
                meta.j = j_five_flag - ( start.i + i - 5)
            else
                meta.j = start.j
            end
        end
        table.insert(dd,meta)
    end
    return dd
end

return AdvancedNode