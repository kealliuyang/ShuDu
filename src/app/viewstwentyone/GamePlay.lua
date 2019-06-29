

local GamePlay = class("GamePlay",BaseLayer)


function GamePlay:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GamePlay.super.ctor( self,param.name )
    self:addCsb( "csbtwentyone/Play.csb" )

    for i = 1,4 do
    	self:addNodeClick( self["ButtonPanel"..i],{ 
	        endCallBack = function() self:touchPanel( i ) end,
	        scaleAction = false
	    })
    end
    self:addNodeClick( self["ButtonClose"],{ 
        endCallBack = function() self:refreshPoker() end
    })

    self:addNodeClick( self.ButtonAddCoin,{
    	endCallBack = function() addUIToScene( UIDefine.TWENTYONE_KEY.Shop_UI ) end
    })

    self:addNodeClick( self.ButtonHelp,{
    	endCallBack = function() addUIToScene( UIDefine.TWENTYONE_KEY.Help_UI ) end
    })

    self:addNodeClick( self.ButtonBack,{
    	endCallBack = function() 
    		removeUIFromScene( UIDefine.TWENTYONE_KEY.Play_UI )
    		addUIToScene( UIDefine.TWENTYONE_KEY.Start_UI )
    	end
    })
end


function GamePlay:onEnter()
	GamePlay.super.onEnter( self )
	self:loadUIData()
end

function GamePlay:loadUIData()
	self._pokerAllData = getRandomArray( 1,52 )
    self._pokerData1 = {}
    self._pokerData2 = {}
    self._pokerData3 = {}
    self._pokerData4 = {}
    self._pokerList1 = {}
    self._pokerList2 = {}
    self._pokerList3 = {}
    self._pokerList4 = {}
    self._curPokerNum = nil
    self._beiPokerList = {}
    self._score = 0
    self._curTiZi = 0
    self._totalTiZi = 16
    self._extreTime = 5
    self._curExtreTime = 0
    self._metaScore = 450
    self.ImgJinDuBg:setVisible( false )

	-- 初始化金币
	local coin = G_GetModel("Model_TwentyOne"):getCoin()
	self.TextCoin:setString( coin )
	-- 初始化显示的牌
	self:loadaImagePoker()
	-- 初始加载51张牌
	self:addBeiPoker()
	-- 公主行走动画
	self:gongZhuMoveAction()
	-- 手指动画
	self:addHandAction()
end

function GamePlay:addHandAction()
	self.ImageHand:setVisible( true )
	local move_by1 = cc.MoveBy:create( 0.5,cc.p( 50,0 ) )
	local move_by2 = cc.MoveBy:create( 0.5,cc.p( -50,0 ) )
	local seq = cc.Sequence:create({ move_by1,move_by2 })
	local rep = cc.RepeatForever:create( seq )
	self.ImageHand:runAction( rep )
end

function GamePlay:removeHandAction()
	if self.ImageHand:isVisible() then
		self.ImageHand:stopAllActions()
		self.ImageHand:setVisible( false )
	end
end

function GamePlay:loadaImagePoker()
	local poker_num = self._pokerAllData[1]
	local path = twenty_one_poker_config[poker_num]
	self.ImagePoker:loadTexture( path,1 )
	self.ImagePoker:setVisible( true )

	table.remove( self._pokerAllData,1 )
	self._curPokerNum = poker_num
end


function GamePlay:touchPanel( index )
	self:removeHandAction()
	if self._pokerNone then
		return
	end

	if self._actionMark then
		return
	end

	self._actionMark = true

	table.insert( self["_pokerData"..index],self._curPokerNum )
	local len = #self["_pokerList"..index]
	-- 添加图片
	self.ImagePoker:setVisible( false )

	local path = twenty_one_poker_config[self._curPokerNum]
	local image_poker = ccui.ImageView:create( path,1 )
	self._csbNode:addChild( image_poker )
	image_poker:setPosition( cc.p( self.ImagePoker:getPosition() ) )
	table.insert( self["_pokerList"..index],image_poker )

	local panel_pos = cc.p( self["ButtonPanel"..index]:getPosition() )
	local end_pos = { 
		x = panel_pos.x,
		y = panel_pos.y + 140 - len * 40
	}

	local move_to = cc.MoveTo:create( 0.2,end_pos )
	local call_result = cc.CallFunc:create( function()
		self:calResult( index )
	end )
	local seq = cc.Sequence:create({ move_to,call_result })
	image_poker:runAction( seq )

	-- 添加新的翻牌
	if #self._pokerAllData == 0 then
		self._pokerNone = true
		return
	end
	self:refreshCurrentPoker( true )
end

function GamePlay:calResult( index )
	assert( index," !! index is nil !! " )
	-- 1:计算这行是否等于21点
	local has_twenty_one,m_type,m_score = self:calPoint( index )
	if has_twenty_one then
		self["TextScorePanel"..index]:setString( 0 )
		self:removePanelPoker( index )
		-- 爱心粒子效果
		self:addAiXin( 3 )
		-- 计算积分
		local org_score = self._score
		local add_score = self._metaScore
		self._curTiZi = self._curTiZi + 1

		local solder_move_two = false

		if self._curExtreTime > 0 then
			local rate_score = self._curExtreTime  / self._extreTime
			local extre_score = math.ceil( self._metaScore * rate_score )
			add_score = add_score + extre_score
			-- 额外爬一格
			self._curTiZi = self._curTiZi + 1
			solder_move_two = true
		end
		self._score = self._score + add_score
		-- 积分增长动画
		dynamicUpdateNum( self.TextScore,add_score,org_score )
		-- 士兵向上爬的动画
		self:solderMoveAction( solder_move_two )
		-- 进度条动画
		self:addExtreJinDuAction()
	else
		if m_type == "dayu" then
			self["TextScorePanel"..index]:setString( 0 )
			local call_set = function()
				self._actionMark = nil
			end
			self:removePanelPoker( index,call_set )
		else
			self["TextScorePanel"..index]:setString( m_score )
			self._actionMark = nil
		end
		-- 检查是否结束游戏
		performWithDelay( self,function()
			self:showGameOver()
		end,0.2 )
	end
end

function GamePlay:calPoint( index )
	assert( index," !! index is nil !! " )
	local result = {}
	local has_a = false
	for i,v in ipairs( self["_pokerData"..index] ) do
		local meta = twenty_one_num_config[v]
		if #meta == 2 then
			if #result > 0 then
				local one_ary = clone(result)
				for c = 1,#result do
					result[c] = result[c] + meta[1]
				end
				for c = 1,#one_ary do
					table.insert( result,one_ary[c] + meta[2] )
				end
			else
				result[1] = meta[1]
				result[2] = meta[2]
			end
			has_a = true
		else
			if #result > 0 then
				for c = 1,#result do
					result[c] = result[c] + meta[1]
				end
			else
				result[1] = 0
				result[1] = result[1] + meta[1]
			end
		end
	end
	-- 查找结果有没有等于21点的
	for i,v in ipairs( result ) do
		if v == 21 then
			return true
		end
	end

	if has_a then
		local temp = 0
		for i,v in ipairs( result ) do
			if v > temp and v < 21 then
				temp = v
			end
		end
		if temp ~= 0 then
			return false,"xiaoyu",temp
		else
			return false,"dayu",temp
		end
	else
		if result[1] > 21 then
			return false,"dayu",result[1]
		else
			return false,"xiaoyu",result[1]
		end
	end
end

function GamePlay:addBeiPoker()
	self.ImagePokerBei:setVisible( false )
	local pos = cc.p( self.ImagePokerBei:getPosition() )
	for i = 1,51 do
		local bei_poker = ccui.ImageView:create( "image/poker/bei.png",1 )
		self._csbNode:addChild(bei_poker)
		bei_poker:setPosition( pos.x - 0.5 * i,pos.y + 0.5 * i )
		bei_poker:setScale(0.5)
		self._beiPokerList[i] = bei_poker
	end
end

function GamePlay:removeBeiPoker()
	local len = #self._beiPokerList
	self._beiPokerList[len]:removeFromParent()
	self._beiPokerList[len] = nil
end

function GamePlay:removePanelPoker( index,callBack )
	for i,v in ipairs( self["_pokerList"..index] ) do
		local random_x = random( -200,200 )
		local random_y = random( -200,200 )
		local move_by = cc.MoveBy:create( 0.2,cc.p( random_x,random_y ) )
		local fade_out = cc.FadeOut:create( 0.2 )
		local spawn = cc.Spawn:create( { move_by,fade_out } )
		local call_set = cc.CallFunc:create( function()
			if i == #self["_pokerList"..index] then
				self["_pokerList"..index] = {}
				self["_pokerData"..index] = {}
				if callBack then
					callBack()
				end
			end
		end )
		local remove_self = cc.RemoveSelf:create()
		local seq = cc.Sequence:create({ spawn,call_set,remove_self })
		v:runAction( seq )
	end
end

function GamePlay:addAiXin( delayTime )
	self.ImageTiZi:stopAllActions()
	if self._aixinPs == nil then
		self._aixinPs = cc.ParticleSystemQuad:create("image/ainxin.plist")
		self._aixinPs:setPosition( cc.p(100,580) )
		self._csbNode:addChild( self._aixinPs )
	end
	self._aixinPs:setVisible( true )

	if delayTime and delayTime > 0 then
		performWithDelay( self.ImageTiZi,function()
			self._aixinPs:setVisible( false )
		end,delayTime )
	end
end

function GamePlay:gongZhuMoveAction()
	local move_right = cc.CallFunc:create( function()
		self:gongZhuMoveRightAction()
	end )
	local time_move = 1
	local move_by1 = cc.MoveBy:create( time_move * 4,cc.p(100,20))
	local move_by2 = cc.MoveBy:create( time_move * 4,cc.p(100,-20))
	local move_left = cc.CallFunc:create( function()
		self:gongZhuMoveLeftAction()
	end )
	local move_by3 = cc.MoveBy:create( time_move * 4,cc.p(-100,20))
	local move_by4 = cc.MoveBy:create( time_move * 4,cc.p(-100,-20))
	local seq_move = cc.Sequence:create({ move_right,move_by1,move_by2,move_left,move_by3,move_by4 })
	local rep_move =cc.RepeatForever:create( seq_move )
	self.NodeGongZhu:runAction( rep_move )
end

function GamePlay:gongZhuMoveRightAction()
	self.ImgGongZhu:stopAllActions()
	local actions = {}
	local time = 0.1
	for i = 1,4 do
		local delay = cc.DelayTime:create(time)
		local change_icon = cc.CallFunc:create( function()
			self.ImgGongZhu:loadTexture( "image/game/gongzhu"..i..".png",1 )
		end )
		table.insert( actions,delay )
		table.insert( actions,change_icon )
	end
	local seq = cc.Sequence:create(actions)
	local rep = cc.RepeatForever:create( seq )
	self.ImgGongZhu:runAction( rep )
end

function GamePlay:gongZhuMoveLeftAction()
	self.ImgGongZhu:stopAllActions()
	local actions = {}
	local time = 0.1
	for i = 5,7 do
		local delay = cc.DelayTime:create(time)
		local change_icon = cc.CallFunc:create( function()
			self.ImgGongZhu:loadTexture( "image/game/gongzhu"..i..".png",1 )
		end )
		table.insert( actions,delay )
		table.insert( actions,change_icon )
	end
	local seq = cc.Sequence:create(actions)
	local rep = cc.RepeatForever:create( seq )
	self.ImgGongZhu:runAction( rep )
end

function GamePlay:solderMoveAction( isMoveTwo )
	local rate = 1
	if isMoveTwo then
		rate = 2
	end
	local dis = self.ImageTiZi:getContentSize().height * rate
	self:solderFrameAction()
	local move_by = cc.MoveBy:create(0.5 * rate,cc.p(0,math.ceil( dis / self._totalTiZi)))
	local call = cc.CallFunc:create( function()
		self.ImageSolder:stopAllActions()
		self._actionMark = nil
		-- 检查是否结束游戏
		self:showGameOver()
	end )
	local seq = cc.Sequence:create({ move_by,call })
	self.NodeSolder:runAction( seq )
end

function GamePlay:solderFrameAction()
	self.ImageSolder:stopAllActions()
	local actions = {}
	local time = 0.1
	for i = 1,3 do
		local delay = cc.DelayTime:create(time)
		local change_icon = cc.CallFunc:create( function()
			self.ImageSolder:loadTexture( "image/game/qs"..i..".png",1 )
		end )
		table.insert( actions,delay )
		table.insert( actions,change_icon )
	end
	local seq = cc.Sequence:create(actions)
	local rep = cc.RepeatForever:create( seq )
	self.ImageSolder:runAction( rep )
end

function GamePlay:addExtreJinDuAction()
	self.ImgJinDuBg:setVisible( true )

	self.LoadingJinDu:stopAllActions()
	self._curExtreTime = self._extreTime
	self.LoadingJinDu:setPercent( 100 )

	local meta_time = 0.1 
	schedule( self.LoadingJinDu,function()
		self._curExtreTime = self._curExtreTime - meta_time
		local percent = self._curExtreTime / self._extreTime * 100
		self.LoadingJinDu:setPercent( percent )
		if self._curExtreTime <= 0 then
			self._curExtreTime = 0
			self.LoadingJinDu:stopAllActions()
			self.ImgJinDuBg:setVisible( false )
		end
	end,meta_time )
end

-- 刷新当前的扑克
function GamePlay:refreshCurrentPoker( removeBei )
	local first_poker_num = self._pokerAllData[1]
	local first_path = twenty_one_poker_config[first_poker_num]
	local first_image_poker = ccui.ImageView:create( first_path,1 )
	self._csbNode:addChild( first_image_poker )
	first_image_poker:setPosition( cc.p( self.ImagePokerBei:getPosition() ) )
	local first_move_to = cc.MoveTo:create( 0.2,cc.p( self.ImagePoker:getPosition() ) )
	local first_call_show = cc.CallFunc:create( function()
		self:loadaImagePoker()
		if removeBei then
			self:removeBeiPoker()
		end
	end )
	local first_remove = cc.RemoveSelf:create()
	local seq = cc.Sequence:create({ first_move_to,first_call_show,first_remove })
	first_image_poker:runAction( seq )
end

function GamePlay:refreshPoker()
	local has_coin = G_GetModel("Model_TwentyOne"):getCoin()
	if has_coin >= 100 then
		-- 将当前扑克插入
		table.insert( self._pokerAllData,self._curPokerNum )
		-- 去掉金币
		G_GetModel("Model_TwentyOne"):setCoin( -100 )
		local coin = G_GetModel("Model_TwentyOne"):getCoin()
		self.TextCoin:setString( coin )

		-- 执行动画
		local bei_poker = ccui.ImageView:create( "image/poker/bei.png",1 )
		self._csbNode:addChild(bei_poker)
		bei_poker:setPosition( self.ImagePoker:getPosition() )
		bei_poker:setScale(0.5)
		self.ImagePoker:setVisible( false )

		local move_to = cc.MoveTo:create(0.2,cc.p( self.ImagePokerBei:getPosition() ))
		local call_reset = cc.CallFunc:create( function()
			self:refreshCurrentPoker()
		end )
		local remove = cc.RemoveSelf:create()
		local seq = cc.Sequence:create({ move_to,call_reset,remove })
		bei_poker:runAction( seq )
	else
		-- 弹出商店购买界面
		addUIToScene( UIDefine.TWENTYONE_KEY.Shop_UI )
	end
end

function GamePlay:showGameOver()
	-- 检查是否结束游戏
	if self._curTiZi >= self._totalTiZi then
		-- 通关
		self.ImgGongZhu:stopAllActions()
		self.NodeGongZhu:stopAllActions()
		self.NodeSolder:setVisible( false )
		self.ImgJinDuBg:setVisible( false )
		self.LoadingJinDu:stopAllActions()

		self.ImgGongZhu:loadTexture("image/game/qishigongzhu.png",1)
		self.NodeGongZhu:setPositionX( 120 )
		self:addAiXin()

		performWithDelay( self._csbNode,function()
			local data = { score = self._score }
			addUIToScene( UIDefine.TWENTYONE_KEY.Pass_UI,data )
		end,2 )

		-- 存储记录
		G_GetModel("Model_TwentyOne"):saveRecordList( self._score )
	else
		if self._pokerNone then
			-- 游戏结束
			local data = { score = self._score }
			addUIToScene( UIDefine.TWENTYONE_KEY.Over_UI,data )
			self.ImgJinDuBg:setVisible( false )
			self.LoadingJinDu:stopAllActions()
			self.ImgGongZhu:stopAllActions()
			self.NodeGongZhu:stopAllActions()
			-- 存储记录
			G_GetModel("Model_TwentyOne"):saveRecordList( self._score )
		end
	end
end

function GamePlay:addListener()
	self:addMsgListener(InnerProtocol.INNER_EVENT_TWENTYONE_REFRESH_COIN,function()
		local coin = G_GetModel("Model_TwentyOne"):getCoin()
		self.TextCoin:setString( coin )
	end )
end


return GamePlay