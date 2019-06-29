


local SelectColor = class("SelectColor",BaseLayer)



function SelectColor:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    SelectColor.super.ctor( self,param.name )

    local layer = cc.LayerColor:create( cc.c4b( 0,0,0,150 ) )
    self:addChild( layer )
    
    self:addCsb( "csbsanguo/Select.csb" )


    self._callBack = param.data.callBack

    for i = 1,4 do
    	self:addNodeClick( self["Image"..i],{ 
	        endCallBack = function() self:clickSelect( i ) end
	    })
    end
end



function SelectColor:clickSelect( index )
    local color_num_index = 96 + index * 2
    self._callBack( color_num_index )
    removeUIFromScene( UIDefine.SANGUO_KEY.Select_UI )
end










return SelectColor