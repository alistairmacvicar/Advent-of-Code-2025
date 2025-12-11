local memo = {}
local DAC = 1
local FFT = 2

local function processInput(file)
	local lines = {}
	local graph = {}

	for line in file:lines() do
		table.insert(lines, line)
	end

	for _, line in pairs(lines) do
		local server, rest = line:match("^([A-Za-z0-9]+):%s*(.*)")
		local outputs = {}

		for output in rest:gmatch("%S+") do
			table.insert(outputs, output)
		end

		graph[server] = outputs
	end

	return graph
end

local function findPaths(graph, node, visited)
	local key = node .. visited
	local paths = 0

	if memo[key] then
		return memo[key]
	end

	if node == "out" then
		if (visited & DAC ~= 0) and (visited & FFT ~= 0) then
			paths = paths + 1
		end

		return paths
	end

	if node == "dac" then
		visited = visited | DAC
	elseif node == "fft" then
		visited = visited | FFT
	end

	for i = 1, #graph[node] do
		local output = graph[node][i]
		paths = paths + findPaths(graph, output, visited)
	end

	memo[key] = paths
	return paths
end

local function main()
	local file = io.open("input.txt", "r")
	local paths = 0

	if file then
		local graph = processInput(file)
		local visited = 00
		paths = findPaths(graph, "svr", visited)
	end

	return paths
end

print(main())
