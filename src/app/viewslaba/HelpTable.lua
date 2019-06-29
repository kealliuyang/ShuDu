
local HelpCell  = import(".HelpCell")
local HelpTable = class("HelpTable",BaseTable)



function HelpTable:setViewData()
    self._viewData = {
        { "财神",12,6,3 },
        { "鞭炮",10,5,3 },
        { "灯笼",10,4,3 },
        { "Q",4,2,2 },
        { "K",8,3,2 },
        { "J",4,2,1 },
        { 10,4,2,1 },
        { 9,3,2,1 },
        { 8,3,2,1 },
    }
end


function HelpTable:cellSizeForTable(table,idx)
    return 954, 53
end


function HelpTable:tableCellAtIndex(table, idx)
    local cell =  table:dequeueCell()
    if nil == cell then
        cell = cc.TableViewCell:new()
    end
    if cell.view == nil then
        cell.view = HelpCell.new( self )
        cell:addChild(cell.view)
    end
    local data = self._viewData[ idx + 1]
    cell.view:loadDataUi( data,idx + 1 )
    self._cellList[idx+1] = cell.view
    return cell
end



return HelpTable