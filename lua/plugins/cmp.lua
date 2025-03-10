-- Icons to use in the completion menu.
local symbol_kinds = {
  Class = "",
  Color = "",
  Constant = "",
  Constructor = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "",
  File = "",
  Folder = "",
  Function = "",
  Interface = "",
  Keyword = "",
  Method = "",
  Module = "",
  Operator = "",
  Property = "",
  Reference = "",
  Snippet = "",
  Struct = "",
  Text = "",
  TypeParameter = "",
  Unit = "",
  Value = "",
  Variable = "",
}

-- Inspiration:
-- https://github.com/MariaSolOs/dotfiles/blob/e9eb1f8e027840f872e69e00e082e2be10237499/.config/nvim/lua/plugins/nvim-cmp.lua

return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    local luasnip = require("luasnip")
    local cmp = require("cmp")

    -- opts.completion = {
    --   autocomplete = false,
    -- }

    opts.mapping = vim.tbl_extend("force", opts.mapping, {
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
      -- Explicitly request completions.
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-c>"] = cmp.mapping.close(),
      -- Overload tab to accept Copilot suggestions.
      ["<Tab>"] = cmp.mapping(function(fallback)
        local copilot = require("copilot.suggestion")

        if copilot.is_visible() then
          copilot.accept()
        elseif cmp.visible() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace })
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.expand_or_locally_jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-d>"] = function()
        if cmp.visible_docs() then
          cmp.close_docs()
        else
          cmp.open_docs()
        end
      end,
    })

    -- Disable preselect. On enter, the first thing will be used if nothing is selected.
    opts.preselect = cmp.PreselectMode.None

    -- Add icons to the completion menu.
    opts.formatting = {
      format = function(_, vim_item)
        vim_item.kind = (symbol_kinds[vim_item.kind] or "") .. "  " .. vim_item.kind
        return vim_item
      end,
    }

    opts.snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    }

    opts.window = {
      completion = {
        border = "rounded",
        scrollbar = true,
      },
      documentation = {
        border = "rounded",
        max_height = math.floor(vim.o.lines * 0.5),
        max_width = math.floor(vim.o.columns * 0.4),
      },
    }

    opts.view = {
      -- Explicitly request documentation.
      docs = { auto_open = false },
    }

    -- use all sources but excluded ones to remove boring completions
    local excluded_sources = { "buffer" }
    local new_sources = {}

    for _, source in ipairs(opts.sources) do
      local excluded = vim.tbl_contains(
        vim.tbl_map(function(src)
          return src.name
        end, excluded_sources),
        source.name
      )

      if not excluded then
        table.insert(new_sources, source)
      end
    end

    opts.sources = new_sources
  end,
}
