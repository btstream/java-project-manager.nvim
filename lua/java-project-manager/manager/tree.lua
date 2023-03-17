local jdtls = require("java-project-manager.commands.jdtls")
local NodeKind = require("java-project-manager.const.node-data").NodeKind

local DataNode = require("java-project-manager.manager.data-node")

local M = {}

M.update = function()
    local co = coroutine.create(function()
        local workspace = jdtls.getWorkspaces()
        local root = DataNode.new({
            name = "workspace",
            uri = workspace,
            kind = NodeKind.Workspace,
        })
        local stack = { root }
        while #stack ~= 0 do
            local node = table.remove(stack, 1)
            local children = node:loadChildren()
            for _, child in pairs(children) do
                print(vim.inspect(child))
                table.insert(stack, child)
            end
        end
    end)
    coroutine.resume(co)
end

return M
