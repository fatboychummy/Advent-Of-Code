local grid = require "linked_grid"

---@diagnostic disable:inject-field We need to inject a few fields and I'm too lazy to mark it as a new class.
---@diagnostic disable:need-check-nil Just to disable warnings -- cannot have nil in the locations that we are getting warned for.

return function(input, output)
  local lines = input.lines()

  local g = grid()

  -- Step 1: Read each character of the input into the grid
  -- During this, check if:
  -- 1. The character is a number
  -- 2. The character is a symbol (but NOT a period)
  for y, line in ipairs(lines) do
    for x = 1, #line do
      local object = g:Insert(y, x, line:sub(x, x))
      if object.value:match("%d") then
        term.setTextColor(colors.green)
        object.is_number = true
      elseif object.value:match("[^%.]") then -- if its not a number and its not a period, its a symbol as given by the parameters of the input
        term.setTextColor(colors.red)
        object.is_symbol = true
      else
        term.setTextColor(colors.white)
      end

      write(object.value)

      object.valid = false
    end

    print()
  end

  -- Link all of the grid objects to their neighbours.
  g:Link()

  -- Step 2: For each position, check:
  -- 1. If the position is a symbol, check all 8 directions for a number. If there is a number, do the following:
  --   1.1. Move to the left as far as possible (from the number's position), then mark the leftmost number as valid
  --   1.2. Combine all consequtive numbers into a single number, store the result in the leftmost number
  for y = 1, g.h do
    for x = 1, g.w do
      local object = g:Get(y, x)

      if object then
        if object.is_symbol then
          -- Check all 8 directions for a number
          for _, direction in ipairs(object.all_connections) do
            -- If the direction is a number
            if direction and direction.is_number then
              -- Move to the left as far as possible
              local leftmost_number = direction
              while leftmost_number.left and leftmost_number.left.is_number do
                leftmost_number = leftmost_number.left
              end

              -- Mark the leftmost number as valid
              leftmost_number.valid = true

              -- Combine all consequtive numbers into a single number
              local combined_number = leftmost_number.value
              local current_number = leftmost_number
              while current_number.right and current_number.right.is_number do
                current_number = current_number.right
                combined_number = combined_number .. current_number.value
              end

              -- Store the result in the leftmost number
              leftmost_number.combined = tonumber(combined_number)
            end
          end
        end
      else
        error("Invalid position: " .. y .. ", " .. x, 0)
      end
    end
  end

  -- Step 3: For each position, check:
  -- If position.valid, sum += position.combined
  local sum = 0
  for y = 1, g.h do
    for x = 1, g.w do
      local object = g:Get(y, x)

      if object then
        if object.valid then
          sum = sum + object.combined
        end
      else
        error("Invalid position: " .. y .. ", " .. x, 0)
      end
    end
  end

  output.write(sum)
end