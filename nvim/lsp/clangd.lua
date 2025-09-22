-- File: ~/.config/nvim/lsp/clangd.lua
return {
    -- Command and arguments to start clangd
    cmd = { "clangd", "--background-index", "--clang-tidy", "--log=verbose" },

    -- Filetypes to automatically attach to
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },

    -- Root markers for determining project root
    root_markers = { ".clangd", ".clang-format", "compile_commands.json", ".git" },

    -- Optional initial options
    init_options = {
        -- fallbackFlags = function(filetype)
        --     if filetype == "c" then
        --         return { "-std=c11" }
        --     elseif filetype == "cpp" then
        --         return { "-std=c++20" }
        --     elseif filetype == "objc" then
        --         return { "-std=gnu11" }
        --     elseif filetype == "objcpp" then
        --         return { "-std=c++20" } -- or whatever Obj-C++ standard you want
        --     else
        --         return {}
        --     end
        -- end,
    },

    -- Single file support
    single_file_support = true,

    -- Optional callbacks
    on_init = function(client)
        print("clangd initialized with root_dir: " .. client.config.root_dir)
    end,

    on_error = function(err)
        print("clangd error: " .. vim.inspect(err))
    end,
}
