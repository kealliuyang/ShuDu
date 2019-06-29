
local MainTable = import(".MainTable")
local Main 		= class("Main",BaseLayer)

function Main:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    Main.super.ctor( self,param.name )
    self:addCsb( "csb/LayerSelect.csb" )

    -- 返回
    self:addNodeClick( self.ButtonBack,{ 
        endCallBack = function() self:close() end
    })
    -- 帮助
    self:addNodeClick( self.ButtonHelp,{ 
        endCallBack = function() self:help() end
    })
    -- 设置
    self:addNodeClick( self.ButtonSet,{ 
        endCallBack = function() self:set() end
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


function Main:loadDataUi()
	self._table:reload()
end






function Main:close()
    removeUIFromScene( UIDefine.UI_KEY.Select_UI )
    addUIToScene( UIDefine.UI_KEY.Start_UI )
end
function Main:help()
    addUIToScene( UIDefine.UI_KEY.Help_UI )
end
function Main:set()
    addUIToScene( UIDefine.UI_KEY.Set_UI )
end

return Main