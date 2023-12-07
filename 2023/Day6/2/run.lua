local string_util = require "string_utils"

return function(input, output)
  local lines = input.lines()

  local times = string_util.match_all(lines[1], "%d+")
  local distances = string_util.match_all(lines[2], "%d+")

  local time = tonumber(table.concat(times))
  local best_distance = tonumber(table.concat(distances))
  print("Time:", time)
  print("Distance:", best_distance)

  local sum = 0

  -- While the new time *is* rather large, it's still small enough to brute force.
  for hold_time = 1, time - 1 do
    local distance = (time - hold_time) * hold_time

    if distance > best_distance then
      sum = sum + 1
    end
  end

  output.write(sum)
end