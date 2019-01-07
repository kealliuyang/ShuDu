

local GameNext = class("GameNext",BaseLayer)



function GameNext:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameNext.super.ctor( self,param.name )
    self._param = param

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer,1 )

    self:addCsb( "csb/LayerNext.csb",2 )

    -- 下一关
    self:addNodeClick( self["ButtonNext"],{ 
        endCallBack = function() self:next() end
    })
    -- 从新开始
    self:addNodeClick( self["ButtonReplay"],{ 
        endCallBack = function() self:replay() end
    })

    self:loadUi()
end

function GameNext:loadUi()
	local level = self._param.data.level
    -- 是否是新纪录
	self.NewScore:setVisible( self._param.data.newScore )
    -- 显示时间
    self.TextTime:setString(formatTimeStr(self._param.data.time,"："))
end

function GameNext:onEnter()
    GameNext.super.onEnter( self )
    UIScaleShowAction( self.MidPanel )
end

function GameNext:next()
	local level = self._param.data.level
	if level < #quest_config then
		removeUIFromScene( UIDefine.UI_KEY.Next_UI )
        removeUIFromScene( UIDefine.UI_KEY.Main_UI )
		-- 从新加载
		local data = { level = level + 1 }
		addUIToScene( UIDefine.UI_KEY.Main_UI,data )
    else
        removeUIFromScene( UIDefine.UI_KEY.Next_UI )
        removeUIFromScene( UIDefine.UI_KEY.Main_UI )
        -- 直接进入第一关
        local data = { level = 1 }
        addUIToScene( UIDefine.UI_KEY.Main_UI,data )
	end
end
function GameNext:replay()
    -- 进入当前关卡
    local level = self._param.data.level
    removeUIFromScene( UIDefine.UI_KEY.Next_UI )
    removeUIFromScene( UIDefine.UI_KEY.Main_UI )
    local data = { level = level }
    addUIToScene( UIDefine.UI_KEY.Main_UI,data )
end


return GameNext