
local EventManager = class("EventManager")


function EventManager:ctor()
	self:reset()
end

function EventManager:reset()
	self._instance = nil
	self._innerListener = nil
	self._netListener = nil
end

function EventManager:getInstance()
	if not self._instance then
		self._instance = EventManager.new()
	end
	return self._instance
end

function EventManager:addInnerListener( eventName,listener )
	assert( eventName," !! eventName is nil !! ")
	assert( listener," !! listener is nil !! ")
	assert( InnerProtocol[eventName]," !! InnerProtocol not regeist !! " )
	if not self._innerListener then
		self._innerListener = {}
	end
	assert( not self._innerListener[eventName], " !! InnerProtocol has regeist !! ")
	assert( type(listener) == "function", " !! listener must be function !! ")
	self._innerListener[eventName] = listener
end

function EventManager:addNetListener( eventName,listener )
	assert( eventName," !! eventName is nil !! ")
	assert( listener," !! listener is nil !! ")
	assert( NetProtocol[eventName]," !! NetProtocol not regeist !! " )
	if not self._netListener then
		self._netListener = {}
	end
	assert( self._netListener[eventName], " !! NetProtocol has regeist !! ")
	assert( type(listener) == "function", " !! listener must be function !! ")
	self._netListener[eventName] = listener
end

function EventManager:dispatchInnerEvent( eventName,... )
	if not self._innerListener or not self._innerListener[eventName] then
		return
	end
	local args = { ... }
	local event = {}
	event.name = eventName
	event.data = args
	self._innerListener[eventName](event)
end

function EventManager:dispatchNetEvent( eventName,... )
	assert( self._netListener[eventName]," !! net event listener is nil !! ")
	local args = { ... }
	local event = {}
	event.name = eventName
	event.data = args
	self._netListener[eventName](event)
end

function EventManager:removeInnerListener( eventName )
	if self._innerListener[eventName] then
		self._innerListener[eventName] = nil
	end
end

function EventManager:removeNetListener( eventName )
	if self._netListener[eventName] then
		self._netListener[eventName] = nil
	end
end

rawset(_G,"EventManager",EventManager)