

local Model_LaBa = class("Model_LaBa")



function Model_LaBa:ctor()
	self:reset()
end


function Model_LaBa:reset()
	self._coin = nil
end


function Model_LaBa:getInstance()
	if not self._instance then
		self._instance = Model_LaBa.new()
	end
	return self._instance
end



function Model_LaBa:getCoin()
	if self._coin == nil then
		local user_default = cc.UserDefault:getInstance()
		self._coin = user_default:getIntegerForKey("labaCoin", 0)
		if self._coin <= 0 then
			self._coin = 20
			user_default:setIntegerForKey("labaCoin", self._coin)
		end
	end
	return self._coin
end

function Model_LaBa:setCoin( addCoin )
	self._coin = self:getCoin() + addCoin
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey("labaCoin", self._coin)
end

function Model_LaBa:initCoin()
	self._coin = 20
	local user_default = cc.UserDefault:getInstance()
	user_default:setIntegerForKey("labaCoin", self._coin)
end









return Model_LaBa