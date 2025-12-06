local function calculateEquation(numbers, symbol)
	local result = 0

	if symbol == "+" then
		for _, number in ipairs(numbers) do
			result = result + number
		end
	elseif symbol == "*" then
		result = 1
		for _, number in ipairs(numbers) do
			result = result * number
		end
	end

	return result
end

local function preprocess(file)
	local lines = {}
	local numbers = {}
	local symbols = {}

	for line in file:lines() do
		local values = {}

		for value in string.gmatch(line, "%S+") do
			if value ~= "" then
				table.insert(values, value)
			end
		end

		table.insert(lines, values)
	end

	for i = 1, #lines[1] do
		local values = {}

		for j = 1, #lines - 1 do
			table.insert(values, lines[j][i])
		end

		table.insert(numbers, values)
		table.insert(symbols, lines[#lines][i])
	end

	return numbers, symbols
end

local function main()
	local file = io.open("input.txt", "r")
	local total = 0

	if file then
		local numbers, symbols = preprocess(file)

		for i = 1, #symbols do
			local result = calculateEquation(numbers[i], symbols[i])
			total = total + result
		end
	end

	return total
end

print(main())
