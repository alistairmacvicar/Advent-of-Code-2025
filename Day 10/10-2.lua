local function organiseManual(file)
	local manual = {}
	local lines = {}

	for line in file:lines() do
		table.insert(lines, line)
	end

	for i = 1, #lines do
		local buttonsStr = lines[i]:match("%]%s*([%(%)%d,%s]+)%s*%{")
		local buttons = {}
		local joltageStr = lines[i]:match("%{([%d,]+)%}")
		local joltage = {}
		local line = {}

		for button in buttonsStr:gmatch("%(([%d,]+)%)") do
			local wires = {}

			for wire in button:gmatch("%d+") do
				table.insert(wires, tonumber(wire))
			end

			table.insert(buttons, wires)
		end

		for val in joltageStr:gmatch("%d+") do
			table.insert(joltage, tonumber(val))
		end

		line["joltage"] = joltage
		line["buttons"] = buttons

		table.insert(manual, line)
	end

	return manual
end

local function solveZ3(buttons, joltages)
	local script = { "(set-option :produce-models true)" }
	local values = {}
	local tempFilePath = string.format("/tmp/%d.smt2", os.time())
	local tempFile = io.open(tempFilePath, "w")
	local totalSum
	local execZ3

	if tempFile then
		for i = 1, #buttons do
			local value = string.char(96 + i)

			table.insert(script, string.format("(declare-const %s Int)", value))
			table.insert(script, string.format("(assert (>= %s 0))", value))
			table.insert(values, value)
		end

		for joltageIndex, joltage in ipairs(joltages) do
			local terms = {}

			for buttonIndex, button in ipairs(buttons) do
				for _, wire in ipairs(button) do
					if wire == joltageIndex - 1 then
						table.insert(terms, string.char(96 + buttonIndex))
						break
					end
				end
			end

			if #terms > 0 then
				local sum = "(+ " .. table.concat(terms, " ") .. ")"

				table.insert(script, string.format("(assert (= %s %d))", sum, joltage))
			else
				table.insert(script, string.format("(assert (= 0 %d))", joltage))
			end
		end

		totalSum = "(+ " .. table.concat(values, " ") .. ")"

		table.insert(script, string.format("(minimize %s)", totalSum))
		table.insert(script, "(check-sat)")
		table.insert(script, "(get-objectives)")
		table.insert(script, "(exit)")

		tempFile:write(table.concat(script, "\n"))

		execZ3 = io.popen("z3 " .. tempFilePath .. " 2>&1")

		if execZ3 then
			local result = execZ3:read("*a")
			local value = result:match("%(objectives.-(%d+)%)")

			return value
		end
	end

	return 0
end

local function main()
	local file = io.open("input.txt", "r")
	local clicks = 0
	local manual

	if file then
		manual = organiseManual(file)

		for i = 1, #manual do
			local machine = manual[i]
			local joltage = machine["joltage"]
			local buttons = machine["buttons"]

			clicks = clicks + solveZ3(buttons, joltage)
		end
	end

	return clicks
end

print(main())
