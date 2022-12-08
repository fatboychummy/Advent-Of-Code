local function grid()
  return {
    w = 0,
    h = 0,
    --- Insert a new value at position y, x
    ---@param self grid The grid.
    ---@param y integer The Y position.
    ---@param x integer The X position.
    ---@param v any The value to insert.
    Insert = function(self, y, x, v)
      if not v then error("bruh", 2) end
      if not self[y] then
        self[y] = {}
        self.h = math.max(y, self.h)
      end
      local grid_obj = { value = v }

      grid_obj.up, grid_obj.down, grid_obj.left, grid_obj.right = self:Get(y - 1, x), self:Get(y + 1, x),
          self:Get(y, x - 1), self:Get(y, x + 1)

      self[y][x] = grid_obj
      self.w = math.max(self.w, x)
    end,

    --- Get the grid object at position y, x
    ---@param self grid The grid.
    ---@param y integer The Y position.
    ---@param x integer The X position.
    ---@return grid_object? grid_object The grid object or nil.
    Get = function(self, y, x)
      if self[y] then return self[y][x] end
    end,

    --- Flip the grid vertically.
    ---@param self grid The grid to flip.
    ---@return grid flipped_grid The flipped grid.
    FlipVertical = function(self)
      local new_grid = grid()

      for y = 1, self.h do
        for x = 1, self.w do
          new_grid:Insert(self.h - y + 1, x, self[y][x].value)
        end
      end

      return new_grid
    end,

    --- Flip the grid horizontally.
    ---@param self grid The grid to flip.
    ---@return grid flipped_grid The flipped grid.
    FlipHorizontal = function(self)
      local new_grid = grid()

      for y = 1, self.h do
        for x = 1, self.w do
          new_grid:Insert(y, self.w - x + 1, self[y][x].value)
        end
      end

      return new_grid
    end,

    --- Flip the grid diagonally.
    ---@param self grid The grid to flip.
    ---@return grid flipped_grid The flipped grid.
    FlipDiagonal = function(self)
      local new_grid = grid()

      for y = 1, self.h do
        for x = 1, self.w do
          new_grid:Insert(x, y, self[y][x].value)
        end
      end

      return new_grid
    end
  }
end

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
