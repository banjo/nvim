return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "j-hui/fidget.nvim",
      "banjo/contextfiles.nvim",
      "ravitemer/mcphub.nvim",
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
                role = "user",
                opts = {
                  contains_code = true,
                },
                content = function(context)
                  local ctx = require("contextfiles.extensions.codecompanion")
                  local content = ctx.get(context.filename, {
                    root_markers = { ".git" },
                    rules_dir = ".cursor/rules",
                    gist_ids = { "1c9b5faca0c89f9877eccc88bc6b3cc0" },
                  })
                  return [[#buffer @full_stack_dev]] .. "\n\n" .. content
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
            tools = {
              ["mcp"] = {
                -- calling it in a function would prevent mcphub from being loaded before it's needed
                callback = function()
                  return require("mcphub.extensions.codecompanion")
                end,
                description = "Call tools and resources from the MCP Servers",
                opts = {
                  requires_approval = false,
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
