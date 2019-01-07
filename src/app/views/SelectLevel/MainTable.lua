
local MainCell  = import(".MainCell")
local MainTable = class("MainTable",BaseTable)



function MainTable:setViewData()
    self._viewData = self:initDataRow( 3 )
end

function MainTable:initDataRow( columnCount )
	local source_data = {}
    local count = #quest_config
	for i = 1,count do
		table.insert( source_data,i )
	end
	local m_data = {}
	getMatrixDataByColumn( m_data,source_data,columnCount )
	return m_data
end

function MainTable:cellSizeForTable(table,idx)
    return 610, 200
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
    cell.view:loadDataUi( data )
    self._cellList[idx+1] = cell.view
    return cell
end

function MainTable:_onTouchBegan( event )
    self._pointTouchBegin = cc.p( event.x,event.y )
    for i,v in pairs( self._cellList ) do
        local out = false
        for a = 1,3 do
            local is_touch = self:onTouchCellChildNode( v["LevelPanel"..a],self._pointTouchBegin )
            if is_touch then
                out = true
                v["LevelPanel"..a]:setScale(0.95)
                -- 播放音效
                G_GetModel("Model_Sound"):playVoice()
                break
            end
        end
        if out then
            break
        end
    end
    return MainTable.super._onTouchBegan( self,event )
end

function MainTable:_onTouchEnded( event )
    MainTable.super._onTouchEnded( self,event )
    local touchPoint = cc.p( event.x,event.y )
    local distance = cc.pGetDistance(self._pointTouchBegin, touchPoint)
    if distance <= 10 then
        for i,v in pairs( self._cellList ) do
        	for a = 1,3 do
        		local is_touch = self:onTouchCellChildNode( v["LevelPanel"..a],touchPoint )
                if is_touch then
                    v["LevelPanel"..a]:setScale(1)
                    v:openGameLayer( a )
                    return
                end
        	end
        end
    else
        self:resetCellScale()
    end
end


function MainTable:_onTouchOutSideEnd( event )
    self:resetCellScale()
end

function MainTable:resetCellScale()
    for i,v in pairs( self._cellList ) do
        for a = 1,3 do
            v["LevelPanel"..a]:setScale(1)
        end
    end
end



return MainTable