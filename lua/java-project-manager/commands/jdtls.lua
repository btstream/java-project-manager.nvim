-- require jdtls
local execute_command = require("jdtls.util").execute_command

local COMMANDS = require("java-project-manager.const.commands")

local NodeKind = require("java-project-manager.const.node-data").NodeKind
local TypeKined = require("java-project-manager.const.node-data").TypeKind
local CPE = require("java-project-manager.const.node-data").ContainerEntryKind

local M = {}

function M.getProjects(workspace)
    local e, projects = execute_command({
        command = COMMANDS.JAVA_PROJECT_LIST,
        arguments = workspace,
    })
    if e then
        print(vim.inspect(e))
        return nil
    else
        return projects
    end
end

function M.getProjectUris() end

function M.refreshLibraries() end

function M.getPackageData(arguments)
    local e, packages = execute_command({
        command = COMMANDS.JAVA_PROJECT_LIST,
        arguments = arguments,
    })
    if e then
        print(vim.inspect(e))
    else
        return packages
    end
end

function M.resolvePath() end

function M.getMainClasses() end

function M.exportJar() end

function M.getWorkspaces()
    local clients = vim.lsp.get_active_clients()

    for _, c in pairs(clients) do
        if c.name == "jdtls" then
            return vim.uri_from_fname(c.config.root_dir)
        end
    end
end

return setmetatable({}, {
    __index = function(_, key)
        return function(...)
            if key ~= "getWorkspaces" then
                assert(
                    coroutine.running(),
                    "function java-project-manager.jdtls." .. key .. " must be called in coroutine"
                )
            end
            return M[key](...)
        end
    end,
})
