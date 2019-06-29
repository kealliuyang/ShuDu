


local LevelCell = class("LevelCell",BaseNode)


function LevelCell:ctor( parentPanel )
	self._parentPanel = parentPanel
	LevelCell.super.ctor( self,"LevelCell" )
	self:addCsb( "csb/NodeLevel.csb" )
end


function LevelCell:loadDataUi( num )
	self:clearUiState()
	self._num = num
	self.TextNum:setString(num)

	-- bg
	local index = math.ceil(num/100)
	local path = string.format("image/select/guanqia_%s.png",index)
	self.BgNormal:loadTexture(path,1)

	local is_pass = G_GetModel("Model_Player"):isPassLevel(num)
	local pass_level = G_GetModel("Model_Player"):getPassLevel()
	if is_pass then
		self.IconPass:setVisible(true)
		self.TextNum:setVisible(true)
	else
		if self._num == pass_level + 1 then
			self.IconTextLock:loadTexture("image/select/unlock-"..index..".png",1)
			self.TextNum:setVisible(true)
		else
			self.IconTextLock:loadTexture("image/select/locked-"..index..".png",1)
			self.BgMask:setVisible(true)
			self.IconLock:setVisible(true)
		end
	end
end

function LevelCell:openGameLayer()
	-- 检查是否解锁
	if G_GetModel("Model_Player"):getPassLevel() + 1 < self._num then
		return
	end
	local data = { level = self._num }
	addUIToScene( UIDefine.UI_KEY.Main_UI,data )
	-- 添加新手引导
	if not G_GetModel("Model_Player"):isPassGuid() then
    	addUIToScene( UIDefine.UI_KEY.Guid1_UI )
    else
    	-- addUIToScene( UIDefine.UI_KEY.Ready_UI )
	end
	removeUIFromScene( UIDefine.UI_KEY.Select_UI )
end


function LevelCell:clearUiState()
	self.IconLock:setVisible(false)
	self.BgMask:setVisible(false)
	self.IconPass:setVisible(false)
	self.TextNum:setVisible(false)
end



return LevelCell