


local SelectPeople = class("SelectPeople",BaseLayer)



function SelectPeople:ctor( param )
    assert( param," !! param is nil !! ")
    assert( param.name," !! param.name is nil !! ")
    SelectPeople.super.ctor( self,param.name )
    self:addCsb( "csbjunshi/SelectPeople.csb" )

    for i = 1,6 do
    	self:addNodeClick( self["Button"..i],{ 
	        endCallBack = function() self:clickSelect( i ) end
	    })
    end
end



function SelectPeople:clickSelect( index )
	removeUIFromScene( UIDefine.JUNSHI_KEY.Select_UI )
	addUIToScene( UIDefine.JUNSHI_KEY.Play_UI,index )
end


















return SelectPeople