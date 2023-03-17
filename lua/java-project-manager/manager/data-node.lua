local jdtls = require("java-project-manager.commands.jdtls")

local NodeKind = require("java-project-manager.const.node-data").NodeKind
-- local TypeKined = require("java-project-manager.const.node-data").TypeKind
local ContainerEntryKind = require("java-project-manager.const.node-data").ContainerEntryKind

local function get_children_arguments(node)
    if node:kind() == NodeKind.Project then
        return {
            kind = NodeKind.Project,
            projectUri = node:projectUri(),
        }
    end

    if node:kind() == NodeKind.Container then
        return {
            kind = NodeKind.Container,
            projectUri = node:projectUri(),
            path = node:jdtlsPath(),
        }
    end

    if node:kind() == NodeKind.PackageRoot then
        return {
            kind = NodeKind.PackageRoot,
            project = node:projectUri(),
            rootPath = node:jdtlsPath(),
            handlerIdentifier = node:handlerIdentifier(),
            isHierarchicalView = true,
        }
    end

    if node:kind() == NodeKind.Package then
        return {
            kind = NodeKind.Package,
            projectUri = node:projectUri(),
            path = node:jdtlsName(),
            handlerIdentifier = node:handlerIdentifier(),
        }
    end
end

local M = {}
setmetatable(M, { __index = M })

function M:kind()
    return self._private.nodeData.kind
end

function M:uri()
    return self._private.nodeData.uri
end

function M:handlerIdentifier()
    return self._private.nodeData.handlerIdentifier
end

function M:project()
    return self._private.project
end

function M:projectUri()
    return self._private.projectUri
end

function M:jdtlsPath()
    return self._private.nodeData.path
end

function M:jdtlsName()
    return self._private.nodeData.name
end

function M:loadChildren()
    -- print(self:kind())
    if self:kind() == NodeKind.PrimaryType or self:kind() == NodeKind.File then
        return {}
    end

    local children = {}

    -- get children for workspace
    if self:kind() == NodeKind.Workspace then
        local projects = jdtls.getProjects(self._private.nodeData.uri)
        for _, project in pairs(projects) do
            table.insert(children, M.new(project, project, self:uri(), self))
        end
        self.children = children
    end

    -- get all containers for project
    if self:kind() == NodeKind.Project then
        local containers = jdtls.getPackageData(get_children_arguments(self))
        for _, container in pairs(containers) do
            -- if current container is s souce container, get package root of this container and add to children
            if container.entryKind == ContainerEntryKind.CPE_SOURCE then
                local package_roots = jdtls.getPackageData({
                    kind = NodeKind.Container,
                    projectUri = self:projectUri(),
                    path = container.path,
                })
                for _, pr in pairs(package_roots) do
                    table.insert(children, M.new(pr, self._private.project, self:projectUri(), self))
                end
            end

            -- if current container is library add to children list directly
            if container.entryKind == ContainerEntryKind.CPE_LIBRARY then
                table.insert(children, M.new(container, self._private.project, self:projectUri(), self))
            end
        end
        self.children = children
    end

    if self:kind() == NodeKind.Container or self:kind() == NodeKind.PackageRoot or self:kind() == NodeKind.Package then
        local nodes = jdtls.getPackageData(get_children_arguments(self))
        for _, n in pairs(nodes) do
            table.insert(children, M.new(n, self._private.project, self:projectUri(), self))
        end
        self.children = children
    end

    return children
end

local function __index(node, key)
    if key == "id" then
        return M.jdtlsName(node)
    end

    if key == "name" then
        return M.jdtlsName(node)
    end

    if key == "path" then
        return vim.uri_to_fname(M.uri(node))
    end

    if key == "type" then
        return M.kind(node)
    end

    if key == "ext" then
        return setmetatable(node, { __index = __index })
    end

    return M[key]
end

function M.new(nodeData, project, projectUri, parent)
    local node = {
        _private = {
            nodeData = nodeData,
            parent = parent,
            project = project,
            projectUri = projectUri,
        },
    }
    return setmetatable(node, { __index = __index })
end

return M
