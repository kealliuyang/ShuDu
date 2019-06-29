
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
	INNER_EVENT_EL_CONTINUE_PLAY											= "INNER_EVENT_EL_CONTINUE_PLAY",
	INNER_EVENT_EL_GENERAL_CONTINUE_DATA									= "INNER_EVENT_EL_GENERAL_CONTINUE_DATA",
	INNER_EVENT_EL_ADVANCED_CONTINUE_DATA                                   = "INNER_EVENT_EL_ADVANCED_CONTINUE_DATA",
	INNER_EVENT_TF_GUID                                                     = "INNER_EVENT_TF_GUID",
	INNER_EVENT_MAJIANG_GAMEOVER                                            = "INNER_EVENT_MAJIANG_GAMEOVER",
	INNER_EVENT_MAJIANG_PLAYER_GANG                                         = "INNER_EVENT_MAJIANG_PLAYER_GANG",
	INNER_EVENT_MAJIANG_PLAYER_PENG                                         = "INNER_EVENT_MAJIANG_PLAYER_PENG",
	INNER_EVENT_MAJIANG_MO_CARD                                             = "INNER_EVENT_MAJIANG_MO_CARD",
	INNER_EVENT_MAJIANG_AI_TURN                                             = "INNER_EVENT_MAJIANG_AI_TURN",
	INNER_EVENT_MAJIANG_AI_GANG                                         	= "INNER_EVENT_MAJIANG_AI_GANG",
	INNER_EVENT_MAJIANG_AI_PENG                                         	= "INNER_EVENT_MAJIANG_AI_PENG",
	INNER_EVENT_MAJIANG_AI_OUT_CARD                                         = "INNER_EVENT_MAJIANG_AI_OUT_CARD",
	INNER_EVENT_MAJIANG_PLAYER_TURN                                         = "INNER_EVENT_MAJIANG_PLAYER_TURN",
	INNER_EVENT_MAJIANG_PLAYER_HU                                           = "INNER_EVENT_MAJIANG_PLAYER_HU",
	INNER_EVENT_MAJIANG_ADD_RATE                                            = "INNER_EVENT_MAJIANG_ADD_RATE",
	INNER_EVENT_LAOHUJI_RESETSTART											= "INNER_EVENT_LAOHUJI_RESETSTART",
	INNER_EVENT_TWENTYONE_REFRESH_COIN										= "INNER_EVENT_TWENTYONE_REFRESH_COIN",
	INNER_EVENT_LABA_REEL_ROOL_DOWN										    = "INNER_EVENT_LABA_REEL_ROOL_DOWN",
	INNER_EVENT_LABA_BUY_COIN												= "INNER_EVENT_LABA_BUY_COIN",
}














rawset(_G, "InnerProtocol", InnerProtocol)