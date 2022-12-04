return function(input, output)
  local contained_pairs = 0

  for line in input.readLine do
    local x1, x2, y1, y2 = line:match("(%d+)%-(%d+),(%d+)%-(%d+)")
    x1, x2, y1, y2 = tonumber(x1), tonumber(x2), tonumber(y1), tonumber(y2)

    if (x1 >= y1 and x2 <= y2) or (y1 >= x1 and y2 <= x2) then
      contained_pairs = contained_pairs + 1
    end
  end

  output.write(contained_pairs)
end
