return function(input, output)
  local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  local score = 0

  for line in input.readLine do
    local seen = {}

    local half1, half2 = line:sub(1, #line / 2), line:sub(#line / 2 + 1, #line)

    for char in half1:gmatch(".") do
      seen[char] = true
    end

    for char in half2:gmatch(".") do
      if seen[char] then
        score = score + string.find(chars, char, 1, true)
        break
      end
    end
  end

  output.write(score)
end
