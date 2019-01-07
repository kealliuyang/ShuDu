
local MainCell  = class("MainCell",BaseNode)


function MainCell:ctor( parentPanel )
	self._parentPanel = parentPanel
	MainCell.super.ctor( self,"MainCell" )
	self:addCsb( "csb/NodeRecordCell.csb" )
end

function MainCell:loadDataUi( data,index )
	assert( data," !! data is nil !! ")
	assert( index," !! index is nil !! ")
	-- bg
	if index % 2 == 0 then
		self.Bg:loadTexture("image/record/01.png",1)
	else
		self.Bg:loadTexture("image/record/02.png",1)
	end
	-- level
	self.TextLevel:setString(data.level)
	-- record
	self.TextRecord:setString(formatTimeStr(data.passTime,":"))
	-- time
	self.TextTime:setString(os.date("%Y.%m.%d %H:%M:%S", data.recordTime))
end



return MainCell