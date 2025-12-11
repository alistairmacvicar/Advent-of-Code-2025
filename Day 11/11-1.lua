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

local function findPaths(graph, node)
	local paths = 0

	if node == "out" then
		return 1
	end

	for i = 1, #graph[node] do
		local output = graph[node][i]
		paths = paths + findPaths(graph, output)
	end

	return paths
end

local function main()
	local file = io.open("input.txt", "r")
	local paths = 0

	if file then
		local graph = processInput(file)
		paths = findPaths(graph, "you")
	end

	return paths
end

print(main())
