local tree = require("tree")

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

  -- Start at node "AAA"
  local current_node = nodes["AAA"]

  -- Start at the first instruction. -1 because we are using modulo with a
  -- 1-based index and we need to add 1 to the index later.
  local current_instruction = -1

  -- Keep track of the amount of steps taken.
  local steps = 0

  -- Loop until we find the node "ZZZ".
  while current_node.value ~= "ZZZ" do
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

    steps = steps + 1
  end


  output.write(steps)
end