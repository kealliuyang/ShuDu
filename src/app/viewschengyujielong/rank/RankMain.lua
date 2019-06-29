
local RankTable     = import(".RankTable")
local RankMain 		= class("RankMain",BaseLayer)

function RankMain:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    RankMain.super.ctor( self,param.name )

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer,1 )
    self._layer = layer

    self:addCsb( "csbchengyujielong/GameRank.csb",2 )

    -- 关闭
    self:addNodeClick( self.ButtonClose,{ 
        endCallBack = function() self:close() end
    })

    self:initTable()
    self:loadDataUi()
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
    casecadeFadeInNode( self._csbNode,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
end

function RankMain:loadDataUi()
    self._table:reload()
end

function RankMain:close()
    removeUIFromScene( UIDefine.CHENGYUJIELONG_KEY.Rank_UI )
end


return RankMain