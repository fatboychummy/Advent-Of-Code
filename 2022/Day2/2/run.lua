return function(input, output)
  local lines = input.lines()

  local score = 0

  -- A rock
  -- B paper
  -- C scissors
  -- X - Lose
  -- Y - Draw, choose same
  -- Z - Win
  local TIE = 3
  local LOSS = 0
  local WIN = 6
  local ROCK_PTS = 1
  local PAPR_PTS = 2
  local SCSR_PTS = 3

  local scores = {
    -- all need to result in loss
    X = { A = LOSS + SCSR_PTS, B = LOSS + ROCK_PTS, C = LOSS + PAPR_PTS },
    -- all need to result in tie
    Y = { A = TIE + ROCK_PTS, B = TIE + PAPR_PTS, C = TIE + SCSR_PTS },
    -- all need to result in win
    Z = { A = WIN + PAPR_PTS, B = WIN + SCSR_PTS, C = WIN + ROCK_PTS }
  }

  for _, line in ipairs(lines) do
    local p1, p2 = line:match("(%S) (%S)")

    if scores[p2] and scores[p2][p1] then
      score = score + scores[p2][p1]
    else
      error(string.format("Missing value for '%s' and '%s'.", p2, p1))
    end
  end

  output.write(score)
end
