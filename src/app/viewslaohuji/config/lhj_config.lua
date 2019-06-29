

-- 水果机: 1:苹果 2:橘子 3:青柠檬 4:铃铛 5:西瓜 6:星星 7:777 8:梨子 9:没押中
local lhj_fruits_btn_config = {
	{
		img = "image/game/fruits/Btn_pingguo.png",
		unimg = "image/game/fruits/Btn_pingguo_un.png",
		rate = "2",
		name = "苹果"
	},
	{
		img = "image/game/fruits/Btn_chengzi.png",
		unimg = "image/game/fruits/Btn_chengzi_un.png",
		rate = "4",
		name = "橘子"
	},
	{
		img = "image/game/fruits/Btn_ningmeng.png",
		unimg = "image/game/fruits/Btn_ningmeng_un.png",
		rate = "5",
		name = "柠檬"
	},
	{
		img = "image/game/fruits/Btn_lingdang.png",
		unimg = "image/game/fruits/Btn_lingdang_un.png",
		rate = "8",
		name = "铃铛"
	},
	{
		img = "image/game/fruits/Btn_xigua.png",
		unimg = "image/game/fruits/Btn_xigua_un.png",
		rate = "10",
		name = "西瓜"
	},
	{
		img = "image/game/fruits/Btn_xing.png",
		unimg = "image/game/fruits/Btn_xing_un.png",
		rate = "15",
		name = "星星"
	},
	{
		img = "image/game/fruits/Btn_777.png",
		unimg = "image/game/fruits/Btn_777_un.png",
		rate = "20",
		name = "777"
	},
	{
		img = "image/game/fruits/Btn_li.png",
		unimg = "image/game/fruits/Btn_li_un.png",
		rate = "30",
		name = "梨子"
	}
}

local lhj_fruits_item_config = {
	[1]   = { index = 3,rate = 1,row = 1,col = 1 },
	[2]   = { index = 1,rate = 1,row = 1,col = 2 },
	[3]   = { index = 2,rate = 1,row = 1,col = 3 },
	[4]   = { index = 8,rate = 1,row = 1,col = 4 },
	[5]   = { index = 6,rate = 1,row = 1,col = 5 },
	[6]   = { index = 2,rate = 2,row = 1,col = 6 },
	[7]   = { index = 1,rate = 1,row = 1,col = 7 },
	[8]   = { index = 3,rate = 1,row = 1,col = 8 },
	[9]   = { index = 4,rate = 2,row = 2,col = 8 },
	[10]  = { index = 9,rate = 1,row = 3,col = 8 },
	[11]  = { index = 5,rate = 1,row = 4,col = 8 },
	[12]  = { index = 3,rate = 2,row = 5,col = 8 },
	[13]  = { index = 1,rate = 1,row = 5,col = 7 },
	[14]  = { index = 2,rate = 1,row = 5,col = 6 },
	[15]  = { index = 7,rate = 1,row = 5,col = 5 },
	[16]  = { index = 4,rate = 2,row = 5,col = 4 },
	[17]  = { index = 9,rate = 1,row = 5,col = 3 },
	[18]  = { index = 1,rate = 1,row = 5,col = 2 },
	[19]  = { index = 2,rate = 2,row = 5,col = 1 },
	[20]  = { index = 5,rate = 2,row = 4,col = 1 },
	[21]  = { index = 6,rate = 1,row = 3,col = 1 },
	[22]  = { index = 4,rate = 1,row = 2,col = 1 },
}

local lhj_fruits_item_img = {
	[1] = "image/game/fruits/pingguo.png",
	[2] = "image/game/fruits/chengzi.png",
	[3] = "image/game/fruits/ningmeng.png",
	[4] = "image/game/fruits/lingdan.png",
	[5] = "image/game/fruits/xigua.png",
	[6] = "image/game/fruits/xing.png",
	[7] = "image/game/fruits/777.png",
	[8] = "image/game/fruits/li.png",
	[9] = "image/game/fruits/tongchi.png",
}


local lhj_animal_btn_config = {
	{
		img = "image/game/animal/Btn_houzi.png",
		unimg = "image/game/animal/Btn_houzi_unclickable.png",
		rate = "2",
		name = "猴子"
	},
	{
		img = "image/game/animal/Btn_bangma.png",
		unimg = "image/game/animal/Btn_bangma_unclickable.png",
		rate = "4",
		name = "斑马"
	},
	{
		img = "image/game/animal/Btn_laoying.png",
		unimg = "image/game/animal/Btn_laoying_unclickable.png",
		rate = "5",
		name = "老鹰"
	},
	{
		img = "image/game/animal/Btn_daxiang.png",
		unimg = "image/game/animal/Btn_daxiang_unclickable.png",
		rate = "8",
		name = "大象"
	},
	{
		img = "image/game/animal/Btn_laohu.png",
		unimg = "image/game/animal/Btn_laohu_unclickable.png",
		rate = "10",
		name = "老虎"
	},
	{
		img = "image/game/animal/Btn_xing.png",
		unimg = "image/game/animal/Btn_xing_un.png",
		rate = "15",
		name = "星星"
	},
	{
		img = "image/game/animal/Btn_777.png",
		unimg = "image/game/animal/Btn_777_un.png",
		rate = "20",
		name = "777"
	},
	{
		img = "image/game/animal/Btn_shizi.png",
		unimg = "image/game/animal/Btn_shizi_unclickable.png",
		rate = "30",
		name = "狮子"
	}
}

local lhj_animal_item_config = {
	[1]   = { index = 3,rate = 1,row = 1,col = 1 },
	[2]   = { index = 1,rate = 1,row = 1,col = 2 },
	[3]   = { index = 2,rate = 1,row = 1,col = 3 },
	[4]   = { index = 8,rate = 1,row = 1,col = 4 },
	[5]   = { index = 6,rate = 1,row = 1,col = 5 },
	[6]   = { index = 2,rate = 2,row = 1,col = 6 },
	[7]   = { index = 1,rate = 1,row = 1,col = 7 },
	[8]   = { index = 3,rate = 1,row = 1,col = 8 },
	[9]   = { index = 4,rate = 2,row = 2,col = 8 },
	[10]  = { index = 9,rate = 1,row = 3,col = 8 },
	[11]  = { index = 5,rate = 1,row = 4,col = 8 },
	[12]  = { index = 3,rate = 2,row = 5,col = 8 },
	[13]  = { index = 1,rate = 1,row = 5,col = 7 },
	[14]  = { index = 2,rate = 1,row = 5,col = 6 },
	[15]  = { index = 7,rate = 1,row = 5,col = 5 },
	[16]  = { index = 4,rate = 2,row = 5,col = 4 },
	[17]  = { index = 9,rate = 1,row = 5,col = 3 },
	[18]  = { index = 1,rate = 1,row = 5,col = 2 },
	[19]  = { index = 2,rate = 2,row = 5,col = 1 },
	[20]  = { index = 5,rate = 2,row = 4,col = 1 },
	[21]  = { index = 6,rate = 1,row = 3,col = 1 },
	[22]  = { index = 4,rate = 1,row = 2,col = 1 },
}

local lhj_animal_item_img = {
	[1] = "image/game/animal/houzi.png",
	[2] = "image/game/animal/bangma.png",
	[3] = "image/game/animal/laoying.png",
	[4] = "image/game/animal/daxiang.png",
	[5] = "image/game/animal/laohu.png",
	[6] = "image/game/animal/xing.png",
	[7] = "image/game/animal/777.png",
	[8] = "image/game/animal/shizi.png",
	[9] = "image/game/animal/tongchi.png",
}


local lhj_seabed_btn_config = {
	{
		img = "image/game/seabed/Btn_xiaoyu.png",
		unimg = "image/game/seabed/Btn_xiaoyu_un.png",
		rate = "2",
		name = "小鱼"
	},
	{
		img = "image/game/seabed/Btn_haima.png",
		unimg = "image/game/seabed/Btn_haima_un.png",
		rate = "4",
		name = "海马"
	},
	{
		img = "image/game/seabed/Btn_haigui.png",
		unimg = "image/game/seabed/Btn_haigui_un.png",
		rate = "5",
		name = "海龟"
	},
	{
		img = "image/game/seabed/Btn_shayu.png",
		unimg = "image/game/seabed/Btn_shayu_un.png",
		rate = "8",
		name = "鲨鱼"
	},
	{
		img = "image/game/seabed/Btn_haitun.png",
		unimg = "image/game/seabed/Btn_haitun_un.png",
		rate = "10",
		name = "海豚"
	},
	{
		img = "image/game/seabed/Btn_xing.png",
		unimg = "image/game/seabed/Btn_xing_un.png",
		rate = "15",
		name = "星星"
	},
	{
		img = "image/game/seabed/Btn_777.png",
		unimg = "image/game/seabed/Btn_777_un.png",
		rate = "20",
		name = "777"
	},
	{
		img = "image/game/seabed/Btn_jing.png",
		unimg = "image/game/seabed/Btn_jing_un.png",
		rate = "30",
		name = "鲸鱼"
	}
}

local lhj_seabed_item_config = {
	[1]   = { index = 3,rate = 1,row = 1,col = 1 },
	[2]   = { index = 1,rate = 1,row = 1,col = 2 },
	[3]   = { index = 2,rate = 1,row = 1,col = 3 },
	[4]   = { index = 8,rate = 1,row = 1,col = 4 },
	[5]   = { index = 6,rate = 1,row = 1,col = 5 },
	[6]   = { index = 2,rate = 2,row = 1,col = 6 },
	[7]   = { index = 1,rate = 1,row = 1,col = 7 },
	[8]   = { index = 3,rate = 1,row = 1,col = 8 },
	[9]   = { index = 4,rate = 2,row = 2,col = 8 },
	[10]  = { index = 9,rate = 1,row = 3,col = 8 },
	[11]  = { index = 5,rate = 1,row = 4,col = 8 },
	[12]  = { index = 3,rate = 2,row = 5,col = 8 },
	[13]  = { index = 1,rate = 1,row = 5,col = 7 },
	[14]  = { index = 2,rate = 1,row = 5,col = 6 },
	[15]  = { index = 7,rate = 1,row = 5,col = 5 },
	[16]  = { index = 4,rate = 2,row = 5,col = 4 },
	[17]  = { index = 9,rate = 1,row = 5,col = 3 },
	[18]  = { index = 1,rate = 1,row = 5,col = 2 },
	[19]  = { index = 2,rate = 2,row = 5,col = 1 },
	[20]  = { index = 5,rate = 2,row = 4,col = 1 },
	[21]  = { index = 6,rate = 1,row = 3,col = 1 },
	[22]  = { index = 4,rate = 1,row = 2,col = 1 },
}

local lhj_seabed_item_img = {
	[1] = "image/game/seabed/xiaoyu.png",
	[2] = "image/game/seabed/haima.png",
	[3] = "image/game/seabed/wugui.png",
	[4] = "image/game/seabed/shayu.png",
	[5] = "image/game/seabed/haitun.png",
	[6] = "image/game/seabed/xing.png",
	[7] = "image/game/seabed/777.png",
	[8] = "image/game/seabed/jing.png",
	[9] = "image/game/seabed/tongchi.png",
}


local lhj_achement_config = {
	{
		name = "解锁动物园机",
		desc = "动物园",
		coin = 300
	},
	{
		name = "解锁海底世界机",
		desc = "海底世界",
		coin = 400
	},
	{
		name = "累计金币数达到",
		desc = "10000枚",
		need_num = 10000,
		coin = 500,
	},
	{
		name = "累计金币数达到",
		desc = "20000枚",
		need_num = 20000,
		coin = 800
	},
	{
		name = "连续押中",
		desc = "3次",
		need_num = 3,
		coin = 500
	},
	{
		name = "连续押中",
		desc = "6次",
		need_num = 6,
		coin = 1000
	},
	{
		name = "累计押中",
		desc = "50次",
		need_num = 50,
		coin = 500
	},
	{
		name = "累计押中",
		desc = "100次",
		need_num = 100,
		coin = 1500
	},
	{
		name = "累计游戏次数达到",
		desc = "1000次",
		need_num = 1000,
		coin = 1000
	},
	{
		name = "累计游戏次数达到",
		desc = "5000次",
		need_num = 5000,
		coin = 5000
	}
}

local lhj_default_coin = 500
local lhj_unlock_animal = 5000
local lhj_unlock_seabed = 10000

local lhj_mode_test = true


rawset(_G,"lhj_fruits_btn_config",lhj_fruits_btn_config)
rawset(_G,"lhj_fruits_item_config",lhj_fruits_item_config)
rawset(_G,"lhj_fruits_item_img",lhj_fruits_item_img)

rawset(_G,"lhj_animal_btn_config",lhj_animal_btn_config)
rawset(_G,"lhj_animal_item_config",lhj_animal_item_config)
rawset(_G,"lhj_animal_item_img",lhj_animal_item_img)

rawset(_G,"lhj_seabed_btn_config",lhj_seabed_btn_config)
rawset(_G,"lhj_seabed_item_config",lhj_seabed_item_config)
rawset(_G,"lhj_seabed_item_img",lhj_seabed_item_img)

rawset(_G,"lhj_achement_config",lhj_achement_config)

rawset(_G,"lhj_default_coin",lhj_default_coin)
rawset(_G,"lhj_unlock_animal",lhj_unlock_animal)
rawset(_G,"lhj_unlock_seabed",lhj_unlock_seabed)

rawset(_G,"lhj_mode_test",lhj_mode_test)