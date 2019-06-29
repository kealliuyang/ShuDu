

local HelpTable = import(".HelpTable")
local GameHelp = class("GameHelp",BaseLayer)

function GameHelp:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameHelp.super.ctor( self,param.name )

    self._param = param

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer )
    self._layer = layer

    self:addCsb( "csblaba/Help.csb" )

    -- 关闭
    self:addNodeClick( self.ButtonCloseHelp,{ 
        endCallBack = function() self:close() end
    })
end


function GameHelp:onEnter()
    GameHelp.super.onEnter( self )
    casecadeFadeInNode( self.bg,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))

    self:initTable()
end

function GameHelp:initTable()
    -- 添加table
    if self._table == nil then
        local size = self.tablePanel:getContentSize()
        local param = {
            tableSize = size,
            parentPanel = self,
            directionType = 2
        }
        self._table = HelpTable.new( param )
        self.tablePanel:addChild( self._table )
    end

    self._table:reload()
end

-- 关闭
function GameHelp:close()
    removeUIFromScene( UIDefine.LABA_KEY.Help_UI )
end




return GameHelp