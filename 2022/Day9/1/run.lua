local grid = require "grid"
local READ_PATTERN = "(.) (%d+)"

--- Get the needed values from the current line.
---@param l string The current line.
---@return string direction The direction.
---@return number steps The amount of times to move in the stated direction.
---@diagnostic disable-next-line Input is guaranteed to be a number.
local function get(l) local a, b = l:match(READ_PATTERN) return a, tonumber(b) end

return function(input, output)
  local positions = grid(false)
  local head = vector.new(0, 0)
  local tail = vector.new(0, 0)
  local count = 0

  local moves = {
    R = vector.new(0, 1),
    D = vector.new(-1, 0),
    L = vector.new(0, -1),
    U = vector.new(1, 0)
  }

  for line in input.readLine do
    local direction, steps = get(line)

    for i = 1, steps do
      positions:Get(tail.y, tail.x).value = true

      head = head + moves[direction]

      local diff = head - tail
      if math.abs(diff.x) > 1 or math.abs(diff.y) > 1 then
        tail = head - moves[direction]
      end
    end
    positions:Get(tail.y, tail.x).value = true
  end


  print(positions.nh, positions.h, positions.nw, positions.w)
  for y = positions.nh, positions.h do
    for x = positions.nw, positions.w do
      if positions:Get(y, x).value then
        count = count + 1
      end
    end
  end

  output.write(count)
end
