return function(input, output)
  local lines = input.lines()
  local totals = {}
  local sum = 0

  for _, line in ipairs(lines) do
    if line ~= "" then
      sum = sum + tonumber(line)
    else
      totals[#totals + 1] = sum
      sum = 0
    end
  end

  totals[#totals + 1] = sum -- get the last one in there

  table.sort(totals)

  output.write(totals[#totals] + totals[#totals - 1] + totals[#totals - 2])
end
