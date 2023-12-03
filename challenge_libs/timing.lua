--- Small library to help with yielding errors.

---@class timing
local timing = {}

--- Yield and resume as fast as possible.
function timing.fast_yield()
  os.queueEvent("fast_yield")
  os.pullEvent("fast_yield")
end

--- Yield and resume after a given amount of milliseconds.
---@param ms integer The amount of milliseconds to wait.
function timing.sleep_ms(ms)
  local end_time = os.epoch("utc") + ms
  repeat
    timing.fast_yield()
  until os.epoch("utc") >= end_time
end


local next_sleep = 0
--- Yield ONLY if it has been a specific amount of time since last calling this function
---@param ms integer The maximum delay between calls, in milliseconds. Used for the *next* call to this function, the first call will always yield.
function timing.sleep_only_as_needed(ms)
  local current_time = os.epoch("utc")
  if current_time >= next_sleep then
    next_sleep = current_time + ms
    timing.fast_yield()
  end
end

return timing