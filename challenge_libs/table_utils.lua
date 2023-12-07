---@class table_utils
local _table = {}

function _table.multiterate(...)
  local args = table.pack(...)

  local i = 0
  return function()
    i = i + 1

    local to_return = {}

    for _, arg in ipairs(args) do
      table.insert(to_return, arg[i])
    end

    return table.unpack(to_return, 1, args.n)
  end
end

return _table