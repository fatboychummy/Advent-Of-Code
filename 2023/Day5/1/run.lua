local string_utils = require("string_utils")

return function(input, output)
  local lines = input.lines()

  local stages = {}

  -- Parse the seeds.
  local seeds = string_utils.match_all(lines[1], "%d+", function(match) return tonumber(match) end)

  -- Parse the maps.
  local stage = 0
  for i = 3, lines.n do
    local line = lines[i]
    if line:match("map") then
      stage = stage + 1
    else
      local destination, source, range_length = table.unpack(string_utils.match_all(line, "%d+", function(match) return tonumber(match) end))
      if destination then -- ignore blank lines
        if not stages[stage] then
          stages[stage] = {}
        end

        table.insert(stages[stage], {
          destination = destination,
          source = source,
          range_length = range_length,
        })
      end
    end
  end

  -- For each seed, run through each stage.
  local finals = {}
  for _, seed in ipairs(seeds) do
    local current = seed
    for _, stage in ipairs(stages) do
      -- Check each map in the stage to see if the seed is within its range.
      for _, map in ipairs(stage) do
        if current >= map.source and current <= map.source + map.range_length - 1 then
          -- If it is, then set the current to the destination.
          current = map.destination + (current - map.source)
          break
        end
      end

      -- If it wasn't found, the seed stays the same - which is what we want.
    end

    finals[#finals + 1] = current
  end

  output.write(math.min(table.unpack(finals)))
end