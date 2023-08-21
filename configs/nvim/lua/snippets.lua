local ls  = require("luasnip")
local s   = ls.snippet
local t   = ls.text_node
local i   = ls.insert_node
local f   = ls.function_node

ls.add_snippets("move", {
  s("test", {
    -- Simple static text.
    t("#[test]"),
    -- function, first parameter is the function, second the Placeholders
    -- whose text it gets as input.
    -- f(copy, 2),
    t({ "", "public fun " }),
    -- Placeholder/Insert.
    i(1),
    t("("),
    -- Linebreak
    t({ ") {", "\t" }),
    -- Last Placeholder, exit Point of the snippet.
    i(0),
    t({ "", "}" }),
  }),
})
