---@class linked_grid_object
---@field value any The value of the grid object.
---@field up linked_grid_object? The grid object above this one.
---@field down linked_grid_object? The grid object below this one.
---@field left linked_grid_object? The grid object to the left of this one.
---@field right linked_grid_object? The grid object to the right of this one.
---@field up_left linked_grid_object? The grid object above and to the left of this one.
---@field up_right linked_grid_object? The grid object above and to the right of this one.
---@field down_left linked_grid_object? The grid object below and to the left of this one.
---@field down_right linked_grid_object? The grid object below and to the right of this one.
---@field all_connections linked_grid_object[] An iterable table of all 8 directions.
---@field cardinal_connections linked_grid_object[] An iterable table of all 4 cardinal directions.

---@class linked_grid
---@field w integer The highest value of the width of the grid.
---@field h integer The highest value of the height of the grid.
---@field nw integer The lowest value of the width of the grid.
---@field nh integer The lowest value of the height of the grid.
---@field Insert fun(self: linked_grid, y: integer, x: integer, v: any): linked_grid_object Insert a new value at position y, x.
---@field Link fun(self: linked_grid) Generate the grid's links. This needs to be done after the grid is generated, otherwise links will be missing.
---@field Get fun(self: linked_grid, y: integer, x: integer): linked_grid_object? Get the grid object at position y, x.
---@field FlipVertical fun(self: linked_grid): linked_grid Flip the grid vertically. Links will need to be regenerated.
---@field FlipHorizontal fun(self: linked_grid): linked_grid Flip the grid horizontally. Links will need to be regenerated.
---@field FlipDiagonal fun(self: linked_grid): linked_grid Flip the grid diagonally. Links will need to be regenerated.

local function grid()
  ---@type linked_grid
  return {
    w = -math.huge,
    h = -math.huge,
    nw = math.huge,
    nh = math.huge,

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

      self[y][x] = grid_obj
      self.w = math.max(self.w, x)
      self.nw = math.min(self.nw, x)

      return grid_obj
    end,

    --- Generate the grid's links. This needs to be done after the grid is generated, otherwise links will be missing.
    ---@param self linked_grid The grid.
    Link = function(self)
      for y = self.nh, self.h do
        for x = self.nw, self.w do
          local grid_obj = self[y][x]

          -- cardinal
          grid_obj.up, grid_obj.down, grid_obj.left, grid_obj.right = self:Get(y - 1, x), self:Get(y + 1, x),
              self:Get(y, x - 1), self:Get(y, x + 1)

          -- diagonal
          grid_obj.up_left, grid_obj.up_right, grid_obj.down_left, grid_obj.down_right = self:Get(y - 1, x - 1),
              self:Get(y - 1, x + 1), self:Get(y + 1, x - 1), self:Get(y + 1, x + 1)

          -- Iterable table of all 8 directions
          grid_obj.all_connections = {
            grid_obj.up, grid_obj.down, grid_obj.left, grid_obj.right,
            grid_obj.up_left, grid_obj.up_right, grid_obj.down_left, grid_obj.down_right
          }

          -- Iterable table of all 4 cardinal directions
          grid_obj.cardinal_connections = {
            grid_obj.up, grid_obj.down, grid_obj.left, grid_obj.right
          }
        end
      end
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
