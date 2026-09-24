-- Ensure secure execution environment
getgenv().SecureMode = true
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Configuration State Table
getgenv().OperationConfig = {
    -- Silent Aim / Bullet TP
    SilentAimEnabled = false,
    SilentFOV = 150,
    HitPartOption = "Head", -- "Head" or "HumanoidRootPart"
    TeamCheck = true,
    
    -- Visuals / ESP
    BoxESP = false,
    NameESP = false,
    ModFOV = false,
    CustomFOV = 90,
    
    -- Character Mods
    Noclip = false,
    SpeedEnabled = false,
    CustomSpeed = 16,
}

-- ESP Storage Table for cleanup
local ESPDrawingCache = {}

-- Create Rayfield Window Interface
local Window = Rayfield:CreateWindow({
    Name = "OPERATION: ONE | TTK & Hardpoint Suite",
    LoadingTitle = "Loading Advanced Modules...",
    LoadingSubtitle = "by p7zu",
    Theme = "DarkBlue",
    
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "OperationOneConfigs",
        FileName = "HardpointConfigV3"
    },
    KeySystem = false,
})

-- Tabs
local CombatTab = Window:CreateTab("Combat & Silent", "crosshair")
local VisualsTab = Window:CreateTab("Visuals & ESP", "eye")
local MiscTab = Window:CreateTab("Player & Misc", "sliders")

----------------------------------------------------------------
-- COMBAT TAB (Silent Aim / Bullet TP)
----------------------------------------------------------------
CombatTab:CreateSection("Silent Aim / Bullet Teleport")

CombatTab:CreateToggle({
    Name = "Enable Silent Aim",
    CurrentValue = false,
    Flag = "SilentToggle",
    Callback = function(Value)
        getgenv().OperationConfig.SilentAimEnabled = Value
    end,
})

CombatTab:CreateSlider({
    Name = "Silent Aim FOV Radius",
    Range = {30, 400},
    Increment = 5,
    Suffix = "px",
    CurrentValue = 150,
    Flag = "SilentFOV",
    Callback = function(Value)
        getgenv().OperationConfig.SilentFOV = Value
    end,
})

CombatTab:CreateDropdown({
    Name = "Target Hitpart",
    Options = {"Head", "HumanoidRootPart"},
    CurrentOption = "Head",
    Flag = "HitPartDropdown",
    Callback = function(Option)
        getgenv().OperationConfig.HitPartOption = Option[1] or Option
    end,
})

CombatTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Flag = "TeamCheck",
    Callback = function(Value)
        getgenv().OperationConfig.TeamCheck = Value
    end,
})

----------------------------------------------------------------
-- VISUALS TAB
----------------------------------------------------------------
VisualsTab:CreateSection("ESP Suite")

VisualsTab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = false,
    Flag = "BoxESP",
    Callback = function(Value)
        getgenv().OperationConfig.BoxESP = Value
        if not Value then
            for _, cache in pairs(ESPDrawingCache) do
                if cache.Box then cache.Box.Visible = false end
            end
        end
    end,
})

VisualsTab:CreateToggle({
    Name = "Name & Health ESP",
    CurrentValue = false,
    Flag = "NameESP",
    Callback = function(Value)
        getgenv().OperationConfig.NameESP = Value
        if not Value then
            for _, cache in pairs(ESPDrawingCache) do
                if cache.Name then cache.Name.Visible = false end
            end
        end
    end,
})

VisualsTab:CreateSection("Camera Settings")

VisualsTab:CreateToggle({
    Name = "Custom Field of View",
    CurrentValue = false,
    Flag = "ModFOV",
    Callback = function(Value)
        getgenv().OperationConfig.ModFOV = Value
        if not Value then
            Camera.FieldOfView = 70
        end
    end,
})

VisualsTab:CreateSlider({
    Name = "Target FOV Value",
    Range = {70, 120},
    Increment = 1,
    Suffix = "°",
    CurrentValue = 90,
    Flag = "CustomFOV",
    Callback = function(Value)
        getgenv().OperationConfig.CustomFOV = Value
    end,
})

----------------------------------------------------------------
-- MISC TAB
----------------------------------------------------------------
MiscTab:CreateSection("Character Enhancements")

MiscTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        getgenv().OperationConfig.Noclip = Value
    end,
})

MiscTab:CreateToggle({
    Name = "Custom WalkSpeed",
    CurrentValue = false,
    Flag = "SpeedToggle",
    Callback = function(Value)
        getgenv().OperationConfig.SpeedEnabled = Value
    end,
})

MiscTab:CreateSlider({
    Name = "WalkSpeed Value",
    Range = {16, 100},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 16,
    Flag = "SpeedVal",
    Callback = function(Value)
        getgenv().OperationConfig.CustomSpeed = Value
    end,
})

MiscTab:CreateSection("Teleportations")

-- Dynamic Player List Dropdown Generator
local playerList = {}
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then table.insert(playerList, p.Name) end
end

Players.PlayerAdded:Connect(function(p)
    table.insert(playerList, p.Name)
end)
Players.PlayerRemoving:Connect(function(p)
    for i, name in ipairs(playerList) do
        if name == p.Name then table.remove(playerList, i) end
    end
end)

local selectedTargetPlayer = nil
MiscTab:CreateDropdown({
    Name = "Select Target Player",
    Options = playerList,
    CurrentOption = "",
    Flag = "TPDropdown",
    Callback = function(Option)
        selectedTargetPlayer = Option[1] or Option
    end,
})

MiscTab:CreateButton({
    Name = "Teleport to Selected Player",
    Callback = function()
        if selectedTargetPlayer then
            local targetObj = Players:FindFirstChild(selectedTargetPlayer)
            if targetObj and targetObj.Character and targetObj.Character:FindFirstChild("HumanoidRootPart") then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetObj.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    Rayfield:Notify({Title = "Teleport", Content = "Successfully teleported to " .. selectedTargetPlayer, Duration = 2})
                end
            else
                Rayfield:Notify({Title = "Teleport", Content = "Target player character not found.", Duration = 2})
            end
        else
            Rayfield:Notify({Title = "Teleport", Content = "No player selected.", Duration = 2})
        end
    end,
})

MiscTab:CreateButton({
    Name = "Teleport to Hardpoint/Zone Object",
    Callback = function()
        local found = false
        for _, obj in ipairs(Workspace:GetDescendants()) do
            local nameLower = obj.Name:lower()
            if (nameLower:find("hardpoint") or nameLower:find("zone") or nameLower:find("capture") or nameLower:find("hill")) and obj:IsA("BasePart") then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                    Rayfield:Notify({Title = "Utility", Content = "Teleported to zone successfully.", Duration = 2})
                    found = true
                    break
                end
            end
        end
        if not found then
            Rayfield:Notify({Title = "Utility", Content = "No objective parts detected in current workspace.", Duration = 2})
        end
    end,
})

----------------------------------------------------------------
-- BACKEND ENGINE & SILENT AIM REDIRECTION
----------------------------------------------------------------

-- Function to find closest target inside silent aim FOV
local function GetSilentTarget()
    local target = nil
    local shortestDistance = getgenv().OperationConfig.SilentFOV
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local allowTarget = true
            if getgenv().OperationConfig.TeamCheck then
                if player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                    allowTarget = false
                end
            end
            
            if allowTarget then
                local character = player.Character
                if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
                    local targetPart = character:FindFirstChild(getgenv().OperationConfig.HitPartOption) or character:FindFirstChild("HumanoidRootPart")
                    if targetPart then
                        local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                target = targetPart
                            end
                        end
                    end
                end
            end
        end
    end
    return target
end

-- Hook into Raycasting/Bullet pathing globally if supported, or provide mouse redirection hook
local oldIndex = nil
oldIndex = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if getgenv().OperationConfig.SilentAimEnabled and (method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList" or method == "Raycast") then
        local targetPart = GetSilentTarget()
        if targetPart then
            -- Redirect ray vector/origin logic toward the chosen target bodypart
            if method == "Raycast" and args[2] then
                args[2] = (targetPart.Position - args[1]).Unit * 1000
            end
        end
    end
    
    return oldIndex(self, unpack(args))
end))

-- ESP Drawing Setup
local function GetESP(player)
    if ESPDrawingCache[player] then return ESPDrawingCache[player] end
    
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(0, 150, 255)
    box.Thickness = 1.5
    box.Filled = false

    local nameTag = Drawing.new("Text")
    nameTag.Visible = false
    nameTag.Color = Color3.fromRGB(255, 255, 255)
    nameTag.Size = 14
    nameTag.Center = true
    nameTag.Outline = true

    ESPDrawingCache[player] = {Box = box, Name = nameTag}
    return ESPDrawingCache[player]
end

-- Main RenderLoop
RunService.RenderStepped:Connect(function()
    if getgenv().OperationConfig.ModFOV then
        Camera.FieldOfView = getgenv().OperationConfig.CustomFOV
    end

    -- ESP Loop
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local esp = GetESP(player)
            local character = player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChild("Humanoid")

            local shouldShow = false
            if player.Team ~= LocalPlayer.Team or not getgenv().OperationConfig.TeamCheck then
                shouldShow = true
            end

            if character and rootPart and humanoid and humanoid.Health > 0 and shouldShow then
                local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    if getgenv().OperationConfig.BoxESP then
                        local sizeFactor = math.clamp(1000 / (Camera.CFrame.Position - rootPart.Position).Magnitude, 20, 300)
                        esp.Box.Size = Vector2.new(sizeFactor * 0.75, sizeFactor)
                        esp.Box.Position = Vector2.new(pos.X - esp.Box.Size.X / 2, pos.Y - esp.Box.Size.Y / 2)
                        esp.Box.Visible = true
                    else
                        esp.Box.Visible = false
                    end

                    if getgenv().OperationConfig.NameESP then
                        esp.Name.Text = player.Name .. " [" .. math.floor(humanoid.Health) .. "HP]"
                        esp.Name.Position = Vector2.new(pos.X, pos.Y - (esp.Box.Size.Y / 2) - 18)
                        esp.Name.Visible = true
                    else
                        esp.Name.Visible = false
                    end
                else
                    esp.Box.Visible = false
                    esp.Name.Visible = false
                end
            else
                esp.Box.Visible = false
                esp.Name.Visible = false
            end
        end
    end
end)

-- Character specific modifiers (Speed & Noclip)
RunService.Stepped:Connect(function()
    local character = LocalPlayer.Character
    if character then
        if getgenv().OperationConfig.SpeedEnabled then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = getgenv().OperationConfig.CustomSpeed
            end
        end

        if getgenv().OperationConfig.Noclip then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPDrawingCache[player] then
        if ESPDrawingCache[player].Box then ESPDrawingCache[player].Box:Remove() end
        if ESPDrawingCache[player].Name then ESPDrawingCache[player].Name:Remove() end
        ESPDrawingCache[player] = nil
    end
end)

Rayfield:LoadConfiguration()
