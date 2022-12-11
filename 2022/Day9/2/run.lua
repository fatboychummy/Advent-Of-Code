local grid = require "grid"
local READ_PATTERN = "(.) (%d+)"
local N_KNOTS = 10

--- Get the needed values from the current line.
---@param l string The current line.
---@return string direction The direction.
---@return number steps The amount of times to move in the stated direction.
---@diagnostic disable-next-line Input is guaranteed to be a number.
local function get(l) local a, b = l:match(READ_PATTERN) return a, tonumber(b) end

return function(input, output)
  local positions = grid(false)
  local knots = {}
  for i = 1, N_KNOTS do
    knots[i] = vector.new(0, 0)
  end
  local count = 0

  local moves = {
    R = vector.new(0, 1),
    D = vector.new(-1, 0),
    L = vector.new(0, -1),
    U = vector.new(1, 0)
  }

  for line in input.readLine do
    local direction, steps = get(line)

    positions:Get(knots[N_KNOTS].y, knots[N_KNOTS].x).value = true

    for _ = 1, steps do
      for i = 1, N_KNOTS - 1 do
        knots[i] = knots[i] + moves[direction]

        local diff = knots[i] - knots[i + 1]
        print(diff.x, diff.y)
        if math.abs(diff.x) > 1.1 or math.abs(diff.y) > 1.1 then
          knots[i + 1] = knots[i] - moves[direction]
        end
      end

      positions:Get(knots[N_KNOTS].y, knots[N_KNOTS].x).value = true
    end
  end

  for y = positions.nh, positions.h do
    for x = positions.nw, positions.w do
      if positions:Get(y, x).value then
        count = count + 1
      end
    end
  end

  output.write(count)
end
