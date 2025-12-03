local function getMaxJoltage(bank)
	local first = 0
	local maxIndex = 1
	local second = 0
	local length = #bank
	local battery = 1

	for value in bank:gmatch(".") do
		local joltage = math.tointeger(value)

		if battery < length and joltage > first then
			first = joltage
			maxIndex = battery
			print("new max found: " .. first .. " at: " .. maxIndex)
		end
		battery = battery + 1
	end

	for i = maxIndex + 1, length, 1 do
		local joltage = math.tointeger(bank:sub(i, i))

		second = math.max(second, joltage)
	end

	return first * 10 + second
end

local function main()
	local file = io.open("input.txt", "r")
	local total = 0

	if file then
		for line in file:lines() do
			total = total + getMaxJoltage(line)
		end
	end

	return total
end

print(main())
