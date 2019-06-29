
local PokerNode = import(".PokerNode")
local GamePlayAdvanced = class("GamePlayAdvanced",BaseLayer)


function GamePlayAdvanced:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePlayAdvanced.super.ctor( self,param.name )
    self:addCsb( "csbtwentyfour/LayerGamePlay1.csb" )
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
    -- 换题
    self:addNodeClick( self.ButtonChange,{ 
        endCallBack = function() self:change() end,
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
    
    self._orgPokerPos = {}
    for i = 1,4 do
    	self._orgPokerPos[i] = cc.p( self["Poker"..i]:getPosition() )
    end

    self._press = 1
    self._maxPress = 10

    self._maxLevel = #tf_quest_config
    self._maxIndex = 20
    -- self._maxLevel = 1
    -- self._maxIndex = 1

    self._refreshTimes = 3
    -- 刷新题目
    self._level = random(1,self._maxLevel)
    self._index = random(1,self._maxIndex)
    self:loadUiData( self._level,self._index )
end


function GamePlayAdvanced:onEnter()
    GamePlayAdvanced.super.onEnter( self )
    casecadeFadeInNode( self.MidPanel,0.5 )
end

function GamePlayAdvanced:loadUiData( level,index )
	self:loadPokerData()
    -- 计时
    self._time = 0
    local str = formatMinuTimeStr( self._time,":" )
    self.TextTime:setString(str)
    self:schedule( function()
        self._time = self._time + 1
        local str = formatMinuTimeStr( self._time,":" )
        self.TextTime:setString(str)
    end,1 )
    -- 当前关卡数
    self.TextPress:setString( self._press.."/10" )
  	-- 当前可以刷新的次数
  	self.TextChangeTimes:setString( self._refreshTimes )
end

function GamePlayAdvanced:loadPokerData()
	-- poker
	for i = 1,4 do
		self["Poker"..i]:setVisible( true )
		self["Poker"..i]:setPosition(self._orgPokerPos[i])
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

    self.ImageNeed:setVisible( false )
end

function GamePlayAdvanced:nextQuest()
	self._level = random(1,self._maxLevel)
    self._index = random(1,self._maxIndex)
    self:loadPokerData()
    -- 当前关卡数
    self.TextPress:setString( self._press.."/10" )
end

function GamePlayAdvanced:back()
	if self._isOver or self._isMove then
		return
	end
	removeUIFromScene( UIDefine.TWENTYFOUR_KEY.Play_Advanced_UI )
    addUIToScene( UIDefine.TWENTYFOUR_KEY.Advanced_UI )
end

function GamePlayAdvanced:refresh()
	if self._isOver or self._isMove then
		return
	end
    self:loadPokerData()
end

function GamePlayAdvanced:add()
	if self._isOver or self._isMove or not self._selectPokerPanel then
		return
	end
	self:resetOperationButton()
	self.ButtonAdd:loadTexture("image/3/add_h.png",1)
	self._operation = 1
end

function GamePlayAdvanced:reduce()
	if self._isOver or self._isMove or not self._selectPokerPanel then
		return
	end
	self:resetOperationButton()
	self.ButtonReduce:loadTexture("image/3/reduce_h.png",1)
	self._operation = 2
end

function GamePlayAdvanced:sheng()
	if self._isOver or self._isMove or not self._selectPokerPanel then
		return
	end
	self:resetOperationButton()
	self.ButtonS:loadTexture("image/3/x_h.png",1)
	self._operation = 3
end

function GamePlayAdvanced:chu()
	if self._isOver or self._isMove or not self._selectPokerPanel then
		return
	end
	self:resetOperationButton()
	self.ButtonC:loadTexture("image/3/c_h.png",1)
	self._operation = 4
end

function GamePlayAdvanced:change()
	if self._refreshTimes <= 0 then
		return
	end
	self._refreshTimes = self._refreshTimes - 1 
	self._level = random(1,self._maxLevel)
    self._index = random(1,self._maxIndex)
    self:loadPokerData()
    self.TextChangeTimes:setString( self._refreshTimes )
end

function GamePlayAdvanced:clickPoker( index )
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

function GamePlayAdvanced:resetOperationButton()
	self.ButtonAdd:loadTexture("image/3/add.png",1)
	self.ButtonReduce:loadTexture("image/3/reduce.png",1)
	self.ButtonS:loadTexture("image/3/x.png",1)
	self.ButtonC:loadTexture("image/3/c.png",1)
end

function GamePlayAdvanced:calResult( targetPanel )
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
		if is_int and tonumber(num_str) == 24 then
			if self._press == self._maxPress then
				self._isOver = true
				-- 存储游戏进程数据
				local new_score = self:saveGamePlayData()
				-- 进入结果页
				local delay = cc.DelayTime:create(0.5)
				local call = cc.CallFunc:create( function()
					-- 播放音效
					audio.playSound("tfmp3/success.mp3", false)
					local data = { score = self._time,newScore = new_score }
					removeUIFromScene( UIDefine.TWENTYFOUR_KEY.Play_Advanced_UI )
	    			addUIToScene( UIDefine.TWENTYFOUR_KEY.Advanced_Result_UI,data )
				end )
				local seq = cc.Sequence:create({delay,call})
				self:runAction( seq )
			else
				self._press = self._press + 1
				-- 刷新下一题
				self:nextQuest()
			end
		else
			-- 播放音效
			local delay = cc.DelayTime:create(0.5)
			local call = cc.CallFunc:create( function()
				audio.playSound("tfmp3/wrong.mp3", false)
				self.ImageNeed:setVisible( true )
				self._selectPokerPanel:setVisible( false )
			end )
			local seq = cc.Sequence:create({delay,call})
			self:runAction( seq )
		end
	end
end

function GamePlayAdvanced:saveGamePlayData()
	if self._press ~= self._maxPress then
		return
	end
	local need_save = G_GetModel("Model_TwentyFour"):saveRecordList( self._time )
	return need_save
end

function GamePlayAdvanced:calNumWithFloat( selectPoker,targetPoker,operation )
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

return GamePlayAdvanced