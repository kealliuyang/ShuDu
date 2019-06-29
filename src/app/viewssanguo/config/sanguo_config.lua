

local sanguo_config = {}



sanguo_config.card = {
	[1] 	= { path = "image/poker/1-4.png",name = "曹操",color = 1,index = 1 },
	[2] 	= { path = "image/poker/1-4.png",name = "曹操",color = 1,index = 1 },
	[3] 	= { path = "image/poker/2-4.png",name = "曹操",color = 2,index = 1 },
	[4] 	= { path = "image/poker/2-4.png",name = "曹操",color = 2,index = 1 },
	[5] 	= { path = "image/poker/3-4.png",name = "曹操",color = 3,index = 1 },
	[6] 	= { path = "image/poker/3-4.png",name = "曹操",color = 3,index = 1 },
	[7] 	= { path = "image/poker/4-4.png",name = "曹操",color = 4,index = 1 },
	[8] 	= { path = "image/poker/4-4.png",name = "曹操",color = 4,index = 1 },

	[9] 	= { path = "image/poker/1-5.png",name = "刘备",color = 1,index = 2 },
	[10] 	= { path = "image/poker/1-5.png",name = "刘备",color = 1,index = 2 },
	[11] 	= { path = "image/poker/2-5.png",name = "刘备",color = 2,index = 2 },
	[12] 	= { path = "image/poker/2-5.png",name = "刘备",color = 2,index = 2 },
	[13] 	= { path = "image/poker/3-5.png",name = "刘备",color = 3,index = 2 },
	[14] 	= { path = "image/poker/3-5.png",name = "刘备",color = 3,index = 2 },
	[15] 	= { path = "image/poker/4-5.png",name = "刘备",color = 4,index = 2 },
	[16] 	= { path = "image/poker/4-5.png",name = "刘备",color = 4,index = 2 },

	[17] 	= { path = "image/poker/1-3.png",name = "吕布",color = 1,index = 3 },
	[18] 	= { path = "image/poker/1-3.png",name = "吕布",color = 1,index = 3 },
	[19] 	= { path = "image/poker/2-3.png",name = "吕布",color = 2,index = 3 },
	[20] 	= { path = "image/poker/2-3.png",name = "吕布",color = 2,index = 3 },
	[21] 	= { path = "image/poker/3-3.png",name = "吕布",color = 3,index = 3 },
	[22] 	= { path = "image/poker/3-3.png",name = "吕布",color = 3,index = 3 },
	[23] 	= { path = "image/poker/4-3.png",name = "吕布",color = 4,index = 3 },
	[24] 	= { path = "image/poker/4-3.png",name = "吕布",color = 4,index = 3 },

	[25] 	= { path = "image/poker/1-2.png",name = "袁绍",color = 1,index = 4 },
	[26] 	= { path = "image/poker/1-2.png",name = "袁绍",color = 1,index = 4 },
	[27] 	= { path = "image/poker/2-2.png",name = "袁绍",color = 2,index = 4 },
	[28] 	= { path = "image/poker/2-2.png",name = "袁绍",color = 2,index = 4 },
	[29] 	= { path = "image/poker/3-2.png",name = "袁绍",color = 3,index = 4 },
	[30] 	= { path = "image/poker/3-2.png",name = "袁绍",color = 3,index = 4 },
	[31] 	= { path = "image/poker/4-2.png",name = "袁绍",color = 4,index = 4 },
	[32] 	= { path = "image/poker/4-2.png",name = "袁绍",color = 4,index = 4 },

	[33] 	= { path = "image/poker/1-7.png",name = "孙权",color = 1,index = 5 },
	[34] 	= { path = "image/poker/1-7.png",name = "孙权",color = 1,index = 5 },
	[35] 	= { path = "image/poker/2-7.png",name = "孙权",color = 2,index = 5 },
	[36] 	= { path = "image/poker/2-7.png",name = "孙权",color = 2,index = 5 },
	[37] 	= { path = "image/poker/3-7.png",name = "孙权",color = 3,index = 5 },
	[38] 	= { path = "image/poker/3-7.png",name = "孙权",color = 3,index = 5 },
	[39] 	= { path = "image/poker/4-7.png",name = "孙权",color = 4,index = 5 },
	[40] 	= { path = "image/poker/4-7.png",name = "孙权",color = 4,index = 5 },

	[41] 	= { path = "image/poker/1-1.png",name = "甄姬",color = 1,index = 6 },
	[42] 	= { path = "image/poker/1-1.png",name = "甄姬",color = 1,index = 6 },
	[43] 	= { path = "image/poker/2-1.png",name = "甄姬",color = 2,index = 6 },
	[44] 	= { path = "image/poker/2-1.png",name = "甄姬",color = 2,index = 6 },
	[45] 	= { path = "image/poker/3-1.png",name = "甄姬",color = 3,index = 6 },
	[46] 	= { path = "image/poker/3-1.png",name = "甄姬",color = 3,index = 6 },
	[47] 	= { path = "image/poker/4-1.png",name = "甄姬",color = 4,index = 6 },
	[48] 	= { path = "image/poker/4-1.png",name = "甄姬",color = 4,index = 6 },

	[49] 	= { path = "image/poker/1-6.png",name = "蔡文姬",color = 1,index = 7 },
	[50] 	= { path = "image/poker/1-6.png",name = "蔡文姬",color = 1,index = 7 },
	[51] 	= { path = "image/poker/2-6.png",name = "蔡文姬",color = 2,index = 7 },
	[52] 	= { path = "image/poker/2-6.png",name = "蔡文姬",color = 2,index = 7 },
	[53] 	= { path = "image/poker/3-6.png",name = "蔡文姬",color = 3,index = 7 },
	[54] 	= { path = "image/poker/3-6.png",name = "蔡文姬",color = 3,index = 7 },
	[55] 	= { path = "image/poker/4-6.png",name = "蔡文姬",color = 4,index = 7 },
	[56] 	= { path = "image/poker/4-6.png",name = "蔡文姬",color = 4,index = 7 },

	[57] 	= { path = "image/poker/1-8.png",name = "貂蝉",color = 1,index = 8 },
	[58] 	= { path = "image/poker/1-8.png",name = "貂蝉",color = 1,index = 8 },
	[59] 	= { path = "image/poker/2-8.png",name = "貂蝉",color = 2,index = 8 },
	[60] 	= { path = "image/poker/2-8.png",name = "貂蝉",color = 2,index = 8 },
	[61] 	= { path = "image/poker/3-8.png",name = "貂蝉",color = 3,index = 8 },
	[62] 	= { path = "image/poker/3-8.png",name = "貂蝉",color = 3,index = 8 },
	[63] 	= { path = "image/poker/4-8.png",name = "貂蝉",color = 4,index = 8 },
	[64] 	= { path = "image/poker/4-8.png",name = "貂蝉",color = 4,index = 8 },

	[65] 	= { path = "image/poker/1-9.png",name = "大乔",color = 1,index = 9 },
	[66] 	= { path = "image/poker/1-9.png",name = "大乔",color = 1,index = 9 },
	[67] 	= { path = "image/poker/2-9.png",name = "大乔",color = 2,index = 9 },
	[68] 	= { path = "image/poker/2-9.png",name = "大乔",color = 2,index = 9 },
	[69] 	= { path = "image/poker/3-9.png",name = "大乔",color = 3,index = 9 },
	[70] 	= { path = "image/poker/3-9.png",name = "大乔",color = 3,index = 9 },
	[71] 	= { path = "image/poker/4-9.png",name = "大乔",color = 4,index = 9 },
	[72] 	= { path = "image/poker/4-9.png",name = "大乔",color = 4,index = 9 },

	[73] 	= { path = "image/poker/1-10.png",name = "小乔",color = 1,index = 10 },
	[74] 	= { path = "image/poker/1-10.png",name = "小乔",color = 1,index = 10 },
	[75] 	= { path = "image/poker/2-10.png",name = "小乔",color = 2,index = 10 },
	[76] 	= { path = "image/poker/2-10.png",name = "小乔",color = 2,index = 10 },
	[77] 	= { path = "image/poker/3-10.png",name = "小乔",color = 3,index = 10 },
	[78] 	= { path = "image/poker/3-10.png",name = "小乔",color = 3,index = 10 },
	[79] 	= { path = "image/poker/4-10.png",name = "小乔",color = 4,index = 10 },
	[80] 	= { path = "image/poker/4-10.png",name = "小乔",color = 4,index = 10 },

	[81] 	= { path = "image/poker/1-11.png",name = "玉玺",color = 1,index = 11 },
	[82] 	= { path = "image/poker/1-11.png",name = "玉玺",color = 1,index = 11 },
	[83] 	= { path = "image/poker/2-11.png",name = "玉玺",color = 2,index = 11 },
	[84] 	= { path = "image/poker/2-11.png",name = "玉玺",color = 2,index = 11 },
	[85] 	= { path = "image/poker/3-11.png",name = "玉玺",color = 3,index = 11 },
	[86] 	= { path = "image/poker/3-11.png",name = "玉玺",color = 3,index = 11 },
	[87] 	= { path = "image/poker/4-11.png",name = "玉玺",color = 4,index = 11 },
	[88] 	= { path = "image/poker/4-11.png",name = "玉玺",color = 4,index = 11 },

	[89] 	= { path = "image/poker/1-12.png",name = "转换",color = 1,index = 12 },
	[90] 	= { path = "image/poker/1-12.png",name = "转换",color = 1,index = 12 },
	[91] 	= { path = "image/poker/2-12.png",name = "转换",color = 2,index = 12 },
	[92] 	= { path = "image/poker/2-12.png",name = "转换",color = 2,index = 12 },
	[93] 	= { path = "image/poker/3-12.png",name = "转换",color = 3,index = 12 },
	[94] 	= { path = "image/poker/3-12.png",name = "转换",color = 3,index = 12 },
	[95] 	= { path = "image/poker/4-12.png",name = "转换",color = 4,index = 12 },
	[96] 	= { path = "image/poker/4-12.png",name = "转换",color = 4,index = 12 },

	[97] 	= { path = "image/poker/1-13.png",name = "选色",color = 1,index = 13 },
	[98] 	= { path = "image/poker/1-13.png",name = "选色",color = 1,index = 13 },
	[99] 	= { path = "image/poker/2-13.png",name = "选色",color = 2,index = 13 },
	[100] 	= { path = "image/poker/2-13.png",name = "选色",color = 2,index = 13 },
	[101] 	= { path = "image/poker/3-13.png",name = "选色",color = 3,index = 13 },
	[102] 	= { path = "image/poker/3-13.png",name = "选色",color = 3,index = 13 },
	[103] 	= { path = "image/poker/4-13.png",name = "选色",color = 4,index = 13 },
	[104] 	= { path = "image/poker/4-13.png",name = "选色",color = 4,index = 13 },

}



sanguo_config.bei_card = {
	[1] = "image/play/red.png",
	[2] = "image/play/green.png",
	[3] = "image/play/bule.png",
	[4] = "image/play/yellow.png",
}







rawset(_G,"sanguo_config",sanguo_config)
