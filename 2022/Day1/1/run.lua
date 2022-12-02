return function(input, output)
  local lines = input.lines()
  local max = 0
  local sum = 0

  for _, line in ipairs(lines) do
    if line ~= "" then
      sum = sum + tonumber(line)
    else
      max = math.max(max, sum)
      sum = 0
    end
  end

  max = math.max(sum, max) -- get the last one in there

  output.write(max)
end
