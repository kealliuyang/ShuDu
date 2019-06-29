
local MainCell  = import(".MainCell")
local MainTable = class("MainTable",BaseTable)




function MainTable:setViewData()
    self._viewData = lhj_achement_config
end


function MainTable:cellSizeForTable(table,idx)
    return 810, 85
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

-- 触摸的处理
function MainTable:_onTouchBegan( event )
    local touchPoint = cc.p( event.x,event.y )
    self._pointTouchBegin = touchPoint

    for i,v in pairs( self._cellList ) do
        local isTouchPosPanel = self:onTouchCellChildNode( v["ButtonState1"],touchPoint )
        if isTouchPosPanel then
            v["ButtonState1"]:setScale(0.9)
        end
    end

    return MainTable.super._onTouchBegan( self,event )
end

function MainTable:_onTouchEnded( event )
    for i,v in pairs( self._cellList ) do
        v["ButtonState1"]:setScale(1)
    end

    local touchPoint = cc.p( event.x,event.y )
    local distance = cc.pGetDistance(self._pointTouchBegin, touchPoint)
    if distance <= 10 then
        for i,v in pairs( self._cellList ) do
            local isTouchPosPanel = self:onTouchCellChildNode( v["ButtonState1"],touchPoint )
            if isTouchPosPanel then
                -- 领取金币
                local index = v:getIndex()
                local get_coin = lhj_achement_config[index].coin
                local has_coin = G_GetModel("Model_LaoHuJi"):getCoin()
                G_GetModel("Model_LaoHuJi"):saveCoin( has_coin + get_coin )
                -- 设置成就数据
                G_GetModel("Model_LaoHuJi"):saveAchievementData( index )

                -- 播放音效
                audio.playSound("lhjmp3/btn_bubble.mp3", false)

                -- 重新刷新
                local data = v:getData()
                v:loadDataUi( data,index )
                -- 发送消息 主界面刷新
                EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_LAOHUJI_RESETSTART )
                return
            end
        end
    end
end



return MainTable