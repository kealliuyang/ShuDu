

local ReelUnit  = import(".ReelUnit")

local GamePlay = class("GamePlay",BaseLayer)


function GamePlay:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePlay.super.ctor( self,param.name )
    self:addCsb( "csblaba/Game.csb" )

    self._reelUnitList 	= {}										-- Reels管理列表 --
    self._reelCount   	= laba_config.reel_count					-- Reel的数量

    -- 开始
    self:addNodeClick( self.ButtonStartbg,{ 
        endCallBack = function() self:startRoll() end
    })
    -- 加注
    self:addNodeClick( self.ButtonRaise,{ 
        endCallBack = function() self:addBeta() end
    })
    -- 减注
    self:addNodeClick( self.ButtonMinus,{ 
        endCallBack = function() self:reduceBeta() end
    })
    -- 关闭
    self:addNodeClick( self.ImageReturn,{ 
        endCallBack = function() self:close() end
    })
    -- 商场
    self:addNodeClick( self.Image9999bg,{ 
        endCallBack = function() self:shop() end
    })

    self._viewPos = {}
    for nCol = 1, self._reelCount do
    	self._viewPos[nCol] = {}
    	for nRow = 1,laba_config.reel_config.view_count do
    		local x = 0
    		local y = ( nRow - 1 ) * laba_config.reel_config.height
    		self._viewPos[nCol][nRow] = cc.p( x,y )
    	end
    end
    self._paoMaDengList = {}
end


function GamePlay:onEnter()
	GamePlay.super.onEnter( self )
	self:createReel()
	self._bet = 1
	self:loadDataUI()
end

function GamePlay:loadDataUI()
	local coin = G_GetModel("Model_LaBa"):getCoin()
	self.TextHasCoin:setString( coin )
	self.TextBet:setString( self._bet )
	self.TextWin:setString(0)
end

function GamePlay:addListener()
    self:addMsgListener( InnerProtocol.INNER_EVENT_LABA_REEL_ROOL_DOWN,function( event )
        self:oneRellStopDone()
    end )
    self:addMsgListener( InnerProtocol.INNER_EVENT_LABA_BUY_COIN,function( event )
        local coin = G_GetModel("Model_LaBa"):getCoin()
        self.TextHasCoin:setString( coin )
    end )
end

function GamePlay:addBeta()
	if self:canRoll() then
		local coin = G_GetModel("Model_LaBa"):getCoin()
		if self._bet >= coin then
			return
		end
		self._bet = self._bet + 1
		self.TextBet:setString( self._bet )
	end
end

function GamePlay:reduceBeta()
	if self:canRoll() then
		if self._bet <= 1 then
			return
		end
		self._bet = self._bet - 1
		self.TextBet:setString( self._bet )
	end
end

function GamePlay:close()
	-- 全部处于静止 可以关闭
	if self:canRoll() then
		removeUIFromScene( UIDefine.LABA_KEY.Play_UI )
		addUIToScene( UIDefine.LABA_KEY.Start_UI )
	end
end


function GamePlay:oneRellStopDone()
	if self._tempStopCount == nil then
		self._tempStopCount = 1
	else
		self._tempStopCount = self._tempStopCount + 1
		if self._tempStopCount >= self._reelCount then
			ungraySprite( self.ButtonStartbg:getVirtualRenderer():getSprite() )
			self:calResult()
			self._tempStopCount = nil
			self._destData = nil
			-- 停止音效
			if G_GetModel("Model_Sound"):isVoiceOpen() then
				if self._machineSound then
					audio.stopSound( self._machineSound )
				end
			end
		end
	end
end

-- 根据数据创建reel
function GamePlay:createReel()
	for i = 1,self._reelCount do
		if self._reelUnitList[ i ] == nil then
			local reel = ReelUnit.new( laba_config.reel_config,i )
			self["Panel"..i]:addChild( reel )
			self._reelUnitList[ i ] = reel
		end
	end
end


-- 轮盘 执行开始滚动的指令
function GamePlay:startRoll()
	-- 判断金币是否足够
	local coin = G_GetModel("Model_LaBa"):getCoin()
	if coin < self._bet then
		-- 打开商城
		self:shop()
		return
	end

	if self:canRoll() then
		self.TextWin:setString(0)
		self:hideAllMaoPaDeng()
		graySprite( self.ButtonStartbg:getVirtualRenderer():getSprite() )
		local actions = {}
		for i = 1,self._reelCount do
			local delay_time = cc.DelayTime:create(0.3)
			local call_start = cc.CallFunc:create( function()
				self._reelUnitList[i]:startRoll()
			end )
			table.insert( actions,delay_time )
			table.insert( actions,call_start )
		end
		local seq = cc.Sequence:create( actions )
		self.Imagebg:runAction( seq )

		performWithDelay( self,function()
			if G_GetModel("Model_Sound"):isVoiceOpen() then
				self._machineSound = audio.playSound("labamp3/machine.mp3", false)
			end
		end,0.5 )

		-- 5秒之后自动停止
		local stop_time = random(3,4)
		performWithDelay( self,function()
			self:stopRoll()
		end,stop_time )
	end
end

-- 轮盘 执行开始停止的指令
function GamePlay:stopRoll()
	-- 判断金币是否足够

	if self:canRoll() then
		-- nothing to do here!!
	else
		-- 随机结果
		self._destData = {}

		for i = 1,self._reelCount do
			local random_ary = getRandomArray(1,9)
			local meta = { random_ary[1],random_ary[2],random_ary[3] }
			table.insert( self._destData,meta )
		end

		local actions = {}
		for i = 1,self._reelCount do
			local delay_time = cc.DelayTime:create(0.2)
			local call_stop = cc.CallFunc:create( function()
				self._reelUnitList[i]:stopRoll( self._destData[i] )
			end )
			table.insert( actions,delay_time )
			table.insert( actions,call_stop )
		end
		local seq = cc.Sequence:create( actions )
		self.Imagebg:runAction( seq )
	end
end

-- 轮盘是否能滚动
function GamePlay:canRoll()
	local can = true
	for i,v in ipairs( self._reelUnitList ) do
		if not v:canRoll() then
			can = false
			break
		end
	end
	return can
end


function GamePlay:calResult()
	if not self._destData or #self._destData == 0 then
		return
	end

	local result = {}
	for nRow = 1,#self._destData[1] do
		local has,line = self:getRewardRate( self._destData[1][nRow],1,nRow )
		if has then
			table.insert( result,line )
		end
	end
	-- 1:计算获得的奖励
	local get_coin = 0
	for i,v in ipairs( result ) do
		local lianxu_num = #v
		local symbolId = v[1].symbolId
		local rate = laba_config.rate_config[symbolId][lianxu_num]
		get_coin = get_coin + self._bet * rate
	end
	self.TextWin:setString( get_coin )
	G_GetModel("Model_LaBa"):setCoin( get_coin - self._bet )
	local coin = G_GetModel("Model_LaBa"):getCoin()
	self.TextHasCoin:setString( coin )

	if G_GetModel("Model_Sound"):isVoiceOpen() then
		if get_coin > 0 then
			audio.playSound("labamp3/reward.mp3", false)
			self:getCoinAction()
		else
			audio.playSound("labamp3/noreward.mp3", false)
		end
	end

	-- 2:播放跑马灯
	local actions = {}
	for i,v in ipairs( result ) do
		local call_show = cc.CallFunc:create( function()
			for a,b in ipairs( v ) do
				self:playPaoMaDengAction( b.col,b.row )
			end
		end )
		local delay_time = cc.DelayTime:create( 3.4 )
		local call_hide = cc.CallFunc:create( function()
			for a,b in ipairs( v ) do
				self:hideLinePaoMaDeng( b.col,b.row )
			end
		end )
		table.insert( actions,call_show )
		table.insert( actions,delay_time )
		table.insert( actions,call_hide )
	end
	if #actions > 0 then
		local seq = cc.Sequence:create( actions )
		local rep = cc.RepeatForever:create( seq )
		self.ImageLogo:runAction( rep )
	end
end

function GamePlay:getRewardRate( symbolId,col,row )
	local line = { { symbolId = symbolId,col = col,row = row } }
	for nCol = 2,self._reelCount do
		local has = false
		for nRow = 1,#self._destData[nCol] do
			if self._destData[nCol][nRow] == symbolId then
				table.insert( line,{ symbolId = symbolId,col = nCol,row = nRow } )
				has = true
			end
		end
		if not has then
			if nCol == 2 or nCol == 3 then
				return false
			end
			if nCol == 4 then
				return true,line
			end
		end
	end
	return true,line
end


function GamePlay:playPaoMaDengAction( col,row )
	if self._paoMaDengList[col] == nil then
		self._paoMaDengList[col] = {}
	end
	if self._paoMaDengList[col][row] == nil then
		local img = ccui.ImageView:create("image/paomadeng/1.png",1)
		img:setScale( 0.85 )
		self["Panel"..col]:addChild( img,100 )
		local pos = clone( self._viewPos[col][row] )
		pos.x = pos.x + laba_config.reel_config.width / 2
		pos.y = pos.y + laba_config.reel_config.height / 2
		img:setPosition( pos )
		self._paoMaDengList[col][row] = img
	end
	self._paoMaDengList[col][row]:stopAllActions()
	self._paoMaDengList[col][row]:setVisible( true )
	local actions = {}
	for i = 1,17 do
		local call_set = cc.CallFunc:create( function()
			self._paoMaDengList[col][row]:loadTexture( "image/paomadeng/"..i..".png",1 )
		end )
		local delay_time = cc.DelayTime:create( 0.1 )
		table.insert( actions,call_set )
		table.insert( actions,delay_time )
	end
	local seq = cc.Sequence:create( actions )
	local rep = cc.RepeatForever:create( seq )
	self._paoMaDengList[col][row]:runAction( rep )
end


function GamePlay:hideAllMaoPaDeng()
	self.ImageLogo:stopAllActions()
	for i,v in pairs( self._paoMaDengList ) do
		for a,b in pairs( v ) do
			b:setVisible( false )
			b:stopAllActions()
		end
	end
end

function GamePlay:hideLinePaoMaDeng( col,row )
	if self._paoMaDengList[col] and self._paoMaDengList[col][row] then
		self._paoMaDengList[col][row]:stopAllActions()
		self._paoMaDengList[col][row]:setVisible( false )
	end
end

function GamePlay:shop()
	addUIToScene( UIDefine.LABA_KEY.Shop_UI )
end

function GamePlay:getCoinAction()
	local count = random( 10,20 )
	for i = 1,count do
		local coin = self:addFlyCoin()
		coin:setPosition( random( 0,display.width),display.height + 150 )
		local move_by = cc.MoveBy:create( random(10,30)/10,cc.p( 0,-display.height - 150 ))
		local remove = cc.RemoveSelf:create()
		coin:runAction(cc.Sequence:create({ move_by,remove }))
	end
end

function GamePlay:addFlyCoin()
	local coin = ccui.ImageView:create("image/flycoin/iocns00.png",1)
	self:addChild( coin,100 )
	coin:setPosition( display.cx,display.cy )
	local index = 1
	schedule( coin,function()
		local path = string.format("image/flycoin/iocns%02d.png",index)
		coin:loadTexture( path,1 )
		index = index + 1
		if index > 15 then
			index = 1
		end
	end,0.08 )
	return coin
end

return GamePlay