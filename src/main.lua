
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "cocos.init"

if CC_SHOW_FPS then
    cc.Director:getInstance():setDisplayStats(true)
end

local function main()
	-- 原生的 去掉
    -- require("app.EnterApp"):create():run()

    -- 模拟小游戏的入口
    local sudokusc = require("app.EnterApp"):create()
    display.runScene(sudokusc)
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
