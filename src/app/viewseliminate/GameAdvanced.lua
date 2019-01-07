
local AdvancedNode = import(".Block.AdvancedNode")
local GameAdvanced = class("GameAdvanced",BaseLayer)


function GameAdvanced:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameAdvanced.super.ctor( self,param.name )
    self:addCsb( "csbEliminate/LayerGameAdvance.csb" )
	self:setCascadeOpacityEnabled(true)

	-- 暂停
    self:addNodeClick( self["ButtonPause"],{
        endCallBack = function() self:clickPause() end
    })
    -- 刷新
    self:addNodeClick( self["ButtonRefresh"],{
        endCallBack = function() self:clickRefresh() end
    })

	for i = 1,3 do
        self:addNodeClick(self["Panel"..i],{
            beganCallBack = function( touchPoint ) self:touchBlockBegan( touchPoint,i ) end,
            moveCallBack = function( touchPoint ) self:touchBlockMoved( touchPoint,i ) end,
            endCallBack = function( touchPoint ) self:touchBlockEnd( touchPoint,i ) end,
            touchOutside = true,
            scaleAction = false
        })
    end

	-- 初始化界面数据
	self:loadDataUI()
	-- 初始化要放入的数据
	self:initDropList()
	-- 添加背景方块
    self:initBgBlock()
    -- 默认隐藏dotted
    self:hiddenAllDotted()
    -- 初始化要销毁的矩阵
    self:initDestoryList()

    -- 判断有没有缓存数据
    local contineue_data = G_GetModel("Model_Eliminate"):getContinueAdvancedData()
    if contineue_data then
        -- 添加要放入的方块
        self:createContinueBlock( contineue_data.createBlock )
        -- 添加已经存在的方块
        self:putContinueBlock( contineue_data.putBlock )
        -- 分数
        self._totalScore = contineue_data.score
        self.TextScore:setString( self._totalScore )
        -- 刷新次数
        self._refreshTimes = contineue_data.refreshTimes
        self.TextTimes:setString("x"..self._refreshTimes)
        -- 重置存储数据
        G_GetModel("Model_Eliminate"):clearContinueAdvancedData()
    else
        -- 添加要放入的方块
        self:createBlock()
    end
end
function GameAdvanced:onEnter()
	GameAdvanced.super.onEnter( self )
	self:onEnterAction()
end
function GameAdvanced:onEnterAction()
	-- 动画
	self._csbNode:setVisible(false)
	local delay = cc.DelayTime:create(0.2)
	local fade_call = cc.CallFunc:create( function()
		casecadeFadeInNode( self._csbNode,0.5 )
		self._csbNode:setVisible(true)
        -- 音效
        audio.playSound("elimp3/in.mp3", false)
	end )
	local seq = cc.Sequence:create({delay,fade_call})
	self._csbNode:runAction( seq )
end
-- 界面数据
function GameAdvanced:loadDataUI()
    -- 初始化积分
    self._totalScore = 0
    self.TextScore:setString( self._totalScore )
    -- 初始化最高积分
    local maxScore = G_GetModel("Model_Eliminate"):getAdvancedScore()
    self.TextBestScore:setString( maxScore )
    -- 刷新的使用次数
    self._refreshTimes = 2
    self.TextTimes:setString("x"..self._refreshTimes)
end
-- 要放入的数据
function GameAdvanced:initDropList()
	self._dropList = {}
	for i = 1,5 do
		self._dropList[i] = {}
		local len = 5 + i - 1
		for j = 1,len do
			self._dropList[i][j] = { canPut = true,imageIndex = 0 }
		end
	end
	for i = 6,9 do
		self._dropList[i] = {}
		local len = 13 - i + 1
		for j = 1,len do
			self._dropList[i][j] = { canPut = true,imageIndex = 0 }
		end
	end
end
-- 背景方块
function GameAdvanced:initBgBlock()
	self._bgCellList = {}
	local cell_width = 66		-- 单个cell的宽
	local cell_height = 66		-- 单个cell的高
	local cell_space = 4 		-- 每个单元格的间距
	local container_space = 60	-- 每行的间距
    local container1_pos = 160
	for i = 1,5 do
		self._bgCellList[i] = {}
		local container = cc.Node:create()
		local len = 5 + i - 1
		local size = cc.size( cell_width * len + cell_space * (len - 1),cell_height )
		container:setContentSize( size )

		self["MainPanel"]:addChild( container )
		container:setPosition(container1_pos - ( i - 1 )*(cell_width / 2),55 + ( i - 1 ) * container_space )
		for j = 1,len do
			self:createBgGrid( container,i,j,cell_space )
		end
	end
    local container2_pos = container1_pos - ( 4 - 1 ) * (cell_width / 2)
	for i = 6,9 do
		self._bgCellList[i] = {}
		local container = cc.Node:create()
		local len = 13 - i + 1
		local size = cc.size( cell_width * len + cell_space * (len - 1),cell_height )
		container:setContentSize( size )
		self["MainPanel"]:addChild( container )
		container:setPosition(container2_pos + ( i - 6 )*(cell_width / 2),55 + ( i - 1 ) * container_space )
		for j = 1,len do
            self:createBgGrid( container,i,j,cell_space )
		end
	end
end
-- 背景方块元素
function GameAdvanced:createBgGrid( container,i,j,cellSpace )
	-- grid
	local bg_cell = ccui.ImageView:create("image/game/advanced/grid_1.png",1)
    local box_width = bg_cell:getContentSize().width
    local box_height = bg_cell:getContentSize().height
    container:addChild(bg_cell)
    local x_pos = ( j - 1 ) * ( box_width + cellSpace ) + box_width / 2
    local y_pos = box_height / 2
    bg_cell:setPosition(cc.p( x_pos,y_pos ))
    self._bgCellList[i][j] = bg_cell
    -- dotted
    local dotted = ccui.ImageView:create("image/game/advanced/Dotted-box2.png",1)
    bg_cell:addChild( dotted )
    dotted:setPosition( cc.p( box_width / 2,box_height/ 2) )
    dotted:setTag(9999)
end
-- 要放入的方块
function GameAdvanced:createBlock()
	-- 先删除
    for i = 1,3 do
        local box = self["Panel"..i]:getChildByTag(1001)
        if box then
            box:removeFromParent()
        end
    end
    for i = 1,3 do
        local box = AdvancedNode.new()
        self["Panel"..i]:addChild(box)
        box:setTag(1001)
        local box_size = box:getContentSize()
        box:setScale(0.5)
        local panel_size = self["Panel"..i]:getContentSize()
        local x_pos = panel_size.width / 2 
        local y_pos = panel_size.height / 2
        box:setPosition( cc.p(x_pos,y_pos) )
    end
end
-- 要放入的方块
function GameAdvanced:createContinueBlock( data )
    for i,v in ipairs( data ) do
        local box = AdvancedNode.new( v.config_index,v.image_index )
        self["Panel"..v.index]:addChild(box)
        box:setTag(1001)
        local box_size = box:getContentSize()
         box:setScale(0.5)
        local panel_size = self["Panel"..v.index]:getContentSize()
        local x_pos = panel_size.width / 2
        local y_pos = panel_size.height / 2
        box:setPosition( cc.p(x_pos,y_pos) )
    end
end
-- 创建已经存在的游戏区域的方块
function GameAdvanced:putContinueBlock( data )
    for i,v in ipairs( data ) do
        local image_path = eli_advanced_image_path_n[v.imageIndex]
        local block = ccui.ImageView:create(image_path,1)
        self._bgCellList[v.i][v.j]:addChild(block,10)
        local size = self._bgCellList[v.i][v.j]:getContentSize()
        block:setPosition(cc.p(size.width / 2,size.height / 2))
        block:setTag(3001)
        block._imageIndex = v.imageIndex

        self._dropList[v.i][v.j].canPut = false
        self._dropList[v.i][v.j].imageIndex = v.imageIndex
    end    
end
-- 要销毁的列表矩阵
function GameAdvanced:initDestoryList()
    self._destoryList = {}
    -- 行
    self._destoryList.rows = {
        [1] = {{ i = 1,j = 1 },{ i = 1,j = 2 },{ i = 1,j = 3 },{ i = 1,j = 4 },{ i = 1,j = 5 }},
        [2] = {{ i = 2,j = 1 },{ i = 2,j = 2 },{ i = 2,j = 3 },{ i = 2,j = 4 },{ i = 2,j = 5 },{ i = 2,j = 6 }},
        [3] = {{ i = 3,j = 1 },{ i = 3,j = 2 },{ i = 3,j = 3 },{ i = 3,j = 4 },{ i = 3,j = 5 },{ i = 3,j = 6 },{ i = 3,j = 7 }},
        [4] = {{ i = 4,j = 1 },{ i = 4,j = 2 },{ i = 4,j = 3 },{ i = 4,j = 4 },{ i = 4,j = 5 },{ i = 4,j = 6 },{ i = 4,j = 7 },{ i = 4,j = 8 }},
        [5] = {{ i = 5,j = 1 },{ i = 5,j = 2 },{ i = 5,j = 3 },{ i = 5,j = 4 },{ i = 5,j = 5 },{ i = 5,j = 6 },{ i = 5,j = 7 },{ i = 5,j = 8 },{ i = 5,j = 9 }},
        [6] = {{ i = 6,j = 1 },{ i = 6,j = 2 },{ i = 6,j = 3 },{ i = 6,j = 4 },{ i = 6,j = 5 },{ i = 6,j = 6 },{ i = 6,j = 7 },{ i = 6,j = 8 }},
        [7] = {{ i = 7,j = 1 },{ i = 7,j = 2 },{ i = 7,j = 3 },{ i = 7,j = 4 },{ i = 7,j = 5 },{ i = 7,j = 6 },{ i = 7,j = 7 }},
        [8] = {{ i = 8,j = 1 },{ i = 8,j = 2 },{ i = 8,j = 3 },{ i = 8,j = 4 },{ i = 8,j = 5 },{ i = 8,j = 6 }},
        [9] = {{ i = 9,j = 1 },{ i = 9,j = 2 },{ i = 9,j = 3 },{ i = 9,j = 4 },{ i = 9,j = 5 }}
    }
    -- 列1
    self._destoryList.cols1 = {
        [1] = {{ i = 1,j = 1 },{ i = 2,j = 1 },{ i = 3,j = 1 },{ i = 4,j = 1 },{ i = 5,j = 1 }},
        [2] = {{ i = 1,j = 2 },{ i = 2,j = 2 },{ i = 3,j = 2 },{ i = 4,j = 2 },{ i = 5,j = 2 },{ i = 6,j = 1 }},
        [3] = {{ i = 1,j = 3 },{ i = 2,j = 3 },{ i = 3,j = 3 },{ i = 4,j = 3 },{ i = 5,j = 3 },{ i = 6,j = 2 },{ i = 7,j = 1 }},
        [4] = {{ i = 1,j = 4 },{ i = 2,j = 4 },{ i = 3,j = 4 },{ i = 4,j = 4 },{ i = 5,j = 4 },{ i = 6,j = 3 },{ i = 7,j = 2 },{ i = 8,j = 1 }},
        [5] = {{ i = 1,j = 5 },{ i = 2,j = 5 },{ i = 3,j = 5 },{ i = 4,j = 5 },{ i = 5,j = 5 },{ i = 6,j = 4 },{ i = 7,j = 3 },{ i = 8,j = 2 },{ i = 9,j = 1 }},
        [6] = {{ i = 2,j = 6 },{ i = 3,j = 6 },{ i = 4,j = 6 },{ i = 5,j = 6 },{ i = 6,j = 5 },{ i = 7,j = 4 },{ i = 8,j = 3 },{ i = 9,j = 2 }},
        [7] = {{ i = 3,j = 7 },{ i = 4,j = 7 },{ i = 5,j = 7 },{ i = 6,j = 6 },{ i = 7,j = 5 },{ i = 8,j = 4 },{ i = 9,j = 3 }},
        [8] = {{ i = 4,j = 8 },{ i = 5,j = 8 },{ i = 6,j = 7 },{ i = 7,j = 6 },{ i = 8,j = 5 },{ i = 9,j = 4 }},
        [9] = {{ i = 5,j = 9 },{ i = 6,j = 8 },{ i = 7,j = 7 },{ i = 8,j = 6 },{ i = 9,j = 5 }}
    }
    -- 列2
    self._destoryList.cols2 = {
        [1] = {{ i = 5,j = 1 },{ i = 6,j = 1 },{ i = 7,j = 1 },{ i = 8,j = 1 },{ i = 9,j = 1 }},
        [2] = {{ i = 4,j = 1 },{ i = 5,j = 2 },{ i = 6,j = 2 },{ i = 7,j = 2 },{ i = 8,j = 2 },{ i = 9,j = 2 }},
        [3] = {{ i = 3,j = 1 },{ i = 4,j = 2 },{ i = 5,j = 3 },{ i = 6,j = 3 },{ i = 7,j = 3 },{ i = 8,j = 3 },{ i = 9,j = 3 }},
        [4] = {{ i = 2,j = 1 },{ i = 3,j = 2 },{ i = 4,j = 3 },{ i = 5,j = 4 },{ i = 6,j = 4 },{ i = 7,j = 4 },{ i = 8,j = 4 },{ i = 9,j = 4 }},
        [5] = {{ i = 1,j = 1 },{ i = 2,j = 2 },{ i = 3,j = 3 },{ i = 4,j = 4 },{ i = 5,j = 5 },{ i = 6,j = 5 },{ i = 7,j = 5 },{ i = 8,j = 5 },{ i = 9,j = 5 }},
        [6] = {{ i = 1,j = 2 },{ i = 2,j = 3 },{ i = 3,j = 4 },{ i = 4,j = 5 },{ i = 5,j = 6 },{ i = 6,j = 6 },{ i = 7,j = 6 },{ i = 8,j = 6 }},
        [7] = {{ i = 1,j = 3 },{ i = 2,j = 4 },{ i = 3,j = 5 },{ i = 4,j = 6 },{ i = 5,j = 7 },{ i = 6,j = 7 },{ i = 7,j = 7 }},
        [8] = {{ i = 1,j = 4 },{ i = 2,j = 5 },{ i = 3,j = 6 },{ i = 4,j = 7 },{ i = 5,j = 8 },{ i = 6,j = 8 }},
        [9] = {{ i = 1,j = 5 },{ i = 2,j = 6 },{ i = 3,j = 7 },{ i = 4,j = 8 },{ i = 5,j = 9 }}
    }
end

function GameAdvanced:touchBlockBegan( touchPoint,index )
	-- 处于回到原位的过程中
    if self._returnBack then
        return
    end
    if not self["Panel"..index]:getChildByTag(1001) then
        return
    end
    -- 触摸开始 执行一个动作 并初始化数据
    self._canMove = false
    self._touchBox = self["Panel"..index]:getChildByTag(1001)
    self._touchBeganPos = touchPoint
    self._boxOriginalPos = cc.p( self._touchBox:getPosition() )

    local scale_to = cc.ScaleTo:create(0.1,0.8)
    local move_by = cc.MoveBy:create(0.1,cc.p(0,150))
    local spawn = cc.Spawn:create({scale_to,move_by})
    local move_call = cc.CallFunc:create( function()
        self._canMove = true
        self._boxBeganPos = cc.p( self._touchBox:getPosition() )
        -- 变为高亮
        self._touchBox:changeBoxToH()
        -- 修改scale
        self._touchBox:setScale(1)
        self._touchBox:BoxHToScale( 0.8 )
    end )
    local seq = cc.Sequence:create({spawn,move_call})
    self._touchBox:runAction(seq)
end

function GameAdvanced:touchBlockMoved( touchPoint,index )
    if not self._canMove then
        return
    end
    local dis_pos = {
        x = touchPoint.x - self._touchBeganPos.x,
        y = touchPoint.y - self._touchBeganPos.y
    }

    local new_pos = {
        x = dis_pos.x + self._boxBeganPos.x,
        y = dis_pos.y + self._boxBeganPos.y
    }
    self._touchBox:setPosition(new_pos)

    -- 检查能否放入方块中
    local can,need_space = self:checkCanPut()
    if can then
        self:showDottedBySpace( need_space )
    else
        self:hiddenAllDotted()
    end
end

function GameAdvanced:touchBlockEnd( touchPoint,index )
    local can,need_space = self:checkCanPut()
    if can then
        -- 放入方块中
        self:putBlock( need_space )
    else
        -- 回到原位
        self._returnBack = true
        local scale_to = cc.ScaleTo:create(0.1,0.5)
        local move_to = cc.MoveTo:create(0.1,self._boxOriginalPos)
        local spawn = cc.Spawn:create({scale_to,move_to})
        local return_call = cc.CallFunc:create( function()
            self._returnBack = nil
            self._touchBox:setPosition( self._boxOriginalPos )
            -- 恢复原亮
            self._touchBox:changeBoxToN()
        end )
        local seq = cc.Sequence:create({spawn,return_call})
        self._touchBox:runAction(seq)
    end
end
-- 检查能否放入
function GameAdvanced:checkCanPut()
	local config = self._touchBox:getConfigData()
	local box = self._touchBox:getFirstBox()
	local pos = cc.p( box:getPosition() )
    pos.x = pos.x - box:getContentSize().width / 2
    pos.y = pos.y - box:getContentSize().height / 2
	local world_point = box:getParent():convertToWorldSpace(pos)
	-- 得到放点
	local i,j = self:getCellPosByWorldPoint( world_point )
	if i <= 0 or j <= 0 or i > 9 or j > 9 then
		return false
	end
	-- 检查剩余的点能否放入
	return self:checkCanPutByPos( config,i,j )
end
-- 放入bolck
function GameAdvanced:putBlock( needSpace )
    -- 播放音效
    audio.playSound("elimp3/put.mp3", false)
	-- 1:设置存放区域的数据
	local imageIndex = self._touchBox:getImageIndex()
    for i,v in ipairs(needSpace) do
        self._dropList[v.i][v.j].canPut = false
        self._dropList[v.i][v.j].imageIndex = imageIndex
    end
    -- 2:将box放入区域
    local bg_cell = self._bgCellList[needSpace[1].i][needSpace[1].j]
    local bg_size = bg_cell:getContentSize()
    local bg_pos = cc.p( bg_cell:getPosition() )
    bg_pos.x = bg_pos.x - bg_size.width / 2
    bg_pos.y = bg_pos.y - bg_size.height / 2
    local world_point1 = bg_cell:getParent():convertToWorldSpace( bg_pos )
    local box = self._touchBox:getFirstBox()
	local box_pos = cc.p( box:getPosition() )
    box_pos.x = box_pos.x - box:getContentSize().width / 2
    box_pos.y = box_pos.y - box:getContentSize().height / 2
	local world_point2 = box:getParent():convertToWorldSpace( box_pos )
	local dis_x = world_point1.x - world_point2.x
    local dis_y = world_point1.y - world_point2.y

    local move_by = cc.MoveBy:create(0.1,cc.p(dis_x,dis_y))
    local call_back = cc.CallFunc:create( function()
        self._touchBox:removeFromParent()
        -- 隐藏dotted
        self:hiddenAllDotted()
        -- 创建cell
        self:createPutBlock( needSpace,imageIndex )
        -- 获得需要销毁的数据
        local destory_data,rows,cols1,cols2 = self:getDestoryData()
        -- 执行销毁动画
        self:blockDestoryAction( destory_data,rows,cols1,cols2 )
        -- 重置dropList的数据
        self:resetDropList( destory_data )

        -- 计算积分动画
        local before = self._totalScore
        self._totalScore = self._totalScore + 20 * (table.nums(rows) + table.nums(cols1) + table.nums(cols2)) * table.nums( destory_data )
        local add_num = self._totalScore - before
        dynamicUpdateNum( self.TextScore,add_num,before )

        -- 判断是否还有剩余的砖块
        local has_block = self:hasLeftPutBlock()
        if not has_block then
            -- 加载新的bolck
            self:createBlock()
        end
        -- 判断游戏是否结束
        if self:isGameOver() then
            -- 进入结果页
            local data = { score = self._totalScore,ui = "GameAdvanced" }
            addUIToScene( UIDefine.ELIMI_KEY.GameNotPut_UI,data )
        end
    end )
    local seq = cc.Sequence:create({move_by,call_back})
    self._touchBox:runAction(seq)
end
-- 根据坐标获取cell的位置
function GameAdvanced:getCellPosByWorldPoint( worldPoint )
    local contains = {}
	for i = 1,9 do
		local len = #self._dropList[i]
		for j = 1,len do
			if self._dropList[i][j].canPut then
				local node_point = self._bgCellList[i][j]:getParent():convertToNodeSpace(worldPoint)
	            local bound_box = self._bgCellList[i][j]:getBoundingBox()
                local rect1 = { x = node_point.x, y = node_point.y,width = bound_box.width,height = bound_box.height }
                local rect3 = cc.rectIntersection(rect1,bound_box)
                if rect3.width > 0 and rect3.height > 0 then
                    local meta = { rect = rect3,i = i,j = j }
                    table.insert( contains,meta )
                end
                if #contains >= 4 then
                    break
                end
			end
		end
        if #contains >= 4 then
            break
        end 
	end

    local max_area,max_i,max_j = 0,0,0
    for i,v in ipairs( contains ) do
        local area = v.rect.width * v.rect.height
        if area > max_area then
            max_area = area
            max_i,max_j = v.i,v.j
        end
    end
    return max_i,max_j
end
-- 隐藏dotted
function GameAdvanced:hiddenAllDotted()
	for i = 1,9 do
		local len = #self._dropList[i]
		for j = 1,len do
			local dotted = self._bgCellList[i][j]:getChildByTag(9999)
			dotted:setVisible( false )
		end
	end
end
-- 显示要放入的dotted
function GameAdvanced:showDottedBySpace( space )
	self:hiddenAllDotted()
	for k,v in ipairs( space ) do
		local dotted = self._bgCellList[v.i][v.j]:getChildByTag(9999)
		dotted:setVisible( true )
	end
end
-- 创建放入的方块
function GameAdvanced:createPutBlock( needSpace,imageIndex )
    local image_path = eli_advanced_image_path_n[imageIndex]
    for k,v in ipairs( needSpace ) do
        local block = ccui.ImageView:create(image_path,1)
        self._bgCellList[v.i][v.j]:addChild(block,10)
        local size = self._bgCellList[v.i][v.j]:getContentSize()
        block:setPosition(cc.p(size.width / 2,size.height / 2))
        block:setTag(3001)
        block._imageIndex = imageIndex
    end
end
-- 获取销毁数据
function GameAdvanced:getDestoryData()
    local destory_data = {}
    local rows,cols1,cols2 = {},{},{}
    self:getDestoryBySource( self._destoryList.rows,destory_data,rows )
    self:getDestoryBySource( self._destoryList.cols1,destory_data,cols1 )
    self:getDestoryBySource( self._destoryList.cols2,destory_data,cols2 )
    return destory_data,rows,cols1,cols2
end
-- 获取销毁数据
function GameAdvanced:getDestoryBySource( source,destoryData,rows )
    for i,v in ipairs( source ) do
        local can_destory = true
        for a,b in ipairs( v ) do
            if self._dropList[b.i][b.j].canPut then
                can_destory = false
                break
            end
        end
        if can_destory then
            for a,b in ipairs( v ) do
                if not destoryData[b.i * 100 + b.j] then
                    local meta = { i = b.i,j = b.j,imageIndex = self._dropList[b.i][b.j].imageIndex }
                    destoryData[b.i * 100 + b.j] = meta
                end
            end
            table.insert( rows,i )
        end
    end
end
-- 执行销毁动画
function GameAdvanced:blockDestoryAction( destoryData,rows,cols1,cols2 )
    local unit_score = 20 * (table.nums(rows) + table.nums(cols1) + table.nums(cols2))
    for k,v in ipairs(rows) do
        local row = self._destoryList.rows[v]
        for a,b in ipairs(row) do
            local meta = clone(b)
            meta.imageIndex = destoryData[b.i * 100 + b.j].imageIndex
            self:blockDestoryActionByCell(meta,"rows",a,unit_score,#row)
        end
    end
    for k,v in ipairs(cols1) do
        local row = self._destoryList.cols1[v]
        for a,b in ipairs(row) do
            local meta = clone(b)
            meta.imageIndex = destoryData[b.i * 100 + b.j].imageIndex
            self:blockDestoryActionByCell(meta,"cols1",a,unit_score,#row)
        end
    end
    for k,v in ipairs(cols2) do
        local row = self._destoryList.cols2[v]
        for a,b in ipairs(row) do
            local meta = clone(b)
            meta.imageIndex = destoryData[b.i * 100 + b.j].imageIndex
            self:blockDestoryActionByCell(meta,"cols2",a,unit_score,#row)
        end
    end

    -- 播放消除音效
    if unit_score > 0 then
        local index = random(1,10)
        if index % 2 == 0 then
            audio.playSound("elimp3/xiaochu.mp3", false)
        else
            audio.playSound("elimp3/xiaochu1.mp3", false)
        end
        if #rows > 1 or #cols1 > 1 or #cols2 > 1 or ( #rows + #cols1 + #cols2 ) > 1 then
            audio.playSound("elimp3/most.mp3", false)
        end
    end
end
-- 单个cell的销毁动画
function GameAdvanced:blockDestoryActionByCell(v,direction,index,unitScore,len)
    -- 闪烁
    local blink_call = cc.CallFunc:create( function()
        local block = self._bgCellList[v.i][v.j]:getChildByTag(3001)
        if block then
            local blink = cc.Blink:create(0.5,2)
            block:runAction(blink)
        end
    end )
    -- 延迟 登台闪烁播放完
    local delay = cc.DelayTime:create(0.6)
    -- 延迟间隔爆炸时间
    local delay1 = nil
    if direction == "rows" then
        delay1 = cc.DelayTime:create(0.05 * (len - index))
    else
        delay1 = cc.DelayTime:create(0.05 * (index - 1))
    end
    -- 添加爆炸特效
    local action_call = cc.CallFunc:create( function()
        local mypat = self._bgCellList[v.i][v.j]:getChildByTag(4001)
        if not mypat then
            mypat = cc.ParticleSystemQuad:create(eli_block_action_path[v.imageIndex])
            self._bgCellList[v.i][v.j]:addChild(mypat,100)
            local size = self._bgCellList[v.i][v.j]:getContentSize()
            mypat:setPosition(size.width / 2,size.height / 2)
            mypat:setTag(4001)
        end
    end )
    -- 延迟
    local delay2 = cc.DelayTime:create(0.2)
    -- 移除方块
    local remove_box = cc.CallFunc:create( function()
        local block = self._bgCellList[v.i][v.j]:getChildByTag(3001)
        if block then
            block:removeFromParent()
        end
    end )
    local delay3 = cc.DelayTime:create(0.2)
    -- 添加字体动画
    local add_score_call = cc.CallFunc:create( function()
        local label = self["MainPanel"]:getChildByTag( v.i * 100 + v.j )
        if not label then
            label = ccui.TextBMFont:create( unitScore,eli_block_bmfont_score_path[v.imageIndex] )
            self["MainPanel"]:addChild(label)
            local world_pos = self._bgCellList[v.i][v.j]:getParent():convertToWorldSpace( cc.p(self._bgCellList[v.i][v.j]:getPosition()) )
            local node_pos = self["MainPanel"]:convertToNodeSpace( world_pos )
            label:setPosition( node_pos )
            local move_by = cc.MoveBy:create(0.5,cc.p(0,50))
            local fade_out = cc.FadeOut:create(0.5)
            local remove_call = cc.RemoveSelf:create()
            local seq = cc.Sequence:create({move_by,fade_out,remove_call})
            label:runAction(seq)
            label:setTag(v.i * 100 + v.j)
        end
    end )
    -- 延迟
    local delay4 = cc.DelayTime:create(1)
    -- 移除特效
    local remove_call = cc.CallFunc:create( function()
        local mypat = self._bgCellList[v.i][v.j]:getChildByTag(4001)
        if mypat then
            mypat:removeFromParent()
        end
    end )
    local seq = cc.Sequence:create({ blink_call,delay,delay1,action_call,
        delay2,remove_box,delay3,add_score_call,delay4,remove_call })
    self._bgCellList[v.i][v.j]:runAction(seq)
end
-- 删除后重置
function GameAdvanced:resetDropList( destoryData )
    for k,v in pairs( destoryData ) do
        self._dropList[v.i][v.j].canPut = true
        self._dropList[v.i][v.j].imageIndex = 0
    end
end
-- 是否还有剩余的未摆放的方块
function GameAdvanced:hasLeftPutBlock()
    for i = 1,3 do
        if self["Panel"..i]:getChildByTag(1001) then
            return true
        end
    end
    return false
end
-- 判断游戏是否结束
function GameAdvanced:isGameOver()
    local game_is_over = true
    for a = 1,3 do
        local touch_box = self["Panel"..a]:getChildByTag(1001)
        if touch_box then
            touch_box:setOpacity(255)
            local can_put = false
            local config = touch_box:getConfigData()
            for i,v in ipairs( self._dropList ) do
                for j,b in ipairs( v ) do
                    can_put = self:checkCanPutByPos( config,i,j )
                    if can_put then
                        game_is_over = false
                        break
                    end
                end
                if can_put then
                    break
                end
            end
            if not can_put then
                touch_box:setOpacity(150)
            end
        end
    end
    return game_is_over
end

function GameAdvanced:checkCanPutByPos( config,i,j )
    local need_space = {}
    local check = nil
    if config.need_caltype then
        check = self._touchBox:getNeedSpace( config.need_caltype,i,j )
        for k,v in ipairs( check ) do
            if (not self._dropList[v.i]) 
                or (not self._dropList[v.i][v.j]) 
                or (not self._dropList[v.i][v.j].canPut) then
                return false
            else
                table.insert( need_space,{ i = v.i,j = v.j } )
            end
        end
    else
        if i < 5 then
            check = config.cells.less
        elseif i == 5 then
            check = config.cells.equal
        else
            check = config.cells.more
        end
        for k,v in ipairs( check ) do
            if (not self._dropList[i + v.i]) 
                or (not self._dropList[i + v.i][j + v.j]) 
                or (not self._dropList[i + v.i][j + v.j].canPut) then
                return false
            else
                table.insert( need_space,{ i = v.i + i,j = v.j + j} )
            end
        end
    end
    return true,need_space
end
-- 移除已经加载的方块
function GameAdvanced:removeBlock()
    for i = 1,9 do
        for j = 1,9 do
            if self._bgCellList[i] and self._bgCellList[i][j] then
                local block = self._bgCellList[i][j]:getChildByTag(3001)
                if block then
                    block:removeFromParent()
                end
            end
        end
    end
end
-- 从新开始游戏
function GameAdvanced:resetPlayAgain()
    -- 重置分数
    self:loadDataUI()
    -- 重置能放入的区域
    self:initDropList()
    -- 重置要放入的方块
    self:createBlock()
    -- 移除已经加载的方块
    self:removeBlock()
end
-- 存储数据用于继续游戏
function GameAdvanced:saveContinueData()
    local put_block = {}
    for i = 1,9 do
        for j = 1,9 do
        	if self._bgCellList[i] and self._bgCellList[i][j] then
	            local block = self._bgCellList[i][j]:getChildByTag(3001)
	            if block then
	                local meta = { i = i,j = j,imageIndex = block._imageIndex }
	                table.insert( put_block,meta )
	            end
	        end
        end
    end
    local create_block = {}
    for i = 1,3 do
        local box = self["Panel"..i]:getChildByTag(1001)
        if box then
            local meta = { index = i,config_index = box:getConfigIndex(),image_index = box:getImageIndex() }
            table.insert( create_block,meta )
        end
    end
    local score = self._totalScore
    local refresh_times = self._refreshTimes
    G_GetModel("Model_Eliminate"):saveContinueAdvancedData( put_block,create_block,score,refresh_times )
end
function GameAdvanced:addListener()
    self:addMsgListener( InnerProtocol.INNER_EVENT_EL_REPLAY,function( event )
        self:resetPlayAgain()
    end )
    self:addMsgListener( InnerProtocol.INNER_EVENT_EL_ADVANCED_CONTINUE_DATA,function( event )
        self:saveContinueData()
    end )
end

function GameAdvanced:clickPause()
    addUIToScene( UIDefine.ELIMI_KEY.GamePause_UI,{ ui = "GameAdvanced" } )
end
function GameAdvanced:clickRefresh()
    if self._refreshTimes <= 0 then
        return
    end
    self._refreshTimes = self._refreshTimes - 1
    self.TextTimes:setString("x"..self._refreshTimes)
    self:createBlock()

    -- 判断游戏是否结束
    if self:isGameOver() then
        -- 进入结果页
        local data = { score = self._totalScore,ui = "GameAdvanced" }
        addUIToScene( UIDefine.ELIMI_KEY.GameNotPut_UI,data )
    end
end

return GameAdvanced