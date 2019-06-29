
local MainCell  = class("MainCell",BaseNode)


function MainCell:ctor( parentPanel )
	self._parentPanel = parentPanel
	MainCell.super.ctor( self,"MainCell" )
	self:addCsb( "csblaohuji/AchieveCell.csb" )
end

function MainCell:loadDataUi( data,index )
	assert( data," !! data is nil !! ")
	assert( index," !! index is nil !! ")
	self:clearUIState()
	self._data = data
	self._index = index
	-- bg index
	if index <= 2 then
		self.BgIndex:loadTexture( "image/achievement/tupian"..index..".png",1 )

		self.TextTitle1:setVisible( true )
		self.TextTitle2:setVisible( true )
		self.TextTitle3:setVisible( true )

		self.TextTitle2:setString( data.desc )
		self.TextTitle3:setPositionX( self.TextTitle2:getPositionX() + self.TextTitle2:getContentSize().width )
	else
		self.BgIndex:loadTexture( "image/achievement/tupian3.png",1 )

		self.TextTitle4:setVisible( true )
		self.TextTitle5:setVisible( true )
		self.TextTitle4:setString( data.name )
		self.TextTitle5:setString( data.desc )
	end
	
	self.TextCoin:setString( data.coin )

	self:loadState( index )
end

function MainCell:loadState( index )
	if index == 1 then
		-- 解锁动物城
		local is_open =  G_GetModel("Model_LaoHuJi"):isAnimalOpen()
		if is_open then
			local is_get =  G_GetModel("Model_LaoHuJi"):isAchievementGet( index )
			if is_get then
				self.State3:setVisible( true )
			else
				self.ButtonState1:setVisible( true )
			end
		else
			self.State2:setVisible( true )
		end
	elseif index == 2 then
		local is_open =  G_GetModel("Model_LaoHuJi"):isSeabedOpen()
		if is_open then
			local is_get =  G_GetModel("Model_LaoHuJi"):isAchievementGet( index )
			if is_get then
				self.State3:setVisible( true )
			else
				self.ButtonState1:setVisible( true )
			end
		else
			self.State2:setVisible( true )
		end
	elseif index == 3 or index == 4 then
		local high_coin = G_GetModel("Model_LaoHuJi"):getHighCoin()
		local need_num = lhj_achement_config[index].need_num
		if high_coin < need_num then
			self.State2:setVisible( true )
		else
			local is_get =  G_GetModel("Model_LaoHuJi"):isAchievementGet( index )
			if is_get then
				self.State3:setVisible( true )
			else
				self.ButtonState1:setVisible( true )
			end
		end
	elseif index == 5 or index == 6 then
		local lianxu_yazhong = G_GetModel("Model_LaoHuJi"):getLianXuYaZhong()
		local need_num = lhj_achement_config[index].need_num
		if lianxu_yazhong < need_num then
			self.State2:setVisible( true )
		else
			local is_get =  G_GetModel("Model_LaoHuJi"):isAchievementGet( index )
			if is_get then
				self.State3:setVisible( true )
			else
				self.ButtonState1:setVisible( true )
			end
		end
	elseif index == 7 or index == 8 then
		local leiji_yazhong = G_GetModel("Model_LaoHuJi"):geLeiJiYaZhong()
		local need_num = lhj_achement_config[index].need_num
		if leiji_yazhong < need_num then
			self.State2:setVisible( true )
		else
			local is_get =  G_GetModel("Model_LaoHuJi"):isAchievementGet( index )
			if is_get then
				self.State3:setVisible( true )
			else
				self.ButtonState1:setVisible( true )
			end
		end
	elseif index == 9 or index == 10 then
		local play_times = G_GetModel("Model_LaoHuJi"):gePlayTimes()
		local need_num = lhj_achement_config[index].need_num
		if play_times < need_num then
			self.State2:setVisible( true )
		else
			local is_get =  G_GetModel("Model_LaoHuJi"):isAchievementGet( index )
			if is_get then
				self.State3:setVisible( true )
			else
				self.ButtonState1:setVisible( true )
			end
		end
	end
end

function MainCell:getIndex()
	return self._index
end

function MainCell:getData()
	return self._data
end

function MainCell:clearUIState()
	self.ButtonState1:setVisible( false )
	self.State2:setVisible( false )
	self.State3:setVisible( false )

	self.TextTitle1:setVisible( false )
	self.TextTitle2:setVisible( false )
	self.TextTitle3:setVisible( false )
	self.TextTitle4:setVisible( false )
	self.TextTitle5:setVisible( false )
end


return MainCell