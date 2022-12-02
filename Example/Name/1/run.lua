return function(input, output)
  local lines = input.lines()
  for i = 1, lines.n do
    local a, b, c = lines[i]:match("(%d+) (%d+) (%d+)")
    a, b, c = tonumber(a), tonumber(b), tonumber(c)

    if a + b == c then
      output.write("+")
    elseif a * b == c then
      output.write("*")
    elseif a / b == c then
      output.write("/")
    elseif a - b == c then
      output.write("-")
    else
      output.write("?")
    end
  end
end