local NodeKind = require("java-project-manager.const.node-data").NodeKind
local TypeKined = require("java-project-manager.const.node-data").TypeKind
local ContainerEntryKind = require("java-project-manager.const.node-data").ContainerEntryKind

local M = {}
setmetatable(M, { __index = M })

function M:load() end

function M:kind() end

function M:uri() end

function M:handlerIdentifier() end

function M:path() end

function M:name() end

function M:getChildren() end

function M.new(meta)
    local node = {
        _private = {
            meta = meta,
        },
    }
    return setmetatable(node, { __index = M })
end

return M
