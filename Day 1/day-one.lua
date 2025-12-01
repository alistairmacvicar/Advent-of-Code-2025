local file = io.open("input.txt", "r")
local count = 0
local dialPosition = 50

local function rotate(direction, distance, dialPosition)
  local newPosition = dialPosition - 100

  if direction == "L" then
    newPosition = newPosition - distance
  end
  if direction == "R" then
    newPosition = newPosition + distance
  end

  return newPosition % 100
end

if file then
  for line in file:lines() do
    local direction = string.sub(line, 1, 1)
    local distance = string.sub(line, 2)

    dialPosition = rotate(direction, distance, dialPosition)

    if dialPosition == 0 then
      count = count + 1
    end
  end
end

print(count)