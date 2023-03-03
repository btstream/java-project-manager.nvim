local NodeKind = require("java-project-manager.const.node-data").NodeKind
local TypeKined = require("java-project-manager.const.node-data").TypeKind
local ContainerEntryKind = require("java-project-manager.const.node-data").ContainerEntryKind

local function generate_arguments() end

local M = {}
setmetatable(M, { __index = M })

function M:load() end

function M:kind()
    return self._private.nodeData.kind
end

function M:uri() end

function M:handlerIdentifier()
    return self._private.nodeData.handlerIdentifier
end

function M:path()
    return self._private.nodeData.path
end

function M:name()
    return self._private.nodeData.name
end

function M:loadChildren() end

function M.new(nodeData)
    local node = {
        _private = {
            nodeData = nodeData,
        },
    }
    return setmetatable(node, { __index = M })
end

return M
