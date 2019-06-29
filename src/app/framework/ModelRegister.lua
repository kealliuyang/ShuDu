--
-- Author: 
-- Date: 2017-06-20
-- 数据模型注册全部写在这里

local ModelRegister = class("ModelRegister")



function ModelRegister:ctor()
	self:reset()
end

function ModelRegister:reset()
	self._modelsList ={}
end

function ModelRegister:getInstance()
	if not self._instance then
		self._instance = ModelRegister.new()
	end
	return self._instance
end

function ModelRegister:registAll()
	local _t = os.clock()
	print("Model 加载 开始读取 ")
	self:registerModel(require("app.mode.Model_Player"),"Model_Player")
	self:registerModel(require("app.mode.Model_Sound"),"Model_Sound")
	self:registerModel(require("app.mode.Model_Eliminate"),"Model_Eliminate")
	self:registerModel(require("app.mode.Model_TwentyFour"),"Model_TwentyFour")
	self:registerModel(require("app.mode.Model_MaJiang"),"Model_MaJiang")
	self:registerModel(require("app.mode.Model_LaoHuJi"),"Model_LaoHuJi")
	self:registerModel(require("app.mode.Model_ChengYuJieLong"),"Model_ChengYuJieLong")
	self:registerModel(require("app.mode.Model_TwentyOne"),"Model_TwentyOne")
	self:registerModel(require("app.mode.Model_JunShi"),"Model_JunShi")
	self:registerModel(require("app.mode.Model_LaBa"),"Model_LaBa")
	self:registerModel(require("app.mode.Model_ZhiPai"),"Model_ZhiPai")
	self:registerModel(require("app.mode.Model_SanGuo"),"Model_SanGuo")
	self:registerModel(require("app.mode.Model_ZhanDou"),"Model_ZhanDou")
	print("Model 加载读取完毕!所需秒:"..(os.clock() - _t))
end


function ModelRegister:registerModel( modelCls, modelName )
	assert( modelCls," !! modelCls is nil !! ")
	assert( modelName," !! modelName is nil !! ")
	assert( self._modelsList[modelName] == nil," !! model is regesiter !! " )
	self._modelsList[modelName] = modelCls:getInstance()
end

function ModelRegister:getModel( modelName )
	assert( modelName," !! modelName is nil !! ")
	assert( self._modelsList[modelName]," !! model is nil !! ")
	return self._modelsList[modelName]
end




rawset(_G, "ModelRegister", ModelRegister)