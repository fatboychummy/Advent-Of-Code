return function(input, output)
  local contained_pairs = 0

  for line in input.readLine do
    local x1, x2, y1, y2 = line:match("(%d+)%-(%d+),(%d+)%-(%d+)")
    x1, x2, y1, y2 = tonumber(x1), tonumber(x2), tonumber(y1), tonumber(y2)
    local found = false

    for i = x1, x2 do
      if i == y1 or i == y2 then
        contained_pairs = contained_pairs + 1
        found = true
        break
      end
    end

    if not found then
      for i = y1, y2 do
        if i == x1 or i == x2 then
          contained_pairs = contained_pairs + 1
          break
        end
      end
    end
  end

  output.write(contained_pairs)
end
