

-- 游戏界面需要执行的动画

local GameAction = class("GameAction")


function GameAction:ctor( gameMainLayer )
	assert( gameMainLayer," !! gameMainLayer is nil !! " )
	self._gameMainLayer = gameMainLayer
	self._managerData = self._gameMainLayer._managerData
	assert( self._managerData," !! self._managerData is nil !! " )
	self._playerNode = self._gameMainLayer._playerNode
	assert( self._playerNode," !! self._playerNode is nil !! " )
	self._aiNode = self._gameMainLayer._aiNode
	assert( self._aiNode," !! self._aiNode is nil !! " )
end


-- 游戏开始动画
function GameAction:readStartAction( callBack )
	assert( callBack," !! callBack is nil !! " )
	local delay = cc.DelayTime:create(0.2)
    local call_action = cc.CallFunc:create( callBack )
    local seq = cc.Sequence:create({ delay,call_action })
    self._gameMainLayer:runAction( seq )
end

-- 发牌动画
function GameAction:sendCardAction( isPlayerWin )
	local cards_ai_ary = self._managerData:getSevenAry(self._managerData._aiHandData)
	local cards_player_ary = self._managerData:getSevenAry(self._managerData._playerHandData)
	local send_actions = {}
	for i = 1,7 do
		local delay1 = cc.DelayTime:create(0.2)
		local send_player_call = cc.CallFunc:create( function()
			self._playerNode:sendCardAction( cards_player_ary[i] )
		end )
		local delay2 = cc.DelayTime:create(0.2)
		local send_ai_call = cc.CallFunc:create( function()
			self._aiNode:sendCardAction( cards_ai_ary[i] )
		end )

		if isPlayerWin then
			-- 玩家先发牌
			table.insert( send_actions,delay1 )
			table.insert( send_actions,send_player_call )
			table.insert( send_actions,delay2 )
			table.insert( send_actions,send_ai_call )
		else
			-- ai先发牌
			table.insert( send_actions,delay1 )
			table.insert( send_actions,send_ai_call )
			table.insert( send_actions,delay2 )
			table.insert( send_actions,send_player_call )
		end
	end

	-- 发牌结束 进行摸牌
	local delay3 = cc.DelayTime:create(0.2)
	table.insert( send_actions,delay3 )

	local call_add_rate = cc.CallFunc:create( function()
		EventManager:getInstance():dispatchInnerEvent( InnerProtocol.INNER_EVENT_MAJIANG_ADD_RATE )
	end )
	table.insert( send_actions,call_add_rate )

	local seq = cc.Sequence:create( send_actions )
	self._gameMainLayer:runAction( seq )
end


-- 播放杠牌动画
function GameAction:gangAction( callBack )
	assert( callBack," !! callBack is nil !! " )
	local image = ccui.ImageView:create("image/2/gang.png",1)
	self._gameMainLayer.MidPanel:addChild(image)
	image:setPosition( display.cx,display.cy )
	image:setScale(5)
	local scale_to1 = cc.ScaleTo:create(0.3,2)
	local delay = cc.DelayTime:create(1)
	local scale_to2 = cc.ScaleTo:create(0.2,0)
	local call = cc.CallFunc:create(callBack)
	local remove = cc.RemoveSelf:create()
	local seq = cc.Sequence:create({ scale_to1,delay,scale_to2,call,remove })
	image:runAction( seq )
end

-- 播放碰牌的动画
function GameAction:pengAction( callBack )
	assert( callBack," !! callBack is nil !! " )
	local image = ccui.ImageView:create("image/2/peng.png",1)
	self._gameMainLayer.MidPanel:addChild(image)
	image:setPosition( display.cx,display.cy )
	image:setScale(5)
	local scale_to1 = cc.ScaleTo:create(0.3,2)
	local delay = cc.DelayTime:create(1)
	local scale_to2 = cc.ScaleTo:create(0.2,0)
	local call = cc.CallFunc:create(callBack)
	local remove = cc.RemoveSelf:create()
	local seq = cc.Sequence:create({ scale_to1,delay,scale_to2,call,remove })
	image:runAction( seq )
end

-- 播放胡牌的动画
function GameAction:huAction( callBack )
	assert( callBack," !! callBack is nil !! " )
	local image = ccui.ImageView:create("image/2/hu.png",1)
	self._gameMainLayer.MidPanel:addChild(image)
	image:setPosition( display.cx,display.cy )
	image:setScale(5)
	local scale_to1 = cc.ScaleTo:create(0.3,2)
	local delay = cc.DelayTime:create(1)
	local scale_to2 = cc.ScaleTo:create(0.2,0)
	local call = cc.CallFunc:create(callBack)
	local remove = cc.RemoveSelf:create()
	local seq = cc.Sequence:create({ scale_to1,delay,scale_to2,call,remove })
	image:runAction( seq )
end

-- 游戏结束 明牌的动画
function GameAction:mingPaiAction( callBack )
	assert( callBack," !! callBack is nil !! " )
	local call_mingpai = cc.CallFunc:create( function()
        self._gameMainLayer:gameOverMingPai()
    end )
    local delay_minpai = cc.DelayTime:create( 3 )
    local call_result = cc.CallFunc:create( callBack )
    local seq = cc.Sequence:create({ call_mingpai,delay_minpai,call_result })
    self._gameMainLayer:runAction( seq )
end


-- AI设置加倍的延迟时间
function GameAction:aiSetAddRateAction( aiAddRate,callBack )
	assert( aiAddRate," !! aiAddRate is nil !! " )
	assert( callBack," !! callBack is nil !! " )
	-- ai设置加倍的延迟时间
	local delay_time = cc.DelayTime:create( 0.5 )
	local add_text_call = cc.CallFunc:create( function()
		local str = "倍数:"..aiAddRate.."倍"
		local text = ccui.TextBMFont:create( str,"csbmajiang/image/2/NB_difen.fnt" )
		self._gameMainLayer:addChild( text )
		text:setPosition( display.cx,display.cy + 150 )

		local move_by = cc.MoveBy:create(0.5,cc.p(0,50))
		local call_back = cc.CallFunc:create( callBack )
		local remove = cc.RemoveSelf:create()
		local seq1 = cc.Sequence:create( { move_by,call_back,remove } )
		text:runAction( seq1 )
	end )
	local seq = cc.Sequence:create( { delay_time,add_text_call } )
	self._gameMainLayer:runAction( seq )
end


return GameAction