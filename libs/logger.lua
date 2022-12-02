local logger = {}

local function output_colored(levelname, color, color2, text, ...)
  local args = table.pack(...)
  if args.n > 0 then
    text = string.format(text, ...)
  end

  term.setTextColor(colors.white)
  term.write("[")
  term.setTextColor(color)
  term.write(levelname)
  term.setTextColor(colors.white)
  term.write("] ")
  term.setTextColor(color2)
  print(text)
end

local function output(levelname, color, text, ...)
  local args = table.pack(...)
  if args.n > 0 then
    text = string.format(text, ...)
  end

  term.setTextColor(colors.white)
  term.write("[")
  term.setTextColor(color)
  term.write(levelname)
  term.setTextColor(colors.white)
  print("]", text)
end

function logger.info(...)
  output("INFO", colors.white, ...)
end

function logger.warn(...)
  output("WARN", colors.orange, ...)
end

function logger.error(...)
  output("ERROR", colors.red, ...)
end

function logger.debug(...)
  output_colored("DEBUG", colors.lightGray, colors.lightGray, ...)
end

function logger.custom(levelname, color, color2, ...)
  output_colored(levelname, color, color2, ...)
end

return logger
