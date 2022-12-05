local function stack()
  return {
    n = 0,
    Push = function(self, ...)
      local args = table.pack(...)

      for i = 1, args.n do
        self.n = self.n + 1
        self[self.n] = args[i]
      end

      return self
    end,
    Pop = function(self, count)
      if not count then error("bruh", 2) end
      local values = {}

      for i = 1, count do
        table.insert(values, 1, self[self.n])
        self.n = self.n - 1
      end

      return table.unpack(values)
    end
  }
end

return function(input, output)
  local lines = input.lines()
  local base_pattern = ".(.)..?"
  local move_pattern = "move (%d+) from (%d+) to (%d+)"

  local stacks = {}
  local line_count = 0

  repeat
    line_count = line_count + 1
    local line = lines[line_count]
  until line:match("%d")
  line_count = line_count - 1

  for i = line_count, 1, -1 do
    local stack_number = 0
    local line = lines[i]
    for char in line:gmatch(base_pattern) do
      stack_number = stack_number + 1
      if char ~= ' ' then
        print(char)
        if stacks[stack_number] then
          stacks[stack_number]:Push(char)
        else
          stacks[stack_number] = stack():Push(char)
        end
      end
    end
  end

  for i = line_count + 1, lines.n do
    local line = lines[i]
    local count, from, to = line:match(move_pattern)
    if count then
      count, from, to = tonumber(count), tonumber(from), tonumber(to)

      stacks[to]:Push(stacks[from]:Pop(count))
    end
  end

  for _, stack in ipairs(stacks) do
    output.write(stack:Pop(1))
  end
end
