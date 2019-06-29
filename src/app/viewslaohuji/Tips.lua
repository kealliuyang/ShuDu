
local Tips = class( "Tips",BaseNode )





function Tips:ctor()
	Tips.super.ctor( self,"Tips" )
	self:addCsb( "csblaohuji/ShowTips.csb" )
end


function Tips:loadUIData( str )
	assert( str," !! str is nil !! " )
	self.TextDesc:setString( str )
end





return Tips