local function organiseManual(file)
  local manual = {}
  local lines = {}

  for line in file:lines() do
    table.insert(lines, line)
  end

  for i = 1, #lines - 1 do
    local firstBlock = lines[i]:find("%s+")
    local lightString = lines[i]:sub(1, firstBlock - 1)
    local lights = {}
    local buttonsString = lines[i]:sub(firstBlock)
    local buttons = {}
    local line = {}

    for j = 2, #lightString - 1 do
      local light = lightString:sub(j,j)
      table.insert(lights, light)
    end

    for button in buttonsString:gmatch("%S+") do
      local values = {}
      button = button:gsub("%s","")

      for value in button:gmatch("([^,]+)") do
        table.insert(values, value)
      end

      if #values > 0 then
        values[1] = values[1]:sub(2)
        values[#values] = values[#values]:sub(1, 1)
      end

      table.insert(buttons, values)
    end

    table.insert(line, {lights, buttons})
    table.insert(manual, line)
  end

  for i = 1, #manual do
    local line = "lights: "

    for j = 1, #manual[i][1] do
      print(manual[i][1][1][1])

      line = line .. manual[i][1][j] .. ", "
    end

    line = line .. " buttons: "

    for j = 1, #manual[i][2] do
      line = line .. "("
      for k = 1, #manual[i][2][j] do
        line = manual[i][2][j] .. ", "
      end
      line = line .. ") "

    end

    print(line)
  end

  return manual
end

local function main()
  local file = io.open("test.txt", "r")
  local clicks = 0
  local instructions

  if file then
    instructions = organiseManual(file)
  end

  return clicks
end

print(main())