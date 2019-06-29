
local RankTable     = import(".RankTable")
local RankMain 		= class("RankMain",BaseLayer)

function RankMain:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    RankMain.super.ctor( self,param.name )

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer,1 )
    self._layer = layer

    self:addCsb( "csbEliminate/LayerGameRecord.csb",2 )

    -- 关闭
    self:addNodeClick( self.ButtonClose,{ 
        endCallBack = function() self:close() end
    })

    self:addNodeClick( self.ButtonGeneral,{ 
        endCallBack = function() self:loadDataUi(1) end
    })

    self:addNodeClick( self.ButtonAdvanced,{ 
        endCallBack = function() self:loadDataUi(2) end
    })

    self:initTable()
    self:loadDataUi(1)
end

function RankMain:initTable()
    -- 添加table
    if self._table == nil then
        local size = self.tablePanel:getContentSize()
        local param = {
            tableSize = size,
            parentPanel = self,
            directionType = 2
        }
        self._table = RankTable.new( param )
        self.tablePanel:addChild( self._table )
    end
end

function RankMain:onEnter()
    RankMain.super.onEnter( self )
    casecadeFadeInNode( self.MidPanel,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
end

function RankMain:loadDataUi( index )
    if self._index == index then
        return
    end
    self:clearUIState()
    self._index = index
    if self._index == 1 then
        self.General2:setVisible( true )
        self.Advanced1:setVisible( true )
    else
        self.General1:setVisible( true )
        self.Advanced2:setVisible( true )
    end
    self._table:reload( self._index )
end

function RankMain:close()
    removeUIFromScene( UIDefine.ELIMI_KEY.Record_UI )
end

function RankMain:clearUIState()
    self.General1:setVisible( false )
    self.General2:setVisible( false )
    self.Advanced1:setVisible( false )
    self.Advanced2:setVisible( false )
end

return RankMain