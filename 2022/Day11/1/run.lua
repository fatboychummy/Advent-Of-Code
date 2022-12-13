local QIT = require "QIT"

return function(input, output)
  local ITEMS_MATCH = "items: (.+)"
  local OP_MATCH = "new = .+"
  local DIV_MATCH = "divisible by (.+)"
  local TF_MATCH = "monkey (.+)"
  local TURN_COUNT = 20

  local monkeys = QIT()
  monkeys.n = -1 -- start index at zero.

  --- Create a new monkey from the information given.
  ---@param items string The matched string of items
  ---@param op string The matched operation
  ---@param divisibility_test string The matched divisibility test
  ---@param on_true string The number to pass to if true (matched)
  ---@param on_false string The number to pass to if false (matched)
  local function new_monkey(items, op, divisibility_test, on_true, on_false)
    local monkey = {}

    monkey.items = QIT()
    for item in items:gmatch("%d+") do
      monkey.items:Insert(tonumber(item))
    end

    monkey.op = op

    monkey.div_test = tonumber(divisibility_test)

    monkey.on_true = tonumber(on_true)
    monkey.on_false = tonumber(on_false)

    monkey.inspections = 0

    monkeys:Insert(monkey)
  end

  local function run_monkey(monkey)
    while monkey.items.n > 0 do
      _ENV.new = 0
      _ENV.old = monkey.items:Drop()


      -- inspect the item
      local fn, er = load(monkey.op, nil, nil, _ENV)

      if fn then
        fn() -- I would pcall this but the only thing I could do with it afterwards is throw an error, so......
        monkey.inspections = monkey.inspections + 1

        _ENV.new = math.floor(_ENV.new / 3)
        if _ENV.new % monkey.div_test == 0 then
          monkeys[monkey.on_true].items:Insert(_ENV.new)
        else
          monkeys[monkey.on_false].items:Insert(_ENV.new)
        end
      else
        error(er, 0)
      end
    end
  end

  local lines = input.lines()

  for i = 1, lines.n, 7 do
    local items = lines[i + 1]:match(ITEMS_MATCH)
    local operation = lines[i + 2]:match(OP_MATCH)
    local test = lines[i + 3]:match(DIV_MATCH)
    local on_true = lines[i + 4]:match(TF_MATCH)
    local on_false = lines[i + 5]:match(TF_MATCH)

    new_monkey(items, operation, test, on_true, on_false)
  end

  for i = 1, TURN_COUNT do
    for j = 0, monkeys.n do
      run_monkey(monkeys[j])
    end
  end

  -- Pull monkey[0] out so that table.sort will see it
  monkeys:Insert(monkeys[0])
  monkeys[0] = nil

  table.sort(monkeys, function(a, b)
    return a.inspections > b.inspections
  end)

  output.write(monkeys[1].inspections * monkeys[2].inspections)
end
