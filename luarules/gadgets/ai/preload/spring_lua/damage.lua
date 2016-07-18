ShardSpringDamage = class(function(a)
   --
end)

local spGetGameFrame = Spring.GetGameFrame
local spGetProjectileDirection = Spring.GetProjectileDirection

function ShardSpringDamage:Init( damage, weaponDefID, paralyzer, projectileID, engineAttacker )
	self.damage = damage
	self.weaponDefID = weaponDefID
	self.paralyzer = paralyzer
	self.projectileID = projectileID
	self.attacker = engineAttacker
	self.gameframe = spGetGameFrame()
	self.direction = spGetProjectileDirection(projectileID)
	self.damageType = weaponDefID
	self.weaponType = WeaponDefs[weaponDefID].name
end

function ShardSpringDamage:Damage()
	return self.damage
end

function ShardSpringDamage:Attacker()
	return self.attacker
end

function ShardSpringDamage:Direction()
	return self.direction
end

function ShardSpringDamage:DamageType()
	return self.damageType
end

function ShardSpringDamage:WeaponType()
	return self.weaponType
end