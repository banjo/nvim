return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local codecompanion = require("codecompanion")

      -- Find the project root directory by walking up the directory tree until a marker is found
      local function find_root_dir(file_path, root_markers)
        local root_dir = vim.fn.fnamemodify(file_path, ":h") -- Start with buffer directory

        -- Walk up the directory tree until we find a marker
        while root_dir ~= "/" do
          local found = false
          for _, marker in ipairs(root_markers) do
            if
              vim.fn.isdirectory(root_dir .. "/" .. marker) == 1
              or vim.fn.filereadable(root_dir .. "/" .. marker) == 1
            then
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
      local function parse_glob_patterns(content)
        local patterns = {}
        local in_frontmatter = false

        for _, line in ipairs(content) do
          if line:match("^%-%-%-$") then
            if in_frontmatter then
              -- End of frontmatter
              break
            else
              -- Start of frontmatter
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
                -- Handle simple string format: globs: pattern
                -- Remove quotes if present
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
      local function scan_rule_files(rules_dir)
        local files = {}
        local scan_files = vim.fn.glob(rules_dir .. "/*", false, true)

        for _, file in ipairs(scan_files) do
          -- Skip directories
          if vim.fn.isdirectory(file) == 0 then
            local content = vim.fn.readfile(file)
            local patterns = parse_glob_patterns(content)

            if #patterns > 0 then
              table.insert(files, { file = file, patterns = patterns, content = content })
            end
          end
        end

        return files
      end

      -- Get the content of files whose patterns match the current file
      local function get_matching_file_contents(files, file_name_from_root_dir)
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

      codecompanion.setup({
        prompt_library = {
          ["default"] = {
            strategy = "chat",
            description = "The default prompt with nice context",
            opts = {
              short_name = "def",
              auto_submit = false,
              user_prompt = false,
              is_slash_cmd = true,
              ignore_system_prompt = false,
              contains_code = true,
            },
            references = {
              {
                type = "file",
                path = ".github/copilot-instructions.md",
              },
            },
            prompts = {
              {
                role = "user",
                content = "This is my current buffer: #buffer\n\n",
              },
            },
          },
          ["dynamic"] = {
            strategy = "chat",
            description = "The default prompt with nice context",
            opts = {
              short_name = "dynamic",
              auto_submit = false,
              user_prompt = false,
              is_slash_cmd = true,
              ignore_system_prompt = false,
              contains_code = true,
              stop_context_insertion = true,
            },
            references = {},
            prompts = {
              {
                role = "system",
                opts = {
                  contains_code = true,
                },
                content = function(context)
                  local rules = require("config.codecompanion.rules")
                  return rules.init(context)
                end,
              },
            },
          },
          ["inline"] = {
            strategy = "inline",
            description = "The default inline with nice context",
            opts = {
              short_name = "inline",
              user_prompt = true,
              ignore_system_prompt = false,
              contains_code = true,
            },
            prompts = {
              {
                role = "user",
                content = "This is my current buffer: #buffer\n\n",
              },
            },
            references = {
              {
                type = "file",
                path = ".github/copilot-instructions.md",
              },
            },
          },
        },
        adapters = {
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  default = "claude-3.7-sonnet",
                },
              },
            })
          end,
        },
        display = {
          diff = {
            provider = "mini_diff",
          },
        },
        strategies = {
          chat = {
            keymaps = {
              close = {
                modes = { n = { "q", "<C-c>" }, i = "<C-c>" },
              },
            },
            adapter = "copilot",
            slash_commands = {
              ["git_files"] = {
                description = "List git files",
                ---@param chat CodeCompanion.Chat
                callback = function(chat)
                  local handle = io.popen("git ls-files")
                  if handle ~= nil then
                    local result = handle:read("*a")
                    handle:close()
                    chat.references:add({ source = "git", id = "<git_files>" })
                    local content = "These are my current git files:\n" .. result
                    return chat:add_message(
                      { content = content, role = "user" },
                      { reference = "<git_files>", visible = false }
                    )
                  else
                    return chat:add_message({ content = "No git files available" })
                  end
                end,
                opts = {
                  contains_code = false,
                },
              },
            },
          },
          inline = {
            adapter = "copilot",
          },
        },
      })
    end,
    keys = {
      {
        "<leader>aa",
        function()
          require("codecompanion").prompt("def")
        end,
        desc = "[a]i ch[a]t",
        mode = { "n", "v" },
      },
      {
        desc = "[a]i [q]uick chat",
        "<leader>aq",
        function()
          require("codecompanion").prompt("inline")
        end,
        mode = { "n", "v" },
      },
      {
        "<leader>ac",
        function()
          require("codecompanion").actions({})
        end,
        desc = "[a]i [c]ommands",
        mode = { "n", "v" },
      },
      {
        "<leader>ad",
        function()
          require("codecompanion").prompt("dynamic")
        end,
        desc = "[a]i [d]ynamic prompt",
        mode = { "n", "v" },
      },
      {
        "<leader>at",
        function()
          require("codecompanion").toggle()
        end,
        desc = "[a]i [t]oggle chat",
        mode = { "n", "v" },
      },
    },
  },
}
