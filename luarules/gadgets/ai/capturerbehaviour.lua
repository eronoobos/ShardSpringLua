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

local function RandomAway(pos, dist, angle)
	angle = angle or math.random() * math.pi * 2
	local away = api.Position()
	away.x = pos.x + dist * math.cos(angle)
	away.z = pos.z - dist * math.sin(angle)
	away.y = pos.y + 0
	return away
end

function CapturerBehaviour:Init()
	self.arePoints = self.ai.controlpointhandler:ArePoints()
	self.maxDist = math.ceil( self.ai.controlpointhandler:CaptureRadius() * 0.9 )
	self.minDist = math.ceil( self.maxDist / 3 )
end

function CapturerBehaviour:UnitIdle()
	if unit.engineID == self.unit.engineID then
		self:GoForth()
	end
end

function CapturerBehaviour:Priority()
	if self.arePoints then
		return 40
	else
		return 0
	end
end

function CapturerBehaviour:Activate()
	self.active = true
	self:GoForth()
end

function CapturerBehaviour:GoForth()
	local upos = self.unit:Internal():GetPosition()
	local point = self.ai.controlpointhandler:ClosestUncapturedPoint(upos)
	if point ~= self.currentPoint then
		local movePos = RandomAway( point, math.random(self.minDist,self.maxDist) )
		self.unit:Internal():Move(movePos)
		self.currentPoint = point
	end
end