

local GameEditor = class("GameEditor",BaseLayer)



function GameEditor:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameEditor.super.ctor( self,param.name )

    self:initConfig()
    self:initContentSize()
    self:createLine()
end

function GameEditor:initConfig()
	self._config = {}
	self._config.matrix = { x = 25,y = 25 }
	self._config.cellSize = 80
end

function GameEditor:initContentSize()
	-- 创建滚动区域
	self._scroll = ccui.ScrollView:create()
	self:addChild( self._scroll )
	self._scroll:setDirection(ccui.ScrollViewDir.both)

	local width = self._config.matrix.x * self._config.cellSize
	local height = self._config.matrix.y * self._config.cellSize

	local scroll_size = cc.size( width,height )
	self._scroll:setContentSize( display.size )
	self._scroll:setInnerContainerSize( scroll_size )

	self._size = scroll_size
end


function GameEditor:createLine()
	local draw = cc.DrawNode:create(1)
    self._scroll:addChild(draw, 10)
    for i = 0,self._config.matrix.x do
    	draw:drawLine(cc.p(i * self._config.cellSize,0), cc.p(i * self._config.cellSize, self._size.height), cc.c4f(0,1,0,0.5))
    end
    for i = 0,self._config.matrix.y do
    	draw:drawLine(cc.p(0,i * self._config.cellSize), cc.p(self._size.width, i * self._config.cellSize), cc.c4f(0,1,0,0.5))
    end
end














return GameEditor