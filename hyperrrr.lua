-- Ensure the environment supports Rayfield and Drawing API
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Configuration Variables
getgenv().Config = {
    AimbotEnabled = false,
    AimbotKey = Enum.UserInputType.MouseButton2, -- Right Click
    AimbotSmoothness = 5,
    AimPart = "Head",
    
    FOVEnabled = true,
    FOVRadius = 120,
    FOVColor = Color3.fromRGB(255, 255, 255),
    
    ESPEnabled = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
    
    SpeedEnabled = false,
    SpeedMultiplier = 24,
    
    JumpEnabled = false,
    JumpPower = 50
}

-- Create FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Transparency = 0.7
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Filled = false

-- Rayfield Window Setup
local Window = Rayfield:CreateWindow({
   Name = "Combat & Utility Suite",
   LoadingTitle = "Initializing Systems...",
   LoadingSubtitle = "p7zu framework",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "RayfieldConfig",
      FileName = "MainConfig"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvite",
      RememberJoins = true
   },
   KeySystem = false,
})

-- Tabs
local CombatTab = Window:CreateTab("Combat", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local MovementTab = Window:CreateTab("Movement", 4483362458)

------------------------------------------------------------------------
-- COMBAT / RAGE TAB
------------------------------------------------------------------------
CombatTab:CreateSection("Aimbot / Rage")

CombatTab:CreateToggle({
   Name = "Enable Aimbot",
   CurrentValue = false,
   Flag = "AimbotToggle",
   Callback = function(Value)
      getgenv().Config.AimbotEnabled = Value
   end,
})

CombatTab:CreateDropdown({
   Name = "Target Hitbox",
   Options = {"Head", "HumanoidRootPart"},
   CurrentOption = "Head",
   Flag = "AimPartDropdown",
   Callback = function(Option)
      getgenv().Config.AimPart = Option[1]
   end,
})

CombatTab:CreateSlider({
   Name = "Smoothing",
   Range = {1, 20},
   Increment = 1,
   Suffix = "factor",
   CurrentValue = 5,
   Flag = "SmoothnessSlider",
   Callback = function(Value)
      getgenv().Config.AimbotSmoothness = Value
   end,
})

CombatTab:CreateSection("Field of View")

CombatTab:CreateToggle({
   Name = "Show FOV Circle",
   CurrentValue = false,
   Flag = "FOVToggle",
   Callback = function(Value)
      getgenv().Config.FOVEnabled = Value
      FOVCircle.Visible = Value
   end,
})

CombatTab:CreateSlider({
   Name = "FOV Radius",
   Range = {30, 400},
   Increment = 5,
   Suffix = "px",
   CurrentValue = 120,
   Flag = "FOVRadiusSlider",
   Callback = function(Value)
      getgenv().Config.FOVRadius = Value
      FOVCircle.Radius = Value
   end,
})

------------------------------------------------------------------------
-- VISUALS TAB (ESP)
------------------------------------------------------------------------
VisualsTab:CreateSection("Player ESP")

VisualsTab:CreateToggle({
   Name = "Highlight ESP",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(Value)
      getgenv().Config.ESPEnabled = Value
   end,
})

------------------------------------------------------------------------
-- MOVEMENT TAB
------------------------------------------------------------------------
MovementTab:CreateSection("Character Modifiers")

MovementTab:CreateToggle({
   Name = "Custom WalkSpeed",
   CurrentValue = false,
   Flag = "SpeedToggle",
   Callback = function(Value)
      getgenv().Config.SpeedEnabled = Value
   end,
})

MovementTab:CreateSlider({
   Name = "WalkSpeed Value",
   Range = {16, 100},
   Increment = 1,
   Suffix = "studs",
   CurrentValue = 24,
   Flag = "SpeedSlider",
   Callback = function(Value)
      getgenv().Config.SpeedMultiplier = Value
   end,
})

MovementTab:CreateToggle({
   Name = "Custom JumpPower",
   CurrentValue = false,
   Flag = "JumpToggle",
   Callback = function(Value)
      getgenv().Config.JumpEnabled = Value
   end,
})

MovementTab:CreateSlider({
   Name = "JumpPower Value",
   Range = {50, 200},
   Increment = 5,
   Suffix = "power",
   CurrentValue = 50,
   Flag = "JumpSlider",
   Callback = function(Value)
      getgenv().Config.JumpPower = Value
   end,
})

------------------------------------------------------------------------
-- CORE EXECUTION LOOPS
------------------------------------------------------------------------

-- Get closest player to crosshair within FOV
local function getClosestPlayer()
    local target = nil
    local shortestDist = getgenv().Config.FOVRadius

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local part = player.Character:FindFirstChild(getgenv().Config.AimPart)
            if part then
                local screenPoint, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        target = part
                    end
                end
            end
        end
    end
    return target
end

-- Main RenderLoop for Aimbot, FOV, and Movement
RunService.RenderStepped:Connect(function()
    -- Update FOV Circle Position
    if getgenv().Config.FOVEnabled then
        local mousePos = UserInputService:GetMouseLocation()
        FOVCircle.Position = mousePos
        FOVCircle.Color = getgenv().Config.FOVColor
    end

    -- Handle Aimbot / Rage Lock-on
    if getgenv().Config.AimbotEnabled and UserInputService:IsMouseButtonPressed(getgenv().Config.AimbotKey) then
        local targetPart = getClosestPlayer()
        if targetPart then
            local currentCFrame = Camera.CFrame
            local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
            Camera.CFrame = currentCFrame:Lerp(targetCFrame, 1 / math.max(getgenv().Config.AimbotSmoothness, 1))
        end
    end

    -- Handle Movement Overrides
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        if getgenv().Config.SpeedEnabled then
            humanoid.WalkSpeed = getgenv().Config.SpeedMultiplier
        end
        if getgenv().Config.JumpEnabled then
            humanoid.JumpPower = getgenv().Config.JumpPower
        end
    end
end)

-- Dynamic ESP Management loop
Task.spawn(function()
    while true do
        task.wait(1)
        if getgenv().Config.ESPEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local char = player.Character
                    if not char:FindFirstChild("HighlightESP") then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "HighlightESP"
                        highlight.Adornee = char
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.5
                        highlight.Parent = char
                    end
                end
            end
        else
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("HighlightESP") then
                    player.Character.HighlightESP:Destroy()
                end
            end
        end
    end
end)

Rayfield:LoadConfiguration()
