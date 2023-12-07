local split = require "string_split"

local _string = {
  split = split
}

function _string.match_all(str, pattern)
  local matches = {}
  for match in str:gmatch(pattern) do
    table.insert(matches, match)
  end

  matches.n = #matches
  return matches
end

return _string