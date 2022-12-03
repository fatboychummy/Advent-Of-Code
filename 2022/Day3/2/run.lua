return function(input, output)
  local lines = input.lines()
  local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  local score = 0

  for i = 1, lines.n, 3 do
    local group = { lines[i], lines[i + 1], lines[i + 2] }
    local seen = {}

    for _, line in ipairs(group) do
      repeat
        local char = line:sub(1, 1)
        if not seen[char] then seen[char] = 0 end
        line = line:gsub(char, "")
        seen[char] = seen[char] + 1
      until #line == 0
    end

    for char, count in pairs(seen) do
      if count == 3 then
        score = score + chars:find(char, 1, true)
        break
      end
    end
  end

  output.write(score)
end
