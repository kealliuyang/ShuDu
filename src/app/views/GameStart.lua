
local GameStart = class("GameStart",BaseLayer)



function GameStart:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameStart.super.ctor( self,param.name )
    self:addCsb( "csb/LayerMain.csb" )

    -- 开始
    self:addNodeClick( self.ButtonStart,{ 
        endCallBack = function() self:start() end
    })
    -- 设置
    self:addNodeClick( self.ButtonSet,{ 
        endCallBack = function() self:set() end
    })
    -- 记录
    self:addNodeClick( self.ButtonRecord,{ 
        endCallBack = function() self:record() end
    })
    -- 帮助
    self:addNodeClick( self.ButtonHelp,{ 
        endCallBack = function() self:help() end
    })

    -- 变灰
    local continue_data = G_GetModel("Model_Player"):getContinueData()
    if continue_data then
        -- 继续
        self:addNodeClick( self.ButtonContinue,{ 
            endCallBack = function() self:continue() end
        })
    else
        graySprite(self.ButtonContinue:getVirtualRenderer():getSprite())
    end
end


function GameStart:start()
	removeUIFromScene( UIDefine.UI_KEY.Start_UI )
	addUIToScene( UIDefine.UI_KEY.Select_UI )
end
function GameStart:continue()
    local continue_data = G_GetModel("Model_Player"):getContinueData()
    if continue_data then
        local data = { level = continue_data.level,continue = true }
        addUIToScene( UIDefine.UI_KEY.Main_UI,data )
    end
end

function GameStart:set()
    addUIToScene( UIDefine.UI_KEY.Set_UI )
end
function GameStart:record()
    addUIToScene( UIDefine.UI_KEY.Record_UI )
end
function GameStart:help()
	addUIToScene( UIDefine.UI_KEY.Help_UI )
end


return GameStart