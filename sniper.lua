-- Ensure safety check for execution environment
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Configuration Variables
getgenv().SniperConfig = {
    SilentAimEnabled = false,
    HitPart = "Head",
    Prediction = 0.135,
    FOVSize = 150,
    FOVVisible = true,
    FOVColor = Color3.fromRGB(255, 0, 0),
    
    TriggerBotEnabled = false,
    TriggerDelay = 0.01,
    
    ESPEnabled = false,
    BoxESP = true,
    NameESP = true,
    ESPColor = Color3.fromRGB(255, 255, 255),
    
    FOVTransparency = 0.7
}

-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "⚡ Sniper Duels | Rage Suite",
    Icon = 0,
    LoadingTitle = "Initializing Rage Framework",
    LoadingSubtitle = "by p7zu",
    Theme = "Default", 
    DisableRayfieldPrompts = false,
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "SniperDuelsConfig"
    },
    KeySystem = false
})

-- Create Tabs
local CombatTab = Window:CreateTab("Rage & Combat", "crosshair")
local VisualsTab = Window:CreateTab("Visuals & ESP", "eye")
local MiscTab = Window:CreateTab("Settings / Misc", "settings")

-- FOV Circle Drawing
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = getgenv().SniperConfig.FOVVisible
FOVCircle.Radius = getgenv().SniperConfig.FOVSize
FOVCircle.Color = getgenv().SniperConfig.FOVColor
FOVCircle.Thickness = 1.5
FOVCircle.Filled = false
FOVCircle.Transparency = getgenv().SniperConfig.FOVTransparency

RunService.RenderStepped:Connect(function()
    local mouseLoc = UserInputService:GetMouseLocation()
    FOVCircle.Position = mouseLoc
    FOVCircle.Visible = getgenv().SniperConfig.FOVVisible
    FOVCircle.Radius = getgenv().SniperConfig.FOVSize
    FOVCircle.Color = getgenv().SniperConfig.FOVColor
end)

-- Function: Get Closest Target to Mouse within FOV
local function GetClosestPlayer()
    local target = nil
    local shortestDist = getgenv().SniperConfig.FOVSize
    local mouseLoc = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local hitPart = player.Character:FindFirstChild(getgenv().SniperConfig.HitPart)
            if hitPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(hitPart.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mouseLoc).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        target = player
                    end
                end
            end
        end
    end
    return target
end

-- Combat Tab Elements
CombatTab:CreateSection("Silent Aim")

CombatTab:CreateToggle({
    Name = "Enable Silent Aim",
    CurrentValue = false,
    Flag = "SilentAimToggle",
    Callback = function(Value)
        getgenv().SniperConfig.SilentAimEnabled = Value
    end,
})

CombatTab:CreateDropdown({
    Name = "Target HitPart",
    Options = {"Head", "HumanoidRootPart", "UpperTorso"},
    CurrentOption = "Head",
    Flag = "HitPartDropdown",
    Callback = function(Option)
        getgenv().SniperConfig.HitPart = Option[1]
    end,
})

CombatTab:CreateSlider({
    Name = "FOV Radius",
    Range = {50, 400},
    Increment = 5,
    Suffix = "px",
    CurrentValue = 150,
    Flag = "FOVSizeSlider",
    Callback = function(Value)
        getgenv().SniperConfig.FOVSize = Value
    end,
})

CombatTab:CreateSlider({
    Name = "Prediction Amount",
    Range = {0, 0.5},
    Increment = 0.005,
    Suffix = "s",
    CurrentValue = 0.135,
    Flag = "PredSlider",
    Callback = function(Value)
        getgenv().SniperConfig.Prediction = Value
    end,
})

CombatTab:CreateSection("Triggerbot")

CombatTab:CreateToggle({
    Name = "Auto-Fire Triggerbot",
    CurrentValue = false,
    Flag = "TriggerToggle",
    Callback = function(Value)
        getgenv().SniperConfig.TriggerBotEnabled = Value
    end,
})

-- Hooking Metatable for Silent Aim Redirection
local oldIndex
oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, index)
    if getgenv().SniperConfig.SilentAimEnabled and not checkcaller() then
        if self == Camera and index == "CFrame" then
            local target = GetClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild(getgenv().SniperConfig.HitPart) then
                local part = target.Character[getgenv().SniperConfig.HitPart]
                local predictedPos = part.Position + (part.AssemblyLinearVelocity * getgenv().SniperConfig.Prediction)
                return CFrame.new(Camera.CFrame.Position, predictedPos)
            end
        end
    end
    return oldIndex(self, index)
end))

-- Triggerbot Execution Loop
task.spawn(function()
    while true do
        task.wait(0.005)
        if getgenv().SniperConfig.TriggerBotEnabled then
            local mouse = LocalPlayer:GetMouse()
            local target = mouse.Target
            if target and target.Parent then
                local enemyPlayer = Players:GetPlayerFromCharacter(target.Parent)
                if enemyPlayer and enemyPlayer ~= LocalPlayer then
                    task.wait(getgenv().SniperConfig.TriggerDelay)
                    mouse1click()
                end
            end
        end
    end
end)

-- Visuals Tab Elements
VisualsTab:CreateSection("ESP Configurations")

VisualsTab:CreateToggle({
    Name = "Enable Visual ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(Value)
        getgenv().SniperConfig.ESPEnabled = Value
    end,
})

VisualsTab:CreateColorPicker({
    Name = "ESP Line / Box Color",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "ESPColorPicker",
    Callback = function(Value)
        getgenv().SniperConfig.ESPColor = Value
    end,
})

-- Simple ESP Implementation loop
local espCache = {}

RunService.RenderStepped:Connect(function()
    if not getgenv().SniperConfig.ESPEnabled then
        for _, drawings in pairs(espCache) do
            for _, drawObj in pairs(drawings) do
                drawObj.Visible = false
            end
        end
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not espCache[player] then
                espCache[player] = {
                    Box = Drawing.new("Square"),
                    Name = Drawing.new("Text")
                }
                espCache[player].Box.Filled = false
                espCache[player].Box.Thickness = 1
                espCache[player].Name.Size = 14
                espCache[player].Name.Center = true
                espCache[player].Name.Outline = true
            end

            local cache = espCache[player]
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local rootPart = char.HumanoidRootPart
                local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

                if onScreen then
                    local head = char:FindFirstChild("Head")
                    local topVector = head and Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)) or vector
                    local legVector = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
                    
                    local height = math.abs(topVector.Y - legVector.Y)
                    local width = height / 2

                    cache.Box.Size = Vector2.new(width, height)
                    cache.Box.Position = Vector2.new(vector.X - width / 2, topVector.Y)
                    cache.Box.Color = getgenv().SniperConfig.ESPColor
                    cache.Box.Visible = getgenv().SniperConfig.BoxESP

                    cache.Name.Text = player.Name
                    cache.Name.Position = Vector2.new(vector.X, topVector.Y - 18)
                    cache.Name.Color = getgenv().SniperConfig.ESPColor
                    cache.Name.Visible = getgenv().SniperConfig.NameESP
                else
                    cache.Box.Visible = false
                    cache.Name.Visible = false
                end
            else
                cache.Box.Visible = false
                cache.Name.Visible = false
            end
        end
    end
end)

-- Misc Tab Elements
MiscTab:CreateSection("Interface Controls")

MiscTab:CreateButton({
    Name = "Unload UI & Cleanup",
    Callback = function()
        FOVCircle:Remove()
        for _, drawings in pairs(espCache) do
            for _, drawObj in pairs(drawings) do
                drawObj:Remove()
            end
        end
        Rayfield:Destroy()
    end,
})

Rayfield:Notify({
    Title = "Rage Script Loaded",
    Content = "Sniper Duels utility initialized successfully.",
    Duration = 5,
    Image = "check",
})
