--[[ Input specifications, given by the example input

```
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
```

  Each line is parsed as follows:
  1. The first number is the destination number.
  2. The second number is the source number.
  3. The third number is the range length.

  You start with two lists of 1 -> N, these lists are linked such that the values
  that are "beside" eachother (if you were to list them side-by-side) are linked
  together. For example, in the first map (seed->soil), seed 1 would be linked
  to soil 1, seed 2 to soil 2, and so on. However, since we have the lines:

  ```
  50 98 2
  52 50 48
  ```

  this is saying to change the link of seed 98 (with range length **2**, so 98
  AND 99) to soil 50 (again range length 2), after which it would revert back
  to being directly a->a, so the list would look like:

  ```
  seed  soil
  0     0
  1     1
  ...   ...
  97    97
  98    50
  99    51
  100   100
  ```

  Then, the second line is saying to change the link of seed 50 (with range
  length **48**, so 50 through 98) to soil 52 (again range length 48), after
  which it would revert back to being directly a->a, so the list would look
  like:

  ```
  seed  soil
  0     0
  1     1
  ...   ...
  49    49
  50    52
  51    53
  ...   ...
  97    99
  98    50
  99    51
  100   100
  ```

  Then you would do the same for every other map.

  Finally, for each seed, you start with your seed, then determine your soil,
  then fertilizer, then water, then light, then temperature, then humidity, then
  location.

  The lowest value you reach as a location is the answer.
]]

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