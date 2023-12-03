local function grid()
  return {
    w = 0,
    h = 0,
    nw = 0,
    nh = 0,
    --- Insert a new value at position y, x
    ---@param self linked_grid The grid.
    ---@param y integer The Y position.
    ---@param x integer The X position.
    ---@param v any The value to insert.
    Insert = function(self, y, x, v)
      if not self[y] then
        self[y] = {}
        self.h = math.max(y, self.h)
        self.nh = math.min(y, self.nh)
      end
      local grid_obj = { value = v }

      -- cardinal
      grid_obj.up, grid_obj.down, grid_obj.left, grid_obj.right = self:Get(y - 1, x), self:Get(y + 1, x),
          self:Get(y, x - 1), self:Get(y, x + 1)
      
      -- diagonal
      grid_obj.up_left, grid_obj.up_right, grid_obj.down_left, grid_obj.down_right = self:Get(y - 1, x - 1),
          self:Get(y - 1, x + 1), self:Get(y + 1, x - 1), self:Get(y + 1, x + 1)

      self[y][x] = grid_obj
      self.w = math.max(self.w, x)
      self.nw = math.min(self.nw, x)
    end,

    --- Get the grid object at position y, x
    ---@param self linked_grid The grid.
    ---@param y integer The Y position.
    ---@param x integer The X position.
    ---@return linked_grid_object? grid_object The grid object or nil.
    Get = function(self, y, x)
      if self[y] then return self[y][x] end
    end,

    --- Flip the grid vertically.
    ---@param self linked_grid The grid to flip.
    ---@return linked_grid flipped_grid The flipped grid.
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
    ---@param self linked_grid The grid to flip.
    ---@return linked_grid flipped_grid The flipped grid.
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
    ---@param self linked_grid The grid to flip.
    ---@return linked_grid flipped_grid The flipped grid.
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

return grid
