return function()
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
    end
  }
end
