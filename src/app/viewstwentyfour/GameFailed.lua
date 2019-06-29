

local GameFailed = class("GameFailed",BaseLayer)

function GameFailed:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameFailed.super.ctor( self,param.name )
    self:addCsb( "csbtwentyfour/LayerGameResultNot.csb" )
    self._param = param
    -- 返回
    self:addNodeClick( self.ButtonBack,{ 
        endCallBack = function() self:back() end
    })
    -- 刷新
    self:addNodeClick( self.ButtonRefresh,{ 
        endCallBack = function() self:refresh() end
    })

    self:loadUiData()
end

function GameFailed:onEnter()
    GameFailed.super.onEnter( self )
    -- casecadeFadeInNode( self.MidPanel,0.5 )
end

function GameFailed:loadUiData()
	-- level
	self.TextLevel:setString( "level "..self._param.data.index )
	self.TextGrade:setString("( "..tf_lang_config[self._param.data.level].." )")
	self.TextNum:setString( self._param.data.num )
    
    if string.find( self._param.data.num,"/") then
        self.TextNum:setScale(0.6)
    else
        self.TextNum:setScale(1)
    end
end

function GameFailed:back()
	removeUIFromScene( UIDefine.TWENTYFOUR_KEY.Failed_UI )
    addUIToScene( UIDefine.TWENTYFOUR_KEY.Level_UI )
end


function GameFailed:refresh()
	local data = { level = self._param.data.level,index = self._param.data.index }
	removeUIFromScene( UIDefine.TWENTYFOUR_KEY.Failed_UI )
    addUIToScene( UIDefine.TWENTYFOUR_KEY.Play_UI,data )
end


return GameFailed