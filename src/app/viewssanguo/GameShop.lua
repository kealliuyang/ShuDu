

-- import( "app.viewssanguo.NodeShop" )---必须赋值，只是因为后面需要调用它的构造函数？？这样写可以直接在后面用
local NodeShop = import( "app.viewssanguo.NodeShop" )--正规写法
local GameShop = class( "GameShop",BaseLayer )



function GameShop:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameShop.super.ctor( self,param.name )
	
	-- local layer = ccui.ImageView:create( cc.c4b( 0,0,0,150))
	-- local layer = ccui.ImageView:create()
	local layer = cc.LayerColor:create( cc.c4b( 0,0,0,150))----给不给值效果一样,写上，怕一些机制上颜色出问题。
	self:addChild( layer )
	self._layer = layer

	self._startLayer = param.data.layer----主页面金币刷新，获取GameStart的指针，需要NodeShop里面用，NodeShop是这个页面的子？这层不用传？
	

	-- local csb_img = self:addCsb( "res/csbsanguo/Shop.csb" )
	self:addCsb( "Shop.csb" )



	-- self:addNodeClick(self.ButtonClose,{
	-- 	endCallBack = function ()--------------------------没看懂为什么是这样写，{}和它里面，这套很复杂，别深究了。
	-- 		self:close()
	-- 	end
	-- })
	self:addNodeClick( self.ButtonClose,{
		endCallBack = function ()
			self:close()			
		end
	})

	self:loadUi()
end

function GameShop:loadUi()
	for i=1,3 do
		local node = NodeShop.new( self,i )
		self["Panel"..i]:addChild( node )---------这self["Panel"..i]是等价于self.Panel1?为什么这样写？语法？lua里面其实所有东西都是一个表，所以self.xxx,和self[xxx]是表的格式。
		
	end
end

function GameShop:onEnter()
	GameShop.super.onEnter( self )
	casecadeFadeInNode( self.Bg,0.5 )
	casecadeFadeInNode( self._layer,0.5,150 )
end


-- function GameShop:close()
-- 	removeUIFromScene( UIDefine.SANGUO_KEY.Shop_UI )
-- end
function GameShop:close()
	removeUIFromScene( UIDefine.SANGUO_KEY.Shop_UI)
end

return GameShop






-- local NodeShop = import(".NodeShop")
-- local GameShop = class( "GameShop",BaseLayer )


-- function GameShop:ctor( param )
-- 	assert( param," !! param is nil !! ")
--     assert( param.name," !! param.name is nil !! ")
--     GameShop.super.ctor( self,param.name )

-- 	local layer = cc.LayerColor:create(cc.c4b(0,0,0,150))
-- 	self:addChild(layer)
-- 	self._layer = layer

-- 	self:addCsb( "csbsanguo/Shop.csb" )

-- 	self:addNodeClick( self.ButtonClose,{
-- 		endCallBack = function ()
-- 			self:close()			
-- 		end
-- 	})

-- 	self:loadUi()
-- end

-- function GameShop:loadUi()
-- 	for i=1,3 do
-- 		local node = NodeShop.new( self,i )
-- 		self["Panel"..i]:addChild( node )
-- 	end
-- end

-- function GameShop:onEnter()
-- 	GameShop.super.onEnter( self )
-- 	casecadeFadeInNode( self.Bg,0.5 )
-- 	casecadeFadeInNode( self._layer,0.5,150 )
-- end


-- function GameShop:close()
-- 	removeUIFromScene( UIDefine.ZHIPAI_KEY.Shop_UI)
-- end


-- return GameShop