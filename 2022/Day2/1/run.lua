return function(input, output)
  local lines = input.lines()

  local score = 0

  -- A, X rock
  -- B, Y paper
  -- C, Z scissors
  local TIE = 3
  local LOSS = 0
  local WIN = 6
  local ROCK_PTS = 1
  local PAPR_PTS = 2
  local SCSR_PTS = 3

  local scores = {
    A = { X = TIE + ROCK_PTS, Y = WIN + PAPR_PTS, Z = LOSS + SCSR_PTS },
    B = { X = LOSS + ROCK_PTS, Y = TIE + PAPR_PTS, Z = WIN + SCSR_PTS },
    C = { X = WIN + ROCK_PTS, Y = LOSS + PAPR_PTS, Z = TIE + SCSR_PTS }
  }

  for _, line in ipairs(lines) do
    local p1, p2 = line:match("(%S) (%S)")

    if scores[p1] and scores[p1][p2] then
      score = score + scores[p1][p2]
    else
      error(string.format("Missing value for '%s' and '%s'.", p1, p2))
    end
  end

  output.write(score)
end
