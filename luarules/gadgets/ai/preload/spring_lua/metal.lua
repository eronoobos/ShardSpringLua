local elmosPerMetal = 16
local metalmapSizeX = Game.mapSizeX / elmosPerMetal
local metalmapSizeZ = Game.mapSizeZ / elmosPerMetal
local extractorRadiusMetal = Game.extractorRadius / elmosPerMetal
local maxSpotArea = math.ceil( (extractorRadiusMetal*extractorRadiusMetal) * 2 * math.pi )
local minSpotArea = math.ceil( maxSpotArea * 0.25 )
local sqRootThree = math.sqrt(3)
local halfHexHeight = math.ceil( (sqRootThree * extractorRadiusMetal) / 2 )
local halfExtractorRadiusMetal = math.ceil( extractorRadiusMetal / 2 )

Spring.Echo(metalmapSizeX, metalmapSizeZ, metalmapSizeX*metalmapSizeZ, extractorRadiusMetal, maxSpotArea)

local spGetMetalAmount = Spring.GetMetalAmount
local spGetGroundHeight = Spring.GetGroundHeight

local isInBlob = {}
local blobs = {}
local hexes = {}
local spotsInBlob = {}

local function Flood4Metal(x, z, id)
	if x > metalmapSizeX or x < 1 or z > metalmapSizeZ or z < 1 then return end
	if isInBlob[x] and isInBlob[x][z] then return end
	local metalAmount = spGetMetalAmount(x, z)
	if metalAmount and metalAmount > 0 then
		if not isInBlob[x] then isInBlob[x] = {} end
		if not blobs[id] then blobs[id] = {} end
		blobs[id][#blobs[id]+1] = {x=x, z=z}
		isInBlob[x][z] = id
		Flood4Metal(x+1,z,id)
		Flood4Metal(x-1,z,id)
		Flood4Metal(x,z+1,id)
		Flood4Metal(x,z-1,id)
		return true
	end
end

local function CheckHorizontalLineBlob(x, z, tx, id)
	local area = 0
	for ix = x, tx do
		if isInBlob[x] and isInBlob[x][z] == id then
			area = area + 1
		end
	end
	return area
end

local function Check4Blob(cx, cz, x, z, id)
	local area = 0
	area = area + CheckHorizontalLineBlob(cx - x, cz + z, cx + x, val, jam)
	if x ~= 0 and z ~= 0 then
        area = area + CheckHorizontalLineBlob(cx - x, cz - z, cx + x, val, jam)
    end
    return area
end

local function CheckCircle(cx, cz, radius, id)
	local area = 0
	if radius > 0 then
		local err = -radius
		local x = radius
		local z = 0
		while x >= z do
	        local lastZ = z
	        err = err + z
	        z = z + 1
	        err = err + z
	        area = area + Check4Blob(cx, cz, x, lastZ, id)
	        if err >= 0 then
	            if x ~= lastZ then
	            	area = area + Check4Blob(cx, cz, lastZ, x, id)
	            end
	            err = err - x
	            x = x - 1
	            err = err - x
	        end
	    end
	end
	return area
end

local function FloodHexBlob(x, z, id)
	if x > metalmapSizeX or x < 1 or z > metalmapSizeZ or z < 1 then return end
	if not hexes[id] then hexes[id] = {} end
	if not hexes[id][x] then hexes[id][x] = {} end
	if hexes[id][x][z] or not (isInBlob[x] and isInBlob[x][z] == id) then return end
	local blobArea = CheckCircle(x, z, extractorRadiusMetal, id)
	if blobArea > minSpotArea then
		spotsInBlob[id][#spotsInBlob[id]+1] = {x=x*elmosPerMetal,z=z*elmosPerMetal}
		hexes[id][x][z] = true
		FloodHexBlob(x + extractorRadiusMetal, z, id)
		FloodHexBlob(x + halfExtractorRadiusMetal, z - halfHexHeight, id)
		FloodHexBlob(x - halfExtractorRadiusMetal, z - halfHexHeight, id)
		FloodHexBlob(x - extractorRadiusMetal, z, id)
		FloodHexBlob(x - halfExtractorRadiusMetal, z + halfHexHeight, id)
		FloodHexBlob(x + halfExtractorRadiusMetal, z + halfHexHeight, id)
		return true
	end
	return false
end

local function CirclePack(x, z, id)
	spotsInBlob[id] = { {x=x*elmosPerMetal, z=z*elmosPerMetal} }
	local okay = FloodHexBlob(x, z, id)
	if not okay then spotsInBlob = {} end
end

local function GetSpots()
	local id = 1
	for x = 1, metalmapSizeX do
		for z = 1, metalmapSizeZ do
			local tharBeMetal = Flood4Metal(x, z, id)
			if tharBeMetal then id = id + 1 end
		end
	end
	local spots = {}
	for id = 1, #blobs do
		local blob = blobs[id]
		local x, z = 0, 0
		for p = 1, #blob do
			local pixel = blob[p]
			x = x + pixel.x
			z = z + pixel.z
		end
		x = x / #blob
		z = z / #blob
		local sx = x * elmosPerMetal
		local sz = z * elmosPerMetal
		if #blob < maxSpotArea then
			spots[#spots+1] = {x=sx, z=sz, y=spGetGroundHeight(sx,sz)}
		else
			x = mCeil(x)
			z = mCeil(z)
			CirclePack(x, z, id)
			local blobSpots = spotsInBlob[id]
			for i = 1, blobSpots do
				local spot = blobSpots[i]
				spots[#spots+1] = spot
			end
		end
	end
	return spots
end

local spots = GetSpots()

return spots