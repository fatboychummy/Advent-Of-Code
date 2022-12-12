local grid = require "grid"

return function(input, output)
  local PATTERN_ADDX = "addx (%-?%d+)"
  local LIT_CHAR = '\x7f'
  local UNLIT_CHAR = '\xb7'
  local crt = grid(UNLIT_CHAR)

  local memory = {
    [-1] = { x = 1 },
    [0] = { x = 1 }
  }
  local _cycle = -1
  local next = 0

  local function update_screen()
    local pos_x = _cycle % 40
    local pos_y = math.floor(_cycle / 40)

    if math.abs(memory[_cycle].x - pos_x) <= 1 then
      crt:Insert(pos_y, pos_x, LIT_CHAR)
    else
      crt:Insert(pos_y, pos_x, UNLIT_CHAR)
    end
  end

  local function cycle(n)
    _cycle = _cycle + 1
    memory[_cycle] = { x = memory[_cycle - 1].x + next }
    next = n
    update_screen()
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

    if addx then
      operations.addx(tonumber(addx))
    else
      operations.noop()
    end
  end

  local answer = {}

  local i = 0
  for y = crt.nh, crt.h do
    i = i + 1
    answer[i] = ""
    for x = crt.nw, crt.w do
      answer[i] = answer[i] .. crt:Get(y, x).value
    end
  end

  local actual = table.concat(answer, '\n')

  print(actual)
  output.write(actual)
end
