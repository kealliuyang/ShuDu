


local LevelUnit = class("LevelUnit",BaseNode)


function LevelUnit:ctor( parentPanel )
	self._parentPanel = parentPanel
	LevelUnit.super.ctor( self,"LevelUnit" )
	self:addCsb( "csbtwentyfour/NodeLevelUnit.csb" )
end


function LevelUnit:loadDataUi( data,level,point )
	self:clearUiState()
	-- bg
	local cur_level,cur_point = G_GetModel("Model_TwentyFour"):getLevelAndPoint()
	if level > cur_level then
		self.BgLocked:setVisible( true )
		self.LockIcon:setVisible( true )
	elseif level == cur_level then
		if point - 1 > cur_point then
			self.BgLocked:setVisible( true )
			self.LockIcon:setVisible( true )
		elseif point - 1 == cur_point then
			self.BgUnlock:setVisible( true )
			self.TextLevel:setVisible( true )
			self.TextLevel:setString( point )
		else
			self.BgPass:setVisible( true )
			self.TextLevel:setVisible( true )
			self.TextLevel:setString( point )
		end
	else
		self.BgPass:setVisible( true )
		self.TextLevel:setVisible( true )
		self.TextLevel:setString( point )
	end

	if level == 1 and point == 1 then
		self.Learning:setVisible( true )
		self.TextLevel:setVisible( false )
	end

	if point == 20 then
		self.TextLevel:setVisible( false )
		if level ~= #tf_quest_config then
			self.ExamIcon:setVisible( true )
			self.LockIcon:setVisible( false )
			if cur_level > level then
				self.ExamIcon:loadTexture("image/2/exam_unlock.png",1)
			elseif cur_level == level then
				if cur_point == 20 then
					self.ExamIcon:loadTexture("image/2/exam_unlock.png",1)
				else
					self.ExamIcon:loadTexture("image/2/exam_locked.png",1)
				end
			else
				self.ExamIcon:loadTexture("image/2/exam_locked.png",1)
			end
		else
			self.ExamIcon:setVisible( false )
			self.LockIcon:setVisible( true )
		end
	end
end

function LevelUnit:openGameLayer()
	
end


function LevelUnit:clearUiState()
	self.BgLocked:setVisible( false )
	self.BgPass:setVisible( false )
	self.BgUnlock:setVisible( false )
	self.Learning:setVisible( false )
	self.LockIcon:setVisible( false )
	self.TextLevel:setVisible( false )
	self.ExamIcon:setVisible( false )
end

function LevelUnit:getDesignSize()
	return self.RootPanel:getContentSize()
end

return LevelUnit