

local Model_ZhiPai = class( "Model_ZhiPai" )


function Model_ZhiPai:ctor()
	self:reset()
end

-----重置数据
function Model_ZhiPai:reset()
	self._coin = nil
	self._recordList = nil
	self:getRecordList()
end


--[[单例模式----
	外部调用这里，不调用上面两个包含构造函数，外部调用构造函数就不再是单例了，
	调用getInstance,表示单例模式，并实例化
--]]
function Model_ZhiPai:getInstance()
	if not self._instance then
		self._instance = Model_ZhiPai.new()
	end
	return self._instance
end


function Model_ZhiPai:getCoin()
	if self._coin == nil then
		--获取cc.UserDefault的单例指针getInstance(),---UserDefault类是控制数据的一个类，写UserDefault文件
		local user_default = cc.UserDefault:getInstance()
		--给self._coin赋值，通过UserDefault类的getIntegerForKey方法，
		--获取zhipaiCoin的值，此时值为nil，赋值0，这里0是外面传进去，也就是自己写的
		--一般情况get只取值,这里在类里面是增加的没有值可以赋值。这里是在读磁盘取值，上面一句只是内存中创建指针
		self._coin = user_default:getIntegerForKey( "zhipaiCoin",0 )
		if self._coin <= 0 then
			self._coin = 20
			--写入磁盘，实际只是在内存中，立即写入需要在后面加push的方法，但是一直读取磁盘写磁盘会很卡，
			--在游戏运行过程中，都是将数据保存在内存中，退出游戏或是内存划分区域满了，再写入磁盘，
			--这里如果突然关机断电等情况可能会数据丢失
			user_default:setIntegerForKey( "zhipaiCoin",self._coin )
		end
	end
	return self._coin	
end


function Model_ZhiPai:setCoin( addCoin )
	self._coin = self:getCoin() + addCoin
	local user_default = cc.UserDefault:getInstance()--获取单例指针
	user_default:setIntegerForKey( "zhipaiCoin",self._coin )--写入数据
end

--开始金币赋值，金币输完，让返回主界面，调用方法再给金币
function Model_ZhiPai:initCoin()
	self._coin = 20
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey("zhipaiCoin", self._coin)
end


-- 读取记录数据
function Model_ZhiPai:getRecordList()
	if not self._recordList then
		self._recordList = {}
		local user_default = cc.UserDefault:getInstance()
		local record_data = user_default:getStringForKey("zhipai_recordList", "")
		if record_data ~= "" then
			self._recordList = json.decode( record_data )
			table.sort( self._recordList, function(a,b)
				return a.score > b.score
			end )
		end
	end
	return self._recordList
end

-- 存贮记录数据
function Model_ZhiPai:saveRecordList( score,curLevel )
	assert( score," !! score is nil !! ")
	assert( curLevel," !! curLevel is nil !! ")

	local need_save = false
	-- 最多存储10条记录
	if #self._recordList < 10 then
		local meta = {}
		meta.score = score
		meta.time = os.time()
		meta.level = curLevel
		table.insert( self._recordList,meta )
		need_save = true
	else
		if self._recordList[#self._recordList].score < score then
			self._recordList[#self._recordList].score = score
			self._recordList[#self._recordList].level = curLevel
			self._recordList[#self._recordList].time = os.time()
			need_save = true
		end
	end
	if need_save then
		table.sort( self._recordList, function(a,b)
			return a.score > b.score
		end )
		-- 存盘
		local json_data = json.encode( self._recordList )
		local user_default = cc.UserDefault:getInstance()
		user_default:setStringForKey("zhipai_recordList", json_data)
	end
	return need_save
end



return Model_ZhiPai