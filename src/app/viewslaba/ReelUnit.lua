

local SymbolUnit = import(".SymbolUnit")

local ReelUnit = class("ReelUnit",BaseNode)


-- 运动状态 --
ReelUnit.RollStatus = 
{
	RollStatus_Idle  		= 0,	-- 静止状态  --
	RollStatus_JumpUp 		= 1,	-- 起跳		--
	RollStatus_SpeedUp  	= 2,	-- 加速		--
	RollStatus_MoveUniform 	= 3,	-- 匀速移动	--
	RollStatus_SlowDown		= 4,	-- 减速		--
	RollStatus_JumpDown		= 5,	-- 回弹		--
}




function ReelUnit:ctor( param,reelTndex )
	assert( param," !! param is nil  !! " )
	self._reelConfig 		= param
	self._symbolIdPointer 	= 1    										-- 当前数据的索引 (位置最低的那个symbol)
	self._symbolList 		= {}   										-- 存放信号块列表
	
	self._symbolSize 		= cc.size( param.width,param.height )		-- 单个单元格的大小	
	self._curSpeed 			= 0	   										-- 当前速度	
	self._maxSpeed          = param.speed 								-- 最大速度
	self._topSymbolUnit		= nil  										-- 处于最高位置的信号块
	self._status 			= self.RollStatus.RollStatus_Idle			-- 初始状态
	

	self._destUnitNode      = nil 										-- 目标node用于停止
	self._destPosY			= 0											-- 目标node的停止位置


	-- 设置reel的数据源
	self._symbolData        = {}
	for i = 1,30 do
		table.insert( self._symbolData,random(1,9) )
	end	
	self._orgSymbolData     = clone( self._symbolData )					-- 原始的信号数据

	self._symbolViewCount  	= self._reelConfig.view_count													 		 -- 当前reel显示几个单元格
	self._symbolTotalCount 	= self._symbolViewCount + 2														 		 -- 需要创建的单元格
	self._size 			 	= cc.size( self._symbolSize.width,self._symbolSize.height * self._symbolViewCount ) 	 -- 裁剪区域的尺寸
	self._bottomPosY		= -self._symbolSize.height * 2
	self._topY 				= self._symbolSize.height * self._symbolViewCount
	-- 设置数据指针(默认指向已经创建的数据位置)
	self._symbolIdPointer   = self._symbolTotalCount

	self._symbolStartPosY = {}	

	self._reelTndex = reelTndex

	-- 初始化裁剪区域
	self:addClipNode()
	-- 初始化信号块
	self:initSymbol()
end


-- 初始化裁剪区域
function ReelUnit:addClipNode()
	-- 添加裁剪node
	if self._clippingNode == nil then
		self._clippingNode = cc.ClippingRectangleNode:create()
		self:addChild( self._clippingNode )
	end
	self._clippingNode:setClippingRegion(cc.rect(0,0,self._size.width,self._size.height))
end

-- 添加信号块
function ReelUnit:initSymbol()
	for i = 1,self._symbolTotalCount do
		local posy = self._bottomPosY + i * self._symbolSize.height
		self:createSymbolUnit( self._symbolData[i],posy )
		-- 存储位置 用于校正
		table.insert( self._symbolStartPosY,posy )
	end

	-- 初始化信号的下一个指针
	for i,v in ipairs( self._symbolList ) do
		if i == #self._symbolList then
			v:setNextSymbolUnit( self._symbolList[1] )
		else
			v:setNextSymbolUnit( self._symbolList[i + 1] )
		end
	end
end

function ReelUnit:createSymbolUnit( symbolId,posY )
	assert( symbolId," !! symbolId is nil !! ")
	assert( posY," !! posY is nil !! " )
	local symbol = SymbolUnit.new( cc.size(self._symbolSize.width,self._symbolSize.height) )
	symbol:loadUIdata( symbolId )
	self._clippingNode:addChild( symbol )
	symbol:setPositionY( posY )
	table.insert( self._symbolList,symbol )
end


function ReelUnit:canRoll()
	-- 只有静止状态 才能滚动
	return self._status == self.RollStatus.RollStatus_Idle
end



-- ################################ 外部接口调用 ################################
-- 开启滚动
function ReelUnit:startRoll()
	if self._status ~= self.RollStatus.RollStatus_Idle then
		return
	end
	-- 重置数据
	self._symbolData = self._orgSymbolData
	-- 设置状态(起跳)
	self:setRollStatus( self.RollStatus.RollStatus_JumpUp )
	-- 开启帧调用
	self:onUpdate( function( dt ) 
		-- 更新运动状态 --
		self:updataMotionStatus(dt)
		-- 更新信号块位置 --
		self:updataSymbolUnit(dt)
	end)	
end
-- 停止滚动
function ReelUnit:stopRoll( destData )
	-- 1:如果是静止状态
	if self._status == self.RollStatus.RollStatus_Idle then
		return
	end
	-- 2:没有数据
	if not destData then
		assert( false,"liuyang 数据格式错误:需要的数据个数为: 没有传入数据")
		return
	end
	-- 3:数据格式错误
	if #destData ~= self._symbolViewCount then
		assert( false,"liuyang 数据格式错误:需要的数据个数为:"..self._symbolViewCount.." 当前传入的数据为:"..(#destData))
		return
	end

	-- 设置状态(减速)
	self:setRollStatus( self.RollStatus.RollStatus_SlowDown )

	-- 更换数据
	local result = clone( self._symbolData )
	-- 算出要修改的数据的索引
	local change_index = {}
	for i,v in ipairs( destData ) do
		local index = self._symbolIdPointer + (i - 1)
		if index > #self._symbolData then
			index = self._symbolIdPointer + (i - 1) - #self._symbolData
		end
		table.insert( change_index,index )
	end
	for i,v in ipairs( change_index ) do
		result[change_index[i]] = destData[i]
	end
	-- 更换显示数据
	self._symbolData = result

	-- 设置停止滚动的目标信号node
	self._destUnitNode = self._topSymbolUnit
	self._destUnitNode:loadUIdata( result[change_index[1]] )
end
-- ###########################################################################





-- ################################ dt 运动状态相关 ###########################

function ReelUnit:updataMotionStatus( dt )
	if self._status == ReelUnit.RollStatus.RollStatus_Idle then
		-- body
	elseif self._status == ReelUnit.RollStatus.RollStatus_JumpUp then

	elseif self._status == ReelUnit.RollStatus.RollStatus_SpeedUp then
		-- 加速
		self:speedUpAction( dt )
	elseif self._status == ReelUnit.RollStatus.RollStatus_MoveUniform then
		-- 匀速
	elseif self._status == ReelUnit.RollStatus.RollStatus_SlowDown then
		-- 减速
		self:slowDownAction( dt )
	elseif self._status == ReelUnit.RollStatus.RollStatus_JumpDown then

	end
end

-- 设置运动状态 --
function ReelUnit:setRollStatus( newStatus )
	if self._status == newStatus then
		return
	end
	-- 开启下一状态回调 --
	self._status = newStatus
	self:startMotionStatus( self._status )
end

-- 开启下一运动状态 
function ReelUnit:startMotionStatus( newStatus )
	if newStatus == ReelUnit.RollStatus.RollStatus_Idle then
		-- body
	elseif newStatus == ReelUnit.RollStatus.RollStatus_JumpUp then
		-- 执行起跳动作
		self:startJumpAction()
	elseif newStatus == ReelUnit.RollStatus.RollStatus_SpeedUp then
		-- 执行加速动作
	elseif newStatus == ReelUnit.RollStatus.RollStatus_MoveUniform then
		-- 匀速动作
	elseif newStatus == ReelUnit.RollStatus.RollStatus_SlowDown then
		-- 执行减速动作
	elseif newStatus == ReelUnit.RollStatus.RollStatus_JumpDown then
		-- 执行回弹动作
		self:jumpDownAction()
	end
end


-- 起跳的动作
function ReelUnit:startJumpAction()
	if self._reelTndex == 1 then
		for i,v in ipairs( self._symbolList ) do
			local move_by1 = cc.MoveBy:create( self._reelConfig.jump_up_time,cc.p(0,self._reelConfig.jump_up_dis) )
			local sine_out = cc.EaseSineOut:create(move_by1)
			local jump_end = cc.CallFunc:create( function()
				-- 起跳结束
				if i == #self._symbolList then
					-- 设置为加速状态
					self:setRollStatus( ReelUnit.RollStatus.RollStatus_SpeedUp )
				end
			end )
			local seq = cc.Sequence:create({sine_out,jump_end})
			v:runAction( seq )
		end
	else
		self:setRollStatus( ReelUnit.RollStatus.RollStatus_SpeedUp )
	end
end

-- 加速动作
function ReelUnit:speedUpAction( dt )
	self._curSpeed = self._curSpeed + self._reelConfig.acc_speed
	if self._curSpeed > self._maxSpeed then
		self._curSpeed = self._maxSpeed
		-- 设置为匀速状态
		self:setRollStatus( ReelUnit.RollStatus.RollStatus_MoveUniform )
	end
end

-- 减速动作
function ReelUnit:slowDownAction( dt )
	if self._curSpeed <= 100 then
		self._curSpeed = 100
	else
		-- self._curSpeed = self._curSpeed - 10
	end
end

-- 回弹动作
function ReelUnit:jumpDownAction()
	if self._destUnitNode then
		self:redRessPosY()
	  	local pos_y = self._destUnitNode:getPositionY()
	  	for i,v in ipairs( self._symbolList ) do
			local call_state = cc.CallFunc:create( function()
			  	if i == #self._symbolList then
			  		EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_LABA_REEL_ROOL_DOWN )
					self:clearState()
			  	end
			end )
			local move_by1 = cc.MoveBy:create( self._reelConfig.jump_down_time_up,cc.p(0,10) )
			local sine_out1 = cc.EaseSineOut:create( move_by1 )
			local move_by2 = cc.MoveBy:create( self._reelConfig.jump_down_time_down,cc.p(0,-10) )
			local sine_out2 = cc.EaseSineIn:create( move_by2 )
			local seq = cc.Sequence:create({ sine_out1,sine_out2,call_state })
			v:runAction( seq )
	  	end
	end
end

-- 滚动结束 清理数据状态 --
function ReelUnit:clearState()
	-- 设置为静止状态
	self:setRollStatus( ReelUnit.RollStatus.RollStatus_Idle )
	-- 关闭定时器
	self:unscheduleUpdate()
	-- 清空目标的node
	self._destUnitNode = nil
	-- 清空目标node的位置
	self._destPosY = 0
	-- 清空速度
	self._curSpeed = 0
end
-- ###########################################################################


-- ################################ dt 信号滚动相关 ################################
function ReelUnit:updataSymbolUnit( dt )
	-- 静止 起跳 回弹三种状态不处理 (目前采用的cocos action动作处理)
	if self._status == ReelUnit.RollStatus.RollStatus_Idle or
		self._status == ReelUnit.RollStatus.RollStatus_JumpUp or 
		self._status == ReelUnit.RollStatus.RollStatus_JumpDown then
		return
	end

	-- 设置位置
	for i,v in ipairs( self._symbolList ) do
		local posy = v:getPositionY()
		posy = posy - laba_config.reel_config.speed
		v:setPositionY( posy )
	end
	-- 重置数据指针
	for i,v in ipairs( self._symbolList ) do
		-- 当前symbol的最低位置
		local posy = v:getPositionY()
		if posy <= self._bottomPosY then
			-- 移动到最高位置
			v:setPositionY( self._topY )
			-- 设置最高位置的信号块
			self._topSymbolUnit = v
			-- 重置数据指针
			self._symbolIdPointer = self._symbolIdPointer + 1
			if self._symbolIdPointer > #self._symbolData then
				self._symbolIdPointer = 1
			end
			-- 重置显示的数据
			v:loadUIdata( self._symbolData[self._symbolIdPointer] )
			break
		end
	end

	-- 检查是否有停止滚动的命令
	if self._destUnitNode then
		if self._destUnitNode:getPositionY() <= self._destPosY then
			-- 设置为回弹状态
	      	self:setRollStatus( ReelUnit.RollStatus.RollStatus_JumpDown )
		end
	end
end

-- ###########################################################################


-- 校正位置
function ReelUnit:redRessPosY()
	
	self._destUnitNode:setPositionY( self._symbolStartPosY[2] )

	local next_symbol = self._destUnitNode:getNextSymbolUnit()
	next_symbol:setPositionY( self._symbolStartPosY[3] )

	next_symbol = next_symbol:getNextSymbolUnit()
	next_symbol:setPositionY( self._symbolStartPosY[4] )

	next_symbol = next_symbol:getNextSymbolUnit()
	next_symbol:setPositionY( self._symbolStartPosY[5] )

	next_symbol = next_symbol:getNextSymbolUnit()
	next_symbol:setPositionY( self._symbolStartPosY[1] )
end


return ReelUnit