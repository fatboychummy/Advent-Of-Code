-- This code is a hot mess that I originally wrote two years ago and am just sort of updating as I go.

local logger = require "libs.logger"

package.path = ("%s;/%s/challenge_libs/?.lua;/%s/challenge_libs/?/init.lua")
    :format(package.path, shell.dir(), shell.dir())

local SESSION_FILE = shell.dir() .. "/.session_cookie"

local year, day, number, setup = ...

local function print_usage()
  print("Usage:")
  print("  challenge.lua <year> <day> <number> ['test']")
  print("  challenge.lua setup <year> <day> <number>")
  error("", 0)
end

if year == "setup" then
  year = day
  day = number
  number = setup
  setup = true
end
local dir = fs.combine(shell.dir(), year, "Day" .. day, number)

if not year or not day or not number or not tonumber(number) then
  print_usage()
end

--### FILE INFORMATION
--### FILE INFORMATION
--### FILE INFORMATION

local function blank_file()
  return ""
end

local function input_txt()
  local handle, err = io.open(SESSION_FILE, 'r')

  if not handle then printError("Failed to open session file! Does it exist?") error(err, 0) end

  local cookie = handle:read("*a"):gsub("\n+$", "")
  handle:close()

  local h, err, errH = http.get("https://adventofcode.com/" .. year .. "/day/" .. day .. "/input",
    { cookie = "session=" .. cookie })
  if not h then
    printError("Failed to download input:")
    printError(err)
    error(errH.readAll(), 0)
  end

  local data = h.readAll()
  h.close()

  return data
end

local function run_lua()
  return [[return function(input, output)
  local lines = input.lines()



  output.write("Sample output")
end]]
end

if setup == true then
  logger.info("Setting up challenge.")
  local files = {
    { fs.combine(dir, "README.md"), blank_file },
    { fs.combine(dir, "run.lua"), run_lua },
    { fs.combine(dir, "test_input.txt"), blank_file },
    { fs.combine(dir, "input.txt"), input_txt },
  }

  logger.info("Make directory: %s", dir)
  fs.makeDir(dir)

  for i = 1, #files do
    logger.info("Create file: %s", files[i][1])
    io.open(files[i][1], 'w'):write(files[i][2]()):close()
  end

  logger.info("Done.")
  return
end

local function make_input(filename)
  local handle = fs.open(filename, 'r')
  if not handle then
    error("Error reading input.txt, most likely it does not exist.", 0)
  end

  function handle.lines()
    local t = { n = 0 }
    while true do
      local line = handle.readLine()
      if not line then
        return t
      end
      t.n = t.n + 1
      t[t.n] = line
    end
  end

  local close = handle.close
  handle.close = function() end

  function handle._close()
    close()
  end

  return handle
end

local function make_output(file1, file2)
  local h1, h2 = fs.open(file1, 'w'), fs.open(file2, 'w')

  return setmetatable(
    {
      data = "",
      _close = function()
        h1.close()
        h2.close()
      end
    },
    {
      __index = function(self, idx)
        if idx == "write" or idx == "writeLine" then
          return function(txt)
            h1[idx](txt)
            h2[idx](txt)

            if idx == "writeLine" then
              self.data = self.data .. tostring(txt) .. "\n"
            else
              self.data = self.data .. tostring(txt)
            end
          end
        else
          return function() end
        end
      end
    }
  )
end

local function read_file(filename)
  local handle = io.open(filename, 'r')
  if handle then
    local data = handle:read("*a")
    handle:close()
    return data
  end

  error("Failed to open file '" .. filename .. "' for reading", 2)
end

local function get_challenge()
  local data = {
    input = make_input(
      fs.combine(dir, setup == "test" and "test_input.txt" or "input.txt")
    ),
    output = make_output(
      fs.combine(dir, "output.txt"),
      fs.combine(shell.dir(), "current_output.txt")
    ),
    run = fs.combine(dir, "run.lua"),
    challenge = fs.combine(dir, "challenge.md")
  }

  local run_data = read_file(data.run)
  local err
  data.run, err = load(run_data, "@" .. data.run, 't', _ENV)
  if not data.run then
    logger.error("Failure to load challenge:")
    error(err, 0)
  end

  local ok, err = pcall(data.run)
  if not ok then
    logger.error("Failure to load challenge:")
    error(err, 0)
  end
  data.run = err

  logger.debug("Challenge loaded: %s", tostring(data.run))

  return data
end

local function display_challenge_results(ns, result)
  logger.info("Challenge took %d milliseconds", ns)
  logger.custom(
    "RESULT",
    colors.green,
    colors.cyan,
    "%s",
    not result:find("\n") and #result < 30 and result
    or "Check current_output.txt"
  )
end

local function run_challenge()
  local challenge_data = get_challenge()

  logger.info("Running challenge.")
  local start_time = os.epoch "utc"
  local ok, err = pcall(
    challenge_data.run,
    challenge_data.input,
    challenge_data.output
  )
  local end_time = os.epoch "utc"

  challenge_data.output:_close()
  challenge_data.input:_close()
  logger.debug("Input and output handles closed.")

  if not ok then
    logger.error("Runtime error while running challenge.")
    error(err, 0)
  end
  logger.info("Done.")

  display_challenge_results(end_time - start_time, challenge_data.output.data)
end

local function display_challenge_metadata()
  -- Do nothing yet.
end

display_challenge_metadata()
run_challenge()
