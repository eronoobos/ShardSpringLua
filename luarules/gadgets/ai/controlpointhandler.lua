ControlPointHandler = class(Module)

function ControlPointHandler:Name()
	return "ControlPointHandler"
end

function ControlPointHandler:internalName()
	return "controlpointhandler"
end

local function distance(pos1,pos2)
	local xd = pos1.x-pos2.x
	local yd = pos1.z-pos2.z
	local dist = math.sqrt(xd*xd + yd*yd)
	return dist
end

function ControlPointHandler:Init()
	self.points = {}
	if ShardSpringLua then
		self.points = Script.LuaRules.ControlPoints()
	end
	self.team = self.ai.id
end

function ControlPointHandler:ClosestUncapturedPoint(position)
	local pos
	local bestDistance
	for i = 1, #self.points do
		local point = self.points[i]
		local pointTeam = Script.LuaRules.ControlPointTeam(point.x, point.y, point.z)
		if pointTeam ~= self.team then
			local dist = distance(position, point)
			if not bestDistance or dist < bestDistance then
				bestDistance = dist
				pos = point
			end
		end
	end
	return pos
end

function ControlPointHandler:ArePoints()
	return #self.points > 0
end