
local GameWin = class("GameWin",BaseLayer)


function GameWin:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameWin.super.ctor( self,param.name )
    self:addCsb( "csbtwentyfour/LayerGameResult.csb" )
    self._param = param
    -- 返回
    self:addNodeClick( self.ButtonBack,{ 
        endCallBack = function() self:back() end
    })
    -- 刷新
    self:addNodeClick( self.ButtonRefresh,{ 
        endCallBack = function() self:refresh() end,
        voicePath = "tfmp3/reset.mp3"
    })
    -- Home
    self:addNodeClick( self.ButtonHome,{ 
        endCallBack = function() self:home() end
    })
    --next
    self:addNodeClick( self.ButtonNext,{ 
        endCallBack = function() self:next() end,
        voicePath = "tfmp3/reset.mp3"
    })
    self:loadUiData()
end

function GameWin:onEnter()
    GameWin.super.onEnter( self )
    -- casecadeFadeInNode( self.MidPanel,0.5 )

    -- action
    local node_name_list = { "TextExpresstion","ImagePerfect","Text1","TextGradeLevel" }
    local delay_time = 0.2

    for i,v in ipairs( node_name_list ) do
        self[v]:setVisible( false )
    end

    local action_list = {}
    for i,v in ipairs( node_name_list ) do
        local delay = cc.DelayTime:create( delay_time )
        local call_show = cc.CallFunc:create( function()
            self[v]:setVisible(true)
        end )
        table.insert( action_list,delay )
        table.insert( action_list,call_show )
    end
    local seq = cc.Sequence:create(action_list)
    self:runAction( seq )
end

function GameWin:loadUiData()
	-- operation result
	local str = self._param.data.resultStr
	self.TextExpresstion:setString( str )
	-- level
	self.TextLevel:setString( "level "..self._param.data.index )
	self.TextGrade:setString("( "..tf_lang_config[self._param.data.level].." )")
	self.TextGradeLevel:setString("then "..tf_lang_config[self._param.data.level].." Level "..self._param.data.index )
end

function GameWin:back()
	removeUIFromScene( UIDefine.TWENTYFOUR_KEY.Win_UI )
    addUIToScene( UIDefine.TWENTYFOUR_KEY.Level_UI )
end

function GameWin:refresh()
	local data = { level = self._param.data.level,index = self._param.data.index }
	removeUIFromScene( UIDefine.TWENTYFOUR_KEY.Win_UI )
    addUIToScene( UIDefine.TWENTYFOUR_KEY.Play_UI,data )
end

function GameWin:home()
	removeUIFromScene( UIDefine.TWENTYFOUR_KEY.Win_UI )
    addUIToScene( UIDefine.TWENTYFOUR_KEY.Start_UI )
end

function GameWin:next()
	local level_max = #tf_quest_config
	local level,index = nil,nil
	if self._param.data.level < level_max then
		if self._param.data.index == 20 then
			level = self._param.data.level + 1
			index = 1
		else
			level = self._param.data.level
			index = self._param.data.index + 1
		end
	else
		if self._param.data.index == 20 then
			-- 最后一关
			level = 1
			index = 1
		else
			level = level_max
			index = self._param.data.index + 1
		end
	end
	removeUIFromScene( UIDefine.TWENTYFOUR_KEY.Win_UI )
    addUIToScene( UIDefine.TWENTYFOUR_KEY.Play_UI,{level = level,index = index} )
end

return GameWin