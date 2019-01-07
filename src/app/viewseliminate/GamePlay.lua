
local BlockNode = import(".Block.BlockNode")
local DottedNode = import(".Block.DottedNode")
local GamePlay = class("GamePlay",BaseLayer)

function GamePlay:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePlay.super.ctor( self,param.name )
    self:addCsb( "csbEliminate/LayerGamePlay.csb" )

    -- 暂停
    self:addNodeClick( self["ButtonPause"],{
        endCallBack = function() self:clickPause() end
    })
    -- 刷新
    self:addNodeClick( self["ButtonRefresh"],{
        endCallBack = function() self:clickRefresh() end
    })

    for i = 1,3 do
        self:addNodeClick( self["Panel"..i],{
            beganCallBack = function( touchPoint ) self:touchBlockBegan( touchPoint,i ) end,
            moveCallBack = function( touchPoint ) self:touchBlockMoved( touchPoint,i ) end,
            endCallBack = function( touchPoint ) self:touchBlockEnd( touchPoint,i ) end,
            touchOutside = true,
            scaleAction = false
        })
    end

    -- 初始化界面ui数据
    self:loadDataUI()
    -- 初始化放入的数据
    self:initDropList()
    -- 添加背景方块
    self:initBgBlock()
    -- 创建要显示的方块
    self:createDottedBlock()
    -- 判断有没有缓存数据
    local contineue_data = G_GetModel("Model_Eliminate"):getContinueGeneralData()
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
        G_GetModel("Model_Eliminate"):clearContinueGeneralData()
    else
        -- 添加要放入的方块
        self:createBlock()
    end
end
function GamePlay:onEnter()
    GamePlay.super.onEnter( self )
    self:onEnterAction()
end
function GamePlay:onEnterAction()
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
function GamePlay:loadDataUI()
    -- 初始化积分
    self._totalScore = 0
    self.TextScore:setString( self._totalScore )
    -- 初始化最高积分
    local maxScore = G_GetModel("Model_Eliminate"):getMaxGeneralScore()
    self.TextBestScore:setString( maxScore )
    -- 刷新的使用次数
    self._refreshTimes = 2
    self.TextTimes:setString("x"..self._refreshTimes)
end
function GamePlay:initDropList()
    self._dropList = {}
    for i = 1,10 do
        self._dropList[i] = {}
        for j = 1,10 do
            self._dropList[i][j] = { canPut = true,imageIndex = 0 }
        end
    end
end
-- 背景方块
function GamePlay:initBgBlock()
    self._bgCellList = {}
    for i = 1,10 do
        self._bgCellList[i] = {}
        for j = 1,10 do
            local bg_cell = ccui.ImageView:create("image/game/general/grid_1.png",1)
            local box_width = bg_cell:getContentSize().width
            self.MainPanel:addChild(bg_cell)
            local x_pos = ( j - 1 ) * ( box_width + 2 ) + box_width / 2
            local y_pos = ( i - 1 ) * ( box_width + 2 ) + box_width / 2
            bg_cell:setPosition(cc.p( x_pos,y_pos ))

            -- 将cell存入容器
            self._bgCellList[i][j] = bg_cell
        end
    end
end
-- 要放入的方块
function GamePlay:createBlock()
    -- 先删除
    for i = 1,3 do
        local box = self["Panel"..i]:getChildByTag(1001)
        if box then
            box:removeFromParent()
        end
    end
    for i = 1,3 do
        local box = BlockNode.new()
        self["Panel"..i]:addChild(box)
        box:setTag(1001)
        local box_size = box:getContentSize()
        local panel_size = self["Panel"..i]:getContentSize()
        local x_pos = panel_size.width / 2
        local y_pos = panel_size.height / 2
        box:setPosition( cc.p(x_pos,y_pos) )
        box:setScale(0.5)
    end
end
-- 要放入的方块
function GamePlay:createContinueBlock( data )
    for i,v in ipairs( data ) do
        local box = BlockNode.new( v.config_index,v.image_index )
        self["Panel"..v.index]:addChild(box)
        box:setTag(1001)
        local box_size = box:getContentSize()
        local panel_size = self["Panel"..v.index]:getContentSize()
        local x_pos = panel_size.width / 2
        local y_pos = panel_size.height / 2
        box:setPosition( cc.p(x_pos,y_pos) )
        box:setScale(0.5)
    end
end
-- 创建已经存在的游戏区域的方块
function GamePlay:putContinueBlock( data )
    for i,v in ipairs( data ) do
        local image_path = eli_block_image_path_n[v.imageIndex]
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
-- 生成要放入的区域显示方块
function GamePlay:createDottedBlock()
    self._boxDotted = DottedNode.new()
    self["MainPanel"]:addChild(self._boxDotted)
    self._boxDotted:hiddenBlock()
end
function GamePlay:touchBlockBegan( touchPoint,index )
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
function GamePlay:touchBlockMoved( touchPoint,index )
    if not self._canMove or self._returnBack then
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
    local can,cell_pos = self:checkCanPut()
    if can then
        self:setShowBlockByConfig( self._touchBox:getConfigData(),cell_pos )
    else
        self._boxDotted:hiddenBlock()
    end
end
function GamePlay:touchBlockEnd( touchPoint,index )
    -- 处于回到原位的过程中
    if self._returnBack then
        return
    end
    local can,cell_pos,need_space = self:checkCanPut()
    if can then
        -- 放入方块中
        self:putBlock( cell_pos,need_space )
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
function GamePlay:checkCanPut()
    -- 获取需要用来计算的box的点
    local config = self._touchBox:getConfigData()
    -- 以左下点为起始点开始计算
    local pos = cc.p( self._touchBox:getPosition() )
    pos.x = pos.x - self._touchBox:getContentSize().width / 2 
    pos.y = pos.y - self._touchBox:getContentSize().height / 2 
    local world_point = self._touchBox:getParent():convertToWorldSpace(pos)
    local contains = {}
    for i = 1,10 do
        for j = 1,10 do
            local node_point = self._bgCellList[i][j]:getParent():convertToNodeSpace(world_point)
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
        if #contains >= 4 then break end
    end

    local max_area,max_i,max_j = 0,0,0
    for i,v in ipairs( contains ) do
        local area = v.rect.width * v.rect.height
        if area > max_area then
            max_area = area
            max_i,max_j = v.i,v.j
        end
    end
    local can,need_space = self:checkCanPutByConfigAndCellPos( config,{ i = max_i,j = max_j } )
    return can,{ i = max_i,j = max_j },need_space
end

-- 根据方块的config和传入的点坐标判断能否放入方块
function GamePlay:checkCanPutByConfigAndCellPos(config,cellPos)
    local need_space = {}
    for i,v in ipairs(config) do
        for a,b in ipairs(v) do
            if b > 0 then
                local meta = clone(cellPos)
                meta.i = meta.i + (i - 1) 
                meta.j = meta.j + (a - 1)
                if meta.i > 0 and meta.j > 0 
                    and (meta.i <= 10 and meta.j <= 10) 
                    and self._dropList[meta.i][meta.j].canPut then
                    table.insert( need_space,meta )
                else
                    return false
                end
            end
        end
    end
    return true,need_space
end
-- 根据配置显示要放入的方块
function GamePlay:setShowBlockByConfig( config,cellPos )
    self._boxDotted:hiddenBlock()
    self._boxDotted:showBlockByConfig( config )

    local pos_x,pos_y = self._bgCellList[cellPos.i][cellPos.j]:getPosition()
    local cell_size = self._bgCellList[cellPos.i][cellPos.j]:getContentSize()
    pos_x = pos_x - cell_size.width / 2
    pos_y = pos_y - cell_size.height / 2
    self._boxDotted:setPosition( cc.p(pos_x,pos_y) )
end
-- 放入方块
function GamePlay:putBlock( cellPos,needSpace )
    -- 播放音效
    audio.playSound("elimp3/put.mp3", false)
    -- 1:设置存放区域的数据
    local imageIndex = self._touchBox:getImageIndex()
    for i,v in ipairs(needSpace) do
        self._dropList[v.i][v.j].canPut = false
        self._dropList[v.i][v.j].imageIndex = imageIndex
    end
    -- 2:将box放入区域
    -- 计算要移动的位置
    local bg_cell = self._bgCellList[cellPos.i][cellPos.j]
    local pos_leftdown = cc.p(self._touchBox:getPosition())
    pos_leftdown.x = pos_leftdown.x - self._touchBox:getContentSize().width / 2 
    pos_leftdown.y = pos_leftdown.y - self._touchBox:getContentSize().height / 2 
    local world_leftdown_pos = self._touchBox:getParent():convertToWorldSpace(pos_leftdown)

    local pos_bgcell = cc.p(bg_cell:getPosition())
    pos_bgcell.x = pos_bgcell.x - bg_cell:getContentSize().width / 2
    pos_bgcell.y = pos_bgcell.y - bg_cell:getContentSize().height / 2
    local world_pos_bgcell = bg_cell:getParent():convertToWorldSpace(pos_bgcell)
    local dis_x = world_pos_bgcell.x - world_leftdown_pos.x
    local dis_y = world_pos_bgcell.y - world_leftdown_pos.y
    
    local move_by = cc.MoveBy:create(0.1,cc.p(dis_x,dis_y))
    local scale_to = cc.ScaleTo:create(0.1,1)
    local spawn = cc.Spawn:create( { move_by,scale_to } )
    local call_back = cc.CallFunc:create( function()
        self._touchBox:removeFromParent()
        -- 隐藏dotted
        self._boxDotted:hiddenBlock()
        -- 创建cell
        self:createPutBlock( needSpace,imageIndex )
        -- 获得需要销毁的数据
        local rows,cols,nums = self:getDestoryData()
        -- 执行销毁动画
        self:blockDestoryAction( rows,cols )
        -- 重置dropList的数据
        self:resetDropList( rows,cols )
        -- 计算积分 (动画)
        local before = self._totalScore
        self._totalScore = self._totalScore + 20 * (#rows + #cols) * nums
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
            local data = { score = self._totalScore,ui = "GamePlay" }
            addUIToScene( UIDefine.ELIMI_KEY.GameNotPut_UI,data )
        end
    end )
    local seq = cc.Sequence:create({spawn,call_back})
    self._touchBox:runAction(seq)
end
-- 创建放入的方块
function GamePlay:createPutBlock( needSpace,imageIndex )
    assert( needSpace," !! needSpace is nil !! " )
    local image_path = eli_block_image_path_n[imageIndex]
    for i,v in ipairs(needSpace) do
        local block = ccui.ImageView:create(image_path,1)
        self._bgCellList[v.i][v.j]:addChild(block,10)
        local size = self._bgCellList[v.i][v.j]:getContentSize()
        block:setPosition(cc.p(size.width / 2,size.height / 2))
        block:setTag(3001)
        block._imageIndex = imageIndex
    end
end
function GamePlay:getDestoryData()
    local rows,cols = {},{}
    -- 遍历行
    local row_index,col_index = 1,1
    for i = 1,10 do
        local can_destory = true
        for j = 1,10 do
            if self._dropList[i][j].canPut then
                can_destory = false
                break
            end
        end
        if can_destory then
            rows[row_index] = {}
            for j = 1,10 do
                local meta = { i = i,j = j,imageIndex = self._dropList[i][j].imageIndex }
                table.insert(rows[row_index],meta)
            end
            row_index = row_index + 1
        end
    end
    -- 遍历列
    for j = 1,10 do
        local can_destory = true
        for i = 1,10 do
            if self._dropList[i][j].canPut then
                can_destory = false
                break
            end
        end
        if can_destory then
            cols[col_index] = {}
            for i = 1,10 do
                local meta = { i = i,j = j,imageIndex = self._dropList[i][j].imageIndex }
                table.insert(cols[col_index],meta)
            end
            col_index = col_index + 1
        end
    end
    local nums = 10 * ( #rows + #cols ) - #rows * #cols
    return rows,cols,nums
end
function GamePlay:blockDestoryAction( rows,cols )
    local unit_score = 20 * (#rows + #cols)
    for k,row in ipairs(rows) do
        for a,v in ipairs(row) do
            self:blockDestoryActionByCell( v,"rows",a,unit_score )
        end
    end
    for k,col in ipairs(cols) do
        for a,v in ipairs(col) do
            self:blockDestoryActionByCell( v,"cols",a,unit_score )
        end
    end

    if unit_score > 0 then
        -- 播放消除音效
        local index = random(1,10)
        if index % 2 == 0 then
            audio.playSound("elimp3/xiaochu.mp3", false)
        else
            audio.playSound("elimp3/xiaochu1.mp3", false)
        end
        if #rows > 1 or #cols > 1 or ( #rows + #cols ) > 1 then
            audio.playSound("elimp3/most.mp3", false)
        end
    end
end
-- 单个cell的销毁动画
function GamePlay:blockDestoryActionByCell(v,direction,index,unitScore)
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
        delay1 = cc.DelayTime:create(0.05 * (10 - index))
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
            label:setPosition(cc.p(self._bgCellList[v.i][v.j]:getPosition()))
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
function GamePlay:resetDropList( rows,cols )
    for k,row in ipairs(rows) do
        for a,v in ipairs(row) do
            self._dropList[v.i][v.j].canPut = true
            self._dropList[v.i][v.j].imageIndex = 0
        end
    end
    for k,col in ipairs(cols) do
        for a,v in ipairs(col) do
            self._dropList[v.i][v.j].canPut = true
            self._dropList[v.i][v.j].imageIndex = 0
        end
    end
end
-- 是否还有剩余的未摆放的方块
function GamePlay:hasLeftPutBlock()
    for i = 1,3 do
        if self["Panel"..i]:getChildByTag(1001) then
            return true
        end
    end
    return false
end
-- 判断游戏是否结束
function GamePlay:isGameOver()
    local game_is_over = true
    for a = 1,3 do
        local touch_box = self["Panel"..a]:getChildByTag(1001)
        if touch_box then
             touch_box:setOpacity(255)
            local can_put = false
            local config = touch_box:getConfigData()
            for i = 1,10 do
                for j = 1,10 do
                    local can = self:checkCanPutByConfigAndCellPos( config,{ i = i,j = j } )
                    if can then
                        game_is_over = false
                        can_put = true
                        break
                    end
                end
                if can_put then
                    break
                end
            end
            if not can_put then
                touch_box:setOpacity(100)
            end
        end
    end
    return game_is_over
end
-- 移除已经加载的方块
function GamePlay:removeBlock()
    for i = 1,10 do
        for j = 1,10 do
            local block = self._bgCellList[i][j]:getChildByTag(3001)
            if block then
                block:removeFromParent()
            end
        end
    end
end
-- 从新开始游戏
function GamePlay:resetPlayAgain()
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
function GamePlay:saveContinueData()
    local put_block = {}
    for i = 1,10 do
        for j = 1,10 do
            local block = self._bgCellList[i][j]:getChildByTag(3001)
            if block then
                local meta = { i = i,j = j,imageIndex = block._imageIndex }
                table.insert( put_block,meta )
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
    G_GetModel("Model_Eliminate"):saveContinueGeneralData( put_block,create_block,score,refresh_times )
end
function GamePlay:addListener()
    self:addMsgListener( InnerProtocol.INNER_EVENT_EL_REPLAY,function( event )
        self:resetPlayAgain()
    end )
    self:addMsgListener( InnerProtocol.INNER_EVENT_EL_GENERAL_CONTINUE_DATA,function( event )
        self:saveContinueData()
    end )
end
function GamePlay:clickPause()
    addUIToScene( UIDefine.ELIMI_KEY.GamePause_UI,{ ui = "GamePlay" } )
end
function GamePlay:clickRefresh()
    if self._refreshTimes <= 0 then
        return
    end
    self._refreshTimes = self._refreshTimes - 1
    self.TextTimes:setString("x"..self._refreshTimes)
    self:createBlock()
    -- 判断游戏是否结束
    if self:isGameOver() then
        -- 进入结果页
        local data = { score = self._totalScore,ui = "GamePlay" }
        addUIToScene( UIDefine.ELIMI_KEY.GameNotPut_UI,data )
    end
end


return GamePlay