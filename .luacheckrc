std = "max"
exclude_files = {
    "libs/**",
}
ignore = {
    "111", -- setting non-standard global variable
    "112", -- mutating non-standard global variable
    "113", -- accessing undefined variable
    "211", -- unused local variable
    "212", -- unused argument
    "213", -- unused loop variable
    "311", -- value assigned to variable is unused
    "411", -- variable was previously defined
    "412", -- variable was previously defined as an argument
    "421", -- shadowing local variable
    "422", -- shadowing argument
    "542", -- empty if branch
    "631", -- line is too long
}

