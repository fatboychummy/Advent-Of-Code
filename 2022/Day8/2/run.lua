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
