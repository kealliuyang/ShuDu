
local Item = import(".Item")
local Coin = import(".Coin")
local GamePlay = class("GamePlay",BaseLayer)


function GamePlay:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer )

    GamePlay.super.ctor( self,param.name )
    self:addCsb( "csblaohuji/Game.csb" )

    -- 关闭
    self:addNodeClick( self.ButtonClose,{ 
        endCallBack = function() self:close() end
    })

    -- 押注
    self:addNodeClick( self.ButtonStart,{ 
        endCallBack = function() self:start() end,
        voicePath = "lhjmp3/spin_button.mp3"
    })

    -- 设置倍数
    for i = 1,8 do
    	self:addNodeClick( self["Button"..i],{ 
    		beganCallBack = function() self:clickRateBegan( i ) end,
	        endCallBack = function() self:clickRateEnd( i ) end,
	        touchOutside = true,
	        palyVoice = false
	    })
    end

    self.item_pos_start = cc.p( self.Image_pos1:getPosition() )
    self.Image_pos1:setVisible( false )
    self.BgYaZhong:setVisible( false )

    self._items = {}
    self._itemsPos = {}
    self.btn_config = nil
	self.item_config = nil
	self.rate_select = {0,0,0,0,0,0,0,0}
	self.result_index = nil
	self.last_random_index = nil

    self:loadUIData()
end


function GamePlay:loadUIData()
	local mode = G_GetModel("Model_LaoHuJi"):getGameType()
	local btn_config = nil
	local item_config = nil
	if mode == 1 then
		btn_config = lhj_fruits_btn_config
		item_config = lhj_fruits_item_config
	elseif mode == 2 then
		btn_config = lhj_animal_btn_config
		item_config = lhj_animal_item_config
	elseif mode == 3 then
		btn_config = lhj_seabed_btn_config
		item_config = lhj_seabed_item_config
	end

	self.btn_config = btn_config
	self.item_config = item_config


	-- 初始化button
	for i = 1,8 do
		self["Button"..i]:loadTexture( btn_config[i].img,1 )
		self["TextBtnBeiShu_"..i]:setString( "x"..btn_config[i].rate )
	end
	-- 初始化item
	for i = 1,22 do
		local item = Item.new()
		self.Bg:addChild( item )
		item:loadUIData( item_config[i] )
		local item_size = item:getDesignSize()
		local x_pos = self.item_pos_start.x + ( item_config[i].col - 1 ) * (item_size.width + 4)
		local y_pos = self.item_pos_start.y - ( item_config[i].row - 1 ) * (item_size.height + 4)
		item:setPosition( x_pos,y_pos)

		self._items[i] = item
		self._itemsPos[i] = cc.p( x_pos,y_pos )
	end
	-- 初始化金币
	local coin = G_GetModel("Model_LaoHuJi"):getCoin()
	self:loadHasCoinUiData( coin )
end


function GamePlay:onEnter()
	GamePlay.super.onEnter( self )
	local mode = G_GetModel("Model_LaoHuJi"):getGameType()
	if mode == 1 then
		self.Bg:setPositionY( display.height + 100 )
		local move_by = cc.MoveTo:create(0.4,cc.p(display.cx,display.cy))
		local ease_sinein = cc.EaseSineIn:create( move_by )
		self.Bg:runAction( ease_sinein )
	elseif mode == 2 then
		self.Bg:setPositionX( -display.width - 100 )
		local move_by = cc.MoveTo:create(0.4,cc.p(display.cx,display.cy))
		local ease_sinein = cc.EaseSineIn:create( move_by )
		self.Bg:runAction( ease_sinein )
	elseif mode == 3 then
		self.Bg:setPositionX( display.width + 100 )
		local move_by = cc.MoveTo:create(0.4,cc.p(display.cx,display.cy))
		local ease_sinein = cc.EaseSineIn:create( move_by )
		self.Bg:runAction( ease_sinein )
	end
end

function GamePlay:start()
	if self._turnAction then
		return
	end

	-- 是否还有金币
	local has_coin = G_GetModel("Model_LaoHuJi"):getCoin()
	if has_coin <= 0 then
		-- 破产
		addUIToScene( UIDefine.LAOHUJI_KEY.PoChan_UI )
		return
	end

	local cost_coin = G_GetModel("Model_LaoHuJi"):getCostCoin()
	local cost_total_coin = 0
	for i,v in ipairs( self.rate_select ) do
		cost_total_coin = cost_total_coin + v * cost_coin
	end
	-- 检查是否下注
	if cost_total_coin == 0 then
		G_ShowTips("请下注")
		return
	end

	if has_coin < cost_total_coin then
		-- 重置
		self:resetXiaZhu()
		G_ShowTips("金币不足")
		return
	end
	-- 扣除下注金币
	G_GetModel("Model_LaoHuJi"):saveCoin( has_coin - cost_total_coin )
	self:loadHasCoinUiData( has_coin - cost_total_coin )

	self.BgYaZhong:setVisible( false )
	self.BgLogo:setVisible( true )

	for i = 1,8 do
		self["Button"..i]:loadTexture(self.btn_config[i].unimg,1)
	end
	self.ButtonStart:loadTexture("image/game/start_un.png",1)

	self._turnAction = true
	local random_index = random(1,22)

	self.result_index = random_index

	if not self.last_random_index then
		self.last_random_index = 1
	end

	self:createLight()
	self._light:setPosition( self._itemsPos[self.last_random_index])

	-- 跑2圈 + 最终停止位置
	-- 构造跑马灯的序列
	local actions = {}

	local move_dis = 0
	if random_index >= self.last_random_index then
		move_dis = random_index - self.last_random_index
	else
		move_dis = 22 - ( self.last_random_index - random_index )
	end

	local total_run_nums = 2 * 22 + move_dis
	self.run_index = self.last_random_index

	-- local call_time1 = cc.CallFunc:create( function()
	-- 	self.temp_time1 = socket.gettime()
	-- end )
	-- table.insert( actions,call_time1 )

	-- 前5个加速
	for i = 1,5 do
		local delay_time = 0.5 - ( i - 1 ) * 0.1
		local delay = cc.DelayTime:create( delay_time )
		local call_back = self:createTurnCallBack()
		table.insert( actions,delay )
		table.insert( actions,call_back )
	end
	-- 第六个到倒数第5个匀速
	local yun_num = total_run_nums - 5
	for i = 6,yun_num do
		local delay = cc.DelayTime:create( 0.05 )
		local call_back = self:createTurnCallBack()
		table.insert( actions,delay )
		table.insert( actions,call_back )
	end
	for i = 1,5 do
		local delay_time = 0.1 + ( i - 1 ) * 0.1
		local delay = cc.DelayTime:create( delay_time )
		local call_back = self:createTurnCallBack()
		table.insert( actions,delay )
		table.insert( actions,call_back )
	end

	local call_action_end = cc.CallFunc:create( function()
		self.last_random_index = random_index
		self:calResult()
	end )
	table.insert( actions,call_action_end )
	local seq = cc.Sequence:create(actions)
	self:runAction( seq )
end

function GamePlay:createTurnCallBack()
	local call_back = cc.CallFunc:create( function()
		if self.run_index == #self._itemsPos then
			self.run_index = 1
		else
			self.run_index = self.run_index + 1
		end
		-- 设置位置
		self._light:setPosition( self._itemsPos[self.run_index])
		self._items[self.run_index]:lightAction()
		-- 播放音效
		audio.playSound("lhjmp3/game_turntable.mp3", false)
	end )
	return call_back
end

function GamePlay:clickRateBegan( index )
	assert( index," !! index is nil !! " )
	if self._turnAction then
		return
	end
	self:loadXiaZhuUIData( index )
	self:schedule( function()
		self:loadXiaZhuUIData( index )
	end,0.1 )

	-- 播放下注音效
	-- self._effect_xiazhu = audio.playSound("lhjmp3/game_bet.mp3", true)
end

function GamePlay:clickRateEnd( index )
	if self._turnAction then
		return
	end
	self:unSchedule()
	if self._effect_xiazhu then
		audio.stopSound( self._effect_xiazhu )
	end
end

function GamePlay:loadXiaZhuUIData( index )
	assert( index," !! index is nil !! " )

	-- 不能超过99个金币
	if self.rate_select[index] and self.rate_select[index] >= 99 then
		return
	end

	-- 播放下注音效
	audio.playSound("lhjmp3/game_bet.mp3", false)

	local coin = self._tempHasCoin
	local cost_coin = G_GetModel("Model_LaoHuJi"):getCostCoin()
	if coin >= cost_coin then
		self.rate_select[index] = self.rate_select[index] + 1
		local index_str = string.format("%02d",self.rate_select[index])
		self["TextXiaZhu"..index]:setString(index_str)

		-- 显示剩余金币
		self:loadHasCoinUiData( coin - cost_coin )
	else
		G_ShowTips("金币不足")
	end
end

function GamePlay:loadHasCoinUiData( coin )
	assert( coin," !! coin is nil !! " )
	local coin_str = string.format("%08d",coin)
	local len = string.len(coin_str)
	local cc_str = ""
	for i = 1,len do
		cc_str = cc_str..string.sub(coin_str,i,i)
		if i <= 8 then
			cc_str = cc_str.."  "
		end
	end
    self.TextHasCoin:setString( cc_str )
    self._tempHasCoin = coin
end

function GamePlay:createLight()
	if self._light == nil then
		self._light = ccui.ImageView:create("image/game/box_s.png",1)
		self.Bg:addChild( self._light )
		self._light:setVisible( false )
	end
	self._light:setVisible( true )
	return self._light
end

function GamePlay:resetOperaButton()
	self.ButtonStart:loadTexture("image/game/start.png",1)
	self._turnAction = nil
	for i = 1,8 do
		self["Button"..i]:loadTexture(self.btn_config[i].img,1)
	end

	-- 是否还有金币
	local has_coin = G_GetModel("Model_LaoHuJi"):getCoin()
	if has_coin <= 0 then
		-- 破产
		addUIToScene( UIDefine.LAOHUJI_KEY.PoChan_UI )
		return
	end
end

-- 结算
function GamePlay:calResult()
	local index = self.item_config[ self.result_index ].index

	-- 设置游戏次数
	local play_times = G_GetModel("Model_LaoHuJi"):gePlayTimes()
	G_GetModel("Model_LaoHuJi"):setPlayTimes( play_times + 1 )

	-- 通吃
	if index == 9 then
		-- 重置
		self:resetXiaZhu()
		-- 重置临时的连续押中次数
		G_GetModel("Model_LaoHuJi"):clearTempLianXu()
		-- 播放没有押中的音效
		audio.playSound("lhjmp3/game_lose.mp3", false)
		-- 重置按钮状态
		self:resetOperaButton()
		return
	end
	-- 没中
	if self.rate_select[index] <= 0 then
		-- 重置
		self:resetXiaZhu()
		-- 重置临时的连续押中次数
		G_GetModel("Model_LaoHuJi"):clearTempLianXu()
		-- 播放没有押中的音效
		audio.playSound("lhjmp3/game_lose.mp3", false)
		-- 重置按钮状态
		self:resetOperaButton()
		return
	end

	-- 播放押中音效
	audio.playSound("lhjmp3/game_big_win.mp3", false)

	-- 基础的coin
	local org_num =  self.rate_select[index] * G_GetModel("Model_LaoHuJi"):getCostCoin()
	-- 加双倍的rate
	local reduce_rate = self.item_config[ self.result_index ].rate
	-- 加倍的rate
	local add_rate = tonumber(self.btn_config[index].rate)

	local result_coin = org_num * add_rate * reduce_rate

	local name = self.btn_config[index].name
	local final_rate = add_rate * reduce_rate
	local result_str = string.format( "押中物品：%s，倍率：%s倍",name,final_rate )

	self.TextGetCoin:setString( "+"..result_coin )
	self.TextGetDesc:setString( result_str )

	self.BgYaZhong:setVisible( true )
	self.BgLogo:setVisible( false )

	-- 存储金币
	local coin = G_GetModel("Model_LaoHuJi"):getCoin()
	G_GetModel("Model_LaoHuJi"):saveCoin( coin + result_coin )

	-- 显示剩余金币
	self:loadHasCoinUiData( coin + result_coin )

	-- 播放动画
	self:dropCoinAction( result_coin )
	-- 重置
	self:resetXiaZhu()

	-- 存储记录
	G_GetModel("Model_LaoHuJi"):saveRecordList( result_coin )

	-- 计算累计金币的成就
	G_GetModel("Model_LaoHuJi"):setHighCoin( coin + result_coin )
	-- 设置连续押中次数
	G_GetModel("Model_LaoHuJi"):addTempLianXu()
	-- 设置累积押中次数
	local lei_ji = G_GetModel("Model_LaoHuJi"):geLeiJiYaZhong()
	G_GetModel("Model_LaoHuJi"):setLeiJiYaZhong( lei_ji + 1 )
end

function GamePlay:dropCoinAction( resultCoin )
	local coinNum = 0
	if resultCoin <= 8 then
		coinNum = 5
	elseif resultCoin >= 9 and resultCoin <= 20 then
		coinNum = 8
	else
		coinNum = 12
	end
	local size = self.CoinActionPanel:getContentSize()
	for i = 1,coinNum do
		local coin = Coin.new()
		self.CoinActionPanel:addChild( coin )
		coin:changeAction()
		local y_pos = size.height + random( 50,200 )
		coin:setPosition( cc.p(random(50,220), y_pos) )
		local delay_time = cc.DelayTime:create( random( 10,20 ) / 10 )
		local move_by = cc.MoveBy:create( random(1,2) / 2,cc.p(0,-y_pos))
		local ease_sinein = cc.EaseSineIn:create( move_by )
		local remove = cc.RemoveSelf:create()
		local seq = cc.Sequence:create({ delay_time,ease_sinein,remove })
		coin:runAction( seq )
	end

	-- 播放金币掉落的音效
	local delay =  cc.DelayTime:create( 0.5 )
	local call_voice = cc.CallFunc:create( function()
		audio.playSound("lhjmp3/game_coin_droping.mp3", false)
	end )
	local delay2 = cc.DelayTime:create( 2.5 )
	local call_button = cc.CallFunc:create( function()
		-- 重置按钮状态
		self:resetOperaButton()
	end )
	local seq = cc.Sequence:create({ delay,call_voice,delay2,call_button })
	self:runAction( seq )
end

function GamePlay:resetXiaZhu()
	local has_coin = G_GetModel("Model_LaoHuJi"):getCoin()
	self.rate_select = {0,0,0,0,0,0,0,0}
	for i = 1,8 do
		self["TextXiaZhu"..i]:setString("00")
	end
	self:loadHasCoinUiData( has_coin )
end

-- 关闭
function GamePlay:close()
	-- 破产后重置金币
	local has_coin = G_GetModel("Model_LaoHuJi"):getCoin()
	if has_coin == 0 then
		G_GetModel("Model_LaoHuJi"):saveCoin( lhj_default_coin )
	end
    removeUIFromScene( UIDefine.LAOHUJI_KEY.Play_UI )
    addUIToScene( UIDefine.LAOHUJI_KEY.Start_UI )
end







return GamePlay