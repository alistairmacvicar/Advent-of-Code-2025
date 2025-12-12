local function processInput(file)
	local presents = {}
	local regions = {}

	return presents, regions
end

local function main()
	local file = io.open("test.txt", "r")
	local validRegions = 0
	local presents
	local regions

	if file then
		presents, regions = processInput(file)
	end

	return validRegions
end

print(main())
