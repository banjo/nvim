local M = {}

-- Find the project root directory by walking up the directory tree until a marker is found
function M.find_root_dir(file_path, root_markers)
  local root_dir = vim.fn.fnamemodify(file_path, ":h") -- Start with buffer directory

  -- Walk up the directory tree until we find a marker
  while root_dir ~= "/" do
    local found = false
    for _, marker in ipairs(root_markers) do
      if vim.fn.isdirectory(root_dir .. "/" .. marker) == 1 or vim.fn.filereadable(root_dir .. "/" .. marker) == 1 then
        found = true
        break
      end
    end

    if found then
      break
    end

    -- Move up one directory
    root_dir = vim.fn.fnamemodify(root_dir, ":h")
  end

  return root_dir
end

-- Parse frontmatter to extract glob patterns from a file's content
function M.parse_glob_patterns(content)
  local patterns = {}
  local in_frontmatter = false

  for _, line in ipairs(content) do
    if line:match("^%-%-%-$") then
      if in_frontmatter then
        break
      else
        in_frontmatter = true
      end
    elseif in_frontmatter then
      local globs = line:match("^globs:%s*(.+)$")
      if globs then
        -- Handle array format: globs: ["pattern1", "pattern2"]
        if globs:match("^%[.+%]$") then
          -- Remove [ and ]
          local globs_content = globs:sub(2, -2)
          -- handles both ' and "
          for pattern_match in globs_content:gmatch("[\"']([^\"']+)[\"']") do
            table.insert(patterns, pattern_match)
          end
        else
          -- Handle simple string format: globs: pattern, removes quotes if present
          local clean_glob = globs:gsub("^[\"'](.+)[\"']$", "%1")
          table.insert(patterns, clean_glob)
        end
        break
      end
    end
  end

  return patterns
end

-- Scan for rule files in the given directory and extract their patterns and content
function M.scan_rule_files(rules_dir)
  local files = {}
  local scan_files = vim.fn.glob(rules_dir .. "/*", false, true)

  for _, file in ipairs(scan_files) do
    if vim.fn.isdirectory(file) == 0 then
      local content = vim.fn.readfile(file)
      local patterns = M.parse_glob_patterns(content)

      if #patterns > 0 then
        table.insert(files, { file = file, patterns = patterns, content = content })
      end
    end
  end

  return files
end

-- Get the content of files whose patterns match the current file
function M.get_matching_file_contents(files, file_name_from_root_dir)
  local file_contents = {}

  for _, file_entry in ipairs(files) do
    if file_entry.patterns then
      for _, pattern in ipairs(file_entry.patterns) do
        local is_match = vim.fn.glob(pattern):find(file_name_from_root_dir)
        if is_match then
          for _, line in ipairs(file_entry.content) do
            table.insert(file_contents, line)
          end

          -- found a match, no need to check other patterns
          break
        end
      end
    end
  end

  return file_contents
end

function M.init(context)
  local RULES_DIR = ".cursor/rules"
  local ROOT_MARKERS = { ".git" }
  local file_name = context.filename

  local root_dir = M.find_root_dir(file_name, ROOT_MARKERS)

  local absolute_rules_dir = root_dir .. "/" .. RULES_DIR
  local file_name_from_root_dir = file_name:sub(#root_dir + 2)

  if vim.fn.isdirectory(absolute_rules_dir) == 0 then
    vim.api.nvim_err_writeln("Rules directory does not exist")
    return ""
  end

  local rule_files = M.scan_rule_files(absolute_rules_dir)
  local file_contents = M.get_matching_file_contents(rule_files, file_name_from_root_dir)

  return table.concat(file_contents, "\n")
end

return M
