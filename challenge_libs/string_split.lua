return function (str, _sep)
  local sep, fields = _sep or "\n", {}
  local pattern = string.format("([^%s]+)", sep)
  str:gsub(pattern, function(c) fields[#fields+1] = c end)
  fields.n = #fields
  return fields
end