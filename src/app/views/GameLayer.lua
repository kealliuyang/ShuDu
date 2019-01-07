
local UnitCell  = import(".UnitCell")
local GameLayer = class("GameLayer",BaseLayer)


function GameLayer:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    self._param = param
    GameLayer.super.ctor( self,param.name )
    self:addCsb( "csb/LayerGame.csb" )

    -- 检查
    self:addNodeClick( self["ButtonCheck"],{ 
        endCallBack = function() self:check() end
    })
    -- 返回
    self:addNodeClick( self["ButtonBack"],{ 
        endCallBack = function() self:returnBack() end
    })
    -- unit 点击
    self:addNodeClick( self.ViewPanel,{ 
        endCallBack = function( touchPoint ) self:touchUnitCell( touchPoint ) end,
        scaleAction = false
    })
    -- 1-9的button点击
    for i = 1,9 do
        self:addNodeClick( self["Button"..i],{ 
            endCallBack = function() self:touchButoon( i ) end
        })
    end
    -- Tips的点击
    self:addNodeClick( self.Tipes,{ 
        endCallBack = function( touchPoint ) self:touchTips( touchPoint ) end
    })


    self._cellList = {}
    self:addUnitCell()
    -- 当前关卡需要填写的数字
    self._quest = {}
    if self._param.data.continue then
        local continue_data = G_GetModel("Model_Player"):getContinueData()
        if continue_data and continue_data.level == self._param.data.level then
            self._quest = continue_data.quest
        end
    else
        self._quest = G_GetModel("Model_Player"):getQuest(self._param.data.level)
    end

    -- 当前选中
    self._selectUnit = nil
    -- 可以被点击的
    self._canTouchUnit = {}

    self:loadUnitCell()

    -- 关卡标题
    self.TextLevel:setString(self._param.data.level.."/"..(#quest_config))
    -- 可以使用提示的次数
    self.TextRepeateNum:setString("X"..G_GetModel("Model_Player"):getAnswerTips())
    -- 当前关卡的最佳纪录
    local best_time = G_GetModel("Model_Player"):getRecordTimeByLevel(self._param.data.level)
    local best_str = formatTimeStr( best_time,":" )
    self.TextScore:setString("BEST SCORE "..best_str)
    -- 倒计时
    self._time = 0
    self.TextCostTime:setString("")
    if G_GetModel("Model_Player"):isPassGuid() then
        self:schedule( function()
            self._time = self._time + 1
            local str = formatTimeStr( self._time,"：" )
            self.TextCostTime:setString(str)
        end,1 )
    end

    -- 记录填写的数字 用于继续游戏时候的初始化
    self._fillNum = {}

    -- 如果是继续游戏 显示继续游戏的ui
    if self._param.data.continue then
        local continue_data = G_GetModel("Model_Player"):getContinueData()
        if continue_data and continue_data.level == self._param.data.level then
            self._fillNum = clone( continue_data.fillNum )
            self._time = continue_data.time
            self:loadContinueUi( continue_data )
        end
    end
end

-- 加载 cell
function GameLayer:addUnitCell()
    local index = 1
    for i = 1,9 do
        self._cellList[i] = {}
        for j = 1,9 do
            local cell = UnitCell.new( self,i,j )
            local cell_size = cell:getDesignSize()
            self.ViewPanel:addChild( cell )
            local x_pos = (j - 1) * (cell_size.width + 7)
            local y_pos = (i - 1) * (cell_size.height + 7)
            cell:setPosition( cc.p(x_pos,y_pos) )
            self._cellList[i][j] = cell
            index = index + 1
        end
    end

    self:initCalUnit( self._cellList )
end
-- 初始化
function GameLayer:loadUnitCell()
    for i,v in ipairs( self._cellList ) do
        for a,b in ipairs(v) do
            if self:isShowNum( i,quest_config[self._param.data.level][i][a] ) then
                b:setNum( quest_config[self._param.data.level][i][a] )
            else
                b:setNum("")
                b:setNeedFill()
                -- 初始化可以被点击的unit
                if self._canTouchUnit[i] == nil then
                    self._canTouchUnit[i] = {}
                end
                self._canTouchUnit[i][a] = true
            end
        end
    end
end
-- 是否是填充的unit
function GameLayer:isShowNum( row,num )
    local row_data = self._quest[row]
    if row_data then
        for i,v in ipairs(row_data) do
            if num == v then
                return false
            end
        end
    end
    return true
end
-- 加载是继续游戏的ui
function GameLayer:loadContinueUi( data )
    -- 设置时间
    local str = formatTimeStr( data.time,"：" )
    self.TextCostTime:setString(str)
    -- 填充数字
    for i,v in ipairs(data.fillNum) do
        self._cellList[v.row][v.column]:setNum(v.num)
        if v.type == "tips" then
            self._cellList[v.row][v.column]:setTipsBMfnt()
            -- 设置此unit不可点击
            self._canTouchUnit[v.row][v.column] = nil
        end
    end
end
-- 点击cell
function GameLayer:touchUnitCell( touchPoint )
    for i,v in ipairs( self._cellList ) do
        for a,b in ipairs(v) do
            if self._canTouchUnit[i] and self._canTouchUnit[i][a] then
                local localPoint = b:getParent():convertToNodeSpace(touchPoint)
                if cc.rectContainsPoint(b:getBoundingBox(), localPoint) then
                    -- 重置状态
                    self:resetCheck()
                    self:setSelectUnit(i,a)
                    -- 设置选中
                    self._selectUnit = { row = i,column = a }
                    return
                end
            end
        end
    end
end
-- 点击数字
function GameLayer:touchButoon( index )
    -- 没有选择unit
    if not self._selectUnit then
        return
    end

    -- 存入fill 用于继续游戏
    local meta = {}
    meta.num = index
    meta.row = self._selectUnit.row
    meta.column = self._selectUnit.column
    meta.type = "button"
    table.insert( self._fillNum,meta )

    local unit = self._cellList[self._selectUnit.row][self._selectUnit.column]
    unit:setNum( index )

    -- 执行一个动画
    unit:fillNumAction()

    -- 检查是否结束
    for i,v in ipairs( self._cellList ) do
        for a,b in ipairs(v) do
            if not b:getNum() then
                return
            end
        end
    end

    -- 检查是否正确
    local pass = self:check()
    if pass then
        -- 存档
        local pass_level = G_GetModel("Model_Player"):getPassLevel()
        if pass_level < self._param.data.level then
            G_GetModel("Model_Player"):savePassLevel(self._param.data.level)
        end
        -- 检查是否是新纪录
        local new_score = false
        local cost_time = G_GetModel("Model_Player"):getRecordTimeByLevel(self._param.data.level)
        if cost_time == 0 or cost_time > self._time  then
            -- 存贮记录
            local record_data = { level = self._param.data.level,passTime = self._time }
            G_GetModel("Model_Player"):saveRecordList(record_data)
            new_score = true
        end

        -- 清空继续游戏的数据
        G_GetModel("Model_Player"):setContinueData(nil)

        -- 进入结果页
        self:unSchedule()
        local data = { level = self._param.data.level,newScore = new_score,time = self._time }
        addUIToScene( UIDefine.UI_KEY.Next_UI,data )
    end
end
-- 点击提示
function GameLayer:touchTips( touchPoint )
    -- 没有选择unit
    if not self._selectUnit then
        return
    end
    -- 没有提示次数
    if G_GetModel("Model_Player"):getAnswerTips() <= 0 then
        return
    end
    -- 显示提示答案
    local num = quest_config[self._param.data.level][self._selectUnit.row][self._selectUnit.column]
    local unit = self._cellList[self._selectUnit.row][self._selectUnit.column]
    unit:setNum( num )
    unit:fillNumAction()
    unit:setTipsBMfnt()

    -- 存入fill 用于继续游戏
    local meta = {}
    meta.num = num
    meta.row = self._selectUnit.row
    meta.column = self._selectUnit.column
    meta.type = "tips"
    table.insert( self._fillNum,meta )

    -- 当前的unit移除可点击状态
    self._canTouchUnit[self._selectUnit.row][self._selectUnit.column] = nil
    -- 存储可以提示的次数
    G_GetModel("Model_Player"):useAnswerTips()

    -- 去掉选中框
    if self._selectUnitImage then
        self._selectUnitImage:setVisible(false)
    end
    -- 提示次数
    self.TextRepeateNum:setString("X"..G_GetModel("Model_Player"):getAnswerTips())
end
-- 设置选中框
function GameLayer:setSelectUnit( i,j )
    if self._selectUnitImage == nil then
        self._selectUnitImage = ccui.ImageView:create("image/game/Box_small_select.png",1)
        self.ViewPanel:addChild( self._selectUnitImage )
    end
    self._selectUnitImage:setVisible( true )
    local unit_size = self._cellList[i][j]:getContentSize()
    local pos = cc.p( self._cellList[i][j]:getPosition() )
    pos.x = pos.x + unit_size.width / 2
    pos.y = pos.y + unit_size.height / 2
    self._selectUnitImage:setPosition( pos )
end
function GameLayer:check()
    -- 显示行重复
    local row_re,num1 = self:calRepeateAndShow( self.crow_ary )
    -- 显示列重复
    local col_re,num2 = self:calRepeateAndShow( self.ccol_ary )
    -- 显示九宫重复
    local c9_re,num3 = self:calRepeateAndShow( self.c9_ary )

    self._selectUnit = nil

    return (not row_re) and (not col_re) and (not c9_re)
end
function GameLayer:returnBack()
    -- 存储当前的游戏数据 以便继续
    if #self._fillNum > 0 then
        local continue_data = {}
        continue_data.fillNum = clone(self._fillNum)
        continue_data.time = self._time
        continue_data.level = self._param.data.level
        continue_data.quest = clone(self._quest)
        G_GetModel("Model_Player"):setContinueData(continue_data)
    end

    removeUIFromScene( UIDefine.UI_KEY.Main_UI )
    addUIToScene( UIDefine.UI_KEY.Select_UI )
end
function GameLayer:resetCheck()
    for i,v in ipairs( self._cellList ) do
        for a,b in ipairs(v) do
            b:setCheckBg( false )
        end
    end
    if self._selectUnitImage then
        self._selectUnitImage:setVisible(false)
    end
end
function GameLayer:initCalUnit( nine_ary )
    self.crow_ary = {}
    self.ccol_ary = {}
    self.c9_ary = {}

    -- 初始化9宫
    self.c9_ary[1] = { 
        nine_ary[1][1],
        nine_ary[1][2],
        nine_ary[1][3],
        nine_ary[2][1],
        nine_ary[2][2],
        nine_ary[2][3],
        nine_ary[3][1],
        nine_ary[3][2],
        nine_ary[3][3]
    }
    self.c9_ary[2] = { 
        nine_ary[1][4],
        nine_ary[1][5],
        nine_ary[1][6],
        nine_ary[2][4],
        nine_ary[2][5],
        nine_ary[2][6],
        nine_ary[3][4],
        nine_ary[3][5],
        nine_ary[3][6]
    }
    self.c9_ary[3] = { 
        nine_ary[1][7],
        nine_ary[1][8],
        nine_ary[1][9],
        nine_ary[2][7],
        nine_ary[2][8],
        nine_ary[2][9],
        nine_ary[3][7],
        nine_ary[3][8],
        nine_ary[3][9]
    }
    self.c9_ary[4] = { 
        nine_ary[4][1],
        nine_ary[4][2],
        nine_ary[4][3],
        nine_ary[5][1],
        nine_ary[5][2],
        nine_ary[5][3],
        nine_ary[6][1],
        nine_ary[6][2],
        nine_ary[6][3]
    }
    self.c9_ary[5] = { 
        nine_ary[4][4],
        nine_ary[4][5],
        nine_ary[4][6],
        nine_ary[5][4],
        nine_ary[5][5],
        nine_ary[5][6],
        nine_ary[6][4],
        nine_ary[6][5],
        nine_ary[6][6]
    }
    self.c9_ary[6] = { 
        nine_ary[4][7],
        nine_ary[4][8],
        nine_ary[4][9],
        nine_ary[5][7],
        nine_ary[5][8],
        nine_ary[5][9],
        nine_ary[6][7],
        nine_ary[6][8],
        nine_ary[6][9]
    }
    self.c9_ary[7] = { 
        nine_ary[7][1],
        nine_ary[7][2],
        nine_ary[7][3],
        nine_ary[8][1],
        nine_ary[8][2],
        nine_ary[8][3],
        nine_ary[9][1],
        nine_ary[9][2],
        nine_ary[9][3]
    }
    self.c9_ary[8] = { 
        nine_ary[7][4],
        nine_ary[7][5],
        nine_ary[7][6],
        nine_ary[8][4],
        nine_ary[8][5],
        nine_ary[8][6],
        nine_ary[9][4],
        nine_ary[9][5],
        nine_ary[9][6]
    }
    self.c9_ary[9] = { 
        nine_ary[7][7],
        nine_ary[7][8],
        nine_ary[7][9],
        nine_ary[8][7],
        nine_ary[8][8],
        nine_ary[8][9],
        nine_ary[9][7],
        nine_ary[9][8],
        nine_ary[9][9]
    }

    -- 记录行
    self.crow_ary = {}
    for i = 1,9 do
        self.crow_ary[i] = {}
        for j = 1,9 do
            table.insert( self.crow_ary[i],nine_ary[i][j] )
        end
    end
    -- 记录列
    self.ccol_ary = {}
    for i = 1,9 do
        self.ccol_ary[i] = {}
        for j = 1,9 do
            table.insert( self.ccol_ary[i],nine_ary[j][i] )
        end
    end
end
function GameLayer:calRepeateAndShow( source )
    local repeate_list = {}
    local num = 0
    for i,v in ipairs( source ) do
        repeate_list[i] = {}
        local repeate = {}
        for a,b in ipairs(v) do
            if b:getNum() then
                if repeate[b:getNum()] == nil then
                    repeate[b:getNum()] = { row = b:getRow(),col = b:getCol() }
                else
                    -- 插入当前元素
                    num = num + 1
                    table.insert(repeate_list[i],{ row = b:getRow(),col = b:getCol() })
                    -- 插入之前的元素 (需要判断是否已经插入)
                    local has_insert = false
                    for o,p in ipairs(repeate_list[i]) do
                        if p.row == repeate[b:getNum()].row and p.col == repeate[b:getNum()].col then
                            has_insert = true
                            break
                        end
                    end
                    if not has_insert then
                        table.insert(repeate_list[i],clone(repeate[b:getNum()]))
                    end
                end
            end
        end
    end
    
    for k,v in ipairs( repeate_list ) do
        for a,b in ipairs(v) do
            self._cellList[b.row][b.col]:setCheckBg(true)
        end
    end
    return num > 0,num
end
function GameLayer:addListener()
    -- 新手引导第二步的选中
    self:addMsgListener( InnerProtocol.INNER_EVENT_GUID_2,function( event )
        self:touchUnitCell( event.data[1] )
    end )
    -- 新手引导第三步
    self:addMsgListener( InnerProtocol.INNER_EVENT_GUID_3,function( event )
        self:touchButoon( 4 )
    end )
    -- 新手引导结束 计时开始
    self:addMsgListener( InnerProtocol.INNER_EVENT_GUID_4,function( event )
        self:schedule( function()
            self._time = self._time + 1
            local str = formatTimeStr( self._time,"：" )
            self.TextCostTime:setString(str)
        end,1 )
    end )
end

return GameLayer