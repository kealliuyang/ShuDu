
local MainTable = import(".MainTable")
local Main 		= class("Main",BaseLayer)

function Main:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    Main.super.ctor( self,param.name )

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer,1 )

    self:addCsb( "csb/LayerRecord.csb",2 )

    -- 关闭
    self:addNodeClick( self.ButtonClose,{ 
        endCallBack = function() self:close() end
    })

    self:initTable()
    self:loadDataUi()
end


function Main:initTable()
	-- 添加table
	if self._table == nil then
        local size = self.tablePanel:getContentSize()
        local param = {
            tableSize = size,
            parentPanel = self,
            directionType = 2
        }
        self._table = MainTable.new( param )
        self.tablePanel:addChild( self._table )
    end
end

function Main:onEnter()
    Main.super.onEnter( self )
    UIScaleShowAction( self.MidPanel )
end


function Main:loadDataUi()
	self._table:reload()
end


function Main:close()
    removeUIFromScene( UIDefine.UI_KEY.Record_UI )
end


return Main