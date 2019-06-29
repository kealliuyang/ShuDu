

local GamePause = class( "GamePause",BaseLayer )

function GamePause:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePause.super.ctor( self,param.name )

    local layer = cc.LayerColor:create( cc.c4b( 0,0,0,150 ))
    self:addChild( layer )
    self._layer = layer

    self._parent = param.data.layer

    self:addCsb( "csbzhandou/Pause.csb" )

    self:addNodeClick( self.ButtonQuit,{ 
        endCallBack = function() 
        	self:close() 
        end
    })

    self:addNodeClick( self.ButtonReturn,{ 
        endCallBack = function() 
            self:clickReturn() 
        end
    })
end

function GamePause:onEnter()
	GamePause.super.onEnter( self )
	casecadeFadeInNode( self.Bg,0.5 )
	casecadeFadeInNode( self._layer,0.5,150 )
end

function GamePause:clickReturn()
    self._parent:startSchedule()
    removeUIFromScene( UIDefine.ZHANDOU_KEY.Pause_UI )
end

function GamePause:close()
	removeUIFromScene( UIDefine.ZHANDOU_KEY.Pause_UI )
    removeUIFromScene( UIDefine.ZHANDOU_KEY.Play_UI )
    addUIToScene( UIDefine.ZHANDOU_KEY.Start_UI )
end



return GamePause