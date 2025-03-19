return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "j-hui/fidget.nvim",
    },
    init = function()
      require("config.codecompanion.fidget-spinner"):init()
    end,
    config = function()
      local codecompanion = require("codecompanion")

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
            -- references = {
            --   {
            --     type = "file",
            --     path = ".github/copilot-instructions.md",
            --   },
            -- },
            prompts = {
              {
                role = "user",
                content = [[#buffer]],
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
                  local rule_files =
                    rules.scan(context.filename, { root_markers = { ".git" }, rules_dir = ".cursor/rules" })
                  local content = rules.format(rule_files, {
                    prefix = "Here is context for the current file: \n\n---",
                    separator = "\n\n---\n",
                    suffix = "\n\n---\n",
                  })

                  return [[#buffer]] .. "\n\n" .. content
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
                content = [[#buffer]],
              },
            },
            -- references = {
            --   {
            --     type = "file",
            --     path = ".github/copilot-instructions.md",
            --   },
            -- },
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
