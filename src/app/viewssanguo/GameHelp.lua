

local GameHelp = class( "GameHelp",BaseLayer )


function GameHelp:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameHelp.super.ctor( self,param.name )--执行父类的构造函数

    self._param = param----------------------------------------这一句有什么用，注销还是正常运行？

	local layer =cc.LayerColor:create(cc.c4b(0,0,0,150))
	self:addChild( layer )
	self._layer = layer----这里只是为了让它变成全局？还是有什么考虑？看你都是这样重新赋值一次，
	-- self._layer = cc.LayerColor:create(cc.c4b(0,0,0,150))---用这两句替代上面3句会不会有问题？
	-- self:addChild( self._layer )

	self:addCsb( "csbsanguo/Help.csb" )

	self:addNodeClick( self.ButtonClose,{
		endCallBack = function ()
			self:close()
		end
	})
end


function GameHelp:onEnter()
    GameHelp.super.onEnter( self )
    casecadeFadeInNode( self.Bg,0.5 )
    self._layer:setOpacity(0)
    self._layer:runAction(cc.FadeTo:create(0.5,150))
end


function GameHelp:close()
	removeUIFromScene( UIDefine.SANGUO_KEY.Help_UI )
	-- body
end





return GameHelp