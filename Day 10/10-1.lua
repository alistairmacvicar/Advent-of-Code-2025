local function organiseManual(file)
	local manual = {}
	local lines = {}

	for line in file:lines() do
		table.insert(lines, line)
	end

	for i = 1, #lines do
		local firstBlock = lines[i]:find("%s+")
		local lightString = lines[i]:sub(1, firstBlock - 1)
		local lights = {}
		local buttonsString = lines[i]:sub(firstBlock)
		local buttons = {}
		local line = {}

		for j = 2, #lightString - 1 do
			local light = lightString:sub(j, j)
			table.insert(lights, light)
		end

		for button in buttonsString:gmatch("%S+") do
			local values = {}
			button = button:gsub("%s", "")

			for value in button:gmatch("([^,]+)") do
				value = value
				table.insert(values, value)
			end

			if #values > 0 then
				values[1] = values[1]:sub(2)
				values[#values] = values[#values]:sub(1, 1)
			end

			for j = 1, #values do
				values[j] = tonumber(values[j]) + 1
			end

			table.insert(buttons, values)
		end

		table.remove(buttons, #buttons)
		line["lights"] = lights
		line["buttons"] = buttons
		table.insert(manual, line)
	end

	return manual
end

local function isValid(targetLights, buttons, presses)
	local state = {}

	for i = 1, #targetLights do
		state[i] = "."
	end

	for i = 1, #buttons do
		if presses[i] % 2 == 1 then
			for j = 1, #buttons[i] do
				if state[buttons[i][j]] == "." then
					state[buttons[i][j]] = "#"
				elseif state[buttons[i][j]] == "#" then
					state[buttons[i][j]] = "."
				end
			end
		end
	end

	for i = 1, #state do
		if state[i] ~= targetLights[i] then
			return false
		end
	end

	return true
end

local function findMinPresses(lights, buttons)
	local numButtons = #buttons

	for numPresses = 1, numButtons do
		for mask = 1, (2 ^ numButtons) - 1 do
			local bitCount = 0

			for i = 0, numButtons - 1 do
				if ((mask >> i) & 1) == 1 then
					bitCount = bitCount + 1
				end
			end

			if bitCount == numPresses then
				local presses = {}

				for i = 1, numButtons do
					presses[i] = (mask >> (i - 1)) & 1
				end

				if isValid(lights, buttons, presses) then
					return numPresses
				end
			end
		end
	end

	return 0
end

local function main()
	local file = io.open("input.txt", "r")
	local totalClicks = 0
	local manual

	if file then
		manual = organiseManual(file)

		for line = 1, #manual do
			local lights = manual[line]["lights"]
			local buttons = manual[line]["buttons"]
			local minPresses = findMinPresses(lights, buttons)

			totalClicks = totalClicks + minPresses
		end
	end

	return totalClicks
end

print(main())

