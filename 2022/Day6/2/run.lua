return function(input, output)
  local line = input.lines()[1]

  -- brute-force-ish method. sliding window, comparing values
  -- thanks lua for easy hashmap testing
  for i = 1, #line - 13 do
    local substring = line:sub(i, i + 13)
    local comparator = {}
    local found = true

    for char in substring:gmatch(".") do
      if comparator[char] then
        found = false
        break
      end
      comparator[char] = true
    end

    if found then
      output.write(i + 13)
      return
    end
  end

  output.write("Something failed, probably your code, idiot.")
end
