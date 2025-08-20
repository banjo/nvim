return {
  "saghen/blink.cmp",
  opts = {
    snippets = {
      preset = "luasnip",
    },
    keymap = {
      preset = "super-tab",
      -- TODO: REMOVE THIS AFTER THIS HAS BEEN MERGED: https://github.com/LazyVim/LazyVim/pull/6183
      ["<Tab>"] = {
        require("blink.cmp.keymap.presets").get("super-tab")["<Tab>"][1],
        require("lazyvim.util.cmp").map({ "snippet_forward", "ai_accept" }),
        "fallback",
      },
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
