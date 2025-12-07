local memo = {}

local function preprocess(file)
	local lines = {}

	for line in file:lines() do
		local elements = {}

		for element in line:gmatch("%S") do
			table.insert(elements, element)
		end

		table.insert(lines, elements)
	end

	return lines
end

local function deepcopy(lines)
	local copy = {}

	for i, line in ipairs(lines) do
		if type(line) == "table" then
			copy[i] = deepcopy(line)
		else
			copy[i] = line
		end
	end

	return copy
end

local function tachyonRoute(lines)
	if #lines == 1 then
		return 1
	end

	local key = table.concat(lines[1], "") .. table.concat(lines[2], "")

	if memo[key] then
		return memo[key]
	end

	local timeLines = 0
	for j = 1, #lines[1] do
		if lines[1][j] == "S" or lines[1][j] == "|" then
			if lines[2][j] == "^" then
				if lines[2][j - 1] ~= "|" then
					local newLines = deepcopy(lines)

					newLines[2][j - 1] = "|"
					timeLines = timeLines + tachyonRoute({ table.unpack(newLines, 2) })
				end

				if lines[2][j + 1] ~= "|" then
					local newLines = deepcopy(lines)

					newLines[2][j + 1] = "|"
					timeLines = timeLines + tachyonRoute({ table.unpack(newLines, 2) })
				end
			else
				local newLines = deepcopy(lines)

				newLines[2][j] = "|"
				timeLines = timeLines + tachyonRoute({ table.unpack(newLines, 2) })
			end
		end
	end

	memo[key] = timeLines
	return timeLines
end

local function main()
	local file = io.open("input.txt", "r")
	local lines
	local timelines = 0

	if file then
		lines = preprocess(file)
		timelines = tachyonRoute(lines)
	end

	return timelines
end

print(main())
