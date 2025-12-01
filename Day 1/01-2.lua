local function rotate(direction, distance, position)
	return position + distance * direction
end

local function evaluateZeroes(rotation, position)
	local zeroes = math.abs(rotation) // 100

	if position ~= 0 and rotation <= 0 then
		zeroes = zeroes + 1
	end

	return zeroes
end

local function main()
	local file = io.open("input.txt", "r")
	local count = 0
	local position = 50

	if file then
		for line in file:lines() do
			local direction = string.sub(line, 1, 1) == "L" and -1 or 1
			local distance = string.sub(line, 2)
			local rotation = rotate(direction, distance, position)

			count = count + evaluateZeroes(rotation, position)

			position = rotation % 100
		end
	end

	return count
end

print(main())
