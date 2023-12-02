local QIT, sum = require "QIT", require "sum_qit"

return function(input, output)
  local lines = input.lines()

  local calibration_values = QIT()

  for i = 1, lines.n do
    local a, b = lines[i]:match("^.-(%d).*(%d).-$")
    local c = lines[i]:match("%d")

    if not a then
      calibration_values:Insert(tonumber(c .. c))
    else
      calibration_values:Insert(tonumber(a .. b))
    end
  end

  output.write(sum(calibration_values))
end