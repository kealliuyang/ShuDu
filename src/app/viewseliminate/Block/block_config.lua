
local eli_block_config = {
	{
		{1}								-- 口
	},
	{
		{1,1}							-- 口口
	},
	{
		{1,1,1}							-- 口口口
	},
	{
		{1,1,1,1}						-- 口口口口
	},
	{
		{1,1,1,1,1}						-- 口口口口口
	},
	{
										-- 口
		{1,1},{1,0}						-- 口口
	},
	{
										-- 口口
		{1,0},{1,1}						-- 口
	},
	{
										--   口
		{1,1},{0,1}						-- 口口
	},
	{
										-- 口口
		{0,1},{1,1}						--   口
	},
	{		
										-- 口口
		{1,1},{1,1}						-- 口口					
	},
	{
										-- 口
										-- 口
		{1,1,1},{1,0,0},{1,0,0}			-- 口口口
	},
	{
										-- 口口口
										-- 口
		{1,0,0},{1,0,0},{1,1,1}			-- 口
	},
	{
										--     口
										--     口
		{1,1,1},{0,0,1},{0,0,1}         -- 口口口
	},
	{
										-- 口口口
										--     口
		{0,0,1},{0,0,1},{1,1,1}			--     口
	},
	{
										-- 口口口
										-- 口口口
		{1,1,1},{1,1,1},{1,1,1}			-- 口口口
	},
	{
										-- 口
		{1},{1}							-- 口
	},
	{
										-- 口
										-- 口
		{1},{1},{1}						-- 口
	},
	{
										-- 口
										-- 口
										-- 口
		{1},{1},{1},{1}					-- 口
	},
	{
										-- 口
										-- 口
										-- 口
										-- 口
		{1},{1},{1},{1},{1}				-- 口
	},
	{
										-- 口口
										--   口
		{0,1,1},{0,1,0},{1,1,0}         --   口口
	},
	{
										--    口口
										--    口
		{1,1,0},{0,1,0},{0,1,1}         --  口口
	},
	{
										--  口
										--  口口口
		{0,0,1},{1,1,1},{1,0,0}			--      口
	},
	{

										--      口
										--  口口口
		{1,0,0},{1,1,1},{0,0,1}			--  口
	},
	{
										--  口口口
										--    口
		{0,1,0},{0,1,0},{1,1,1}			--    口
	},
	{
										--    口
										--    口 
		{1,1,1},{0,1,0},{0,1,0}         --  口口口
	},
	{
										--  口
										--  口口口
		{1,0,0},{1,1,1},{1,0,0}			--  口
	},
	{
										--      口
										--  口口口
		{0,0,1},{1,1,1},{0,0,1}			--      口
	},
	{
										--  口
										--  口口
		{1,0},{1,1},{1,0}				--  口
	},
	{
										--    口
										--  口口
		{0,1},{1,1},{0,1}				--    口
	},
	{
										--   口
		{1,1,1},{0,1,0}					-- 口口口
	},
	{
										-- 口口口
		{0,1,0},{1,1,1}					--   口
	},
	{
										--  口口
										--  口
		{1,1},{1,0},{1,1}				--  口口
	},
	{
										--  口口
										--    口
		{1,1},{0,1},{1,1}				--  口口
	},
	{
										--  口  口
		{1,1,1},{1,0,1}					--  口口口
	},
	{
										--  口口口
		{1,0,1},{1,1,1}					--  口  口
	},
	{
										--   口
										-- 口口
		{1,0},{1,1},{0,1}				-- 口
	},
	{
										-- 口
										-- 口口
		{0,1},{1,1},{1,0}				--   口
	},
	{
										--   口口
		{1,1,0},{0,1,1}					-- 口口
	},
	{
										-- 口口
		{0,1,1},{1,1,0}					--   口口
	},
	{
										--   口
										-- 口口口
		{0,1,0},{1,1,1},{0,1,0}			--   口
	}
}

-- local eli_block_image_path_n = {
-- 	[1] = "image/game/general/big_blue_n.png",
--     [2] = "image/game/general/big_green_n.png",
--     [3] = "image/game/general/big_orange_n.png",
--     [4] = "image/game/general/big_purple_n.png",
--     [5] = "image/game/general/big_red_n.png",
--     [6] = "image/game/general/big_yellow_n.png"
-- }

-- local eli_block_image_path_h = {
-- 	[1] = "image/game/general/big_blue_h.png",
--     [2] = "image/game/general/big_green_h.png",
--     [3] = "image/game/general/big_orange_h.png",
--     [4] = "image/game/general/big_purple_h.png",
--     [5] = "image/game/general/big_red_h.png",
--     [6] = "image/game/general/big_yellow_h.png"
-- }

local eli_block_image_path_n = {
	[1] = "image/game/advanced/big_blue_n.png",
    [2] = "image/game/advanced/big_green_n.png",
    [3] = "image/game/advanced/big_orange_n.png",
    [4] = "image/game/advanced/big_purple_n.png",
    [5] = "image/game/advanced/big_red_n.png",
    [6] = "image/game/advanced/big_yellow_n.png"
}

local eli_block_image_path_h = {
	[1] = "image/game/advanced/big_blue_h.png",
    [2] = "image/game/advanced/big_green_h.png",
    [3] = "image/game/advanced/big_orange_h.png",
    [4] = "image/game/advanced/big_purple_h.png",
    [5] = "image/game/advanced/big_red_h.png",
    [6] = "image/game/advanced/big_yellow_h.png"
}


local eli_block_action_path = {
	[1] = "csbEliminate/action/blue.plist",
    [2] = "csbEliminate/action/green.plist",
    [3] = "csbEliminate/action/orange.plist",
    [4] = "csbEliminate/action/purple.plist",
    [5] = "csbEliminate/action/red.plist",
    [6] = "csbEliminate/action/yellow.plist"
}

local eli_block_bmfont_score_path = {
	[1] = "csbEliminate/image/game/NB_score_blue.fnt",
    [2] = "csbEliminate/image/game/NB_score_green.fnt",
    [3] = "csbEliminate/image/game/NB_score_orange.fnt",
    [4] = "csbEliminate/image/game/NB_score_purple.fnt",
    [5] = "csbEliminate/image/game/NB_score_red.fnt",
    [6] = "csbEliminate/image/game/NB_score_yellow.fnt"
}

rawset(_G,"eli_block_config",eli_block_config)
rawset(_G,"eli_block_image_path_n",eli_block_image_path_n)
rawset(_G,"eli_block_image_path_h",eli_block_image_path_h)
rawset(_G,"eli_block_action_path",eli_block_action_path)
rawset(_G,"eli_block_bmfont_score_path",eli_block_bmfont_score_path)