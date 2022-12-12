return function(input, output)
  local PATTERN_ADDX = "addx (%-?%d+)"
  local PATTERN_NOOP = "noop"

  local memory = {
    [0] = { x = 1 }
  }
  local _cycle = 0
  local next = 0
  local function cycle(n)
    _cycle = _cycle + 1
    memory[_cycle] = { x = next + memory[_cycle - 1].x }
    next = n
  end

  local operations = {
    addx = function(n)
      cycle(0)
      cycle(n)
    end,
    noop = function()
      cycle(0)
    end
  }

  for line in input.readLine do
    local addx = line:match(PATTERN_ADDX)
    local noop = line:match(PATTERN_NOOP)

    if addx then
      operations.addx(tonumber(addx))
    else
      operations.noop()
    end
  end

  local function sum(...)
    local args = table.pack(...)
    local sum = 0

    for i = 1, args.n do
      sum = sum + memory[args[i]].x * args[i]
    end

    return sum
  end

  output.write(sum(20, 60, 100, 140, 180, 220))
end
