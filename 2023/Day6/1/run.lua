--[[ Input specifications:
  Time:      7  15   30
  Distance:  9  40  200

  Each race is a column. The time allowed per race is described by the "Time"
  row, and the distance the fastest boat of the race traveled is described by
  the "Distance" row.

  "Holding" the boat will increase its travel speed by 1 (but keep it
  stationary), and can only be done at the start of the race.

  Once you let go of the boat, it will travel at its current speed until it runs
  out of time.

  The goal is to determine how many ways we can beat the record in each race,
  then multiply the counts of each race together.
]]

local string_util = require "string_utils"
local table_util = require "table_utils"

return function(input, output)
  local lines = input.lines()

  local time_line = lines[1]
  local distance_line = lines[2]

  local times = string_util.match_all(time_line, "%d+", function(input) return tonumber(input) end)
  local distances = string_util.match_all(distance_line, "%d+", function(input) return tonumber(input) end)

  --- Get the amount of distance the boat will travel if it holds for the given amount of time restricted by the maximum race time).
  --- @param hold_time integer The amount of time to hold the boat for.
  --- @param race_time integer The maximum race time.
  local function get_distance_for_hold_time(hold_time, race_time)
    return (race_time - hold_time) * hold_time
  end

  local cum_product = 0
  for race_time, best_distance in table_util.multiterate(times, distances) do
    print(race_time, best_distance)
    -- We know that if we hold for 0 it won't move, and if we hold the entire
    -- race time, it also won't move - ignore those cases.
    local better = 0
    for hold_time = 1, race_time - 1 do
      local distance = get_distance_for_hold_time(hold_time, race_time)

      if distance > best_distance then
        better = better + 1
      end
    end

    cum_product = cum_product == 0 and better or cum_product * better
  end

  output.write(cum_product)
end