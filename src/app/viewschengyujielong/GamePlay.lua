
local CharUnit = import(".CharUnit")
local GamePlay = class("GamePlay",BaseLayer)



function GamePlay:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePlay.super.ctor( self,param.name )
    self:addCsb( "csbchengyujielong/GamePlay.csb" )

    self._bgGeZiList = {}
    
    -- 加载背景方块
    self:initBgBlock()
    -- 初始化数据
    self:resetLoadUiData()
end

function GamePlay:onEnter()
    GamePlay.super.onEnter( self )
    casecadeFadeInNode( self._csbNode,0.5 )
end

function GamePlay:resetLoadUiData()
	-- 清除加载的char node
    self:clearCharNode()

	self._geZiPosition = {}
    self._questData = {}
    self._charUnitList = {}
    self._passCount = 0
    -- 每个关卡的通关时间 60秒
    self._passLevelTime = 60

    -- 加载界面数据
    self:loadUIData()
    -- 加载题库
    self:loadQuest()

    -- 开始倒计时
    self:schedule( function()
    	self._passLevelTime = self._passLevelTime - 0.2
    	self.TimeBar:setPercent( 100 * ( self._passLevelTime / 60 ) )
    	if self._passLevelTime <= 0 then
    		self:unSchedule()
    		-- 存储记录
    		G_GetModel("Model_ChengYuJieLong"):saveRecordList()
    		-- 结束游戏
    		addUIToScene( UIDefine.CHENGYUJIELONG_KEY.GameOver_UI )
    	end
    end,0.2 )
end

-- 添加背景块
function GamePlay:initBgBlock()
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

function GamePlay:loadUIData()
	-- score
	local score = G_GetModel("Model_ChengYuJieLong"):getScore()
	self.TextScore:setString( score )
	-- level 
	local level = G_GetModel("Model_ChengYuJieLong"):getLevel()
	self.TextLevel:setString( level )
	-- time
	self.TimeBar:setPercent( 100 )

	-- 背景音乐
	if level >= 6 then
		if self._changeMusic == nil then
			audio.playMusic("cyjlmp3/bg1.mp3",true)
			self._changeMusic = true
		end
	end
end

function GamePlay:loadQuest()
	self._questData = G_GetModel("Model_ChengYuJieLong"):getQuestData()
	local arr_char = {}
	for i,v in ipairs( self._questData ) do
		local arr = string.split( v,"," )
		for a,b in ipairs(arr) do
			table.insert( arr_char,b )
		end
	end
	for i,v in ipairs( arr_char ) do
		local row,col = self:getRandomGeZiPosition()
		local char_unit = CharUnit.new( self,row,col )
		char_unit:loadUi( v )
		table.insert( self._charUnitList,char_unit )
		-- 计算需要随机摆放的位置
		self.BgContent:addChild( char_unit )
		char_unit:setPosition( cc.p( self._bgGeZiList[row][col]:getPosition() ) )
	end
end




function GamePlay:putCharUnit( charUnit )
	local char_unit_box = charUnit.RootPanel:getBoundingBox()
	local char_unit_world_pos = charUnit.RootPanel:getParent():convertToWorldSpace( cc.p(charUnit.RootPanel:getPosition()) )
	local char_unit_rect = cc.rect( char_unit_world_pos.x,char_unit_world_pos.y,char_unit_box.width,char_unit_box.height )
	local contains = {} 
	for i = 1,12 do
		for j = 1,8 do
			local bound_box = self._bgGeZiList[i][j]:getBoundingBox()
			local ge_zi_world_pos = self._bgGeZiList[i][j]:getParent():convertToWorldSpace( cc.p(self._bgGeZiList[i][j]:getPosition()) )
			local rect1 = { x = ge_zi_world_pos.x, y = ge_zi_world_pos.y,width = bound_box.width,height = bound_box.height }
			local rect3 = cc.rectIntersection(char_unit_rect,rect1)
			if rect3.width > 0 and rect3.height > 0 then
                local meta = { rect = rect3,i = i,j = j }
                table.insert( contains,meta )
            end
            if #contains >= 4 then
                break
            end
		end
		if #contains >= 4 then
            break
        end
	end

	local end_pos = nil
	local can_put,can_put_row,can_put_col = false,nil,nil

	if #contains > 0 then
		local max_area,max_i,max_j = 0,0,0
	    for i,v in ipairs( contains ) do
	        local area = v.rect.width * v.rect.height
	        if area > max_area then
	            max_area = area
	            max_i,max_j = v.i,v.j
	        end
	    end
	    can_put = self:checkHasCharUnitByPos( max_i,max_j )
	    if can_put then
		    can_put_row = max_i
		    can_put_col = max_j
	    end
	end

	if can_put then
		end_pos = cc.p(self._bgGeZiList[can_put_row][can_put_col]:getPosition())
		-- 从新设置位置
		charUnit:setOrgRowAndCol( can_put_row,can_put_col )
	else
		local row,col = charUnit:getOrgRowAndCol()
		end_pos = cc.p(self._bgGeZiList[row][col]:getPosition())
	end

	local move_to = cc.MoveTo:create( 0.2,end_pos )
	local call_pass = cc.CallFunc:create( function()
		if can_put then
			local is_pass,pass_data = self:checkQuestIsPass( can_put_row )
			if is_pass then
				self._passCount = self._passCount + 1
				self:passQuestAction( pass_data )
			end
		end
	end )
	local seq = cc.Sequence:create({ move_to,call_pass })
	charUnit:runAction( seq )
end

-- 检查当前题目是否过关
function GamePlay:checkQuestIsPass( row )
	assert( row," !! row is nil !! " )
	local char_units = {}
	for i,v in ipairs( self._charUnitList ) do
		local char_row,char_col = v:getOrgRowAndCol()
		if not v:getIsPass() and char_row == row then
			table.insert( char_units,v )
		end
	end
	-- 1:判断数量
	if #char_units < 4 then
		return false
	end
	-- 2:判断是否连续
	table.sort( char_units,function( a,b )
		local row1,col1 = a:getOrgRowAndCol()
		local row2,col2 = b:getOrgRowAndCol()
		return col1 < col2
	end )


	local continue = {}
	local len = #char_units - 4 + 1
	local start_row,start_col = char_units[1]:getOrgRowAndCol()
	for i = 1,len do
		local row1,col1 = char_units[i]:getOrgRowAndCol()
		local row2,col2 = char_units[i+1]:getOrgRowAndCol()
		local row3,col3 = char_units[i+2]:getOrgRowAndCol()
		local row4,col4 = char_units[i+3]:getOrgRowAndCol()
		if ( col2 == col1 + 1 and col3 == col1 + 2 and col4 == col1 + 3 ) then
			table.insert( continue,i )
		end
	end
	if #continue == 0 then
		return false
	end


	-- 3:判断是否组成成语
	for i,v in ipairs( continue ) do
		local result_str = ""
		result_str = result_str..char_units[v]:getChar()..","
		result_str = result_str..char_units[v+1]:getChar()..","
		result_str = result_str..char_units[v+2]:getChar()..","
		result_str = result_str..char_units[v+3]:getChar()

		local row1,col1 = char_units[v]:getOrgRowAndCol()
		local row2,col2 = char_units[v+1]:getOrgRowAndCol()
		local row3,col3 = char_units[v+2]:getOrgRowAndCol()
		local row4,col4 = char_units[v+3]:getOrgRowAndCol()

		for a,b in ipairs( self._questData ) do
			if b == result_str then
				local pass_data = {}
				pass_data[1] = { row = row1,col = col1 }
				pass_data[2] = { row = row2,col = col2 }
				pass_data[3] = { row = row3,col = col3 }
				pass_data[4] = { row = row4,col = col4 }
				return true,pass_data
			end
		end
	end
	
	return false
end

-- 判断该位置有没有char_unit
function GamePlay:checkHasCharUnitByPos( row,col )
	for i,v in ipairs( self._charUnitList ) do
		local char_row,char_col = v:getOrgRowAndCol()
		if char_row == row and char_col == col then
			return false
		end
	end
	return true
end

-- 检查是否通关
function GamePlay:checkIsPassLevel()
	return self._passCount >= #self._questData
end


-- 当前题目过关的动画
function GamePlay:passQuestAction( passData )
	assert( passData," !! passData is nil !! " )
	for i,v in ipairs( passData ) do
		for a,b in ipairs( self._charUnitList ) do
			if (not b:getIsPass()) then
				local char_row,char_col = b:getOrgRowAndCol()
				if char_row == v.row and char_col == v.col then
					-- 设置通过状态
					b:setPassDone()
					b:changeTextColor()
				end
			end
		end
	end
	-- 积分飘动的动画
	self:addScoreAction( passData[2].row,passData[2].col )

	-- 播放音效
	audio.playSound("cyjlmp3/cy.mp3", false)

	-- 显示积分
	local level = G_GetModel("Model_ChengYuJieLong"):getLevel()
	local add_score = level * 10
	local score = G_GetModel("Model_ChengYuJieLong"):getScore()
	self.TextScore:setString( score + add_score )

	-- 检查是否通过关卡
	if self:checkIsPassLevel() then
		self:unSchedule()
		-- 通关
		-- 1:存储分数
		local chengyu_score = level * 10 * #self._questData
		local time_score = math.ceil( self._passLevelTime ) * 4
		local score = chengyu_score + time_score
		G_GetModel("Model_ChengYuJieLong"):addScore( score )

		local now_score = G_GetModel("Model_ChengYuJieLong"):getScore()
		self.TextScore:setString( now_score )

		performWithDelay( self,function()
			-- 2:打开结果页面
			if level >= G_GetModel("Model_ChengYuJieLong"):getMaxLevel() then
				-- 存储记录
				G_GetModel("Model_ChengYuJieLong"):saveRecordList()
				-- 打开界面
				addUIToScene( UIDefine.CHENGYUJIELONG_KEY.PassAll_UI )
			else
				local data = { 
					chengyu_score = chengyu_score,
					time_score = time_score,
					score = score,
					parent = self
				}
				addUIToScene( UIDefine.CHENGYUJIELONG_KEY.PassQuest_UI,data )
			end
		end,1 )
	end
end

-- 获得积分的动画
function GamePlay:addScoreAction( row,col )
	assert( row," !! row is nil !! " )
	assert( col," !! col is nil !! " )
	local level = G_GetModel("Model_ChengYuJieLong"):getLevel()
	local chengyu_score = level * 10
	local label = ccui.TextBMFont:create( "+"..chengyu_score,"image/game/cydfshuzi.fnt" )
	local pos_x,pos_y = 0,0 
	local ge_zi_pos = cc.p( self._bgGeZiList[row][col]:getPosition() )
	pos_x = ge_zi_pos.x + 30
	pos_y = ge_zi_pos.y + 30
	self.BgContent:addChild( label )
	label:setPosition( pos_x,pos_y )

	local move_by = cc.MoveBy:create( 1,cc.p( 0,50 ) )
	local remove = cc.RemoveSelf:create()
	local seq = cc.Sequence:create({ move_by,remove })
	label:runAction( seq )
end

-- 清楚charNode
function GamePlay:clearCharNode()
	if self._charUnitList then
		for i,char_node in ipairs( self._charUnitList ) do
			char_node:removeFromParent()
		end
	end
end

-- 获得unit要摆放的随机位置
function GamePlay:getRandomGeZiPosition()
	while true do
		local row = random( 1,12 )
		local col = random( 1,8 )
		local has = self:hasGeZiPosition( row,col )
		if not has then
			table.insert( self._geZiPosition,{ row = row,col = col } )
			return row,col
		end
	end
end

-- 检查当前格子是否已经被占用
function GamePlay:hasGeZiPosition( row,col )
	for i,v in ipairs( self._geZiPosition ) do
		if v.row == row and v.col == col then
			return true
		end
	end
	return false
end



return GamePlay















