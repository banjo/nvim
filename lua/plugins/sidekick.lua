--- Send a message to opencode, bypassing the picker.
--- If a sidekick-spawned opencode terminal is already attached, sends to it directly.
--- Otherwise, starts a new opencode terminal and sends after it's ready.
--- External opencode sessions (e.g. from tmux) are ignored.
local function send_opencode(msg)
  local State = require("sidekick.cli.state")
  local cli = require("sidekick.cli")
  -- Check if we already have a sidekick-spawned opencode terminal attached
  local attached = State.get({ name = "opencode", terminal = true, attached = true })
  if #attached > 0 then
    cli.send({ msg = msg, filter = { name = "opencode", terminal = true, attached = true } })
  else
    -- Get the unstarted opencode tool state
    local all = State.get({ name = "opencode" })
    -- Pick the first non-external one, or fallback to any
    local state
    for _, s in ipairs(all) do
      if not s.external then
        state = s
        break
      end
    end
    if not state then
      vim.notify("opencode not found", vim.log.levels.ERROR)
      return
    end
    -- Attach (this starts the terminal), then send
    local result = State.attach(state, { show = true, focus = false })
    vim.schedule(function()
      local rendered = cli.render({ msg = msg })
      if rendered and rendered ~= "" and result.session then
        result.session:send(rendered .. "\n")
      end
    end)
  end
end

return {
  "folke/sidekick.nvim",
  opts = {
    cli = {
      tools = {
        opencode = {},
      },
    },
  },
  keys = {
    {
      "<tab>",
      function()
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>"
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<c-.>",
      function() require("sidekick.cli").focus() end,
      desc = "Sidekick Focus",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>aa",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>as",
      function() require("sidekick.cli").select() end,
      desc = "Select CLI",
    },
    {
      "<leader>ad",
      function() require("sidekick.cli").close() end,
      desc = "Detach a CLI Session",
    },
    {
      "<leader>at",
      function() send_opencode("{this}") end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>af",
      function() send_opencode("{file}") end,
      desc = "Send File",
    },
    {
      "<leader>av",
      function() send_opencode("{selection}") end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>ap",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
  },
}
