
local MainCell  = import(".MainCell")
local MainTable = class("MainTable",BaseTable)



function MainTable:setViewData()
    self._viewData = G_GetModel("Model_Player"):getRecordList()
end


function MainTable:cellSizeForTable(table,idx)
    return 572, 48
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



return MainTable