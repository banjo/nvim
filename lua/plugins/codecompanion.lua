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
        extensions = {
          contextfiles = {
            opts = {
              slash_command = {
                enabled = true,
                name = "context",
                ctx_opts = {
                  context_dir = ".cursor/rules",
                  root_markers = { ".git" },
                  enable_local = true,
                  -- gist_ids = { "1c9b5faca0c89f9877eccc88bc6b3cc0" },
                },
                format_opts = {
                  ---@param context_file ContextFiles.ContextFile the context file to prepend the prefix
                  prefix = function(context_file)
                    return string.format(
                      "Please follow the rules located at `%s`:",
                      vim.fn.fnamemodify(context_file.file, ":.")
                    )
                  end,
                  suffix = "",
                  separator = "",
                },
              },
            },
          },
        },
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
                content = [[
#{buffer}
@{insert_edit_into_file}
]],
              },
            },
          },
          ["lsp"] = {
            strategy = "chat",
            description = "A prompt that explains and then calls the #lsp variable.",
            opts = {
              short_name = "lsp",
              auto_submit = false,
              user_prompt = false,
              is_slash_cmd = true,
              ignore_system_prompt = false,
              contains_code = true,
            },
            prompts = {
              {
                role = "user",
                content = [[Analyze the current buffer using LSP (Language Server Protocol) features. Identify all errors present and explain each one with a clear and concise description.]],
              },
              {
                role = "user",
                content = [[#lsp]],
              },
              {
                role = "user",
                content = [[\n\n]],
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
                  -- models
                  -- https://github.com/olimorris/codecompanion.nvim/blob/6d8d355f402a304eb2b4f2052ebfd53f05ba5784/doc/usage/chat-buffer/agents.md?plain=1#L116
                  default = "gpt-4.1",
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
        desc = "AI Chat",
        mode = { "n", "v" },
      },
      {
        desc = "AI Quick Chat",
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
        desc = "AI Commands",
        mode = { "n", "v" },
      },
      {
        "<leader>at",
        function()
          require("codecompanion").toggle()
        end,
        desc = "AI Toggle Chat",
        mode = { "n", "v" },
      },
      {
        "<leader>ae",
        function()
          require("codecompanion").prompt("lsp")
        end,
        desc = "AI Explain LSP Error",
        mode = { "n", "v" },
      },
    },
  },
}
