--- Basic grid object with Insert and Get capabilities
---@param initial any The initial value to set if Get called before Insert
---@return grid grid The grid object.
return function(initial)
  return {
    w = 0,
    h = 0,
    nw = 0,
    nh = 0,
    --- Insert a new value at position y, x
    ---@param self grid The grid.
    ---@param y integer The Y position.
    ---@param x integer The X position.
    ---@param v any The value to insert.
    ---@return grid_object grid_object The grid object.
    Insert = function(self, y, x, v)
      if not self[y] then
        self[y] = {}
        self.h = math.max(y, self.h)
        self.nh = math.min(y, self.nh)
      end
      local grid_obj = { value = v or initial }

      self[y][x] = grid_obj
      self.w = math.max(self.w, x)
      self.nw = math.min(self.nw, x)

      return grid_obj
    end,

    --- Get the grid object at position y, x
    ---@param self grid The grid.
    ---@param y integer The Y position.
    ---@param x integer The X position.
    ---@return grid_object grid_object The grid object.
    Get = function(self, y, x)
      if self[y] and self[y][x] then return self[y][x] end

      return self:Insert(y, x)
    end
  }
end
