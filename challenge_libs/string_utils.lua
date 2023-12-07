local split = require "string_split"

--- Please note that for efficiency reasons, this module does not do any argument checking.
---@class string_utils
local _string = {
  split = split
}

--- Match all instances of a pattern in a string, optionally converting each match given a conversion function.
--- @param str string The string to match against.
--- @param pattern string The pattern to match.
--- @param conversion_func nil|fun(match: string): any The function to convert each match with.
---@return table
function _string.match_all(str, pattern, conversion_func)
  local matches = {}

  for match in str:gmatch(pattern) do
    table.insert(matches, match)
  end

  if conversion_func then
    for i, match in ipairs(matches) do
      matches[i] = conversion_func(match)
    end
  end

  matches.n = #matches
  return matches
end

return _string