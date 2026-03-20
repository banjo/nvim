return {
  "saghen/blink.cmp",
  opts = {
    snippets = {
      preset = "luasnip",
    },
    keymap = {
      preset = "super-tab",
      ["<Tab>"] = {
        require("lazyvim.util.cmp").map({ "ai_accept" }),
        "fallback",
      },
      ["<CR>"] = { "accept", "fallback" },
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
