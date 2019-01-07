
local UIDefine = class("UIDefine")


UIDefine.LayerFlag = {
	Main 		= { name = "Main",		order = 1 },					-- 1:创建主界面层(可以是世界层 地图层)
	UI   		= { name = "UI",		order = 2 },					-- 2:创建UI层
	Dialog	    = { name = "Dialog",	order = 3 },					-- 3:创建dialog层
	Notice      = { name = "Notice",    order = 4 },					-- 4:创建消息层(类似世界跑马灯之类的)
	Guid        = { name = "Guid",      order = 5 },					-- 5:创建新手引导层
	Loading     = { name = "Loading",   order = 6 }						-- 6:创建网络loading层
}

-- 数独的ui
UIDefine.UI_KEY = {
	Start_UI    = { layer = import("app.views.GameStart"),					flag = UIDefine.LayerFlag.Main.name,	name = "Start_UI"},
	Main_UI		= { layer = import("app.views.GameLayer"),					flag = UIDefine.LayerFlag.Main.name,	name = "Main_UI" },
	Editor_UI	= { layer = import("app.views.GameEditor"),					flag = UIDefine.LayerFlag.Main.name,	name = "Editor_UI" },
	Select_UI	= { layer = import("app.views.SelectLevel.Main"),			flag = UIDefine.LayerFlag.Main.name,	name = "Select_UI" },
	Ready_UI	= { layer = import("app.views.GameReady"),					flag = UIDefine.LayerFlag.Main.name,	name = "Ready_UI" },
	Next_UI	    = { layer = import("app.views.GameNext"),					flag = UIDefine.LayerFlag.Main.name,	name = "Next_UI" },
	Help_UI	    = { layer = import("app.views.GameHelp"),					flag = UIDefine.LayerFlag.Main.name,	name = "Help_UI" },
	Set_UI	    = { layer = import("app.views.GameSet"),					flag = UIDefine.LayerFlag.Main.name,	name = "Set_UI" },
	Record_UI	= { layer = import("app.views.Record.Main"),				flag = UIDefine.LayerFlag.Main.name,	name = "Record_UI" },
	Guid1_UI	= { layer = import("app.views.Guid.Guid1"),				    flag = UIDefine.LayerFlag.Guid.name,	name = "Guid1_UI" },
	Guid2_UI	= { layer = import("app.views.Guid.Guid2"),				    flag = UIDefine.LayerFlag.Guid.name,	name = "Guid2_UI" },
	Guid3_UI	= { layer = import("app.views.Guid.Guid3"),				    flag = UIDefine.LayerFlag.Guid.name,	name = "Guid3_UI" },
	Guid4_UI	= { layer = import("app.views.Guid.Guid4"),				    flag = UIDefine.LayerFlag.Guid.name,	name = "Guid4_UI" },
}

-- 消除的ui
UIDefine.ELIMI_KEY = {
	Start_UI    	= { layer = import("app.viewseliminate.GameStart"),			flag = UIDefine.LayerFlag.Main.name,	name = "Elimi_Start_UI"},
	Play_UI			= { layer = import("app.viewseliminate.GamePlay"),			flag = UIDefine.LayerFlag.Main.name,	name = "Elimi_Play_UI" },
	GameOver_UI		= { layer = import("app.viewseliminate.GameOver"),			flag = UIDefine.LayerFlag.Main.name,	name = "Elimi_GameOver_UI" },
	GamePause_UI	= { layer = import("app.viewseliminate.GamePause"),			flag = UIDefine.LayerFlag.Main.name,	name = "Elimi_GamePause_UI" },
	Advanced_UI		= { layer = import("app.viewseliminate.GameAdvanced"),		flag = UIDefine.LayerFlag.Main.name,	name = "Elimi_Advanced_UI" },
	Record_UI		= { layer = import("app.viewseliminate.rank.RankMain"),		flag = UIDefine.LayerFlag.Main.name,	name = "Elimi_Record_UI" },
	GameNotPut_UI   = { layer = import("app.viewseliminate.GameNotPut"),		flag = UIDefine.LayerFlag.Main.name,	name = "Elimi_GameNotPut_UI" },
}






rawset(_G,"UIDefine",UIDefine)