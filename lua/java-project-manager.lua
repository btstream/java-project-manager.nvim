local jdtls = require("java-project-manager.commands.jdtls")
local NodeKind = require("java-project-manager.const.node-data").NodeKind
local CPE = require("java-project-manager.const.node-data").ContainerEntryKind

local co = coroutine.create(function()
    local workspace = jdtls.getWorkspaces()
    local project = jdtls.getProjects(workspace)[1]
    -- print(vim.inspect(project))
    local containers = jdtls.getPackageData({
        kind = NodeKind.Project,
        projectUri = project.uri,
    })

    for _, v in pairs(containers) do
        -- if source container, need to get source folder
        if v.entryKind == CPE.CPE_SOURCE then
            local c = jdtls.getPackageData({
                kind = NodeKind.Container,
                projectUri = project.uri,
                path = v.path,
            })
            local p = jdtls.getPackageData({
                kind = NodeKind.PackageRoot, -- package root of a source container is a folder
                project = project.uri,
                rootPath = c[1].path,
                handlerIdentifier = c[1].handlerIdentifier,
                isHierarchicalView = true,
            })
        end

        -- CPE_CONTAINER is dependency libraries, such as jre libraries or maven libraries
        if v.entryKind == CPE.CPE_CONTAINER then
            -- TODO: get Libraries data
        end
    end

    -- print(vim.inspect(rootPackages))
end)
coroutine.resume(co)
