local grid = require "linked_grid"

---@diagnostic disable:inject-field We need to inject a few fields and I'm too lazy to mark it as a new class.

return function(input, output)
  local lines = input.lines()

  local g = grid()

  -- Step 1: Read each character of the input into the grid
  -- During this, check if:
  -- 1. The character is a number
  -- 2. The character is a "gear" (asterisk)
  for y, line in ipairs(lines) do
    for x = 1, #line do
      local object = g:Insert(y, x, line:sub(x, x))
      if object.value:match("%d") then
        term.setTextColor(colors.green)
        object.is_number = true
      elseif object.value:match("%*") then -- A gear is an asterisk, as given by the parameters of the input
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
  -- 1. If the position is a gear, check all 8 directions for a number. If there is a number, do the following:
  --  1.1. Note the position of the number.
  -- 2. If there is only one number detected, continue.
  -- 3. If there are two or more numbers detected, Simplify each number out, then check the positions of the end result of simplification. If any overlap, ignore the extras.
  --  3.1. If there are two numbers left, simplify each number and mark one of them as valid, then multiply their values together.
  --  3.2. If there are three or more numbers left (or a single number), continue.

  -- "Simplification" process:
  -- 1. Move to the left as far as possible (from the number's position)
  -- 2. Combine all consequtive numbers (numbers to the right) into a single number, store the result in the leftmost number

  for y = 1, g.h do
    for x = 1, g.w do
      local object = g:Get(y, x)

      if object then
        if object.is_symbol then
          local number_locations = {}

          -- Check all 8 directions for a number
          for _, direction in ipairs(object.all_connections) do
            -- If the direction is a number
            if direction and direction.is_number then
              -- Note the position of the number
              table.insert(number_locations, direction)
            end
          end

          -- If there is only one number detected, continue.
          if #number_locations == 1 then
            -- Continue
          elseif #number_locations >= 2 then
            -- Simplify each number out, then check the positions of the end result of simplification. If any overlap, ignore the extras.

            -- This table will store the simplified locations, in a format such that duplicates will be ignored.
            local simplified_locations = {}

            -- Simplify each number
            for _, number in ipairs(number_locations) do
              -- Move to the left as far as possible
              local leftmost_number = number
              while leftmost_number.left and leftmost_number.left.is_number do
                leftmost_number = leftmost_number.left
              end

              -- Combine all consequtive numbers into a single number
              local combined_number = leftmost_number.value
              local current_number = leftmost_number
              while current_number.right and current_number.right.is_number do
                current_number = current_number.right
                combined_number = combined_number .. current_number.value
              end

              -- Store the result in the leftmost number
              leftmost_number.combined = tonumber(combined_number)

              -- Add the simplified location to the simplified locations table
              simplified_locations[leftmost_number.y .. ":" .. leftmost_number.x] = leftmost_number

              print("Location", number.x, number.y, "simplified to", leftmost_number.combined, "at position", leftmost_number.x, leftmost_number.y)
            end

            -- count the number of simplified locations
            local simplified_locations_count = 0
            for _ in pairs(simplified_locations) do
              simplified_locations_count = simplified_locations_count + 1
            end

            print("Simplified count:", simplified_locations_count)

            -- If only two numbers remain, multiply their values together and mark one of them as valid
            if simplified_locations_count == 2 then
              local key1, first = next(simplified_locations)
              local _, second = next(simplified_locations, key1)

              if first.valid then
                -- The first number is already part of a valid gear, so we should combine to the second value instead.
                second.valid = true
                second.combined = second.combined * first.combined
              else
                first.valid = true
                first.combined = first.combined * second.combined
              end
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