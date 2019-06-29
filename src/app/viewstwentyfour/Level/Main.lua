
local MainTable = import(".MainTable")
local Main 		= class("Main",BaseLayer)


function Main:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    Main.super.ctor( self,param.name )
    self:addCsb( "csbtwentyfour/LayerGameLevel.csb" )

    -- 返回
    self:addNodeClick( self.ButtonBack,{ 
        endCallBack = function() self:close() end
    })

    self:initCurLevel()
    self:initTable()
    self:loadDataUi()
    self:initBottomPoint()

    -- 设置需要高亮显示的 point
    local len = #tf_quest_config
    for i = 1,len do
        local point = self.BottomPanel:getChildByTag(1000 + i)
        if i == self._currentLv then
            point:loadTexture("image/2/point_h.png",1)
        else
            point:loadTexture("image/2/point_n.png",1)
        end
    end
end

function Main:onEnter()
    Main.super.onEnter( self )
    casecadeFadeInNode( self.MidPanel,0.5 )
end

function Main:initTable()
	-- 添加table
	if self._table == nil then
        local size = self.tablePanel:getContentSize()
        local param = {
            tableSize = size,
            parentPanel = self,
            directionType = 1
        }
        self._table = MainTable.new( param )
        self.tablePanel:addChild( self._table )
    end
end

function Main:loadDataUi()
	self._table:reload()
    -- 滚动到指定的行
    self._table:scrollTableViewByRowIndex(self._currentLv)
end

function Main:initCurLevel()
    local cur_level,cur_point = G_GetModel("Model_TwentyFour"):getLevelAndPoint()
    -- ImageLevel
    self:initImageLevel( cur_level )
    self._currentLv = cur_level
end

function Main:initImageLevel(level)
    assert( level," !! level is nil !! ")
    self.TextLevel:setString("YOUR LEVEL:"..tf_lang_config[level])
    self.ImageLevel:loadTexture("image/2/"..level..".png",1 )
    self.ImageLevel:ignoreContentAdaptWithSize( true )
    if level == 5 or level == 6 or level == 7 or level == 11
        or level == 9 or level == 12 or level == 13 or level == 14 then
        self.ImageLevel:setPositionX(360)
        self.TextLevel:setPositionX(360)
    else
        self.ImageLevel:setPositionX(413)
        self.TextLevel:setPositionX(404)
    end 
end

function Main:initBottomPoint()
    local len = #tf_quest_config
    local point_width = 15
    local point_space = 15
    local total_width = len * point_width + (len -1) * point_space
    local container_width = self.BottomPanel:getContentSize().width
    local start_pos = ( container_width - total_width ) / 2
    for i = 1,len do
        local point = self.BottomPanel:getChildByTag(1000 + i)
        if not point then
            if i == 1 then
                point = ccui.ImageView:create("image/2/point_h.png",1)
            else
                point = ccui.ImageView:create("image/2/point_n.png",1)
            end
            point:setTag(1000 + i)
            self.BottomPanel:addChild(point)
            local y_pos = self.BottomPanel:getContentSize().height / 2
            local x_pos = start_pos + ( i - 1 ) * point_width + ( i - 1 ) * point_space
            point:setPosition(cc.p( x_pos,y_pos ))
        end
    end
end

function Main:clickLeft()
    if self._currentLv <= 1 then
        return
    end
    local isScroll = self._table:isScroll()
    if isScroll then
        return
    end
    local before = self._currentLv
    self._currentLv = self._currentLv - 1
    local rowIndex = self._currentLv
    self._table:scrollTableViewByRowIndex( rowIndex,0.3 )
    self:resetPoint( before )
    self:initImageLevel( self._currentLv )
end

function Main:clickRight()
    local maxLv = #tf_quest_config
    if self._currentLv >= maxLv then
        return
    end
    local isScroll = self._table:isScroll()
    if isScroll then
        return
    end
    local before = self._currentLv
    self._currentLv = self._currentLv + 1
    local rowIndex = self._currentLv
    self._table:scrollTableViewByRowIndex( rowIndex,0.3 )
    self:resetPoint( before )
    self:initImageLevel( self._currentLv )
end

function Main:resetPoint( index )
    local len = #tf_quest_config
    local point1 = self.BottomPanel:getChildByTag(1000 + index)
    if point1 then
        point1:loadTexture("image/2/point_n.png",1)
    end
    local point2 = self.BottomPanel:getChildByTag(1000 + self._currentLv)
    if point2 then
        point2:loadTexture("image/2/point_h.png",1)
    end
end

function Main:close()
    removeUIFromScene( UIDefine.TWENTYFOUR_KEY.Level_UI )
    addUIToScene( UIDefine.TWENTYFOUR_KEY.Start_UI )
end


return Main