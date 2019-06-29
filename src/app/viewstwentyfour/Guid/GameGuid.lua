
local GameGuid = class("GameGuid",BaseLayer)


function GameGuid:ctor( param )
	assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    self._param = param
    GameGuid.super.ctor( self,param.name )
    self:addCsb( "csbtwentyfour/LayerGameGuid.csb",1 )

    self._gameLayer = self._param.data.playPanel

    for i = 1,4 do
    	self:addNodeClick( self["Poker"..i],{ 
	        endCallBack = function() self:clickPokerPanel(i) end,
	        voicePath = "tfmp3/card.mp3"
	    })
	    self:addNodeClick( self["OpPanel"..i],{ 
	        endCallBack = function() self:clickOpPanel(i) end,
	        voicePath = "tfmp3/card.mp3"
	    })
    end
    -- 执行第一步
    self:excutionGuid(1)
end

function GameGuid:excutionGuid( guidStep )
	-- 第一步 指向13
	self._guidStep = guidStep
	if self._guidStep == 1 then
		self:showTipAction( self["Poker3"],3,"poker" )
		return
	end
	-- 第二步 指向"-""
	if self._guidStep == 2 then
		self:showTipAction( self["OpPanel2"],2,"operation" )
		return
	end
	-- 第三步 指向1
	if self._guidStep == 3 then
		self:showTipAction( self["Poker1"],1,"poker" )
		return
	end
	-- 第四步 指向第二个13
	if self._guidStep == 4 then
		self:showTipAction( self["Poker4"],4,"poker" )
		return
	end
	-- 第五步 指向"-"
	if self._guidStep == 5 then
		self:showTipAction( self["OpPanel2"],2,"operation" )
		return
	end
	-- 第六步 指向1
	if self._guidStep == 6 then
		self:showTipAction( self["Poker2"],2,"poker" )
		return
	end
	-- 第七步 指向"+"
	if self._guidStep == 7 then
		self:showTipAction( self["OpPanel1"],1,"operation" )
		return
	end
	-- 第八步 指向"12"
	if self._guidStep == 8 then
		self:showTipAction( self["Poker1"],1,"poker",3 )
		return
	end
	-- 第九步 结束
	if self._guidStep == 9 then
		removeUIFromScene( UIDefine.TWENTYFOUR_KEY.Guid_UI )
		return
	end
end

--[[
	index:poker的第几个位置
]]
function GameGuid:showTipAction( panel,index,panelType,panelIndex )
	if self._dirTip == nil then
		self._dirTip = ccui.ImageView:create("image/3/yindao.png",1)
		self.MidPanel:addChild( self._dirTip )
	end
	self._dirTip:stopAllActions()
	local move_by1 = cc.MoveBy:create(1,cc.p(0,50))
	local move_by2 = cc.MoveBy:create(1,cc.p(0,-50))
	local move_by3 = cc.MoveBy:create(1,cc.p(0,50))
	local move_by4 = cc.MoveBy:create(1,cc.p(0,-50))
	local delay1 = cc.DelayTime:create(1)
	-- 发送消息 执行scale
	local action_call = cc.CallFunc:create( function()
		if panelType == "poker" then
			if panelIndex then
				self:pokerAction(panelIndex)
			else
				self:pokerAction(index)
			end
		elseif panelType == "operation" then
			self:operationAction( index )
		end
	end )
	local delay2 = cc.DelayTime:create(3)
	local seq = cc.Sequence:create({ 
		move_by1,move_by2,move_by3,move_by4,
		delay1,action_call,delay2
	})
	local rep = cc.RepeatForever:create( seq )
	self._dirTip:runAction( rep )
	-- 设置位置
	local panel_pos = cc.p(panel:getPosition())
	local panel_size = panel:getContentSize()
	panel_pos.y = panel_pos.y + panel_size.height / 2 + 30
	self._dirTip:setPosition( panel_pos )
end

function GameGuid:pokerAction( pokerIndex )
	local poker_panel = self._gameLayer["Poker"..pokerIndex]
	poker_panel:stopAllActions()
	local scale_to1 = cc.ScaleTo:create(0.5,1.1)
	local scale_to2 = cc.ScaleTo:create(0.5,1)
	local scale_to3 = cc.ScaleTo:create(0.5,1.1)
	local scale_to4 = cc.ScaleTo:create(0.5,1)
	local seq = cc.Sequence:create( { scale_to1,scale_to2,scale_to3,scale_to4 } )
	poker_panel:runAction( seq )
end

function GameGuid:operationAction( operationIndex )
	local operation_button = nil
	if operationIndex == 1 then
		operation_button = self._gameLayer.ButtonAdd
	elseif operationIndex == 2 then
		operation_button = self._gameLayer.ButtonReduce
	end
	if not operation_button then
		return
	end
	operation_button:stopAllActions()
	local scale_to1 = cc.ScaleTo:create(0.5,0.9)
	local scale_to2 = cc.ScaleTo:create(0.5,1)
	local scale_to3 = cc.ScaleTo:create(0.5,0.9)
	local scale_to4 = cc.ScaleTo:create(0.5,1)
	local seq = cc.Sequence:create( { scale_to1,scale_to2,scale_to3,scale_to4 } )
	operation_button:runAction( seq )
end


function GameGuid:clickPokerPanel( index )
	if index == 3 and self._guidStep == 1 then
		-- 设置选中
		self._gameLayer:clickPoker( index )
		-- 执行下一步guid
		self:excutionGuid(2)
		return
	end
	if index == 1 and self._guidStep == 3 then
		-- 执行结果
		self._gameLayer:clickPoker( index )
		-- 执行下一步guid
		self:excutionGuid(4)
		return
	end
	if index == 4 and self._guidStep == 4 then
		-- 设置选中
		self._gameLayer:clickPoker( index )
		-- 执行下一步guid
		self:excutionGuid(5)
		return
	end
	if index == 2 and self._guidStep == 6 then
		-- 执行结果
		self._gameLayer:clickPoker( index )
		-- 执行下一步guid
		self:excutionGuid(7)
		return
	end
	if index == 1 and self._guidStep == 8 then
		-- 执行结果
		self._gameLayer:clickPoker( 3 )
		-- 执行下一步guid
		self:excutionGuid(9)
		return
	end
end


function GameGuid:clickOpPanel( index )
	if index == 2 and self._guidStep == 2 then
		-- 设置"-"的button选中
		self._gameLayer["ButtonReduce"]:stopAllActions()
		self._gameLayer["ButtonReduce"]:setScale(1)
		self._gameLayer:reduce()
		-- 执行下一步guid
		self:excutionGuid(3)
		return
	end
	if index == 2 and self._guidStep == 5 then
		-- 设置"-"的button选中
		self._gameLayer["ButtonReduce"]:stopAllActions()
		self._gameLayer["ButtonReduce"]:setScale(1)
		self._gameLayer:reduce()
		-- 执行下一步guid
		self:excutionGuid(6)
		return
	end
	if index == 1 and self._guidStep == 7 then
		-- 设置"+"的button选中
		self._gameLayer["ButtonAdd"]:stopAllActions()
		self._gameLayer["ButtonAdd"]:setScale(1)
		self._gameLayer:add()
		-- 执行下一步guid
		self:excutionGuid(8)
		return
	end
end



return GameGuid