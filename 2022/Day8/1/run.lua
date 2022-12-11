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
      tree_grid:Insert(y, x, { height = tonumber(char), seen = false })
    end
  end

  -- Check, horizontal flip, check, diagonal flip, check, horizontal flip, check

  local function check_visible(grid_in)
    for y = 1, grid_in.h do
      local height = -1
      for x = 1, grid_in.w do
        local obj = grid_in:Get(y, x)
        if obj then
          if obj.value.height > height then
            height = obj.value.height
            obj.value.seen = true
          end
        else
          error("This shouldn't happen...", 0)
        end
      end
    end
  end

  check_visible(tree_grid) -- left to right

  tree_grid = tree_grid:FlipHorizontal()
  check_visible(tree_grid) -- right to left

  tree_grid = tree_grid:FlipDiagonal()
  check_visible(tree_grid) -- top to bottom

  tree_grid = tree_grid:FlipHorizontal()
  check_visible(tree_grid) -- bottom to top

  local count = 0
  for y = 1, tree_grid.h do
    for x = 1, tree_grid.w do
      if tree_grid:Get(y, x).value.seen then
        count = count + 1
      end
    end
  end

  output.write(count)
end
