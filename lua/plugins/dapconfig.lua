---@module "lazy"
---@type LazySpec
return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "nvim-neotest/nvim-nio",
            { "rcarriga/nvim-dap-ui", opts = {} },
        },
    },
}
