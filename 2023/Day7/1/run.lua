local card_powers = {
  ["2"] = 1,
  ["3"] = 2,
  ["4"] = 3,
  ["5"] = 4,
  ["6"] = 5,
  ["7"] = 6,
  ["8"] = 7,
  ["9"] = 8,
  ["T"] = 9,
  ["J"] = 10,
  ["Q"] = 11,
  ["K"] = 12,
  ["A"] = 13
}

return function(input, output)
  local lines = input.lines()

  local hands = {}

  -- Load the hands into a table
  -- we will sort the cards in the hand based on their card power
  print("Reading and sorting hands...")
  for _, line in ipairs(lines) do
    local hand = {}
    local cards, bid = line:match("(.....) (%d+)")

    hand.bid = tonumber(bid)
    hand.original = cards
    hand.rank = 0

    -- Sort the cards in the hand
    local sorted_cards = {}
    for card in cards:gmatch(".") do
      table.insert(sorted_cards, card)
    end

    table.sort(sorted_cards, function(a, b)
      return card_powers[a] > card_powers[b]
    end)

    hand.cards = table.concat(sorted_cards)

    table.insert(hands, hand)
  end

  -- Determine the rank of every hand.
  -- Hands will be ranked according to the following:
  -- 1. Five of a kind (AAAAA)
  -- 2. Four of a kind (AAAA2)
  -- 3. Full house (AAA22)
  -- 4. Three of a kind (AAA23)
  -- 5. Two pair (AA223)
  -- 6. One pair (AA234)
  -- 7. High card (A2345)
  print("Determining hand ranks...")
  for _, hand in ipairs(hands) do
    local cards = hand.cards

    -- Check for five of a kind
    if cards:match("(.)%1%1%1%1") then
      hand.rank = 1 -- Five of a kind
      -- print(cards, hand.bid, "Five of a kind")
    elseif cards:match("(.)%1%1%1") then
      hand.rank = 2 -- Four of a kind
      -- print(cards, hand.bid, "Four of a kind")
    elseif cards:match("(.)%1%1(.)%2") or cards:match("(.)%1(.)%2%2") then
      hand.rank = 3 -- Full house
      -- print(cards, hand.bid, "Full house")
    elseif cards:match("(.)%1%1") then
      hand.rank = 4 -- Three of a kind
      -- print(cards, hand.bid, "Three of a kind")
    elseif cards:match("(.)%1.-(.)%2") then
      hand.rank = 5 -- Two pair
      -- print(cards, hand.bid, "Two pair")
    elseif cards:match("(.)%1") then
      hand.rank = 6 -- One pair
      -- print(cards, hand.bid, "One pair")
    else
      hand.rank = 7 -- High card
      -- print(cards, hand.bid, "High card")
    end
  end

  -- Now sort the hands by rank, making sure to sort by the highest card in the
  -- hand if the rank is the same.
  print("Sorting hands...")
  table.sort(hands, function(a, b)
    if a.rank == b.rank then
      for i = 1, 5 do
        local a_card = a.original:sub(i, i)
        local b_card = b.original:sub(i, i)

        if card_powers[a_card] < card_powers[b_card] then
          return true
        elseif card_powers[a_card] > card_powers[b_card] then
          return false
        end
      end
    end

    return a.rank > b.rank
  end)

  -- Now calculate the score
  print("Calculating score...")
  local score = 0
  for i, hand in ipairs(hands) do
    --print(hand.original, hand.bid, i, hand.bid * i)
    score = score + hand.bid * i
  end

  output.write(score)
end