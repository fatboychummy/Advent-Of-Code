return function(input, output)
  local SPACE_AVAILABLE = 70000000
  local SPACE_REQUIRED  = 30000000
  local LS_MATCH        = "^%$ ls"
  local CD_MATCH        = "^%$ cd (.+)"
  local FILE_MATCH      = "(%d+) (.+)"
  local DIR_MATCH       = "^dir (.+)"

  local tree = { ["/"] = {} }
  local directory = { "/", n = 1 }

  --- Insert an object to the directory tree
  ---@param name string
  ---@param type fs_type
  ---@param size integer?
  local function insert(name, type, size)
    local pos = tree
    for _, dir in ipairs(directory) do
      pos = pos[dir]
    end

    if type == "dir" then
      pos[name] = {}
    else -- type == "file"
      pos[name] = size
    end
  end

  --- change directory
  ---@param to string the directory to change to
  local function cd(to)
    if to == "/" then
      directory = { "/", n = 1 }
    elseif to == ".." then
      directory[directory.n] = nil
      directory.n = directory.n - 1
      if directory.n <= 0 then return cd("/") end
    else
      directory.n = directory.n + 1
      directory[directory.n] = to
    end
  end

  -- First: Read all filesystem information.
  for line in input.readLine do
    local ls = line:match(LS_MATCH)
    local cd_to = line:match(CD_MATCH)
    local size, filename = line:match(FILE_MATCH)
    local dir = line:match(DIR_MATCH)

    if ls then -- Nothing? Ignore?
    elseif cd_to then
      cd(cd_to)
    elseif size then
      insert(filename, 'file', tonumber(size))
    elseif dir then
      insert(dir, 'dir')
    end
  end

  -- Then, recursively size every directory, keeping track of which are below
  -- MAX_SIZE.
  local sizes = { n = 0 }
  local function size(folder, depth)
    local folder_size = 0
    for _, value in pairs(folder) do
      if type(value) == "table" then
        -- folder
        local sub_size = size(value, depth + 1)
        folder_size = folder_size + sub_size
      else
        -- file
        folder_size = folder_size + value
      end
    end

    sizes.n = sizes.n + 1
    sizes[sizes.n] = folder_size

    return folder_size
  end

  size(tree, 0)

  table.sort(sizes)

  local total_size = sizes[sizes.n]

  local remove_requirement = math.abs(SPACE_AVAILABLE - SPACE_REQUIRED - total_size)

  local best_fit = math.huge
  for i = 1, sizes.n do
    if sizes[i] >= remove_requirement then
      best_fit = math.min(best_fit, sizes[i])
    end
  end

  print("Space available:", SPACE_AVAILABLE)
  print("Space required :", SPACE_REQUIRED)
  print("Total size     :", total_size)
  print("Remove require :", remove_requirement)
  print("Best fit       :", best_fit)

  output.write(best_fit)
end
