

local PokerNode = import(".PokerNode")
local GamePlay = class("GamePlay",BaseLayer)


function GamePlay:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePlay.super.ctor( self,param.name )
    self:addCsb( "csbtwentyfour/LayerGamePlay.csb" )
    self._param = param
    -- 返回
    self:addNodeClick( self.ButtonBack,{ 
        endCallBack = function() self:back() end
    })
    -- 刷新
    self:addNodeClick( self.ButtonRefresh,{ 
        endCallBack = function() self:refresh() end,
        voicePath = "tfmp3/reset.mp3"
    })
    -- +
    self:addNodeClick( self.ButtonAdd,{ 
        endCallBack = function() self:add() end,
        voicePath = "tfmp3/card.mp3"
    })
    -- -
    self:addNodeClick( self.ButtonReduce,{ 
        endCallBack = function() self:reduce() end,
        voicePath = "tfmp3/card.mp3"
    })
    -- *
    self:addNodeClick( self.ButtonS,{ 
        endCallBack = function() self:sheng() end,
        voicePath = "tfmp3/card.mp3"
    })
    -- /
    self:addNodeClick( self.ButtonC,{ 
        endCallBack = function() self:chu() end,
        voicePath = "tfmp3/card.mp3"
    })
    -- poker
    for i = 1,4 do
    	self:addNodeClick( self["Poker"..i],{ 
	        endCallBack = function() self:clickPoker( i ) end,
	        voicePath = "tfmp3/card.mp3"
	    })
    end
    self:loadUiData( self._param.data.level,self._param.data.index )
end

function GamePlay:onEnter()
    GamePlay.super.onEnter( self )
    casecadeFadeInNode( self.MidPanel,0.5 )
end

function GamePlay:loadUiData( level,index )
	assert( level," !! level is nil !! ")
	assert( index," !! index is nil !! ")
	self._level = level
	self._index = index
	self.TextLevel:setString("level "..self._index)
	self.TextGrade:setString("( "..tf_lang_config[self._level].." )")
	-- poker
	for i = 1,4 do
		local poker = self["Poker"..i]:getChildByTag(1111)
		if not poker then
			poker = PokerNode.new(self)
			self["Poker"..i]:addChild( poker )
			poker:setTag(1111)
		end
		local num = tf_quest_config[self._level][self._index][i]
		poker:loadUiData(num)
	end
	-- 初始化数据
	self._operation = 0
    self._selectPokerPanel = nil
    self._resultStr = ""
    self._isOver = nil
    self._isMove = nil
    self._calStep = nil
    self._tempPokerPanel = nil
    self._resultStr = ""
end

function GamePlay:back()
	if self._isOver or self._isMove then
		return
	end
	removeUIFromScene( UIDefine.TWENTYFOUR_KEY.Play_UI )
    addUIToScene( UIDefine.TWENTYFOUR_KEY.Level_UI )
end

function GamePlay:refresh()
	if self._isOver or self._isMove then
		return
	end
	local data = { level = self._level,index = self._index }
	removeUIFromScene( UIDefine.TWENTYFOUR_KEY.Play_UI )
    addUIToScene( UIDefine.TWENTYFOUR_KEY.Play_UI,data )
end

function GamePlay:add()
	if self._isOver or self._isMove then
		return
	end
	self:resetOperationButton()
	self.ButtonAdd:loadTexture("image/3/add_h.png",1)
	self._operation = 1
end

function GamePlay:reduce()
	if self._isOver or self._isMove then
		return
	end
	self:resetOperationButton()
	self.ButtonReduce:loadTexture("image/3/reduce_h.png",1)
	self._operation = 2
end

function GamePlay:sheng()
	if self._isOver or self._isMove then
		return
	end
	self:resetOperationButton()
	self.ButtonS:loadTexture("image/3/x_h.png",1)
	self._operation = 3
end

function GamePlay:chu()
	if self._isOver or self._isMove then
		return
	end
	self:resetOperationButton()
	self.ButtonC:loadTexture("image/3/c_h.png",1)
	self._operation = 4
end

function GamePlay:clickPoker( index )
	if self._isOver or self._isMove then
		return
	end
	local target_panel = self["Poker"..index]
	local poker = target_panel:getChildByTag(1111)
	assert( poker," !! poker is nil !! ")
	-- 清除选中
	for i = 1,4 do
		local poker_one = self["Poker"..i]:getChildByTag(1111)
		poker_one:setSelectBg( false )
		self["Poker"..i]:setLocalZOrder(1)
	end
	-- 选中
	if not self._selectPokerPanel then
		poker:setSelectBg( true )
		target_panel:setLocalZOrder(10)
		self._selectPokerPanel = target_panel
		return
	end
	-- 改变选中
	if self._operation == 0 then
		poker:setSelectBg( true )
		target_panel:setLocalZOrder(10)
		self._selectPokerPanel = target_panel
		return
	end
	-- 操作
	-- select移动
	local select_poker = self._selectPokerPanel:getChildByTag(1111)
	assert( select_poker," !! select_poker is nil !! ")
	select_poker:setSelectBg( true )
	self._isMove = true
	local move_to = cc.MoveTo:create(0.5,cc.p(target_panel:getPosition()))
	local hide_call = cc.CallFunc:create(function()
		target_panel:setVisible(false)
		self._isMove = nil
		-- 播放音效
		audio.playSound("tfmp3/combine.mp3", false)
		-- 计算结果
		self:calResult( target_panel )
	end)
	local seq = cc.Sequence:create({ move_to,hide_call })
	self._selectPokerPanel:runAction(seq)
end

function GamePlay:resetOperationButton()
	self.ButtonAdd:loadTexture("image/3/add.png",1)
	self.ButtonReduce:loadTexture("image/3/reduce.png",1)
	self.ButtonS:loadTexture("image/3/x.png",1)
	self.ButtonC:loadTexture("image/3/c.png",1)
end

function GamePlay:calResult( targetPanel )
	if (not self._selectPokerPanel) or (not targetPanel) then
		return
	end
	local select_poker = self._selectPokerPanel:getChildByTag(1111)
	assert( select_poker," !! select_poker is nil !! ")
	local target_poker = targetPanel:getChildByTag(1111)
	assert( target_poker," !! target_poker is nil !! ")
	assert( self._operation > 0, " !! operation is error !! ")

	local num_str,is_int,total_fenzi,total_fenmu = self:calNumWithFloat(select_poker,target_poker,self._operation)
	-- 设置显示
	select_poker:setNumStr( num_str )
	select_poker:setFenZi( total_fenzi )
	select_poker:setFenMu( total_fenmu )

	-- 计算操作步骤的字符串
	self:calResultStr(targetPanel)

	-- 清空操作符的选中
	self._operation = 0
	self:resetOperationButton()

	-- 查看还剩几个panel 决定是否结束游戏
	local left = 0
	for i = 1,4 do
		if self["Poker"..i]:isVisible() then
			left = left + 1
		end
	end
	-- 结束
	if left == 1 then
		self._isOver = true
		local result_str = self._resultStr
		self._resultStr = ""
		if is_int and tonumber(num_str) == 24 then
			-- 存储游戏进程数据
			self:saveGamePlayData()
			-- 进入结果页
			self:showWinResult(result_str)
		else
    		-- 进入结果页
			self:showFailedResult(num_str)
		end
	end
end

function GamePlay:saveGamePlayData()
	local cur_level,cur_point = G_GetModel("Model_TwentyFour"):getLevelAndPoint()
	local save_level = self._param.data.level
	local save_point = self._param.data.index
	local need_save = false
	if save_level == cur_level and save_point == cur_point + 1 then
		need_save = true
		if save_point == 20 then
			save_level = save_level + 1
			if save_level > #tf_quest_config then
				save_level = #tf_quest_config
			else
				save_point = 0
			end
		end
	end
	if need_save then
		G_GetModel("Model_TwentyFour"):setLevelAndPoint(save_level,save_point)
	end
end

function GamePlay:calResultStr( targetPanel )
	local target_poker = targetPanel:getChildByTag(1111)
	local num2 = target_poker:getOrgNum()
	local select_poker = self._selectPokerPanel:getChildByTag(1111)
	local num1 = select_poker:getOrgNum()
	if self._resultStr == "" then
		-- 第一步
		if self._operation == 1 then
			self._resultStr = num1.."+"..num2
		elseif self._operation == 2 then
			self._resultStr = num1.."-"..num2
		elseif self._operation == 3 then
			self._resultStr = num1.."*"..num2
		elseif self._operation == 4 then
			self._resultStr = num1.."/"..num2
		end
		self._calStep = 1
		self._tempPokerPanel = self._selectPokerPanel
	else
		if self._calStep == 1 then
			-- 第二步
			if self._tempPokerPanel == self._selectPokerPanel or self._tempPokerPanel == targetPanel then
				local cc_num = nil
				if self._tempPokerPanel == self._selectPokerPanel then
					cc_num = num2
				else
					cc_num = num1
				end
				if self._operation == 1 then
					self._resultStr = self._resultStr.."+"..cc_num
				elseif self._operation == 2 then
					self._resultStr = self._resultStr.."-"..cc_num
				elseif self._operation == 3 then
					if (string.find(self._resultStr,"+") or string.find(self._resultStr,"-")) 
						and ( not string.find(self._resultStr,")") ) then
						self._resultStr = "("..self._resultStr..")".."*"..cc_num
					else
						self._resultStr = self._resultStr.."*"..cc_num
					end
				elseif self._operation == 4 then
					if (string.find(self._resultStr,"+") or string.find(self._resultStr,"-")) and ( not string.find(self._resultStr,")")) then
						self._resultStr = "("..self._resultStr..")".."/"..cc_num
					else
						self._resultStr = self._resultStr.."/"..cc_num
					end
				end
			else
				local select_poker = self._selectPokerPanel:getChildByTag(1111)
				local num1 = select_poker:getOrgNum()
				if self._operation == 1 then
					self._resultStr1 = num1.."+"..num2
				elseif self._operation == 2 then
					self._resultStr1 = num1.."-"..num2
				elseif self._operation == 3 then
					self._resultStr1 = num1.."*"..num2
				elseif self._operation == 4 then
					self._resultStr1 = num1.."/"..num2
				end
				self._resultStr1 = "("..self._resultStr1..")"
			end
			self._calStep = 2
			self._tempPokerPanel = self._selectPokerPanel
		elseif self._calStep == 2 then
			-- 第三步
			if self._resultStr1 and self._resultStr1 ~= "" then
				if self._operation == 1 then
					self._resultStr = self._resultStr.."+"..self._resultStr1
				elseif self._operation == 2 then
					self._resultStr = self._resultStr.."-"..self._resultStr1
				elseif self._operation == 3 then
					self._resultStr = "("..self._resultStr..")".."*"..self._resultStr1
				elseif self._operation == 4 then
					self._resultStr = "("..self._resultStr..")".."/"..self._resultStr1
				end
			else
				local cc_num = nil
				if self._tempPokerPanel == self._selectPokerPanel then
					cc_num = num2
				else
					cc_num = num1
				end
				if self._operation == 1 then
					self._resultStr = self._resultStr.."+"..cc_num
				elseif self._operation == 2 then
					self._resultStr = self._resultStr.."-"..cc_num
				elseif self._operation == 3 then
					if (string.find(self._resultStr,"+") or string.find(self._resultStr,"-")) 
						and ( not string.find(self._resultStr,")") ) then
						self._resultStr = "("..self._resultStr..")".."*"..cc_num
					else
						self._resultStr = self._resultStr.."*"..cc_num
					end
				elseif self._operation == 4 then
					if (string.find(self._resultStr,"+") or string.find(self._resultStr,"-")) and ( not string.find(self._resultStr,")")) then
						self._resultStr = "("..self._resultStr..")".."/"..cc_num
					else
						self._resultStr = self._resultStr.."/"..cc_num
					end
				end
			end
		end
	end
end

function GamePlay:showWinResult( resultStr )
	local last_poker = 0
	for i = 1,4 do
		if self["Poker"..i]:isVisible() then
			last_poker = self["Poker"..i]
			break
		end
	end
	-- 动画
	local move_to = cc.MoveTo:create(0.5,cc.p(display.cx,838))
	local call_change = cc.CallFunc:create( function()
		local sp1 = ccui.ImageView:create("image/3/24.png",0)
		last_poker:addChild(sp1)
		local size = last_poker:getContentSize()
		sp1:setPosition( size.width / 2,size.height / 2 )
		local sp2 = ccui.ImageView:create("image/3/24_light.png",0)
		last_poker:addChild(sp2)
		local size = last_poker:getContentSize()
		sp2:setPosition( size.width / 2,size.height / 2 )
	end )
	local delay = cc.DelayTime:create(1)
	local call_back = cc.CallFunc:create( function()
		-- 播放音效
		audio.playSound("tfmp3/success.mp3", false)
		local data = { 
			level = self._param.data.level,
			index = self._param.data.index,
			resultStr = resultStr
		}
		removeUIFromScene( UIDefine.TWENTYFOUR_KEY.Play_UI )
		addUIToScene( UIDefine.TWENTYFOUR_KEY.Win_UI,data )
	end )
	-- 进入结果页
	local seq = cc.Sequence:create({move_to,call_change,delay,call_back})
	last_poker:runAction( seq )
end

function GamePlay:showFailedResult( numStr )
	local last_poker = 0
	for i = 1,4 do
		if self["Poker"..i]:isVisible() then
			last_poker = self["Poker"..i]
			break
		end
	end
	-- 动画
	local move_to = cc.MoveTo:create(0.5,cc.p(355,667))
	local call_change = cc.CallFunc:create( function()
		
	end )
	local delay = cc.DelayTime:create(1)
	local call_back = cc.CallFunc:create( function()
		-- 播放音效
		audio.playSound("tfmp3/wrong.mp3", false)
		local data = { 
			level = self._param.data.level,
			index = self._param.data.index,
			num = numStr
		}
		removeUIFromScene( UIDefine.TWENTYFOUR_KEY.Play_UI )
		addUIToScene( UIDefine.TWENTYFOUR_KEY.Failed_UI,data )
	end )
	-- 进入结果页
	local seq = cc.Sequence:create({move_to,call_change,delay,call_back})
	last_poker:runAction( seq )
end

function GamePlay:calNumWithFloat( selectPoker,targetPoker,operation )
	assert( selectPoker," !! selectPoker is nil !! " )
	assert( targetPoker," !! targetPoker is nil !! ")
	local num_str = ""
	local is_int = false
	local total_fenmu = 0
	local total_fenzi = 0
	if operation == 1 then
		-- "+"
		if selectPoker:getFenMu() == 1 and targetPoker:getFenMu() == 1 then
			local num = selectPoker:getFenZi() + targetPoker:getFenZi()
			total_fenmu = 1
			total_fenzi = num
		else
			local sel_fenmu = selectPoker:getFenMu()
			local tar_fenmu = targetPoker:getFenMu()
			total_fenmu = sel_fenmu * tar_fenmu
			local sel_fenzi = selectPoker:getFenZi() * tar_fenmu
			local tar_fenzi = targetPoker:getFenZi() * sel_fenmu
			total_fenzi = sel_fenzi + tar_fenzi
		end
	elseif operation == 2 then
		if selectPoker:getFenMu() == 1 and targetPoker:getFenMu() == 1 then
			local num = selectPoker:getFenZi() - targetPoker:getFenZi()
			total_fenmu = 1
			total_fenzi = num
		else
			local sel_fenmu = selectPoker:getFenMu()
			local tar_fenmu = targetPoker:getFenMu()
			total_fenmu = sel_fenmu * tar_fenmu
			local sel_fenzi = selectPoker:getFenZi() * tar_fenmu
			local tar_fenzi = targetPoker:getFenZi() * sel_fenmu
			total_fenzi = sel_fenzi - tar_fenzi
		end
	elseif operation == 3 then
		if selectPoker:getFenMu() == 1 and targetPoker:getFenMu() == 1 then
			local num = selectPoker:getFenZi() * targetPoker:getFenZi()
			total_fenmu = 1
			total_fenzi = num
		else
			local sel_fenmu = selectPoker:getFenMu()
			local tar_fenmu = targetPoker:getFenMu()
			total_fenmu = sel_fenmu * tar_fenmu
			local sel_fenzi = selectPoker:getFenZi()
			local tar_fenzi = targetPoker:getFenZi()
			total_fenzi = sel_fenzi * tar_fenzi
		end
	elseif operation == 4 then
		if selectPoker:getFenMu() == 1 and targetPoker:getFenMu() == 1 then
			if selectPoker:getFenZi() % targetPoker:getFenZi() == 0 then
				local num = selectPoker:getFenZi() / targetPoker:getFenZi()
				total_fenmu = 1
				total_fenzi = num
			else
				total_fenzi = selectPoker:getFenZi()
				total_fenmu = targetPoker:getFenZi()
			end
		else
			local sel_fenmu = selectPoker:getFenMu()
			local tar_fenmu = targetPoker:getFenMu()
			local sel_fenzi = selectPoker:getFenZi()
			local tar_fenzi = targetPoker:getFenZi()
			total_fenmu = sel_fenmu * tar_fenzi
			total_fenzi = sel_fenzi * tar_fenmu
		end
	end

	-- 显示
	if total_fenzi % total_fenmu == 0 then
		num_str = tostring(total_fenzi / total_fenmu)
		is_int = true
	else
		num_str = tostring(total_fenzi).."/"..tostring(total_fenmu)
		is_int = false
	end
	return num_str,is_int,total_fenzi,total_fenmu
end

return GamePlay