function IsCapturer(unit)
	local noncapturelist = {}
	if ShardSpringLua then
		noncapturelist = Script.LuaRules.NonCapturingUnits() or {}
	end
	for i = 1, #noncapturelist do
		local name = noncapturelist[i]
		if name == unit:Internal():Name() then
			return false
		end
	end
	return true
end

CapturerBehaviour = class(Behaviour)

function CapturerBehaviour:Init()
end

function CapturerBehaviour:UnitIdle()
	if unit.engineID == self.unit.engineID then
		self:GoForth()
	end
end

function CapturerBehaviour:Priority()
	return 40
end

function CapturerBehaviour:Activate()
	self.active = true
	self:GoForth()
end

function CapturerBehaviour:GoForth()
	local upos = self.unit:Internal():GetPosition()
	local point = self.ai.controlpointbehaviour:ClosestUncapturedPoint(upos)
	if point ~= self.currentPoint then
		self.unit:Internal():Move(point)
		self.currentPoint = point
	end
end