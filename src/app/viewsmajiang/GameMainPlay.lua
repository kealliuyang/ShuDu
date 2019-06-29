
local GameAction    = import(".Action.GameAction")
local PlayerNode    = import(".Player.PlayerNode")
local AINode        = import(".AI.AINode")
local ManagerData   = import(".Manager.ManagerData")
local GameMainPlay 	= class("GameMainPlay",BaseLayer)


function GameMainPlay:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameMainPlay.super.ctor( self,param.name )
    self:addCsb( "csbmajiang/GamePlay.csb" )
    -- 关闭
    self:addNodeClick( self.ButtonClose,{ 
        endCallBack = function() self:close() end
    })

    -- 胡
    self:addNodeClick( self.ButtonHu,{ 
        endCallBack = function() self:playerHu() end
    })
    -- 杠
    self:addNodeClick( self.ButtonGang,{ 
        endCallBack = function() self:playerGang() end
    })
    -- 碰
    self:addNodeClick( self.ButtonPeng,{ 
        endCallBack = function() self:playerPeng() end
    })
    -- 弃
    self:addNodeClick( self.ButtonQi,{ 
        endCallBack = function() self:playerQi() end
    })

    -- 不加倍
    self:addNodeClick( self.ButtonNotRate,{ 
        endCallBack = function() self:addBei(1) end
    })

    -- 2倍
    self:addNodeClick( self.ButtonTwoRate,{ 
        endCallBack = function() self:addBei(2) end
    })

    -- 5倍
    self:addNodeClick( self.ButtonFiveRate,{ 
        endCallBack = function() self:addBei(5) end
    })

    -- 10倍
    self:addNodeClick( self.ButtonTenRate,{ 
        endCallBack = function() self:addBei(10) end
    })

    -- 点击了出牌区域
    self:addNodeClick( self.TouchOutCardPanel,{ 
        endCallBack = function() self:outCard() end,
        scaleAction = false
    })

    self:setOperaButtonVisible( false )

    self.BgShengyu:setVisible( false )

    -- button 设置Zorder
    self.ButtonHu:setLocalZOrder( 100 )
    self.ButtonGang:setLocalZOrder( 100 )
    self.ButtonPeng:setLocalZOrder( 100 )
    self.ButtonQi:setLocalZOrder( 100 )

    self._opPositionX = {
        [1] = self.ButtonPeng:getPositionX(),
        [2] = self.ButtonGang:getPositionX(),
        [3] = self.ButtonHu:getPositionX(),
        [4] = self.ButtonQi:getPositionX()
    }


    -- 加倍按钮的隐藏
    self:setRateButtonVisible( false )
    
    -- 管理数据的类
    self._managerData = ManagerData.new()
    -- 添加玩家的node
    self._playerNode = PlayerNode.new( self,self._managerData )
    self.MidPanel:addChild( self._playerNode )
    -- 添加AI的node
    self._aiNode = AINode.new( self,self._managerData )
    self.MidPanel:addChild( self._aiNode )
    -- 管理动作的类
    self._gameAction = GameAction.new( self )

    -- 游戏结束的标志
    self._gameOver = false

    self:loadUiData()
end

function GameMainPlay:onEnter()
    GameMainPlay.super.onEnter( self )
    casecadeFadeInNode( self.MidPanel,0.5 )
    -- 游戏开始
    local start_call = function() self:gameStart() end
    self._gameAction:readStartAction( start_call )
end
-- 游戏开始动画
function GameMainPlay:gameStart()
	local continue_data = G_GetModel("Model_MaJiang"):getContinueData()
	if continue_data then
		-- 有未完的游戏数据 继续开始
	else
		-- 新的游戏局
	    local is_player_win = G_GetModel("Model_MaJiang"):isPlayerWin()
	    -- 先初始化手牌数据 (玩家赢 玩家先摸牌 先出牌,AI赢 AI先摸牌 先出牌)
	    self._managerData:initNewGameCardData( is_player_win )
	    -- 播放发牌动画
	    self._gameAction:sendCardAction( is_player_win )
	end
end

-- 初始化界面数据
function GameMainPlay:loadUiData()
    -- 显示底分
    local di_score = G_GetModel("Model_MaJiang"):getDiScore() + G_GetModel("Model_MaJiang"):getPlayTimes() * 5
    self.TextDiFen:setString( di_score )
    -- 显示倍数
    self.TextPeiShu:setString( 1 )
    -- 显示玩家拥有的积分
    local has_score = G_GetModel("Model_MaJiang"):getHasScore()
    self.TextMyGold:setString( has_score )
    -- 显示连庄数
    self:setLianZhuang()

    -- 设置背景
    local game_type = G_GetModel("Model_MaJiang"):getGameType()
    if game_type == 1 then
        self.Bg:loadTexture("image/2/bg_changgui.jpg",0)
    else
        self.Bg:loadTexture("image/2/bg_tiaozhan.jpg",0)
    end
end

-- 显示连庄数
function GameMainPlay:setLianZhuang()
    local lian_data = G_GetModel("Model_MaJiang"):getLianZhuang()
    self.BgZhuangPlayer:setVisible( lian_data.player > 1 )
    self.TextZhuangPlayer:setVisible( lian_data.player > 1 )
    self.TextZhuangPlayer:setString( "X"..lian_data.player )
    self.BgZhuangAi:setVisible( lian_data.ai > 1 )
    self.TextZhuangAi:setVisible( lian_data.ai > 1 )
    self.TextZhuangAi:setString( "X"..lian_data.ai )
end

--[[
	摸牌
	moType 1:玩家摸牌 2:ai摸牌
]]
function GameMainPlay:moCard( moType )
	assert( moType," !! moType is nil !! " )
	if moType == 1 then
		self._playerNode:createMoNode()
	else
		self._aiNode:createMoNode()
	end

    self.BgShengyu:setVisible( true )
    local shengyu = #self._managerData._allCard
    self.TextShengyu2:setString( shengyu.."张" )
end
-- 游戏结束
function GameMainPlay:gameOver( code )
	assert( code," !! code is nil !! " )
    -- 设置标志
    self._gameOver = true
    self.ButtonClose:setVisible( false )

    if code == 0 then
        -- 牌堆没有牌了 和局
        -- 显示界面
        addUIToScene( UIDefine.MAJIANG_KEY.LiuJu_UI )
        return
    end

    if code == 1 then
        local call_back = function()
            local call_result = function()
                -- 玩家赢
                local result_data = self:getResultDataByPlayerWin()
                -- 添加界面
                addUIToScene( UIDefine.MAJIANG_KEY.Win_UI,result_data )
                -- 存储数据
                self:savePlayerDataByGameOver( true )
            end
            self._gameAction:mingPaiAction( call_result )
        end
        self._gameAction:huAction( call_back )
        audio.playSound("mjmp3/boy_ac_hu.mp3", false)
        return
    end

    if code == 2 then
        local call_back = function()
            -- ai赢
            local call_result = function()
                local result_data = self:getResultDataByAIWin()
                addUIToScene( UIDefine.MAJIANG_KEY.Lose_UI,result_data )
                -- 存储数据
                self:savePlayerDataByGameOver( false )
            end
            self._gameAction:mingPaiAction( call_result )
        end
        self._gameAction:huAction( call_back )
        audio.playSound("mjmp3/boy_ac_hu.mp3", false)
        return
    end
end







--[[
    当玩家赢的结算数据
]]
function GameMainPlay:getResultDataByPlayerWin()
    local result_data = {}
    -- 底分
    result_data.di_score = G_GetModel("Model_MaJiang"):getDiScore() + G_GetModel("Model_MaJiang"):getPlayTimes() * 5
    -- 门清
    result_data.men_qing = #self._managerData._playerGangPengData <= 0
    -- 天胡
    result_data.tian_hu = false
    if #self._managerData._playerGangPengData <= 0 
        and #self._managerData._playerOutData <= 0
        and #self._managerData._aiGangPengData <= 0
        and #self._managerData._aiOutData <= 0 then
        result_data.tian_hu = true
    end
    -- 自摸
    result_data.zi_mo = ( self._playerNode._moNode ~= nil and self._playerNode._moNode:getNum() > 0 )
    local player_gang_num = 0
    -- player
    local player_peng_gang = self._managerData:calHashCard( self._managerData._playerGangPengData )
    for k,v in pairs( player_peng_gang ) do
        if v == 4 then
            player_gang_num = player_gang_num + 1
        end
    end
    -- ai
    local ai_peng_gang = self._managerData:calHashCard( self._managerData._aiGangPengData )
    for k,v in pairs( ai_peng_gang ) do
        if v == 4 then
            player_gang_num = player_gang_num + 1
        end
    end
    -- 杠牌数量
    result_data.gang_num = player_gang_num
    -- 加倍数
    result_data.add_rate = self._playerRateNum * self._aiRateNum
    -- 连庄数
    result_data.lian_zhuang = 1
    local lian_data = G_GetModel("Model_MaJiang"):getLianZhuang()
    if lian_data.player > 1 then
        result_data.lian_zhuang = lian_data.player
    end
    return result_data
end
--[[
    当ai赢的结算数据
]]
function GameMainPlay:getResultDataByAIWin()
    local result_data = {}
    -- 底分
    result_data.di_score = G_GetModel("Model_MaJiang"):getDiScore() + G_GetModel("Model_MaJiang"):getPlayTimes() * 5
    -- 门清
    result_data.men_qing = #self._managerData._aiGangPengData <= 0
    -- 天胡
    result_data.tian_hu = false
    if #self._managerData._playerGangPengData <= 0 
        and #self._managerData._playerOutData <= 0
        and #self._managerData._aiGangPengData <= 0
        and #self._managerData._aiOutData <= 0 then
        result_data.tian_hu = true
    end
    -- 自摸
    result_data.zi_mo = ( self._aiNode._moNode ~= nil and self._aiNode._moNode:getNum() > 0 )
    local ai_gang_num = 0
    -- player
    local player_peng_gang = self._managerData:calHashCard( self._managerData._playerGangPengData )
    for k,v in pairs( player_peng_gang ) do
        if v == 4 then
            ai_gang_num = ai_gang_num + 1
        end
    end
    -- ai
    local ai_peng_gang = self._managerData:calHashCard( self._managerData._aiGangPengData )
    for k,v in pairs( ai_peng_gang ) do
        if v == 4 then
            ai_gang_num = ai_gang_num + 1
        end
    end
    -- 杠牌数
    result_data.gang_num = ai_gang_num
    -- 加倍数
    result_data.add_rate = self._playerRateNum * self._aiRateNum
    -- 连庄数
    result_data.lian_zhuang = 1
    local lian_data = G_GetModel("Model_MaJiang"):getLianZhuang()
    if lian_data.ai > 1 then
        result_data.lian_zhuang = lian_data.ai
    end
    -- 是否破产
    result_data.po_chan = false
    local reduce_score = G_GetModel("Model_MaJiang"):calAddScoreByResult( result_data )
    if G_GetModel("Model_MaJiang"):getHasScore() < reduce_score then
        result_data.po_chan = true
    end
    return result_data
end


-- 存储玩家数据
function GameMainPlay:savePlayerDataByGameOver( isPlayerWin )
    local result_data = nil
    if isPlayerWin then
        result_data = self:getResultDataByPlayerWin()
    else
        result_data = self:getResultDataByAIWin()
    end
    local add_score = G_GetModel("Model_MaJiang"):calAddScoreByResult( result_data )
    local has_score = G_GetModel("Model_MaJiang"):getHasScore()
    if isPlayerWin then
        local final_score = has_score + add_score
        -- 存储积分
        G_GetModel("Model_MaJiang"):setHasScore( final_score )
        -- 设置连庄数
        G_GetModel("Model_MaJiang"):setLianZhuang( true )
        -- 设置玩家玩的次数
        local play_times = G_GetModel("Model_MaJiang"):getPlayTimes()
        play_times = play_times + 1
        G_GetModel("Model_MaJiang"):setPlayTimes( play_times )
        -- 设置这一局谁赢
        G_GetModel("Model_MaJiang"):setPlayerWin( 1 )
        -- 存储记录
        G_GetModel("Model_MaJiang"):saveRecordList( add_score )
    else
        local final_score = has_score - add_score
        if final_score < 0 then
            -- 重置玩家数据
            G_GetModel("Model_MaJiang"):resetPlayerDataByPoChan()
        else
            -- 存储积分
            G_GetModel("Model_MaJiang"):setHasScore( final_score )
            -- 设置连庄数
            G_GetModel("Model_MaJiang"):setLianZhuang( false )
            -- 设置玩家玩的次数
            local play_times = G_GetModel("Model_MaJiang"):getPlayTimes()
            play_times = play_times + 1
            G_GetModel("Model_MaJiang"):setPlayTimes( play_times )
            -- 设置这一局谁赢
            G_GetModel("Model_MaJiang"):setPlayerWin( 2 )
        end
    end
end







--[[
    AI针对玩家出牌的选择
    cardNum:玩家的出牌
]]
function GameMainPlay:aiCheckPlayerOutCard( cardNum )
    assert( cardNum," !! cardNum is nil !! ")
    self._aiNode:checkPlayerOutLogic( cardNum )
end
--[[
    玩家针对AI出牌的选择
    cardNum:玩家的出牌
]]
function GameMainPlay:playerCheckAIOutCard( cardNum )
    assert( cardNum," !! cardNum is nil !! ")
    self._playerNode:checkAIOutLogic( cardNum )
end







--[[
    显示加倍按钮
]]
function GameMainPlay:showAddRate()
    self:setRateButtonVisible( true )
end


-- 针对玩家 显示胡牌的按钮
function GameMainPlay:showHuOperation( cardNum )
    assert( cardNum," !! cardNum is nil !! " )
    self.ButtonHu:setVisible( true )
    self.ButtonQi:setVisible( true )
    self._playerHuNum = cardNum
end
-- 针对玩家 显示杠和弃的操作按钮
function GameMainPlay:showGangOperation( cardNum,gangType )
    assert( cardNum," !! cardNum is nil !! " )
    assert( gangType," !! gangType is nil !! " )
    self.ButtonGang:setPositionX( self._opPositionX[2] )
    self.ButtonGang:setVisible( true )
    self.ButtonQi:setVisible( true )
    if not self.ButtonHu:isVisible() then
        self.ButtonGang:setPositionX( self._opPositionX[3] )
    end
    self._playerGangNum = cardNum
    self._gangType = gangType
end
-- 针对玩家 显示碰和弃的操作按钮
function GameMainPlay:showPengOperation( cardNum )
    assert( cardNum," !! cardNum is nil !! " )
    local delay = cc.DelayTime:create(0.02)
    self.ButtonPeng:setVisible( true )
    self.ButtonQi:setVisible( true )
    self.ButtonPeng:setPositionX( self._opPositionX[1] )
    if not self.ButtonHu:isVisible()  then
        if not self.ButtonGang:isVisible() then
            self.ButtonPeng:setPositionX( self._opPositionX[3] )
        else
            self.ButtonPeng:setPositionX( self._opPositionX[2] )
        end
    else
        if not self.ButtonGang:isVisible() then
            self.ButtonPeng:setPositionX( self._opPositionX[2] )
        end
    end
    self._playerPengNum = cardNum
end






--[[
    AI 杠牌
    cardNum:要杠的牌
    gangType: 1:自己摸暗杠 2:自己摸明杠 3:玩家点杠 
]]
function GameMainPlay:AIGang( cardNum,gangType )
    assert( cardNum," !! cardNum is nil !! " )
    assert( gangType == 1 or gangType == 2 or gangType == 3," !! gangType must be 1 or 2 or 3 !! " )
    local call_back = function()
        -- 玩家的出牌区移除node
        if gangType == 3 then
            self._playerNode:removeOutNodeWhenAIGangOrPeng( cardNum )
        end
        self._aiNode:gangCard( cardNum,gangType )
    end
    self._gameAction:gangAction( call_back )
    audio.playSound("mjmp3/boy_ac_gang.mp3", false)
end
--[[
    AI 碰牌
    pengCardNum:要碰的牌
    outCardNum:碰之后要出的牌
]]
function GameMainPlay:AIPeng( pengCardNum,outCardNum )
    assert( pengCardNum," !! pengCardNum is nil !! " )
    assert( outCardNum," !! outCardNum is nil !! " )
    local call_back = function()
        -- 玩家的出牌区移除node
        self._playerNode:removeOutNodeWhenAIGangOrPeng( pengCardNum )
        -- 创建碰牌的node
        self._aiNode:createPengNodes( pengCardNum,outCardNum )
    end
    self._gameAction:pengAction( call_back )
    audio.playSound("mjmp3/boy_ac_peng.mp3", false)
end
--[[
    AI 出牌
    cardNum:要出牌的数字
    outType:1:AI自己摸牌出牌 2:碰牌出牌
]]
function GameMainPlay:AIOutCard( cardNum,outType )
    assert( cardNum," !! cardNum is nil !! " )
    assert( outType," !! outType is nil !! " )
    local delay = cc.DelayTime:create( 0.5 )
    local call_back = cc.CallFunc:create( function()
        -- 玩家node隐藏tips
        self._playerNode:hideOutCardTips()
        -- ai 出牌
        if outType == 1 then
            self._aiNode:outCardNodeByMo( cardNum )
        else
            self._aiNode:outHandCardByPeng( cardNum )
        end
        G_GetModel("Model_MaJiang"):playOutCardVoice( cardNum )
    end )
    local seq = cc.Sequence:create({ delay,call_back })
    self:runAction( seq )
end




function GameMainPlay:playerHu()
    self:setOperaButtonVisible( false )
    self:resetOperaData()
    self:gameOver(1)
end

function GameMainPlay:playerGang()
    assert( self._playerGangNum," !! self._playerGangNum is nil !! " )
    assert( self._gangType," !! self._gangType is nil !! " )
    local gang_num = self._playerGangNum
    local gang_type = self._gangType
    local call_back = function()
        self._playerNode:gangCard( gang_num,gang_type )
        -- 玩家点杠 需要移除AI的出牌
        if self._gangType == 3 then
            self._aiNode:removeOutNode( gang_num )
            self._aiNode:hideOutCardTips()
        end
        self:resetOperaData()
    end
    self:setOperaButtonVisible( false )
    self._gameAction:gangAction( call_back )
    audio.playSound("mjmp3/boy_ac_gang.mp3", false)
end

function GameMainPlay:playerPeng()
    assert( self._playerPengNum," !! self._playerPengNum is nil !! " )
    local peng_num = self._playerPengNum
    local call_back = function()
        self._playerNode:pengCard( peng_num )
        -- 移除AI的碰牌
        self._aiNode:removeOutNode( peng_num )
        self._aiNode:hideOutCardTips()
        self:resetOperaData()
    end
    self:setOperaButtonVisible( false )
    self._gameAction:pengAction( call_back )
    audio.playSound("mjmp3/boy_ac_peng.mp3", false)
end

function GameMainPlay:playerQi()
    -- 玩家摸牌
    if self._playerNode._moNode then
        -- 出牌
        self._playerNode._canOutHandCard = true
    else
        self:moCard(1)
    end
    self:setOperaButtonVisible( false )
    self:resetOperaData()
end

function GameMainPlay:resetOperaData()
    self._playerHuNum = nil
    self._playerGangNum = nil
    self._playerPengNum = nil
    self._playerHuNum = nil
    self._gangType = nil
end


-- 添加监听
function GameMainPlay:addListener()
    -- 加倍的监听
    self:addMsgListener( InnerProtocol.INNER_EVENT_MAJIANG_ADD_RATE,function( event )
        self:showAddRate()
    end )
    -- 游戏结束的监听
    self:addMsgListener( InnerProtocol.INNER_EVENT_MAJIANG_GAMEOVER,function( event )
        self:gameOver( event.data[1] )
    end )
    -- 摸牌的监听
    self:addMsgListener( InnerProtocol.INNER_EVENT_MAJIANG_MO_CARD,function( event )
        self:moCard( event.data[1] )
    end )
    -- 玩家可以胡牌的监听
    self:addMsgListener( InnerProtocol.INNER_EVENT_MAJIANG_PLAYER_HU,function( event )
        self:showHuOperation( event.data[1] )
    end )
    -- 玩家可以杠牌的监听
    self:addMsgListener( InnerProtocol.INNER_EVENT_MAJIANG_PLAYER_GANG,function( event )
        self:showGangOperation( event.data[1],event.data[2] )
    end )
    -- 玩家可以碰牌的监听
    self:addMsgListener( InnerProtocol.INNER_EVENT_MAJIANG_PLAYER_PENG,function( event )
        self:showPengOperation( event.data[1] )
    end )
    -- 玩家出牌后 通知AI
    self:addMsgListener( InnerProtocol.INNER_EVENT_MAJIANG_AI_TURN,function( event )
        self:aiCheckPlayerOutCard( event.data[1] )
    end )
    -- AI 杠牌
    self:addMsgListener( InnerProtocol.INNER_EVENT_MAJIANG_AI_GANG,function( event )
        self:AIGang(event.data[1],event.data[2])
    end )
    -- AI 碰牌
    self:addMsgListener( InnerProtocol.INNER_EVENT_MAJIANG_AI_PENG,function( event )
        self:AIPeng(event.data[1],event.data[2])
    end )
    -- AI 出牌
    self:addMsgListener( InnerProtocol.INNER_EVENT_MAJIANG_AI_OUT_CARD,function( event )
        self:AIOutCard(event.data[1],event.data[2])
    end )
    -- AI出牌后 通知player
    self:addMsgListener( InnerProtocol.INNER_EVENT_MAJIANG_PLAYER_TURN,function( event )
        self:playerCheckAIOutCard( event.data[1] )
    end )
end
-- 点击了出牌区域
function GameMainPlay:outCard()
    -- 隐藏ai的出牌tips
    self._aiNode:hideOutCardTips()
    -- 玩家出牌
	self._playerNode:touchOutHandNode()
end

function GameMainPlay:addBei( rateNum )
    self._playerRateNum = rateNum
    -- 设置倍数
    self.TextPeiShu:setString( self._playerRateNum )
    -- 隐藏
    self:setRateButtonVisible( false )
    -- AI设置加倍
    local ai_rates = { 1,2,5,10 }
    self._aiRateNum = ai_rates[random(1,#ai_rates)]
    -- ai设置倍数结束后 开局
    local call_back = function()
        -- 设置倍数
        self.TextPeiShu:setString( self._playerRateNum * self._aiRateNum )
        -- 开局
        local is_player_win = G_GetModel("Model_MaJiang"):isPlayerWin()
        local mo_type = 1
        if not is_player_win then
            mo_type = 2
        end
        self:moCard( mo_type )
    end
    self._gameAction:aiSetAddRateAction( self._aiRateNum,call_back )
end

function GameMainPlay:setRateButtonVisible( value )
    self.ButtonNotRate:setVisible( value )
    self.ButtonTwoRate:setVisible( value )
    self.ButtonFiveRate:setVisible( value )
    self.ButtonTenRate:setVisible( value )
end

function GameMainPlay:setOperaButtonVisible( value )
    self.ButtonGang:setVisible( value )
    self.ButtonPeng:setVisible( value )
    self.ButtonQi:setVisible( value )
    self.ButtonHu:setVisible( value )
end

function GameMainPlay:gameOverMingPai()
    self._playerNode:huPaiChangeMingPai()
    self._aiNode:huPaiChangeMingPai()
end


-- 关闭
function GameMainPlay:close()
	removeUIFromScene( UIDefine.MAJIANG_KEY.Play_UI )
	addUIToScene( UIDefine.MAJIANG_KEY.Start_UI )
end




return GameMainPlay