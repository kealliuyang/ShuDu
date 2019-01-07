
--
-- Author: 刘阳
-- Date: 2018-09-15
-- 

--[[
	注: 注册的时候key必须value 同名
]]

local InnerProtocol = {
	INNER_EVENT_GUID_2         												= "INNER_EVENT_GUID_2",
	INNER_EVENT_GUID_3         												= "INNER_EVENT_GUID_3",
	INNER_EVENT_GUID_4         												= "INNER_EVENT_GUID_4",
	INNER_EVENT_EL_REPLAY      												= "INNER_EVENT_EL_REPLAY",
	INNER_EVENT_EL_GENERAL_CONTINUE_DATA									= "INNER_EVENT_EL_GENERAL_CONTINUE_DATA",
	INNER_EVENT_EL_ADVANCED_CONTINUE_DATA                                   = "INNER_EVENT_EL_ADVANCED_CONTINUE_DATA",
}














rawset(_G, "InnerProtocol", InnerProtocol)