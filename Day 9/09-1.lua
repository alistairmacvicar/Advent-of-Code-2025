local function findLargestRectangle(tiles)
	local area = 0

	for i = 1, #tiles - 1 do
		for j = i, #tiles do
			local x = math.abs(tiles[i]["x"] - tiles[j]["x"]) + 1
			local y = math.abs(tiles[i]["y"] - tiles[j]["y"]) + 1

			area = math.max(x * y, area)
		end
	end

	return area
end

local function getRedTiles(file)
	local tiles = {}

	for line in file:lines() do
		local tile = {}
		local split = line:gmatch("([^" .. "," .. "]+)")
		local x = tonumber(split())
		local y = tonumber(split())

		tile["x"] = x
		tile["y"] = y

		table.insert(tiles, tile)
	end

	return tiles
end

local function main()
	local file = io.open("input.txt", "r")
	local area = 0

	if file then
		local redTiles = getRedTiles(file)
		area = findLargestRectangle(redTiles)
	end

	return area
end

print(main())
