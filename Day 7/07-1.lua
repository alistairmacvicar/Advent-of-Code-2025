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

local function tachyonRoute(lines)
	local splits = 0

	for i = 1, #lines - 1 do
		for j = 1, #lines[i] do
			if lines[i][j] == "S" then
				lines[i][j] = "|"
			end

			if lines[i][j] == "|" then
				if lines[i + 1][j] == "^" then
					splits = splits + 1

					lines[i + 1][j - 1] = "|"
					lines[i + 1][j + 1] = "|"
				else
					lines[i + 1][j] = "|"
				end
			end
		end
	end

	return splits
end

local function main()
	local file = io.open("input.txt", "r")
	local lines
	local splits = 0

	if file then
		lines = preprocess(file)
		splits = tachyonRoute(lines)
	end

	return splits
end

print(main())
