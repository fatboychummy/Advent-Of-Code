local split = require "string_split"

return function(input, output)
  local lines = input.lines()

  local maxes = {
    red = 12,
    green = 13,
    blue = 14
  }

  local total_ids = 0

  for i, line in ipairs(lines) do
    -- for each line, split the line into the game id and the values revealed in the game
    local id_line, game_line = table.unpack(split(line, ":"), 1, 2)
    local id = tonumber(id_line:match("%d+"))
    local sets = split(game_line, ";")
    local bad_game = false

    for j, game in ipairs(sets) do
      local values = split(game, ",")

      for k, value in ipairs(values) do
        local max = maxes[values[k]:match("%l+")] or 0
        local num = tonumber(values[k]:match("%d+"))

        if num > max then
          bad_game = true
          break
        end
      end

      if bad_game then
        break
      end
    end

    if not bad_game then
      total_ids = total_ids + id
    end
  end

  output.write(total_ids)
end