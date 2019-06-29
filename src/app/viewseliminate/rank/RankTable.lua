
local RankCell  = import(".RankCell")
local RankTable = class("RankTable",BaseTable)


function RankTable:reload( mType )
    self._mType = mType
    RankTable.super.reload( self )
end

function RankTable:setViewData()
    self._viewData = {}
    if self._mType == 1 then
        self._viewData = G_GetModel("Model_Eliminate"):getGeneralRecordList()
    else
        self._viewData = G_GetModel("Model_Eliminate"):getAdvancedRecordList()
    end
end


function RankTable:cellSizeForTable(table,idx)
    return 509, 116
end


function RankTable:tableCellAtIndex(table, idx)
    local cell =  table:dequeueCell()
    if nil == cell then
        cell = cc.TableViewCell:new()
    end
    if cell.view == nil then
        cell.view = RankCell.new( self )
        cell:addChild(cell.view)
    end
    local data = self._viewData[ idx + 1]
    cell.view:loadDataUi( data,idx + 1 )
    self._cellList[idx+1] = cell.view
    return cell
end



return RankTable