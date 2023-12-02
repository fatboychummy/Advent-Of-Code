---@class QIT
---@field n integer The number of elements in the QIT.
---@field Insert fun(self: QIT, value: any) Insert a value into the QIT at the end.
---@field Push fun(self: QIT, value: any) Insert a value into the QIT at the beginning.
---@field Remove fun(self: QIT): any Remove a value from the end of the QIT.
---@field Drop fun(self: QIT): any Remove a value from the beginning of the QIT.

return function()
  ---@type QIT
  return {
    n = 0,

    --- Insert a value into the QIT at the end.
    ---@param self QIT
    ---@param value any The value to be inserted.
    Insert = function(self, value)
      self.n = self.n + 1
      self[self.n] = value
    end,

    --- Insert a value into the QIT at the beginning.
    ---@param self QIT
    ---@param value any The value to be inserted.
    Push = function(self, value)
      table.insert(self, 1, value)
      self.n = self.n + 1
    end,

    --- Remove a value from the end of the QIT.
    ---@param self QIT
    ---@return any value The value removed.
    Remove = function(self)
      local value = self[self.n]
      self[self.n] = nil
      self.n = self.n - 1

      return value
    end,

    --- Remove a value from the beginning of the QIT.
    ---@param self QIT
    ---@return any value The value removed.
    Drop = function(self)
      local value = table.remove(self, 1)

      return value
    end
  }
end
