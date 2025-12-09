local function findLargestRectangle(area)
	local largestRectangle = 0

	for row = 1, #area do
		for tile = 1, #area[row][1] do
			local x = area[row][1][tile]

			if x == nil then
				goto continue
			end

			for nextRow = row, #area do
				for nextTile = 1, #area[nextRow][1] do
					local nextX = area[nextRow][1][nextTile]

					if nextX ~= nil then
						local minX = math.min(x, nextX)
						local maxX = math.max(x, nextX)

						local validRect = true
						for checkRow = row, nextRow do
							if
								area[checkRow][2][1] == -1
								or minX < area[checkRow][2][1]
								or maxX > area[checkRow][2][2]
							then
								validRect = false
								break
							end
						end

						if validRect then
							largestRectangle = math.max(largestRectangle, ((maxX - minX + 1) * (nextRow - row + 1)))
						end
					end
				end
			end
			::continue::
		end
	end

	return largestRectangle
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

local function getValidArea(tiles)
	local validArea = {}
	local minRows = 1
	local maxRows = math.mininteger

	for i = 1, #tiles do
		maxRows = math.max(maxRows, tiles[i]["y"])
	end

	for y = minRows, maxRows do
		validArea[y] = { {}, { -1, -1 } }
	end

	for i = 1, #tiles do
		local x = tiles[i]["x"]
		local y = tiles[i]["y"]

		table.insert(validArea[y][1], x)

		if validArea[y][2][1] == -1 then
			validArea[y][2] = { x, x }
		else
			validArea[y][2] = {
				math.min(validArea[y][2][1], x),
				math.max(validArea[y][2][2], x),
			}
		end
	end

	for i = 1, #tiles do
		local nextI = (i % #tiles) + 1
		local x1, y1 = tiles[i]["x"], tiles[i]["y"]
		local x2, y2 = tiles[nextI]["x"], tiles[nextI]["y"]

		if x1 == x2 and y1 ~= y2 then
			local minRow = math.min(y1, y2)
			local maxRow = math.max(y1, y2)

			for row = minRow, maxRow do
				if validArea[row][2][1] == -1 then
					validArea[row][2] = { x1, x1 }
				else
					validArea[row][2] = {
						math.min(validArea[row][2][1], x1),
						math.max(validArea[row][2][2], x1),
					}
				end
			end
		end
	end

	return validArea
end

local function main()
	local file = io.open("input.txt", "r")
	local largestRectangle = 0

	if file then
		local redTiles = getRedTiles(file)
		local area = getValidArea(redTiles)
		largestRectangle = findLargestRectangle(area)
	end

	return largestRectangle
end

print(main())
