
local GameTest = class("GameTest",BaseLayer)

function GameTest:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    GameTest.super.ctor( self,param.name )
    self:addCsb( "csbmajiang/GameTest.csb" )
end


return GameTest