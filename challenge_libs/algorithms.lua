--- This module contains a bunch of random mathematical algorithms.

local algorithms = {}

local abs = math.abs

--- Returns the greatest common divisor of two numbers.
---@param a number The first number.
---@param b number The second number.
---@return number The GCD of the numbers.
local function _GCD(a, b)
  if b == 0 then
    return a
  end

  return _GCD(b, a % b)
end

--- Uses Euclidean's algorithm to return the greatest common divisor of two or more numbers.
---@param ... number The numbers to find the GCD of.
---@return number The GCD of the numbers.
function algorithms.GCD(...)
  local numbers = {...}

  local gcd = numbers[1]
  for i = 2, #numbers do
    gcd = _GCD(gcd, numbers[i])
  end

  return gcd
end

--- Returns the least common multiple of two numbers.
---@param a number The first number.
---@param b number The second number.
---@return number The LCM of the numbers.
local function _LCM(a, b)
  return abs(a * b) / _GCD(a, b)
end

--- Returns the least common multiple of multiple numbers.
---@param ... number The numbers to find the LCM of.
---@return number The LCM of the numbers.
function algorithms.LCM(...)
  local numbers = {...}

  local lcm = numbers[1]
  for i = 2, #numbers do
    lcm = _LCM(lcm, numbers[i])
  end

  return lcm
end

return algorithms