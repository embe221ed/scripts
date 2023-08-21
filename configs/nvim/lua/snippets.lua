local ls  = require("luasnip")
local s   = ls.snippet
local t   = ls.text_node
local i   = ls.insert_node
local f   = ls.function_node


-- args is a table, where 1 is the text in Placeholder 1, 2 the text in
-- placeholder 2,...
local function copy(args)
	return args[1]
end

-- LuaSnip custom snippets
-- -- Move
ls.add_snippets("move", {
  s("test", {
    -- simple text with a linebreak (`"\t"`)
    t("#[test]", "\t"),
    -- text
    t("// Parameters: "),
    -- function, first parameter is the function, second the placeholder's index
    -- whose text it gets as input. 
    f(copy, 2),
    -- text
    t({ "", "public fun " }),
    -- placeholder/insert
    i(1),
    -- text
    t("("),
    -- placeholder/insert
    i(2, "val: u64"),
    -- text + linebreak
    t({ ") {", "\t" }),
    -- last placeholder, exit point of the snippet (idx: 0)
    i(0),
    -- text
    t({ "", "}" }),
  }),
})

-- -- Python
ls.add_snippets("python", {
  s("remote", {
    -- simple text
    t("HOST, PORT = \""),
    -- text
    i(1),
    -- text
    t("\".split()"),
  }),
})
