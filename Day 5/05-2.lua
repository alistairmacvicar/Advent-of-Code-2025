local function sortIDs(file)
	local ranges = {}

	for line in file:lines() do
		if line == "" then
			break
		end

		local getRange = string.gmatch(line, "([^" .. "-" .. "]+)")
		local start = tonumber(getRange())
		local finish = tonumber(getRange())

		table.insert(ranges, { start, finish })
	end

	table.sort(ranges, function(a, b)
		return a[1] < b[1]
	end)

	return ranges
end

local function mergeRanges(ranges)
	local mergedRanges = {}

	for i = 1, #ranges do
		local start = ranges[i][1]
		local finish = ranges[i][2]

		if #mergedRanges < 1 or start > mergedRanges[#mergedRanges][2] then
			table.insert(mergedRanges, { start, finish })
		else
			mergedRanges[#mergedRanges][2] = math.max(mergedRanges[#mergedRanges][2], finish)
		end
	end

	return mergedRanges
end

local function countFreshIngredients(freshRanges)
	local freshIngredients = 0

	for i = 1, #freshRanges do
		local start = freshRanges[i][1]
		local finish = freshRanges[i][2]

		freshIngredients = freshIngredients + 1 + finish - start
	end

	return freshIngredients
end

local function main()
	local file = io.open("input.txt", "r")
	local freshIngredients = 0

	if file then
		local sortedIDs = sortIDs(file)
		local freshRanges = mergeRanges(sortedIDs)
		freshIngredients = countFreshIngredients(freshRanges)
	end

	return freshIngredients
end

print(main())
