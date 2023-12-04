local split = require("string_split")

--- Calculate the points for a given hand and winning numbers.
--- @param lr table<integer, string> The two halves of the line.
---@return integer points The points for the hand.
local function calculate_points(lr)
  local hand, winning_numbers = lr[1], lr[2]

  local cards = {}
  for card in hand:gmatch("%d+") do
    cards[card] = true
  end

  local points = 0
  for card in winning_numbers:gmatch("%d+") do
    if cards[card] then
      points = points + 1
    end
  end

  return points
end

return function(input, output)
  local lines = input.lines()

  -- Given each line looks like so: `Card X: xx yy zz aa bb | xx yy zz aa bb`
  -- We can split on `:` and `|` to get the two halves of the line.
  -- then we can gmatch numbers out of each side, and then load them into a
  -- lookup table.
  -- Then we can gmatch the winning numbers, and check if they're in the lookup
  -- table. If they are, we can add one to the current points for that hand.
  -- Finally, we add one copy of the next <points> cards.
  -- Then, we repeat the process until we reach the end of the input. Our final
  -- score is the total amount of cards we have at the end.

  local card_counts = {}

  local function add_next_n(count, n, from)
    local str = "so we add %d cop%s of card(s): "
    for i = from, from + n - 1 do
      if card_counts[i] then -- we only want to add cards that exist
        card_counts[i] = card_counts[i] + count
        str = str .. i .. ", "
      else
        break
      end
    end

    return str:sub(1, -3)
  end

  -- Initialize all cards to 1 value
  for i in ipairs(lines) do
    card_counts[i] = 1
  end

  local sum = 0
  for i, line in ipairs(lines) do
    local card_number, deck = line:match("Card%s+(%d+): (.*)")
    local lr = split(deck, "|")

    -- Calculate the points earned from this card.
    local points = calculate_points(lr)

    -- Add one card to each of the next <points> cards for each card in this hand.
    local copy_str = add_next_n(card_counts[i], points, i + 1)

    --[[
    print(("There %s %d cop%s of card %d and we earn %d point%s, %s")
      :format(card_counts[i] == 1 and "is" or "are", card_counts[i], card_counts[i] == 1 and "y" or "ies", i, points, points == 1 and "" or "s each",
        copy_str:format(card_counts[i], card_counts[i] == 1 and "y" or "ies")
      )
    )]]

    -- And the amount of cards for this hand is the "points" we sum
    sum = sum + card_counts[i]
  end

  output.write(sum)
end