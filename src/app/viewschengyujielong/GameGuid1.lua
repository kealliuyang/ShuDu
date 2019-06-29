
local CharUnit  = import(".CharUnit")
local GameGuid1 = class("GameGuid1",BaseLayer)


function GameGuid1:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameGuid1.super.ctor( self,param.name )
    self:addCsb( "csbchengyujielong/Guid1.csb",0 )

    self._bgGeZiList = {}
    self._charUnitList = {}
    -- 加载背景方块
    self:initBgBlock()
    -- 加载题库
    self:loadQuest()

    self._step = 1

    -- BgMask
    self:addNodeClick( self["BgMask"],{ 
        endCallBack = function() self:guidStep() end,
        scaleAction = false
    })
end

-- 添加背景块
function GameGuid1:initBgBlock()
	for i = 1,12 do
		self._bgGeZiList[i] = {}
		local usedi1 = true
		if i % 2 == 0 then
			usedi1 = false
		end
		for j = 1,8 do
			local image_path = ""
			if usedi1 then
				if j % 2 == 0 then
					image_path = "image/game/gezi2.png"
				else
					image_path = "image/game/gezi1.png"
				end
			else
				if j % 2 == 0 then
					image_path = "image/game/gezi1.png"
				else
					image_path = "image/game/gezi2.png"
				end
			end
			local image_gezi = ccui.ImageView:create( image_path, 1 )
			self.BgContent:addChild( image_gezi )
			local dis_x = image_gezi:getContentSize().width / 2
			local dis_y = image_gezi:getContentSize().height / 2
			local x_pos = ( j - 1 ) * ( image_gezi:getContentSize().width ) + dis_x + j * 3.8
			local y_pos = ( i - 1 ) * ( image_gezi:getContentSize().height ) + dis_y + i * 3.8
			image_gezi:setPosition( x_pos,y_pos )

			-- 存储
			self._bgGeZiList[i][j] = image_gezi
		end
	end
end


function GameGuid1:onEnter()
    GameGuid1.super.onEnter( self )
    
    -- 打开背景音乐
    G_GetModel("Model_Sound"):playBgMusic()

    self:showGuidPeople()
end

function GameGuid1:showGuidPeople()
	self.BgMask:setVisible( true )
	self.ImageRenWu:setVisible( true )
	self.ImageYuan1:setVisible( false )
    self.Text_1:setVisible( false )
    self.Text_2:setVisible( false )
    local size = self.ImageRenWu:getContentSize()
    self.ImageRenWu:setPositionX( display.width + size.width + 10 )
    local move_by = cc.MoveBy:create( 0.5,cc.p( -size.width - 10,0 ) )
    local call_show = cc.CallFunc:create( function()
    	self.ImageYuan1:setVisible( true )
    	self.Text_1:setVisible( true )
    	self.Text_2:setVisible( true )
    end )
    local seq = cc.Sequence:create({ move_by,call_show })
    self.ImageRenWu:runAction( seq )
    local renWu = self.ImageRenWu:clone()
end


function GameGuid1:loadQuest()
	self._questData = { "金,玉,满,堂" }
	local arr_char = {}
	for i,v in ipairs( self._questData ) do
		local arr = string.split( v,"," )
		for a,b in ipairs(arr) do
			table.insert( arr_char,b )
		end
	end
	local pos = {
		{ row = 9,col = 2 },
		{ row = 11,col = 3 },
		{ row = 7,col = 4 },
		{ row = 9,col = 7 },
	}
	for i,v in ipairs( arr_char ) do
		local row,col = pos[i].row,pos[i].col
		local char_unit = CharUnit.new( self,row,col )
		char_unit:loadUi( v )
		char_unit:setPassDone()
		table.insert( self._charUnitList,char_unit )
		-- 计算需要随机摆放的位置
		self.BgContent:addChild( char_unit )
		char_unit:setPosition( cc.p( self._bgGeZiList[row][col]:getPosition() ) )
	end
end


function GameGuid1:addClipNode( row1,col1,row2,col2 )
	local clip_node = cc.ClippingNode:create()
    self.BgContent:addChild( clip_node,2 )

    clip_node:setInverted(true) --设置地板可见
    clip_node:setAlphaThreshold(0)--设置透明度Alpha值为0
    local layerColor = cc.LayerColor:create(cc.c4b(0,0,0,100))
    clip_node:addChild(layerColor,1)--在裁剪节点添加一个灰色的透明层

    local node = cc.Node:create() --创建模版
    
    local width,height = 80,80
    local image_gezi1 = ccui.ImageView:create( "image/game/gezi1.png", 1 )
    local pos = cc.p( self._bgGeZiList[row1][col1]:getPosition() )
    image_gezi1:setPosition( pos )
    node:addChild( image_gezi1 )

    local image_gezi2 = ccui.ImageView:create( "image/game/gezi1.png", 1 )
    local pos = cc.p( self._bgGeZiList[row2][col2]:getPosition() )
    image_gezi2:setPosition( pos )
    node:addChild( image_gezi2 )

    clip_node:setStencil(node)--设置模版

    self._clip_node = clip_node
end

function GameGuid1:addCharCircle( row,col )
	if self._imgCircle == nil then
		self._imgCircle = ccui.ImageView:create("image/guid/yuan2.png",1)
		self:addChild( self._imgCircle,100 )
	end
	self._imgCircle:setVisible( true )
	local pos = cc.p( self._bgGeZiList[row][col]:getPosition() )
	local world_pos = self._bgGeZiList[row][col]:getParent():convertToWorldSpace( pos )
	self._imgCircle:setPosition( world_pos )
end

function GameGuid1:addDirectImg( row,col,dir )
	if self._imgDirect == nil then
		self._imgDirect = ccui.ImageView:create("image/guid/jiantou.png",1)
		self:addChild( self._imgDirect,101 )
	end
	self._imgDirect:setVisible( true )
	self._imgDirect:stopAllActions()
	local pos = cc.p( self._bgGeZiList[row][col]:getPosition() )
	local world_pos = self._bgGeZiList[row][col]:getParent():convertToWorldSpace( pos )
	self._imgDirect:setPosition( world_pos )

	
	local move_posy1 = nil
	local move_posy2 = nil
	if dir == 1 then
		move_posy1 = 20
		move_posy2 = -move_posy1
		local move_by1 = cc.MoveBy:create( 1,cc.p( 0,move_posy1 ) )
		local move_by2 = cc.MoveBy:create( 1,cc.p( 0,move_posy2 ) )
		local seq = cc.Sequence:create({ move_by1,move_by2 })
		local rep = cc.RepeatForever:create( seq )
		self._imgDirect:runAction( rep )
	elseif dir == 2 then
		self._imgDirect:setRotation( - 180 )
		move_posy1 = 20
		move_posy2 = -move_posy1
		local move_by1 = cc.MoveBy:create( 1,cc.p( 0,move_posy1 ) )
		local move_by2 = cc.MoveBy:create( 1,cc.p( 0,move_posy2 ) )
		local seq = cc.Sequence:create({ move_by1,move_by2 })
		local rep = cc.RepeatForever:create( seq )
		self._imgDirect:runAction( rep )
	elseif dir == 3 then
		self._imgDirect:setRotation( 0 )
		self._imgDirect:setRotation( 90 )
		move_posy1 = 20
		move_posy2 = -move_posy1
		local move_by1 = cc.MoveBy:create( 1,cc.p( move_posy1,0 ) )
		local move_by2 = cc.MoveBy:create( 1,cc.p( move_posy2,0 ) )
		local seq = cc.Sequence:create({ move_by1,move_by2 })
		local rep = cc.RepeatForever:create( seq )
		self._imgDirect:runAction( rep )
	end
end

function GameGuid1:clearGuidUi()
	self._imgDirect:setVisible( false )
	self._imgCircle:setVisible( false )
	self._clip_node:removeFromParent()
end

function GameGuid1:guidStep()
	if self._step == 1 then
		self.BgMask:setVisible( false )
		self.ImageRenWu:setVisible( false )
		self:addClipNode( 11,3,9,3 )
		self:addCharCircle( 11,3 )
		self:addDirectImg( 10,3,1 )
		self._charUnitList[2]:setPassDone( false )
		self._step = 2
	elseif self._step == 2 then
		self.BgMask:setVisible( false )
		self.ImageRenWu:setVisible( false )
		self:addClipNode( 7,4,9,4 )
		self:addCharCircle( 7,4 )
		self:addDirectImg( 8,4,2 )
		self._charUnitList[3]:setPassDone( false )
		self._step = 3
	elseif self._step == 3 then
		self.BgMask:setVisible( false )
		self.ImageRenWu:setVisible( false )
		self:addClipNode( 9,7,9,5 )
		self:addCharCircle( 9,7 )
		self:addDirectImg( 9,6,3 )
		self._charUnitList[4]:setPassDone( false )
		self._step = 4
	elseif self._step == 4 then
		-- 引导结束
		G_GetModel("Model_ChengYuJieLong"):setPassGuid()
		removeUIFromScene( UIDefine.CHENGYUJIELONG_KEY.Guid1_UI )
		addUIToScene( UIDefine.CHENGYUJIELONG_KEY.Start_UI )
	end
end

function GameGuid1:putCharUnit( charUnit )
	local text = charUnit:getChar()
	if text == "玉" then
		local call_back = function()
			self:clearGuidUi()
			self.Text_1:setString("按住\"满\"字,将它拖到箭头所指的格子上")
			self.Text_2:setString("满")
			self:showGuidPeople()
		end
		self:guidMoveAction( 9,3,call_back,charUnit )
	elseif text == "满" then
		local call_back = function()
			self:clearGuidUi()
			self.Text_1:setString("按住\"堂\"字,将它拖到箭头所指的格子上")
			self.Text_2:setString("堂")
			self:showGuidPeople()
		end
		self:guidMoveAction( 9,4,call_back,charUnit )
	elseif text == "堂" then
		local call_back = function()
			self:clearGuidUi()
			self.Text_1:setString("很简单吧,开始你的通关之旅吧")
			self.Text_2:setString("")
			self:showGuidPeople()
		end
		self:guidMoveAction( 9,5,call_back,charUnit )
	end
end

function GameGuid1:guidMoveAction( dirRow,dirCol,callBack,charUnit )

	local char_unit_box = charUnit.RootPanel:getBoundingBox()
	local char_unit_world_pos = charUnit.RootPanel:getParent():convertToWorldSpace( cc.p(charUnit.RootPanel:getPosition()) )
	local char_unit_rect = cc.rect( char_unit_world_pos.x,char_unit_world_pos.y,char_unit_box.width,char_unit_box.height )
	local contains = {}

	local ge_zi_node = self._bgGeZiList[dirRow][dirCol]
	local bound_box = ge_zi_node:getBoundingBox()
	local ge_zi_world_pos = ge_zi_node:getParent():convertToWorldSpace( cc.p(ge_zi_node:getPosition()) )
	local rect1 = { x = ge_zi_world_pos.x, y = ge_zi_world_pos.y,width = bound_box.width,height = bound_box.height }
	local rect3 = cc.rectIntersection(char_unit_rect,rect1)
	if rect3.width > 20 and rect3.height > 20 then
		local meta = { rect = rect3,i = i,j = j }
        table.insert( contains,meta )
	end
	local end_pos = nil
	local can_next = false
	if #contains > 0 then
		can_next = true
		end_pos = cc.p(ge_zi_node:getPosition())
		charUnit:setOrgRowAndCol( dirRow,dirCol )
		charUnit:setPassDone()
	else
		local row,col = charUnit:getOrgRowAndCol()
		end_pos = cc.p(self._bgGeZiList[row][col]:getPosition())
	end

	local move_to = cc.MoveTo:create( 0.2,end_pos )
	local call_pass = cc.CallFunc:create( function()
		if can_next then
			callBack()
		end
	end )
	local seq = cc.Sequence:create({ move_to,call_pass })
	charUnit:runAction( seq )
end

return GameGuid1