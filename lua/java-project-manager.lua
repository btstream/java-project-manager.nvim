local jdtls = require("java-project-manager.commands.jdtls")
local NodeKind = require("java-project-manager.const.node-data").NodeKind
local CPE = require("java-project-manager.const.node-data").ContainerEntryKind

local tree = require("java-project-manager.manager.tree")
local sss, b = tree.update()

print(vim.inspect(sss, b))

-- local co = coroutine.create(function()
--     local workspace = jdtls.getWorkspaces()
--     print(vim.inspect(workspace))
--     local project = jdtls.getProjects(workspace)[1]
--     -- print(vim.inspect(project))
--     local containers = jdtls.getPackageData({
--         kind = NodeKind.Project,
--         projectUri = project.uri,
--     })

--     for _, v in pairs(containers) do
--         -- if source container, need to get source folder
--         -- print(vim.inspect(v))
--         if v.entryKind == CPE.CPE_CONTAINER then
--             local c = jdtls.getPackageData({
--                 kind = NodeKind.Container,
--                 projectUri = project.uri,
--                 path = v.path,
--             })
--             local p = jdtls.getPackageData({
--                 kind = NodeKind.PackageRoot, -- package root of a source container is a folder
--                 project = project.uri,
--                 rootPath = c[1].path,
--                 handlerIdentifier = c[1].handlerIdentifier,
--                 isHierarchicalView = true,
--             })
--             for _, j in pairs(p) do
--                 print(vim.inspect(p))
--                 if j.kind == NodeKind.Package then
--                     local s = jdtls.getPackageData({
--                         kind = NodeKind.Package,
--                         projectUri = project.uri,
--                         path = j.name,
--                         handlerIdentifier = j.handlerIdentifier,
--                     })
--                     -- print(vim.inspect(s))
--                     -- break
--                 end
--             end
--         end

--         -- CPE_CONTAINER is dependency libraries, such as jre libraries or maven libraries
--         -- if v.entryKind == CPE.CPE_CONTAINER then
--         --     -- TODO: get Libraries data
--         -- end
--     end

--     -- print(vim.inspect(rootPackages))
-- end)
-- coroutine.resume(co)
