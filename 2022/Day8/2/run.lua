local grid = require "linked_grid"

return function(input, output)
  local tree_grid = grid()

  -- Parse the grid
  local y = 0
  for line in input.readLine do
    y = y + 1
    local x = 0
    for char in line:gmatch "." do
      x = x + 1
      tree_grid:Insert(y, x, tonumber(char))
    end
  end

  local best_score = 0
  local function test(x) best_score = math.max(best_score, x) end

  -- ignore edges, their score will always be 0.
  for y = 2, tree_grid.h - 1 do
    for x = 2, tree_grid.w - 1 do
      local height = tree_grid:Get(y, x).value

      --vertical up
      local s_up = 0
      for _y = y - 1, 1, -1 do
        local gh = tree_grid:Get(_y, x).value
        s_up = s_up + 1
        if gh >= height then
          break
        end
      end

      --vertical down
      local s_down = 0
      for _y = y + 1, tree_grid.h do
        local gh = tree_grid:Get(_y, x).value
        s_down = s_down + 1
        if gh >= height then
          break
        end
      end

      --horizontal right
      local s_right = 0
      for _x = x + 1, tree_grid.w do
        local gh = tree_grid:Get(y, _x).value
        s_right = s_right + 1
        if gh >= height then
          break
        end
      end

      --horizontal left
      local s_left = 0
      for _x = x - 1, 1, -1 do
        local gh = tree_grid:Get(y, _x).value
        s_left = s_left + 1
        if gh >= height then
          break
        end
      end

      -- combine score.
      test(s_up * s_down * s_left * s_right)
    end
  end

  output.write(best_score)
end
