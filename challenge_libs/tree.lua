--- A small library for working with trees.



---@class Tree-class
local tree = {}

--- Create a new node.
---@param value any The value of the node.
---@return Tree tree The node.
function tree.new(value)
  ---@class Tree
  ---@field parent Tree? The parent of the node.
  ---@field left Tree? The left child of the node.
  ---@field right Tree? The right child of the node.
  local obj = {
    _is_tree = true,
    parent = nil,
    left = nil,
    right = nil,
    value = value
  }

  --- Get the root node of the tree.
  ---@return Tree root The root node.
  function obj.get_root()
    local root = obj

    while root.parent do
      root = root.parent --[[@as Tree]]
    end

    return root
  end

  --- Insert a new node for the left child. If the value is a node, it will be
  --- used directly as the left child. Otherwise, a new node will be created
  --- with the value.
  ---@param value any The value of the node.
  ---@return Tree node The new node.
  function obj.new_left(value)
    if type(value) == "table" and value._is_tree then
      value.parent = obj
      obj.left = value
      return value
    end

    local node = tree.new(value)
    node.parent = obj
    obj.left = node
    return node
  end

  --- Insert a new node for the right child. If the value is a node, it will be
  --- used directly as the right child. Otherwise, a new node will be created
  --- with the value.
  ---@param value any The value of the node.
  ---@return Tree node The new node.
  function obj.new_right(value)
    if type(value) == "table" and value._is_tree then
      value.parent = obj
      obj.right = value
      return value
    end

    local node = tree.new(value)
    node.parent = obj
    obj.right = node
    return node
  end

  return obj
end

return tree