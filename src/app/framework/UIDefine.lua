
local UIDefine = class("UIDefine")


UIDefine.LayerFlag = {
	Main 		= { name = "Main",		order = 1 },					-- 1:创建主界面层(可以是世界层 地图层)
	UI   		= { name = "UI",		order = 2 },					-- 2:创建UI层
	Dialog	    = { name = "Dialog",	order = 3 },					-- 3:创建dialog层
	Notice      = { name = "Notice",    order = 4 },					-- 4:创建消息层(类似世界跑马灯之类的)
	Guid        = { name = "Guid",      order = 5 },					-- 5:创建新手引导层
	Loading     = { name = "Loading",   order = 6 }						-- 6:创建网络loading层
}


-- -- 数独的ui
-- UIDefine.UI_KEY = {
-- 	Start_UI    = { layer = import("app.views.GameStart"),					flag = UIDefine.LayerFlag.Main.name,	name = "Start_UI"},
-- 	Main_UI		= { layer = import("app.views.GameLayer"),					flag = UIDefine.LayerFlag.Main.name,	name = "Main_UI" },
-- 	Editor_UI	= { layer = import("app.views.GameEditor"),					flag = UIDefine.LayerFlag.Main.name,	name = "Editor_UI" },
-- 	Select_UI	= { layer = import("app.views.SelectLevel.Main"),			flag = UIDefine.LayerFlag.Main.name,	name = "Select_UI" },
-- 	Ready_UI	= { layer = import("app.views.GameReady"),					flag = UIDefine.LayerFlag.Main.name,	name = "Ready_UI" },
-- 	Next_UI	    = { layer = import("app.views.GameNext"),					flag = UIDefine.LayerFlag.Main.name,	name = "Next_UI" },
-- 	Help_UI	    = { layer = import("app.views.GameHelp"),					flag = UIDefine.LayerFlag.Main.name,	name = "Help_UI" },
-- 	Set_UI	    = { layer = import("app.views.GameSet"),					flag = UIDefine.LayerFlag.Main.name,	name = "Set_UI" },
-- 	Record_UI	= { layer = import("app.views.Record.Main"),				flag = UIDefine.LayerFlag.Main.name,	name = "Record_UI" },
-- 	Guid1_UI	= { layer = import("app.views.Guid.Guid1"),				    flag = UIDefine.LayerFlag.Guid.name,	name = "Guid1_UI" },
-- 	Guid2_UI	= { layer = import("app.views.Guid.Guid2"),				    flag = UIDefine.LayerFlag.Guid.name,	name = "Guid2_UI" },
-- 	Guid3_UI	= { layer = import("app.views.Guid.Guid3"),				    flag = UIDefine.LayerFlag.Guid.name,	name = "Guid3_UI" },
-- 	Guid4_UI	= { layer = import("app.views.Guid.Guid4"),				    flag = UIDefine.LayerFlag.Guid.name,	name = "Guid4_UI" },
-- }

-- -- 消除的ui
-- UIDefine.ELIMI_KEY = {
-- 	Start_UI    	= { layer = import("app.viewseliminate.GameStart"),			flag = UIDefine.LayerFlag.Main.name,	name = "Elimi_Start_UI"},
-- 	Play_UI			= { layer = import("app.viewseliminate.GamePlay"),			flag = UIDefine.LayerFlag.Main.name,	name = "Elimi_Play_UI" },
-- 	GameOver_UI		= { layer = import("app.viewseliminate.GameOver"),			flag = UIDefine.LayerFlag.Main.name,	name = "Elimi_GameOver_UI" },
-- 	GamePause_UI	= { layer = import("app.viewseliminate.GamePause"),			flag = UIDefine.LayerFlag.Main.name,	name = "Elimi_GamePause_UI" },
-- 	Advanced_UI		= { layer = import("app.viewseliminate.GameAdvanced"),		flag = UIDefine.LayerFlag.Main.name,	name = "Elimi_Advanced_UI" },
-- 	Record_UI		= { layer = import("app.viewseliminate.rank.RankMain"),		flag = UIDefine.LayerFlag.Main.name,	name = "Elimi_Record_UI" },
-- 	GameNotPut_UI   = { layer = import("app.viewseliminate.GameNotPut"),		flag = UIDefine.LayerFlag.Main.name,	name = "Elimi_GameNotPut_UI" },
-- 	Set_UI          = { layer = import("app.viewseliminate.GameSet"),		    flag = UIDefine.LayerFlag.Main.name,	name = "Elimi_GameSet_UI" },
-- }

-- -- 24点的ui
-- UIDefine.TWENTYFOUR_KEY = {
-- 	Start_UI    		= { layer = import("app.viewstwentyfour.GameStart"),			flag = UIDefine.LayerFlag.Main.name,	name = "TwentyFour_Start_UI" },
-- 	Set_UI	        	= { layer = import("app.viewstwentyfour.GameSet"),				flag = UIDefine.LayerFlag.Main.name,	name = "TwentyFour_Set_UI"  },
-- 	Level_UI	    	= { layer = import("app.viewstwentyfour.Level.Main"),			flag = UIDefine.LayerFlag.Main.name,	name = "TwentyFour_Level_UI"  },
-- 	Play_UI	        	= { layer = import("app.viewstwentyfour.GamePlay"),		    	flag = UIDefine.LayerFlag.Main.name,	name = "TwentyFour_Play_UI"  },
-- 	Win_UI	        	= { layer = import("app.viewstwentyfour.GameWin"),		    	flag = UIDefine.LayerFlag.Main.name,	name = "TwentyFour_Win_UI"  },
-- 	Failed_UI	    	= { layer = import("app.viewstwentyfour.GameFailed"),			flag = UIDefine.LayerFlag.Main.name,	name = "TwentyFour_Failed_UI" },
-- 	Advanced_UI     	= { layer = import("app.viewstwentyfour.GameAdvanced"),			flag = UIDefine.LayerFlag.Main.name,	name = "TwentyFour_Advanced_UI" },
-- 	Play_Advanced_UI   	= { layer = import("app.viewstwentyfour.GamePlayAdvanced"), 	flag = UIDefine.LayerFlag.Main.name,	name = "TwentyFour_Play_Advanced_UI" },
-- 	Advanced_Result_UI  = { layer = import("app.viewstwentyfour.GameAdvancedResult"), 	flag = UIDefine.LayerFlag.Main.name,	name = "TwentyFour_Advanced_Result_UI" },
-- 	Rank_Main_UI        = { layer = import("app.viewstwentyfour.rank.RankMain"), 	    flag = UIDefine.LayerFlag.Main.name,	name = "TwentyFour_Rank_Main_UI" },
-- 	Guid_UI             = { layer = import("app.viewstwentyfour.Guid.GameGuid"), 	    flag = UIDefine.LayerFlag.Main.name,	name = "TwentyFour_Guid_UI" },
-- }


-- -- 麻将的ui
-- UIDefine.MAJIANG_KEY = {
-- 	Start_UI    		= { layer = import("app.viewsmajiang.GameStart"),			    flag = UIDefine.LayerFlag.Main.name,	name = "MaJiang_Start_UI" },
-- 	Play_UI	        	= { layer = import("app.viewsmajiang.GameMainPlay"),		    flag = UIDefine.LayerFlag.Main.name,	name = "MaJiang_Play_UI"  },
-- 	Win_UI	        	= { layer = import("app.viewsmajiang.GameWin"),		    		flag = UIDefine.LayerFlag.Main.name,	name = "MaJiang_Win_UI"   },
-- 	Lose_UI	        	= { layer = import("app.viewsmajiang.GameLose"),		    	flag = UIDefine.LayerFlag.Main.name,	name = "MaJiang_Lose_UI"  },
-- 	Voice_UI	        = { layer = import("app.viewsmajiang.GameVoiceSet"),		    flag = UIDefine.LayerFlag.Main.name,	name = "MaJiang_Voice_UI" },
-- 	LiuJu_UI 			= { layer = import("app.viewsmajiang.GameLiuJu"),		    	flag = UIDefine.LayerFlag.Main.name,	name = "MaJiang_LiuJu_UI" },
-- 	PoChan_UI 			= { layer = import("app.viewsmajiang.GamePoChan"),		    	flag = UIDefine.LayerFlag.Main.name,	name = "MaJiang_PoChan_UI" },
-- 	Rank_UI 			= { layer = import("app.viewsmajiang.Rank.GameRank"),		    flag = UIDefine.LayerFlag.Main.name,	name = "MaJiang_Rank_UI" },
-- 	Test_UI 			= { layer = import("app.viewsmajiang.GameTest"),		    	flag = UIDefine.LayerFlag.Main.name,	name = "MaJiang_Test_UI" },
-- 	Help_UI 			= { layer = import("app.viewsmajiang.GameHelp"),		    	flag = UIDefine.LayerFlag.Main.name,	name = "MaJiang_Help_UI" },
-- 	Loading_UI 			= { layer = import("app.viewsmajiang.GameLoading"),		    	flag = UIDefine.LayerFlag.Main.name,	name = "MaJiang_Loading_UI" },
-- }


-- -- 老虎机的ui
-- UIDefine.LAOHUJI_KEY = {
-- 	Loading_UI 			= { layer = import("app.viewslaohuji.GameLoading"),		    	flag = UIDefine.LayerFlag.Main.name,	name = "LaoHuJi_Loading_UI" 		},
-- 	Start_UI 			= { layer = import("app.viewslaohuji.GameStart"),			    flag = UIDefine.LayerFlag.Main.name,	name = "LaoHuJi_Start_UI"   		},
-- 	Voice_UI	        = { layer = import("app.viewslaohuji.GameVoiceSet"),		    flag = UIDefine.LayerFlag.Main.name,	name = "LaoHuJi_Voice_UI"   		},
-- 	Help_UI 			= { layer = import("app.viewslaohuji.GameHelp"),		    	flag = UIDefine.LayerFlag.Main.name,	name = "LaoHuJi_Help_UI"    		},
-- 	Play_UI             = { layer = import("app.viewslaohuji.GamePlay"),		    	flag = UIDefine.LayerFlag.Main.name,	name = "LaoHuJi_Play_UI"    		},
-- 	PoChan_UI           = { layer = import("app.viewslaohuji.PoChan"),		    		flag = UIDefine.LayerFlag.Main.name,	name = "LaoHuJi_PoChan_UI"  		},
-- 	Achievement_UI      = { layer = import("app.viewslaohuji.achievement.Main"),		flag = UIDefine.LayerFlag.Main.name,	name = "LaoHuJi_Achievement_UI"  	},
-- 	Rank_UI 			= { layer = import("app.viewslaohuji.rank.RankMain"),		    flag = UIDefine.LayerFlag.Main.name,	name = "LaoHuJi_Rank_UI"		    },
-- 	UnLock_UI 			= { layer = import("app.viewslaohuji.UnLock"),		    		flag = UIDefine.LayerFlag.Main.name,	name = "LaoHuJi_UnLock_UI"		    },
-- 	AddCoin_UI 			= { layer = import("app.viewslaohuji.AddCoin"),		    		flag = UIDefine.LayerFlag.Main.name,	name = "LaoHuJi_AddCoin_UI"		    },
-- }


-- -- 成语接龙的ui
-- UIDefine.CHENGYUJIELONG_KEY = {
-- 	Loading_UI 			= { layer = import("app.viewschengyujielong.GameLoading"),		flag = UIDefine.LayerFlag.Main.name,	name = "ChengYuJieLong_Loading_UI" 			},
-- 	Start_UI 			= { layer = import("app.viewschengyujielong.GameStart"),	    flag = UIDefine.LayerFlag.Main.name,	name = "ChengYuJieLong_Start_UI"   			},
-- 	Voice_UI	        = { layer = import("app.viewschengyujielong.GameVoiceSet"),		flag = UIDefine.LayerFlag.Main.name,	name = "ChengYuJieLong_Voice_UI"    		},
-- 	Help_UI 			= { layer = import("app.viewschengyujielong.GameHelp"),		    flag = UIDefine.LayerFlag.Main.name,	name = "ChengYuJieLong_Help_UI"    			},
-- 	Play_UI             = { layer = import("app.viewschengyujielong.GamePlay"),		    flag = UIDefine.LayerFlag.Main.name,	name = "ChengYuJieLong_Play_UI"    			},
-- 	PassQuest_UI        = { layer = import("app.viewschengyujielong.GamePassQuest"),    flag = UIDefine.LayerFlag.Main.name,	name = "ChengYuJieLong_PassQuest_UI"		},
-- 	GameOver_UI         = { layer = import("app.viewschengyujielong.GameOver"),    		flag = UIDefine.LayerFlag.Main.name,	name = "ChengYuJieLong_GameOver_UI" 		},
-- 	PassAll_UI          = { layer = import("app.viewschengyujielong.GamePassAll"),    	flag = UIDefine.LayerFlag.Main.name,	name = "ChengYuJieLong_PassAll_UI"  		},
-- 	Rank_UI 			= { layer = import("app.viewschengyujielong.rank.RankMain"),    flag = UIDefine.LayerFlag.Main.name,	name = "ChengYuJieLong_Rank_UI"				},
-- 	Guid1_UI 			= { layer = import("app.viewschengyujielong.GameGuid1"),        flag = UIDefine.LayerFlag.Guid.name,	name = "ChengYuJieLong_GameGuid1_UI"		},
-- }

-- -- 21点的ui
-- UIDefine.TWENTYONE_KEY = {
-- 	Loading_UI 			= { layer = import("app.viewstwentyone.GameLoading"),		    flag = UIDefine.LayerFlag.Main.name,	name = "TwentyOne_Loading_UI" 			    },
-- 	Start_UI 			= { layer = import("app.viewstwentyone.GameStart"),	    		flag = UIDefine.LayerFlag.Main.name,	name = "TwentyOne_Start_UI"                 },
-- 	Help_UI 			= { layer = import("app.viewstwentyone.GameHelp"),		    	flag = UIDefine.LayerFlag.Main.name,	name = "TwentyOne_Help_UI"    			    },
-- 	Voice_UI	        = { layer = import("app.viewstwentyone.GameVoiceSet"),		    flag = UIDefine.LayerFlag.Main.name,	name = "TwentyOne_Voice_UI"    		        },
-- 	Shop_UI	       		= { layer = import("app.viewstwentyone.GameShop"),		        flag = UIDefine.LayerFlag.Main.name,	name = "TwentyOne_Shop_UI"    		        },
-- 	Play_UI             = { layer = import("app.viewstwentyone.GamePlay"),		    	flag = UIDefine.LayerFlag.Main.name,	name = "TwentyOne_Play_UI"    			    },
-- 	Pass_UI             = { layer = import("app.viewstwentyone.GamePass"),		    	flag = UIDefine.LayerFlag.Main.name,	name = "TwentyOne_Pass_UI"    			    },
-- 	Over_UI             = { layer = import("app.viewstwentyone.GameOver"),		    	flag = UIDefine.LayerFlag.Main.name,	name = "TwentyOne_Over_UI"    			    },
-- 	Rank_UI 			= { layer = import("app.viewstwentyone.rank.RankMain"),         flag = UIDefine.LayerFlag.Main.name,	name = "TwentyOne_Rank_UI"				    },
-- 	Buy_UI 				= { layer = import("app.viewstwentyone.GameBuy"),         		flag = UIDefine.LayerFlag.Main.name,	name = "TwentyOne_Buy_UI"				    },
-- }

-- -- 军事纸牌的ui
-- UIDefine.JUNSHI_KEY = {
-- 	Loading_UI 			= { layer = import("app.viewsjunshi.GameLoading"),		        flag = UIDefine.LayerFlag.Main.name,	name = "JunShi_Loading_UI" 			        },
-- 	Start_UI 			= { layer = import("app.viewsjunshi.GameStart"),	    		flag = UIDefine.LayerFlag.Main.name,	name = "JunShi_Start_UI"                    },
-- 	Help_UI 			= { layer = import("app.viewsjunshi.GameHelp"),		    		flag = UIDefine.LayerFlag.Main.name,	name = "JunShi_Help_UI"    			        },
-- 	Voice_UI	        = { layer = import("app.viewsjunshi.GameVoiceSet"),		        flag = UIDefine.LayerFlag.Main.name,	name = "JunShi_Voice_UI"    		        },
-- 	Shop_UI	       		= { layer = import("app.viewsjunshi.GameShop"),		            flag = UIDefine.LayerFlag.Main.name,	name = "JunShi_Shop_UI"    		            },
-- 	Play_UI             = { layer = import("app.viewsjunshi.GamePlay"),		    	    flag = UIDefine.LayerFlag.Main.name,	name = "JunShi_Play_UI"    			        },
-- 	Select_UI           = { layer = import("app.viewsjunshi.SelectPeople"),		    	flag = UIDefine.LayerFlag.Main.name,	name = "JunShi_Select_UI"    			    },
-- 	Choose_UI           = { layer = import("app.viewsjunshi.ChooseCard"),		    	flag = UIDefine.LayerFlag.Main.name,	name = "JunShi_Choose_UI"    			    },
-- 	Over_UI             = { layer = import("app.viewsjunshi.GameOver"),		    	    flag = UIDefine.LayerFlag.Main.name,	name = "JunShi_Over_UI"    			        },
-- 	Rank_UI 			= { layer = import("app.viewsjunshi.RankMain"),         		flag = UIDefine.LayerFlag.Main.name,	name = "JunShi_Rank_UI"				    	},
-- 	Buy_UI 				= { layer = import("app.viewsjunshi.GameBuy"),         			flag = UIDefine.LayerFlag.Main.name,	name = "JunShi_Buy_UI"				        },
-- }

-- -- 拉霸的ui
-- UIDefine.LABA_KEY   = {
-- 	Loading_UI 			= { layer = import("app.viewslaba.GameLoading"),		        flag = UIDefine.LayerFlag.Main.name,	name = "LaBa_Loading_UI" 			        },
-- 	Start_UI 			= { layer = import("app.viewslaba.GameStart"),	    			flag = UIDefine.LayerFlag.Main.name,	name = "LaBa_Start_UI"                      },
-- 	Play_UI             = { layer = import("app.viewslaba.GamePlay"),		    	    flag = UIDefine.LayerFlag.Main.name,	name = "LaBa_Play_UI"    			        },
-- 	Help_UI 			= { layer = import("app.viewslaba.GameHelp"),		    		flag = UIDefine.LayerFlag.Main.name,	name = "LaBa_Help_UI"    			        },
-- 	Voice_UI	        = { layer = import("app.viewslaba.GameVoiceSet"),		        flag = UIDefine.LayerFlag.Main.name ,	name = "LaBa_Voice_UI"    		     	  	},
-- 	Shop_UI	       		= { layer = import("app.viewslaba.GameShop"),		            flag = UIDefine.LayerFlag.Main.name ,	name = "LaBa_Shop_UI"    		            },
-- 	Buy_UI 				= { layer = import("app.viewslaba.GameBuy"),         			flag = UIDefine.LayerFlag.Main.name ,	name = "LaBa_Buy_UI"				        },
-- }

-- -- 纸牌21点的ui
-- UIDefine.ZHIPAI_KEY    = {
-- 	Loading_UI 			= { layer = import("app.viewszhipai.GameLoading"),		        flag = UIDefine.LayerFlag.Main.name,	name = "ZhiPai_Loading_UI" 			        },
-- 	Start_UI 			= { layer = import("app.viewszhipai.GameStart"),	    		flag = UIDefine.LayerFlag.Main.name,	name = "ZhiPai_Start_UI"                    },
-- 	Play_UI             = { layer = import("app.viewszhipai.GamePlay"),		    	    flag = UIDefine.LayerFlag.Main.name,	name = "ZhiPai_Play_UI"    			        },
-- 	Pass_UI             = { layer = import("app.viewszhipai.GamePass"),		    		flag = UIDefine.LayerFlag.Main.name,	name = "ZhiPai_Pass_UI"    			        },
-- 	Over_UI             = { layer = import("app.viewszhipai.GameOver"),		    	    flag = UIDefine.LayerFlag.Main.name,	name = "ZhiPai_Over_UI"    			        },
-- 	Help_UI 			= { layer = import("app.viewszhipai.GameHelp"),		    		flag = UIDefine.LayerFlag.Main.name,	name = "ZhiPai_Help_UI"    			        },
-- 	Voice_UI	        = { layer = import("app.viewszhipai.GameVoiceSet"),		        flag = UIDefine.LayerFlag.Main.name,	name = "ZhiPai_Voice_UI"    		     	},
-- 	Pause_UI	        = { layer = import("app.viewszhipai.GamePause"),		        flag = UIDefine.LayerFlag.Main.name,	name = "ZhiPai_Pause_UI"    		     	},
-- 	Rank_UI 			= { layer = import("app.viewszhipai.RankMain"),         		flag = UIDefine.LayerFlag.Main.name,	name = "ZhiPai_Rank_UI"				    	},
-- 	Shop_UI	    	    = { layer = import("app.viewszhipai.GameShop"),		      	    flag = UIDefine.LayerFlag.Main.name,	name = "ZhiPai_Shop_UI"    		   		  	},
-- 	Buy_UI	    	    = { layer = import("app.viewszhipai.GameBuy"),		      	    flag = UIDefine.LayerFlag.Main.name,	name = "ZhiPai_Buy_UI"    		   		  	},
-- }

-- --三国的ui
-- UIDefine.SANGUO_KEY   	= {
-- 	Loading_UI 			= { layer = import("app.viewssanguo.GameLoading"),		        flag = UIDefine.LayerFlag.Main.name,	name = "SanGuo_Loading_UI" 			        },
-- 	Start_UI 			= { layer = import("app.viewssanguo.GameStart"),	    		flag = UIDefine.LayerFlag.Main.name,	name = "SanGuo_Start_UI"                    },
-- 	Help_UI 			= { layer = import("app.viewssanguo.GameHelp"),		    		flag = UIDefine.LayerFlag.Main.name,	name = "SanGuo_Help_UI"    			        },
-- 	Voice_UI	        = { layer = import("app.viewssanguo.GameVoiceSet"),		        flag = UIDefine.LayerFlag.Main.name,	name = "SanGuo_Voice_UI"    		     	},
-- 	Shop_UI	    	    = { layer = import("app.viewssanguo.GameShop"),		      	    flag = UIDefine.LayerFlag.Main.name,	name = "SanGuo_Shop_UI"    		   		  	},
-- 	Buy_UI	    	    = { layer = import("app.viewssanguo.GameBuy"),		      	    flag = UIDefine.LayerFlag.Main.name,	name = "SanGuo_Buy_UI"    		   		  	},
-- 	Play_UI             = { layer = import("app.viewssanguo.GamePlay"),		    	    flag = UIDefine.LayerFlag.Main.name,	name = "SanGuo_Play_UI"    			        },
-- 	Select_UI           = { layer = import("app.viewssanguo.SelectColor"),		    	flag = UIDefine.LayerFlag.Main.name,	name = "SanGuo_SelectColor_UI"    			},
-- 	Win_UI              = { layer = import("app.viewssanguo.GameWin"),		    	    flag = UIDefine.LayerFlag.Main.name,	name = "SanGuo_Win_UI"    			        },
-- 	Lose_UI             = { layer = import("app.viewssanguo.GameLose"),		    	    flag = UIDefine.LayerFlag.Main.name,	name = "SanGuo_Lose_UI"    			        },
-- 	LiuJu_UI            = { layer = import("app.viewssanguo.GameLiuJu"),		    	flag = UIDefine.LayerFlag.Main.name,	name = "SanGuo_LiuJu_UI"    			    },
-- }

-- 战斗的ui
UIDefine.ZHANDOU_KEY   	= {
	Loading_UI 			= { layer = import("app.viewszhandou.GameLoading"),		        flag = UIDefine.LayerFlag.Main.name,	name = "ZhanDou_Loading_UI" 		        },
	Start_UI 			= { layer = import("app.viewszhandou.GameStart"),	    		flag = UIDefine.LayerFlag.Main.name,	name = "ZhanDou_Start_UI"                   },
	Play_UI             = { layer = import("app.viewszhandou.GamePlay"),		    	flag = UIDefine.LayerFlag.Main.name,	name = "ZhanDou_Play_UI"    			    },
	Help_UI 			= { layer = import("app.viewszhandou.GameHelp"),		    	flag = UIDefine.LayerFlag.Main.name,	name = "ZhanDou_Help_UI"    			    },
	Voice_UI	        = { layer = import("app.viewszhandou.GameVoiceSet"),	        flag = UIDefine.LayerFlag.Main.name,	name = "ZhanDou_Voice_UI"    		     	},
	Shop_UI	    	    = { layer = import("app.viewszhandou.GameShop"),		        flag = UIDefine.LayerFlag.Main.name,	name = "ZhanDou_Shop_UI"    		   	  	},
	Buy_UI	    	    = { layer = import("app.viewszhandou.GameBuy"),		      	    flag = UIDefine.LayerFlag.Main.name,	name = "ZhanDou_Buy_UI"    		   		  	},
	Pause_UI	    	= { layer = import("app.viewszhandou.GamePause"),		      	flag = UIDefine.LayerFlag.Main.name,	name = "ZhanDou_Pause_UI"    		   		},
	Win_UI              = { layer = import("app.viewszhandou.GameWin"),		    	    flag = UIDefine.LayerFlag.Main.name,	name = "ZhanDou_Win_UI"    			        },
	Lose_UI             = { layer = import("app.viewszhandou.GameLose"),		    	flag = UIDefine.LayerFlag.Main.name,	name = "ZhanDou_Lose_UI"    			    },
}
rawset(_G,"UIDefine",UIDefine)