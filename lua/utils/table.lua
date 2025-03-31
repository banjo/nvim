local M = {}

---@generic T : any
---@param tbl T[]
---@return T[]
M.tbl_reverse = function(tbl)
  local len = #tbl
  for i = 1, math.floor(len / 2) do
    local j = len - i + 1
    local swp = tbl[i]
    tbl[i] = tbl[j]
    tbl[j] = swp
  end
  return tbl
end

---@generic T : any
---@param tbl T[]
---@param start_idx? number
---@param end_idx? number
---@return T[]
M.tbl_slice = function(tbl, start_idx, end_idx)
  local ret = {}
  if not start_idx then
    start_idx = 1
  end
  if not end_idx then
    end_idx = #tbl
  end
  for i = start_idx, end_idx do
    table.insert(ret, tbl[i])
  end
  return ret
end

---@generic T : any
---@generic U : any
---@param tbl T[]
---@param needle U
---@param transform? fun(item: T): U
---@return T?
M.tbl_remove = function(tbl, needle, transform)
  for i, v in ipairs(tbl) do
    if transform then
      if transform(v) == needle then
        return table.remove(tbl, i)
      end
    elseif v == needle then
      return table.remove(tbl, i)
    end
  end
end

---@generic T : any
---@generic U : any
---@param tbl T[]
---@param needle U
---@param extract? fun(item: T): U
---@return number?
M.tbl_index = function(tbl, needle, extract)
  for i, v in ipairs(tbl) do
    if extract then
      if extract(v) == needle then
        return i
      end
    else
      if v == needle then
        return i
      end
    end
  end
end

---@generic T : any
---@param list T[]
---@param cb fun(item: T): boolean
---@return boolean
M.list_any = function(list, cb)
  for _, v in ipairs(list) do
    if cb(v) then
      return true
    end
  end
  return false
end

---@generic T : any
---@param list T[]
---@param cb fun(item: T): boolean
---@return boolean
M.list_all = function(list, cb)
  for _, v in ipairs(list) do
    if not cb(v) then
      return false
    end
  end
  return true
end

---@generic T : any
---@param list T[]
---@param key string
---@return table<string, T>
M.tbl_group_by = function(list, key)
  local ret = {}
  for _, v in ipairs(list) do
    local k = v[key]
    if k then
      if not ret[k] then
        ret[k] = {}
      end
      table.insert(ret[k], v)
    end
  end
  return ret
end

---@generic T : any
---@param list_or_obj T|T[]
---@return fun(): integer, T
M.iter_as_list = function(list_or_obj)
  if list_or_obj == nil then
    return function() end
  end
  if type(list_or_obj) ~= "table" then
    local i = 0
    return function()
      if i == 0 then
        i = i + 1
        return i, list_or_obj
      end
    end
  else
    ---@diagnostic disable-next-line: redundant-return-value
    return ipairs(list_or_obj)
  end
end

return M
