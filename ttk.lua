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
    AimbotEnabled = false,
    AimbotFOV = 120,
    Smoothness = 2,
    TeamCheck = true,
    
    BoxESP = false,
    ModFOV = false,
    CustomFOV = 90,
}

-- Create Rayfield Window Interface
local Window = Rayfield:CreateWindow({
    Name = "OPERATION: ONE | TTK & Hardpoint Suite",
    LoadingTitle = "Loading Combat Modules...",
    LoadingSubtitle = "by p7zu",
    Theme = "DarkBlue",
    
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "OperationOneConfigs",
        FileName = "HardpointConfig"
    },
    KeySystem = false,
})

-- Tabs
local CombatTab = Window:CreateTab("Combat & Rage", "crosshair")
local VisualsTab = Window:CreateTab("Visuals", "eye")
local MiscTab = Window:CreateTab("Hardpoint Utils", "sliders")

----------------------------------------------------------------
-- COMBAT TAB
----------------------------------------------------------------
CombatTab:CreateSection("Rage / Target Lock")

CombatTab:CreateToggle({
    Name = "Enable Assist / Lock",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(Value)
        getgenv().OperationConfig.AimbotEnabled = Value
    end,
})

CombatTab:CreateSlider({
    Name = "FOV Radius",
    Range = {30, 300},
    Increment = 5,
    Suffix = "px",
    CurrentValue = 120,
    Flag = "AimbotFOV",
    Callback = function(Value)
        getgenv().OperationConfig.AimbotFOV = Value
    end,
})

CombatTab:CreateSlider({
    Name = "Smoothing / Lock Speed",
    Range = {1, 10},
    Increment = 1,
    Suffix = "",
    CurrentValue = 2,
    Flag = "Smoothness",
    Callback = function(Value)
        getgenv().OperationConfig.Smoothness = Value
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
VisualsTab:CreateSection("Camera Settings")

VisualsTab:CreateToggle({
    Name = "Custom Field of View",
    CurrentValue = false,
    Flag = "ModFOV",
    Callback = function(Value)
        getgenv().OperationConfig.ModFOV = Value
        if not Value then
            Camera.FieldOfView = 70 -- Reset to default Roblox FOV
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
MiscTab:CreateSection("Match Utility")

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
-- BACKEND ENGINE LOOPS
----------------------------------------------------------------

local function GetClosestTarget()
    local target = nil
    local shortestDistance = getgenv().OperationConfig.AimbotFOV
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
                    local rootPart = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        local screenPoint, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                        if onScreen then
                            local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                target = rootPart
                            end
                        end
                    end
                end
            end
        end
    end
    return target
end

-- Connect execution logic cleanly to RenderStepped
RunService.RenderStepped:Connect(function()
    -- Handle FOV overrides safely
    if getgenv().OperationConfig.ModFOV then
        Camera.FieldOfView = getgenv().OperationConfig.CustomFOV
    end

    -- Handle Combat Lock
    if getgenv().OperationConfig.AimbotEnabled then
        local targetPart = GetClosestTarget()
        if targetPart then
            local camPos = Camera.CFrame.Position
            local targetPos = targetPart.Position
            local smoothVal = math.max(1, getgenv().OperationConfig.Smoothness)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(camPos, targetPos), 1 / smoothVal)
        end
    end
end)

-- Initialize configuration persistence state
Rayfield:LoadConfiguration()
