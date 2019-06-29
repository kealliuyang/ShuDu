
local RankTable = import(".RankTable")
local GameRank 	= class("GameRank",BaseLayer)


function GameRank:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameRank.super.ctor( self,param.name )

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer,1 )
    self._layer = layer

    self:addCsb( "csbmajiang/GameRank.csb",2 )
    -- 返回
    self:addNodeClick( self.ButtonClose,{ 
        endCallBack = function() self:close() end
    })
    self:initTable()
    self:loadDataUi()
end

function GameRank:onEnter()
    GameRank.super.onEnter( self )
    casecadeFadeInNode( self.MidPanel,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
end

function GameRank:initTable()
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

function GameRank:loadDataUi()
	self._table:reload()
end

function GameRank:close()
    removeUIFromScene( UIDefine.MAJIANG_KEY.Rank_UI )
end


return GameRank