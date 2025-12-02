local function isRepeating(id)
	id = string.sub(id, 1, string.find(id, "%.") - 1)

	local match = false
	local pattern = string.sub(id, 1, 1)
	local idLength = string.len(id)
	local i = 2

	while i <= idLength do
		local patternLength = string.len(pattern)
		local startIndex = i
		local endIndex = startIndex + patternLength - 1
		local nextSequence = string.sub(id, startIndex, endIndex)

		match = nextSequence == pattern

		if match then
			i = i + patternLength
		else
			pattern = string.sub(id, 1, i)
			i = i + 1
		end

		if not match and i > idLength - patternLength then
			return match
		end
	end

	return match
end

local function main()
	local file = io.open("input.txt", "r")
	local sum = 0

	if file then
		for line in string.gmatch(file:read("*line"), "([^" .. "," .. "]+)") do
			local splitIndex = string.find(line, "-")
			if splitIndex then
				local start = string.sub(line, 1, splitIndex - 1)
				local finish = string.sub(line, splitIndex + 1)

				for i = start, finish, 1 do
					if isRepeating(i) then
						sum = sum + i
					end
				end
			end
		end
	end
	return sum
end

print(main())
