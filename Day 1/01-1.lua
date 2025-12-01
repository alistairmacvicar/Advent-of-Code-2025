local function rotate(direction, distance, position)
	return (position + distance * direction) % 100
end

local function main()
	local file = io.open("input.txt", "r")
	local count = 0
	local position = 50

	if file then
		for line in file:lines() do
			local direction = string.sub(line, 1, 1) == "L" and -1 or 1
			local distance = string.sub(line, 2)
			position = rotate(direction, distance, position)

			if position == 0 then
				count = count + 1
			end
		end
	end

	return count
end

print(main)
