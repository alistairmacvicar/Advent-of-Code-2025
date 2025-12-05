local function countFreshIngredients(file)
	local ranges = {}
	local isRange = true
	local freshIngredients = 0

	for line in file:lines() do
		if line == "" then
			isRange = false
			goto continue
		end

		if isRange then
			local getRange = string.gmatch(line, "([^" .. "-" .. "]+)")
			local start = getRange()
			local finish = getRange()
			table.insert(ranges, { tonumber(start), tonumber(finish) })
		else
			line = tonumber(line)

			for i, _ in ipairs(ranges) do
				if line >= ranges[i][1] and line <= ranges[i][2] then
					freshIngredients = freshIngredients + 1
					goto continue
				end
			end
		end
		::continue::
	end

	return freshIngredients
end

local function main()
	local file = io.open("input.txt", "r")
	local freshIngredients = 0

	if file then
		freshIngredients = countFreshIngredients(file)
	end

	return freshIngredients
end

print(main())
