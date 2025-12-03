local function getMaxJoltage(bank, digits, index)
	local joltage = 0
	local length = #bank

	for i = index, length - digits + 1, 1 do
		local battery = math.tointeger(bank:sub(i, i))

		if battery > joltage then
			joltage = math.tointeger(battery)
			index = i + 1
		end
	end

	digits = digits - 1

	if digits > 0 then
		joltage = joltage .. getMaxJoltage(bank, digits, index)
	end

	return joltage
end

local function main()
	local file = io.open("input.txt", "r")
	local total = 0
	local digits = 12
	local index = 1

	if file then
		for line in file:lines() do
			total = total + getMaxJoltage(line, digits, index)
		end
	end

	return total
end

print(main())
