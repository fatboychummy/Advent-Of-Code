local card_powers = {
  ["J"] = 1,
  ["2"] = 2,
  ["3"] = 3,
  ["4"] = 4,
  ["5"] = 5,
  ["6"] = 6,
  ["7"] = 7,
  ["8"] = 8,
  ["9"] = 9,
  ["T"] = 10,
  ["Q"] = 11,
  ["K"] = 12,
  ["A"] = 13
}

--- Get the rank of the hand with the given joker count.
---@param cards Hand The cards in the hand.
---@return integer rank The rank of the hand.
---@return string name The name of the hand.
local function get_joker_rank(cards)
  local _, joker_count = cards.cards:gsub("J", "")

  local highest, highest_kind = 100, "None"
  if joker_count == 1 then
    for card, count in pairs(cards.card_counts) do
      if card ~= "J" then
        if count == 4 then
          return 1, "Five of a kind" -- Four of a kind can be turned into five of a kind, also the highest so just return immediately.
        elseif count == 3 then
          if 2 < highest then
            highest, highest_kind = 2, "Four of a kind" -- Three of a kind can be turned into four of a kind
          end
        elseif count == 2 then
          if cards.cards:match("(.)%1.-(.)%2") then
            if 3 < highest then
              highest, highest_kind = 3, "Full house" -- Two pair can be turned into full house
            end
          end
          if 4 < highest then
            highest, highest_kind = 4, "Three of a kind" -- One pair can be turned into three of a kind
          end
        elseif count == 1 then
          if 6 < highest then
            highest, highest_kind = 6, "Two of a kind" -- High card can be turned into one pair
          end
        end
      end
    end
  elseif joker_count == 2 then
    for card, count in pairs(cards.card_counts) do
      if card ~= "J" then
        if count == 3 then
          return 1, "Four of a kind" -- Three of a kind can be turned into five of a kind
        elseif count == 2 then
          if 2 < highest then
            highest, highest_kind = 2, "Four of a kind" -- One pair can be turned into four of a kind
          end
        elseif count == 1 then
          if 4 < highest then
            highest, highest_kind = 4, "Three of a kind" -- High card can be turned into three of a kind
          end
        end
      end
    end
  elseif joker_count == 3 then
    for card, count in pairs(cards.card_counts) do
      if card ~= "J" then
        if count == 2 then
          return 1, "Five of a kind" -- One pair can be turned into five of a kind
        elseif count == 1 then
          return 2, "Four of a kind" -- High card can be turned into four of a kind
        end
      end
    end
  elseif joker_count == 4 then
    return 1, "Five of a kind" -- High card can be turned into five of a kind
  else
    return 1, "Five of a kind" -- All cards are Jokers, so we have five of a kind.
  end

  if highest_kind == "None" then
    error("No highest kind found for " .. cards.original)
  else
    return highest, highest_kind
  end
end

return function(input, output)
  local lines = input.lines()

  local hands = {}

  -- Load the hands into a table
  -- we will sort the cards in the hand based on their card power
  print("Reading and sorting hands...")
  for _, line in ipairs(lines) do
    ---@class Hand
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

    -- We will note down each original card in the hand, for use with comparing
    -- jokers.
    hand.card_counts = {}
    for card in cards:gmatch(".") do
      hand.card_counts[card] = hand.card_counts[card] and hand.card_counts[card] + 1 or 1
    end

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

    if not cards:match("J") then
      -- No jokers, so we can just check for the hand rank as normal.

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
    else
      local rname
      hand.rank, rname = get_joker_rank(hand)
      -- print("### JOKER", cards, hand.bid, rname)
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