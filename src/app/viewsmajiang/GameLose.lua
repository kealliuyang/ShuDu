
local GameLose = class("GameLose",BaseLayer)

function GameLose:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameLose.super.ctor( self,param.name )

    self._param = param

    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 150))
    self:addChild( layer )

    self:addCsb( "csbmajiang/GameLose.csb" )

    -- 关闭
    self:addNodeClick( self.ButtonClose,{ 
        endCallBack = function() self:close() end
    })
    -- 再来一局
    self:addNodeClick( self.ButtonAgain,{ 
        endCallBack = function() self:again() end
    })

    self:loadUIData()
end


function GameLose:onEnter()
    GameLose.super.onEnter( self )
    audio.playSound("mjmp3/ef_lose.mp3", false)
    -- 播放动画
    self:enterAction()
end

function GameLose:enterAction()
    self.BgTitle:setVisible( false )
    self.ButtonAgain:setVisible( false )
    self.Bg1:setScale( 3 )

    self.TextBeiShu:setVisible( false )

    local scale_to = cc.ScaleTo:create(0.2,1)
    local call_back = cc.CallFunc:create( function()
        self.BgTitle:setVisible( true )
        -- 显示被数数据
        self:showTextAction()
        -- 显示增加的积分动画
        self:addScoreAction()
        -- 显示再玩一次的按钮
        self.ButtonAgain:setVisible( true )
    end )
    local seq = cc.Sequence:create( { scale_to,call_back } )
    self.Bg1:runAction( seq )
end

function GameLose:loadUIData()
    local result_data = self._param.data
    self.TextDiScore:setString( result_data.di_score )
    self._texts = {}
    local dis = 30
    -- 门清
    if result_data.men_qing then
        local text_men_qing = self.TextBeiShu:clone()
        self.MidPanel:addChild( text_men_qing )
        text_men_qing:setString("门清:  X2")
        text_men_qing:setPositionY( text_men_qing:getPositionY() - #self._texts * dis )
        table.insert( self._texts,text_men_qing )
    end
    -- 天胡
    if result_data.tian_hu then
        local text_tian_hu = self.TextBeiShu:clone()
        self.MidPanel:addChild( text_tian_hu )
        text_tian_hu:setString("天胡:  X8")
        text_tian_hu:setPositionY( text_tian_hu:getPositionY() - #self._texts * dis )
        table.insert( self._texts,text_tian_hu )
    end
    -- 自摸
    if result_data.zi_mo then
        local text_zi_mo = self.TextBeiShu:clone()
        self.MidPanel:addChild( text_zi_mo )
        text_zi_mo:setString("自摸:  X2")
        text_zi_mo:setPositionY( text_zi_mo:getPositionY() - #self._texts * dis )
        table.insert( self._texts,text_zi_mo )
    end
    -- 杠牌
    if result_data.gang_num and result_data.gang_num > 0 then
        local text_gang_pai = self.TextBeiShu:clone()
        self.MidPanel:addChild( text_gang_pai )
        text_gang_pai:setString("杠牌:  X"..(2 * result_data.gang_num))
        text_gang_pai:setPositionY( text_gang_pai:getPositionY() - #self._texts * dis )
        table.insert( self._texts,text_gang_pai )
    end
    -- 加倍
    if result_data.add_rate and result_data.add_rate > 0 then
        local text_add_rate = self.TextBeiShu:clone()
        self.MidPanel:addChild( text_add_rate )
        text_add_rate:setString("加倍:  X"..result_data.add_rate)
        text_add_rate:setPositionY( text_add_rate:getPositionY() - #self._texts * dis )
        table.insert( self._texts,text_add_rate )
    end
    -- 连庄数
    if result_data.lian_zhuang and result_data.lian_zhuang > 1 then
        local text_lian_zhuang = self.TextBeiShu:clone()
        self.MidPanel:addChild( text_lian_zhuang )
        text_lian_zhuang:setString("连庄:  X"..result_data.lian_zhuang)
        text_lian_zhuang:setPositionY( text_lian_zhuang:getPositionY() - #self._texts * dis )
        table.insert( self._texts,text_lian_zhuang )
    end
    -- 全部隐藏 用于执行动画
    for i,v in ipairs( self._texts ) do
        v:setVisible( false )
    end
end

function GameLose:showTextAction()
    for i,v in ipairs( self._texts ) do
        local actions = {}
        local delay_time = cc.DelayTime:create( 0.3 * (i-1) )
        local call_show = cc.CallFunc:create( function()
            v:setVisible( true )
            v:setPositionX( v:getPositionX() + 100 )
        end )
        local moveBy = cc.MoveBy:create(0.5,cc.p(-100,0))
        table.insert( actions,delay_time )
        table.insert( actions,call_show )
        table.insert( actions,moveBy )
        local seq = cc.Sequence:create( actions )
        v:runAction( seq )
    end
end

function GameLose:addScoreAction()
    local add_score = G_GetModel("Model_MaJiang"):calAddScoreByResult( self._param.data )
    dynamicUpdateNum( self.TextScore,add_score,0,function()
        self.TextScore:setString("-"..add_score)
        -- 显示破产界面
        if self._param.data.po_chan then
            removeUIFromScene( UIDefine.MAJIANG_KEY.Lose_UI )
            addUIToScene( UIDefine.MAJIANG_KEY.PoChan_UI )
        end
    end )
end

function GameLose:again()
    removeUIFromScene( UIDefine.MAJIANG_KEY.Lose_UI )
    removeUIFromScene( UIDefine.MAJIANG_KEY.Play_UI )
    addUIToScene( UIDefine.MAJIANG_KEY.Play_UI )
end

-- 关闭
function GameLose:close()
    removeUIFromScene( UIDefine.MAJIANG_KEY.Lose_UI )
    removeUIFromScene( UIDefine.MAJIANG_KEY.Play_UI )
    addUIToScene( UIDefine.MAJIANG_KEY.Start_UI )
end



return GameLose