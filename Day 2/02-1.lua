local function isRepeating(id)
	id = string.sub(id, 1, string.find(id, "%.") - 1)
	local idLength = string.len(id)
	local firstHalf = string.sub(id, 1, idLength // 2)
	local secondHalf = string.sub(id, idLength // 2 + 1)

	return firstHalf == secondHalf
end

local function main()
	local file = io.open("input.txt", "r")
	local sum = 0

	if file then
		for line in string.gmatch(file:read("*line"), "([^" .. "," .. "]+)") do
			local splitIndex = string.find(line, "-")

			local start = string.sub(line, 1, splitIndex - 1)
			local finish = string.sub(line, splitIndex + 1)

			for i = start, finish, 1 do
				if isRepeating(i) then
					sum = sum + i
				end
			end
		end
	end

	return sum
end

print(main())
