local split = require("string_split")

return function(input, output)
  local lines = input.lines()

  -- Given each line looks like so: `Card X: xx yy zz aa bb | xx yy zz aa bb`
  -- We can split on `:` and `|` to get the two halves of the line.
  -- then we can gmatch numbers out of each side, and then load them into a
  -- lookup table.
  -- Then we can gmatch the winning numbers, and check if they're in the lookup
  -- table. If they are, we can double the current points for that hand.
  -- Finally, sum all the totals together and output the result.
  local sum = 0
  for _, line in ipairs(lines) do
    local card_number, deck = line:match("Card%s+(%d+): (.*)")
    local lr = split(deck, "|")
    local hand, winning_numbers = lr[1], lr[2]

    local cards = {}
    for card in hand:gmatch("%d+") do
      cards[card] = true
    end

    local points = 0
    for card in winning_numbers:gmatch("%d+") do
      if cards[card] then
        points = points == 0 and 1 or points * 2
      end
    end

    sum = sum + points
  end

  output.write(sum)
end