local function getJunctions(file)
	local coordinates = {}

	for line in file:lines() do
		local split = line:gmatch("([^" .. "," .. "]+)")
		local x = split()
		local y = split()
		local z = split()
		local circuit = 0

		table.insert(coordinates, { x, y, z, circuit })
	end

	return coordinates
end

local function getEuclideanDistance(a, b)
	return math.sqrt(((a[1] - b[1]) ^ 2) + ((a[2] - b[2]) ^ 2) + ((a[3] - b[3]) ^ 2))
end

local function updateCircuits(junctions, oldCircuit, newCircuit)
	for i = 1, #junctions do
		if junctions[i][4] == newCircuit then
			junctions[i][4] = oldCircuit
		end
	end

	return junctions
end

local function getNextCircuitNumber(junctions)
	local highestNumber = 0

	for i = 1, #junctions do
		if junctions[i][4] > highestNumber then
			highestNumber = junctions[i][4]
		end
	end

	return highestNumber + 1
end

local function allInOneCircuit(junctions)
	local firstCircuit = nil

	for i = 1, #junctions do
		if firstCircuit == nil then
			firstCircuit = junctions[i][4]
		elseif junctions[i][4] ~= firstCircuit or junctions[i][4] == 0 then
			return false
		end
	end

	return true
end

local function getCircuitLengths(junctions)
	local lastConnected = {}
	local edges = {}

	for i = 1, #junctions - 1 do
		for j = i + 1, #junctions do
			local distance = getEuclideanDistance(junctions[i], junctions[j])
			table.insert(edges, { i, j, distance })
		end
	end

	table.sort(edges, function(a, b)
		return a[3] < b[3]
	end)

	for _, edge in ipairs(edges) do
		local i, j = edge[1], edge[2]

		if allInOneCircuit(junctions) then
			break
		end

		if not (junctions[i][4] ~= 0 and junctions[j][4] ~= 0 and junctions[i][4] == junctions[j][4]) then
			if junctions[i][4] == 0 and junctions[j][4] == 0 then
				local circuitNumber = getNextCircuitNumber(junctions)

				junctions[i][4] = circuitNumber
				junctions[j][4] = circuitNumber
			elseif junctions[i][4] == 0 then
				junctions[i][4] = junctions[j][4]
			elseif junctions[j][4] == 0 then
				junctions[j][4] = junctions[i][4]
			else
				junctions = updateCircuits(junctions, junctions[i][4], junctions[j][4])
			end
			lastConnected = { junctions[i][1], junctions[j][1] }
		end
	end

	return lastConnected
end

local function main()
	local file = io.open("input.txt", "r")
	local result

	if file then
		local junctions = getJunctions(file)
		local lengths = getCircuitLengths(junctions)
		result = lengths[1] * lengths[2]
	end

	return result
end

print(main())
