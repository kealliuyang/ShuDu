
local MainTable     = import(".MainTable")
local Main 		= class("Main",BaseLayer)

function Main:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    Main.super.ctor( self,param.name )

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer,1 )
    self._layer = layer

    self:addCsb( "csblaohuji/Achievement.csb",2 )

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
    casecadeFadeInNode( self.Bg,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
end

function Main:loadDataUi()
    self._table:reload()
end

function Main:close()
    removeUIFromScene( UIDefine.LAOHUJI_KEY.Achievement_UI )
end


return Main