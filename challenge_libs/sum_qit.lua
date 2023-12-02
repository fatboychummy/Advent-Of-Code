--- Sum a QIT.
---@param values QIT
---@return integer sum The sum of the QIT.
return function(values)
  local s = 0

  for i = 1, values.n do
    s = s + values[i]
  end

  return s
end
