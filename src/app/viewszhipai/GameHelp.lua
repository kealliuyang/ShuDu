

local GameHelp = class( "GameHelp",BaseLayer )


function GameHelp:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameHelp.super.ctor( self,param.name )--执行父类的构造函数

    self._param = param

	local layer =cc.LayerColor:create(cc.c4b(0,0,0,150))
	self:addChild( layer )
	self._layer = layer

	self:addCsb( "csbzhipai/Help.csb" )

	self:addNodeClick( self.ButtonHelpClose,{
		endCallBack = function ()
			self:close()
		end
	})
end


function GameHelp:onEnter()
    GameHelp.super.onEnter( self )
    casecadeFadeInNode( self.ImageHelpBg,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
end


function GameHelp:close()
	removeUIFromScene( UIDefine.ZHIPAI_KEY.Help_UI )
	-- body
end





return GameHelp