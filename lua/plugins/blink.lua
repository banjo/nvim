return {
  "saghen/blink.cmp",
  opts = {
    snippets = {
      preset = "luasnip",
    },
    keymap = {
      preset = "super-tab",
      -- ["<Tab>"] = {
      --   "snippet_forward",
      --   function() -- sidekick next edit suggestion
      --     return require("sidekick").nes_jump_or_apply()
      --   end,
      --   require("blink.cmp.keymap.presets").get("super-tab")["<Tab>"][1],
      --   require("lazyvim.util.cmp").map({ "snippet_forward", "ai_accept" }),
      --   -- function() -- if you are using Neovim's native inline completions
      --   --   return vim.lsp.inline_completion.get()
      --   -- end,
      --   "fallback",
      -- },
    },
    completion = {
      menu = {
        border = "rounded",
        winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
      },
      documentation = {
        window = {
          border = "rounded",
        },
      },
    },
    -- https://github.com/Saghen/blink.cmp/discussions/613 - remove text source
    sources = {
      transform_items = function(ctx, items)
        -- Remove the "Text" source from lsp autocomplete
        return vim.tbl_filter(function(item)
          return item.kind ~= vim.lsp.protocol.CompletionItemKind.Text
        end, items)
      end,
    },
  },
}
