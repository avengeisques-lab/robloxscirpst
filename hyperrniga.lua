-- Ensure environment support & robust loadstring execution
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then
    warn("Failed to load Rayfield UI library. Check your executor's internet/HttpGet capabilities.")
    return
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Configuration Variables
getgenv().Config = {
    SilentEnabled = false,
    Hitbox = "Head",
    
    FOVEnabled = true,
    FOVRadius = 150,
    FOVColor = Color3.fromRGB(255, 255, 255),
    
    ESPEnabled = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
    
    SpeedEnabled = false,
    SpeedMultiplier = 24,
    
    JumpEnabled = false,
    JumpPower = 50
}

-- Create FOV Circle safely using Drawing API
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Transparency = 0.7
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Filled = false

-- Rayfield Window Setup with explicit Keybind and Visibility controls
local Window = Rayfield:CreateWindow({
   Name = "Combat & Utility Suite [v3]",
   LoadingTitle = "Initializing Systems...",
   LoadingSubtitle = "p7zu framework",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "RayfieldConfig",
      FileName = "SilentConfigV3"
   },
   KeySystem = false,
})

-- Tabs
local CombatTab = Window:CreateTab("Combat", "crosshair")
local VisualsTab = Window:CreateTab("Visuals", "eye")
local MovementTab = Window:CreateTab("Movement", "activity")

------------------------------------------------------------------------
-- COMBAT / SILENT TAB
------------------------------------------------------------------------
CombatTab:CreateSection("Silent Aim")

CombatTab:CreateToggle({
   Name = "Enable Silent Aim",
   CurrentValue = false,
   Flag = "SilentToggle",
   Callback = function(Value)
      getgenv().Config.SilentEnabled = Value
   end,
})

CombatTab:CreateDropdown({
   Name = "Target Hitbox",
   Options = {"Head", "HumanoidRootPart"},
   CurrentOption = "Head",
   Flag = "AimPartDropdown",
   Callback = function(Option)
      getgenv().Config.Hitbox = Option[1]
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
   Range = {50, 500},
   Increment = 5,
   Suffix = "px",
   CurrentValue = 150,
   Flag = "FOVRadiusSlider",
   Callback = function(Value)
      getgenv().Config.FOVRadius = Value
      FOVCircle.Radius = Value
   end,
})

------------------------------------------------------------------------
-- VISUALS TAB
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
-- CORE SILENT & GAME LOGIC
------------------------------------------------------------------------

local function getClosestTarget()
    local target = nil
    local shortestDist = getgenv().Config.FOVRadius

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local part = player.Character:FindFirstChild(getgenv().Config.Hitbox)
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

-- Safely hook namecall if supported by executor environment
if hookmetamethod and getnamecallmethod then
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        
        if getgenv().Config.SilentEnabled and not checkcaller() then
            if method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRayWithWhitelist" then
                local targetPart = getClosestTarget()
                if targetPart then
                    local ray = args[1]
                    if typeof(ray) == "Ray" then
                        local origin = ray.Origin
                        local direction = (targetPart.Position - origin).Unit * ray.Direction.Magnitude
                        args[1] = Ray.new(origin, direction)
                        return oldNamecall(self, unpack(args))
                    end
                end
            end
        end
        
        return oldNamecall(self, ...)
    end)
end

-- Render loop for FOV updates and Movement modifiers
RunService.RenderStepped:Connect(function()
    if getgenv().Config.FOVEnabled then
        FOVCircle.Position = UserInputService:GetMouseLocation()
        FOVCircle.Color = getgenv().Config.FOVColor
    end

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

-- Dynamic ESP Loop
task.spawn(function()
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
