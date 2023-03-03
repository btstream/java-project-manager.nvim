local M = {}

-- stylua: ignore start
M.NodeKind      = {
    Workspace   = 1,
    Project     = 2,
    Container   = 3,
    PackageRoot = 4,
    Package     = 5,
    PrimaryType = 6,
    Folder      = 7,
    File        = 8,
}

M.TypeKind    = {
    Class     = 1,
    Interface = 2,
    Enum      = 3,
}

M.ContainerEntryKind = {
    CPE_LIBRARY      = 1,
    CPE_PROJECT      = 2,
    CPE_SOURCE       = 3,
    CPE_VARIABLE     = 4,
    CPE_CONTAINER    = 5,
}

M.PackageRootKind = {
    K_SOURCE      = 1,
    K_BINARY      = 2
}
-- stylua: ignore end

return M
