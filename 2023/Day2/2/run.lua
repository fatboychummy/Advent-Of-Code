local split = require "string_split"

return function(input, output)
  local lines = input.lines()

  local power_set = 0

  for i, line in ipairs(lines) do
    -- for each line, split the line into the game id and the values revealed in the game
    local id_line, game_line = table.unpack(split(line, ":"), 1, 2)
    local id = tonumber(id_line:match("%d+"))
    local sets = split(game_line, ";")
    local maxes = {
      red = 0,
      green = 0,
      blue = 0
    }

    for j, game in ipairs(sets) do
      local values = split(game, ",")

      for k, value in ipairs(values) do
        local num = tonumber(values[k]:match("%d+"))
        local color = values[k]:match("%l+")

        if num > maxes[color] then
          maxes[color] = num
        end
      end
    end

    power_set = power_set + (maxes.red * maxes.green * maxes.blue)
  end

  output.write(power_set)
end