local tree = require "tree"
local timing = require "timing"

return function(input, output)
  local lines = input.lines()

  local left_right_instructions = lines[1]

  -- Is accessing a table faster than accessing a string? i dunno. easier to do later tho
  local instructions = {}
  for i = 1, #left_right_instructions do
    instructions[i] = left_right_instructions:sub(i, i)
  end
  instructions.n = #instructions

  -- A LUT for the nodes so we can quickly add them instead of searching for
  -- them every time.
  local nodes = {}

  -- Parse the nodes.
  for i = 3, #lines do
    local line = lines[i]
    local name, left, right = line:match("(%w+) = %((%w+), (%w+)%)")

    -- Create the node if it doesn't exist.
    local node
    if not nodes[name] then
      node = tree.new(name)
      nodes[name] = node
    else
      node = nodes[name]
    end

    -- Create the left child if it doesn't exist.
    if not nodes[left] then
      nodes[left] = node.new_left(left)
    else -- otherwise just set the left child
      node.left = node.new_left(nodes[left])
    end

    -- Create the right child if it doesn't exist.
    if not nodes[right] then
      nodes[right] = node.new_right(right)
    else -- otherwise just set the right child
      node.right = node.new_right(nodes[right])
    end
  end

  -- Start at the first instruction. -1 because we are using modulo with a
  -- 1-based index and we need to add 1 to the index later.
  local current_instruction = -1

  -- Determine all of the starting points (nodes that end with "A").
  local current_nodes = {}
  for name in pairs(nodes) do
    if name:sub(-1) == "A" then
      current_nodes[#current_nodes + 1] = nodes[name]
      nodes[name].length = -1
      nodes[name].return_trip = -1
    end
  end
  current_nodes.n = #current_nodes

  -- Determine all the ending points (nodes that end with "Z").
  for name, node in pairs(nodes) do
    if name:sub(-1) == "Z" then
      node.is_ending = true -- Inject a boolean value into the node to make checking quicker.
    end
  end

  -- We need to just go over each node (ending in "A") one-by-one and determine
  -- how many iterations it takes to reach a node ending in "Z". From there,
  -- we should be able to do some kind of GCM to determine how many iterations
  -- it takes for all nodes to end in "Z" at the same time.

  for i = 1, current_nodes.n do
    local current_node = current_nodes[i]
    local length = 0

    -- reset the current instruction counter for every loop
    current_instruction = -1

    local start_node = current_node

    while not current_node.is_ending do
      -- Get the next instruction.
      current_instruction = (current_instruction + 1) % instructions.n
      local instruction = instructions[current_instruction + 1]

      -- Follow the instruction.
      if instruction == "L" then
        current_node = current_node.left
      elseif instruction == "R" then
        current_node = current_node.right
      else
        error("Unknown instruction: " .. instruction, 0)
      end

      length = length + 1

      if current_node.is_ending then
        start_node.length = length
        break
      end
    end
  end

  -- Find all of the lengths.
  local lengths = {}
  for name, node in pairs(nodes) do
    if node.value:sub(-1) == "A" then
      print(name, node.length)
      lengths[#lengths + 1] = {base = node.length, current = node.length}
    end
  end

  -- Now we know the length of every __A to __Z path. We need to find the GCM
  -- of all of these lengths. We can do this by just adding the length of each
  -- path to itself until we find a number that is divisible by all of the
  -- lengths.

  -- Start with the largest value.
  table.sort(lengths, function(a, b) return a.base > b.base end)

  local function divisible_by_all(number)
    for i = 1, #lengths do
      if number % lengths[i].base ~= 0 then
        return false
      end
    end

    return true
  end

  -- Now, I could google an algorithm for this, but I'm just going to brute
  -- force it.
  local iter = 0
  while not divisible_by_all(lengths[1].current) do
    lengths[1].current = lengths[1].current + lengths[1].base

    if iter % 1000000 == 0 then
      write(lengths[1].current .. " ")
    end
    iter = iter + 1
    timing.sleep_only_as_needed(5000)
  end

  output.write(lengths[1].current)
end