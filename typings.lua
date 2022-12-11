---@meta

---@alias fs_type
---| 'dir'
---| 'file'

---@alias grid {[integer]:{[integer]:grid_object}}
---@alias grid_object {value:any}
---@alias linked_grid {[integer]:{[integer]:linked_grid_object}}
---@alias linked_grid_object {left:grid_object?,right:grid_object?,up:grid_object?,down:grid_object?,value:any}
