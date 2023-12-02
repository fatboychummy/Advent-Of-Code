local QIT, sum = require "QIT", require "sum_qit"

return function(input, output)
  local lines = input.lines()

  local calibration_values = QIT()

  local searches = {
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine"
  }

  -- We need to find the starting indexes of each spelled out number in the input.
  -- We also need to find the starting indexes of actual numbers.
  -- Once complete, we combine the lowest index number with the highest index number and add them to the QIT.
  for i = 1, lines.n do
    local line = lines[i]
    local len = #line
    local lowest_index, highest_index = math.huge, -1
    local lowest_num, highest_num = "", ""

    -- I'm not going to worry about making weird-ass patterns for this,
    -- a min-max search is good enough.
    for j = 1, #searches do
      local search = searches[j]

      local start_index = 1
      
      while start_index < len do
        local index = line:find(search, start_index, true)

        if index then
          if index < lowest_index then
            lowest_index = index
            lowest_num = tostring(j)
          end

          if index > highest_index then
            highest_index = index
            highest_num = tostring(j)
          end

          start_index = index + 1
        else
          start_index = math.huge -- continue
        end
      end
    end

    --print("Initial:", lowest_index, highest_index, lowest_num, highest_num)

    -- Thanks to string.find being rediculous, I am now instead going to just manually search the string like a madman.
    for j = 1, #line do
      local val = tonumber(line:sub(j, j))

      if val then
        if j < lowest_index then
          lowest_num = tostring(val)
          lowest_index = j
        end
        if j > highest_index then
          highest_num = tostring(val)
          highest_index = j
        end
      end
    end

    -- Now we can add the combination of the lowest number to the highest number.
    calibration_values:Insert(tonumber(lowest_num .. highest_num))
  end

  output.write(sum(calibration_values))
end