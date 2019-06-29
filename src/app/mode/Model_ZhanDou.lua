

local Model_ZhanDou = class( "Model_ZhanDou" )


function Model_ZhanDou:ctor()
	self:reset()
end

-----重置数据
function Model_ZhanDou:reset()
	self._coin = nil
	self._score = 0
	self._stage = 1
end

function Model_ZhanDou:resetStage(  )
	self._stage = 1
	self._score = 0
end

--[[单例模式----
	外部调用这里，不调用上面两个包含构造函数，外部调用构造函数就不再是单例了，
	调用getInstance,表示单例模式，并实例化
--]]
function Model_ZhanDou:getInstance()
	if not self._instance then
		self._instance = Model_ZhanDou.new()
	end
	return self._instance
end


function Model_ZhanDou:getCoin()
	if self._coin == nil then
		--获取cc.UserDefault的单例指针getInstance(),---UserDefault类是控制数据的一个类，写UserDefault文件
		local user_default = cc.UserDefault:getInstance()
		--给self._coin赋值，通过UserDefault类的getIntegerForKey方法，
		--获取zhipaiCoin的值，此时值为nil，赋值0，这里0是外面传进去，也就是自己写的
		--一般情况get只取值,这里在类里面是增加的没有值可以赋值。这里是在读磁盘取值，上面一句只是内存中创建指针
		self._coin = user_default:getIntegerForKey( "zhandouCoin",20 )
		--注销，只送一次金币
		-- if self._coin <= 0 then
		-- 	self._coin = 50
		-- 	--写入磁盘，实际只是在内存中，立即写入需要在后面加push的方法，但是一直读取磁盘写磁盘会很卡，
		-- 	--在游戏运行过程中，都是将数据保存在内存中，退出游戏或是内存划分区域满了，再写入磁盘，
		-- 	--这里如果突然关机断电等情况可能会数据丢失
		-- 	user_default:setIntegerForKey( "sanguoCoin",self._coin )
		-- end
	end
	return self._coin	
end


function Model_ZhanDou:setCoin( addCoin )
	self._coin = self:getCoin() + addCoin
	local user_default = cc.UserDefault:getInstance()--获取单例指针
	user_default:setIntegerForKey( "zhandouCoin",self._coin )--写入数据
end

--开始金币赋值，金币输完，让返回主界面，调用方法再给金币
function Model_ZhanDou:initCoin()
	self._coin = 20
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey("zhandouCoin", self._coin)
end


function Model_ZhanDou:getScore()
	return self._score	
end


function Model_ZhanDou:setScore( addScore )
	self._score = self._score + addScore
end

function Model_ZhanDou:getStage()
	return self._stage
end

function Model_ZhanDou:setStage()
	self._stage = self._stage + 1
end

return Model_ZhanDou