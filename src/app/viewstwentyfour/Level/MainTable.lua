
local MainCell  = import(".MainCell")
local MainTable = class("MainTable",BaseTable)



function MainTable:reload()
    MainTable.super.reload( self )

    -- 开启定时器 检查是否table是否在滑动
    self._isMove = false
    self:schedule( function()
        if self._tempPos then
            local nowX = self._unitTableView:getContentOffset().x
            self._isMove = self._tempPos ~= nowX
        end
        self._tempPos = self._unitTableView:getContentOffset().x
    end,0.1 )

    self._unitTableView:setTouchEnabled( false )
end

function MainTable:isScroll()
    return self._isMove
end

function MainTable:setViewData()
    self._viewData = tf_quest_config
end



function MainTable:cellSizeForTable(table,idx)
    return 656, 912
end


function MainTable:tableCellAtIndex(table, idx)
    local cell =  table:dequeueCell()
    if nil == cell then
        cell = cc.TableViewCell:new()
    end
    if cell.view == nil then
        cell.view = MainCell.new( self )
        cell:addChild(cell.view)
    end
    local data = self._viewData[ idx + 1]
    cell.view:loadDataUi( data,idx + 1 )
    self._cellList[idx+1] = cell.view
    return cell
end

function MainTable:_onTouchBegan( event )
    self._pointTouchBegin = cc.p( event.x,event.y )
    for i,v in pairs( self._cellList ) do
        local is_touch,level,index = v:getTouchLevelUnit( self._pointTouchBegin )
        if is_touch then
            local level_unit = v["RootPanel"]:getChildByTag( index )
            level_unit.RootPanel:setScale(0.95)
            self.select_level_unit = level_unit
            -- 播放音效
            G_GetModel("Model_Sound"):playVoice("tfmp3/reset.mp3")
            break
        end
    end

    return MainTable.super._onTouchBegan( self,event )
end

function MainTable:_onTouchEnded( event )
    if self.select_level_unit then
        self.select_level_unit.RootPanel:setScale(1)
    end
    local touchPoint = cc.p( event.x,event.y )
    local xdis = math.abs( self._pointTouchBegin.x - touchPoint.x )
    if xdis >= 30 then
        if self._pointTouchBegin.x < touchPoint.x then
            self._parentPanel:clickLeft()
        else
            self._parentPanel:clickRight()
        end
    else
        for i,v in pairs( self._cellList ) do
            local is_touch,level,index = v:getTouchLevelUnit(touchPoint)
            if is_touch then
                -- 打开游戏界面
                local data = { level = level,index = index }
                removeUIFromScene( UIDefine.TWENTYFOUR_KEY.Level_UI )
                local game_play = addUIToScene( UIDefine.TWENTYFOUR_KEY.Play_UI,data )
                -- 添加引导
                if level == 1 and index == 1 then
                    addUIToScene( UIDefine.TWENTYFOUR_KEY.Guid_UI,{ playPanel = game_play } )
                end
                return
            end
        end
    end
end


return MainTable