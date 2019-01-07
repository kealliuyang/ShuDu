
--
-- Author: 	刘阳
-- Date: 	2018-01-22 10:20:03
-- Desc:	tableView的基类

local BaseTable = class( "BaseTable",BaseNode )

function BaseTable:ctor( param )
    BaseTable.super.ctor( self )
	assert( param," !! BaseTable is nil !!")
	assert( type(param) == "table"," !! param must be table!! " )
	assert( param.tableSize," !! must define table's size !! ")
	assert( param.parentPanel," !! must define table's parentPanel !! ")

	self._tableSize      = param.tableSize          		-- tableview的size
    self._parentPanel    = param.parentPanel        		-- 要加载到的layer
    self._tableDirection = param.directionType or 1      	-- tableview的显示方式 1 水平展示 2 竖直展示 (默认水平)

    self._cellList = {}     -- 存储cell的指针

    self:addTableView()

    -- 添加监听
    self:_createListeren()
end

function BaseTable:addTableView()
    local tableView = cc.TableView:create(cc.size(self._tableSize.width, self._tableSize.height))

    tableView:setDelegate()

    tableView:registerScriptHandler( handler(self,self.tableCellTouched),		 cc.TABLECELL_TOUCHED )
    tableView:registerScriptHandler( handler(self,self.cellSizeForTable),		 cc.TABLECELL_SIZE_FOR_INDEX )
    tableView:registerScriptHandler( handler(self,self.tableCellAtIndex),        cc.TABLECELL_SIZE_AT_INDEX )
    tableView:registerScriptHandler( handler(self,self.numberOfCellsInTableView),cc.NUMBER_OF_CELLS_IN_TABLEVIEW )
    tableView:registerScriptHandler( handler(self,self.scrollViewDidScroll),     cc.SCROLLVIEW_SCRIPT_SCROLL)
    tableView:registerScriptHandler( handler(self,self.scrollViewDidZoom),       cc.SCROLLVIEW_SCRIPT_ZOOM )
    tableView:registerScriptHandler( handler(self,self.tableHighLight),          cc.TABLECELL_HIGH_LIGHT )
    tableView:registerScriptHandler( handler(self,self.tableUnHighLight),        cc.TABLECELL_UNHIGH_LIGHT )

    self._unitTableView = tableView
    -- self._unitTableView:setBounceable(false) -- 取消弹性性能

    self:setTableDirection()
    self:addChild(self._unitTableView,1)
end

--[[ 重要 用于处理cell的点击的业务逻辑 ]]
function BaseTable:_createListeren()
    local node = cc.Node:create()
    node:setContentSize( self._tableSize )
    self:addChild( node,999 )
    self._listener = TouchNode.extends( node,function(event)
        if event.name == "began" then
            return self:_onTouchBegan( event)
        elseif event.name == "moved" then
            self:_onTouchMoved( event)
        elseif event.name == "ended" then
            self:_onTouchEnded( event )
        elseif event.name == "outside" then
            self:_onTouchOutSide( event )
        elseif event.name == "outsideend" then
            self:_onTouchOutSideEnd( event )
        end
    end,true )
end


function BaseTable:onTouchCellChildNode( cellNode,touchPoint )
    if cellNode and cellNode:isVisible() then
        local boxRect = cellNode:getBoundingBox()
        local localPoint = cellNode:getParent():convertToNodeSpace(touchPoint)
        local isTouchInside = cc.rectContainsPoint(boxRect, localPoint)
        return isTouchInside
    end
    return false
end

--[[ 子类需要重写 ]]
function BaseTable:_onTouchBegan( event )
    return true
end
--[[ 子类需要重写 ]]
function BaseTable:_onTouchMoved( event )
end
--[[ 子类需要重写 ]]
function BaseTable:_onTouchEnded( event )
end
--[[ 子类可能需要重写 ]]
function BaseTable:_onTouchOutSide( event )
    return false
end
--[[ 子类可能需要重写 ]]
function BaseTable:_onTouchOutSideEnd( event )
end
function BaseTable:onExit()
    BaseTable.super.onExit( self )
    local eventDispatcher = self:getEventDispatcher()
    if self._listener then
        eventDispatcher:removeEventListener(self._listener)
        self._listener = nil
    end
end



function BaseTable:getTable()
    return self._unitTableView
end


--[[ 子类需要重写 ]]
function BaseTable:reload()
    -- 加载 tableview
    self._cellList = {}
    self:setViewData()
    self._rowNumber = #self._viewData
    self._unitTableView:reloadData()
end

--[[ 子类 可能 需要重写 ]]
function BaseTable:setTableDirection()
	if self._tableDirection == 1 then
		self._unitTableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL) 		-- 水平展示
	else
		self._unitTableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)		-- 竖直展示
    	self._unitTableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	end
	
end


--[[ 子类需要重写 ]]
function BaseTable:setViewData()
    self._viewData = {}
end


function BaseTable:scrollViewDidScroll( view )
    
end

function BaseTable:numberOfCellsInTableView(table)
    if self._rowNumber then
        return self._rowNumber
    else
        return 0
    end
end

--[[ 子类 可能 需要重写 ]]
function BaseTable:scrollViewDidZoom(view)
    
end


--[[ 子类需要重写 ]]
function BaseTable:tableCellTouched(table,cell)
    
end

--[[ 子类需要重写 ]]
function BaseTable:tableHighLight(table,cell)
    
end

--[[ 子类需要重写 ]]
function BaseTable:tableUnHighLight(table,cell)
    
end

--[[ 子类需要重写 ]]
function BaseTable:cellSizeForTable(table,idx)
    return 0, 0
end

--[[ 子类需要重写]]
function BaseTable:tableCellAtIndex(table, idx)
    
end



rawset(_G, "BaseTable", BaseTable)

