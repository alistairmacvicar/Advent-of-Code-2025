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

	table.sort(tiles, function(a, b)
		return a[2] > b[2]
	end)

	return tiles
end

local function getValidArea(tiles)
	local validArea = {}
	local min = tiles[1]["y"]
	local max = tiles[#tiles]["y"]

	for i = min, max do
		table.insert(validArea, { {}, {} })
	end

	for i = 1, #tiles do
		local x = tiles[i]["x"]
		local y = tiles[i]["y"]

		table.insert(validArea[y][1], x)
		table.insert(validArea[y][2], x)

		validArea[y][2] = { math.min(validArea[y][2], x), math.max(validArea[y][2], x) }
	end

	for i = 1, #validArea do
		for j = 1, #validArea[i] do
			for k = i, #validArea do
				if validArea[i][k] == validArea[i][j] then
					for l = j, k do
						validArea[l][2] =
							{ math.min(validArea[l][2], validArea[i][k]), math.max(validArea[l][2], validArea[i][k]) }
					end
				end
			end
		end
	end

	return validArea
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
