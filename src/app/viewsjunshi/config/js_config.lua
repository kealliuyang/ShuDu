
local js_num_config = {
	[1]		 = 2,
	[2]		 = 2,
	[3]		 = 2,
	[4]		 = 2,
	[5]		 = 2,
	[6]		 = 2,

	[7]		 = 3,
	[8]		 = 3,
	[9]		 = 3,
	[10]     = 3,
	[11]     = 3,
	[12]     = 3,

	[13]     = 4,
	[14]     = 4,
	[15]     = 4,
	[16]     = 4,
	[17]     = 4,
	[18]     = 4,

	[19]     = 5,
	[20]     = 5,
	[21]     = 5,
	[22]     = 5,
	[23]     = 5,
	[24]     = 5,

	[25]     = 6,
	[26]     = 6,
	[27]     = 6,
	[28]     = 6,
	[29]     = 6,
	[30]     = 6,

	[31]     = 7,
	[32]     = 7,
	[33]     = 7,
	[34]     = 7,
	[35]     = 7,
	[36]     = 7,

	[37]     = 8,
	[38]     = 8,
}

local js_card_path_config = {
	[1] = "image/poker/beimian.png",
}


local js_card_image_num_path = {
	[1] = "image/poker/numone.png",
	[2] = "image/poker/num1.png",
	[3] = "image/poker/num2.png",
	[4] = "image/poker/num3.png",
	[5] = "image/poker/num4.png",
	[6] = "image/poker/num5.png",
}

local js_select_people_path = {
	[1] = "image/people/guojia.png",
	[2] = "image/people/lusu.png",
	[3] = "image/people/simayi.png",
	[4] = "image/people/zugeliang.png",
	[5] = "image/people/zhouyu.png",
	[6] = "image/people/pangtong.png",
}

local js_over_people_path = {
	[1] = "image/over/guojiatx.png",
	[2] = "image/over/lusutx.png",
	[3] = "image/over/simayitx.png",
	[4] = "image/over/zugeliangtx.png",
	[5] = "image/over/zhouyutx.png",
	[6] = "image/over/pangtongtx.png",
}

local js_card_people_path = {
	[1] = "image/poker/poker6.png",
	[2] = "image/poker/poker1.png",
	[3] = "image/poker/poker2.png",
	[4] = "image/poker/poker3.png",
	[5] = "image/poker/poker4.png",
	[6] = "image/poker/poker5.png",
	[8] = "image/poker/poker7.png",
}

local js_card_lang = 1	-- 1:英语 2:中文


rawset(_G,"js_num_config",js_num_config)
rawset(_G,"js_card_path_config",js_card_path_config)
rawset(_G,"js_card_image_num_path",js_card_image_num_path)
rawset(_G,"js_card_people_path",js_card_people_path)
rawset(_G,"js_select_people_path",js_select_people_path)
rawset(_G,"js_over_people_path",js_over_people_path)
rawset(_G,"js_card_lang",js_card_lang)