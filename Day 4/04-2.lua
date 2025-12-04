local function processInput(file)
	local grid = {}

	for line in file:lines() do
		local row = {}
		for item in line:gmatch(".") do
			table.insert(row, item)
		end

		table.insert(grid, row)
	end

	return grid
end

local function countRolls(grid)
	local count = 0

	for i = 1, #grid do
		local row = grid[i]
		for j = 1, #row do
			local adjacent = 0

			if row[j] ~= "@" then
				goto continue
			end

			for cell = math.max(j - 1, 1), math.min(j + 1, #row) do
				if i > 1 then
					if grid[i - 1][cell] == "@" then
						adjacent = adjacent + 1
					end
				end
				if cell ~= j and grid[i][cell] == "@" then
					adjacent = adjacent + 1
				end
				if i < #grid then
					if grid[i + 1][cell] == "@" then
						adjacent = adjacent + 1
					end
				end
			end

			if adjacent < 4 then
				count = count + 1
				row[j] = "."
			end

			::continue::
		end
	end

	return count
end

local function main()
	local file = io.open("input.txt", "r")
	local grid = processInput(file)
	local total = 0

	while true do
		local rolls = countRolls(grid)
		total = total + rolls
		if rolls == 0 then
			break
		end
	end

	return total
end

print(main())
