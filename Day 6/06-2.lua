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
	local symbols = {}
	local numbers = {}
	local currentProblem = {}
	local symbol = nil

	for line in file:lines() do
		table.insert(lines, line)
	end

	for col = #lines[1], 1, -1 do
		local hasDigit = false
		local numberBuilder = ""
		local currentSymbol = lines[#lines]:sub(col, col)

		for row = 1, #lines - 1 do
			local char = lines[row]:sub(col, col)
			if char:match("%d") then
				numberBuilder = numberBuilder .. char
				hasDigit = true
			end
		end

		if currentSymbol:match("[%+%*]") then
			symbol = currentSymbol
		end

		if hasDigit then
			table.insert(currentProblem, 1, tonumber(numberBuilder))
		elseif #currentProblem > 0 then
			table.insert(numbers, 1, currentProblem)
			table.insert(symbols, 1, symbol)
			currentProblem = {}
			symbol = nil
		end
	end

	if #currentProblem > 0 then
		table.insert(numbers, 1, currentProblem)
		table.insert(symbols, 1, symbol)
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
