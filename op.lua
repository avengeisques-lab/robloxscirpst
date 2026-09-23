-- Rayfield UI Library Integration for Operation One
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Configuration Table
getgenv().RageSettings = {
    ESPEnabled = false,
    BoxESP = false,
    NameESP = false,
    FOV = 120,
    FOVEnabled = false,
    Triggerbot = false,
    NoRecoil = false
}

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "Operation One | Tactical Suite",
    Icon = 0,
    LoadingTitle = "Initializing Rage System",
    LoadingSubtitle = "by p7zu",
    Theme = "Default", 
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "OperationOneHub",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Tabs
local CombatTab = Window:CreateTab("Combat & Rage", "crosshair")
local VisualsTab = Window:CreateTab("Visuals (ESP)", "eye")
local MiscTab = Window:CreateTab("Settings", "settings")

--- COMBAT / RAGE TAB ---
CombatTab:CreateSection("Aimbot & Assists")

CombatTab:CreateToggle({
    Name = "Triggerbot",
    CurrentValue = false,
    Flag = "TriggerbotFlag",
    Callback = function(Value)
        getgenv().RageSettings.Triggerbot = Value
    end,
})

CombatTab:CreateToggle({
    Name = "FOV Circle Visible",
    CurrentValue = false,
    Flag = "FOVToggle",
    Callback = function(Value)
        getgenv().RageSettings.FOVEnabled = Value
    end,
})

CombatTab:CreateSlider({
    Name = "FOV Radius",
    Range = {30, 400},
    Increment = 5,
    Suffix = "px",
    CurrentValue = 120,
    Flag = "FOVSlider",
    Callback = function(Value)
        getgenv().RageSettings.FOV = Value
    end,
})

CombatTab:CreateSection("Weapon Modifiers")

CombatTab:CreateToggle({
    Name = "Remove Recoil / Spread (Visual)",
    CurrentValue = false,
    Flag = "RecoilFlag",
    Callback = function(Value)
        getgenv().RageSettings.NoRecoil = Value
    end,
})

--- VISUALS TAB ---
VisualsTab:CreateSection("Player ESP")

VisualsTab:CreateToggle({
    Name = "Enable ESP Suite",
    CurrentValue = false,
    Flag = "ESPFlag",
    Callback = function(Value)
        getgenv().RageSettings.ESPEnabled = Value
    end,
})

VisualsTab:CreateToggle({
    Name = "Name Tags",
    CurrentValue = false,
    Flag = "NameESPFlag",
    Callback = function(Value)
        getgenv().RageSettings.NameESP = Value
    end,
})

--- LOGIC LOOPS ---

-- FOV Drawing
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Transparency = 0.7
FOVCircle.Color = Color3.fromRGB(255, 255, 255)

RunService.RenderStepped:Connect(function()
    -- Update FOV Circle
    if getgenv().RageSettings.FOVEnabled then
        FOVCircle.Visible = true
        FOVCircle.Radius = getgenv().RageSettings.FOV
        FOVCircle.Position = UserInputService:GetMouseLocation()
    else
        FOVCircle.Visible = false
    end

    -- Simple Triggerbot implementation checking mouse target
    if getgenv().RageSettings.Triggerbot then
        local target = LocalPlayer:GetMouse().Target
        if target and target.Parent then
            local enemyPlayer = Players:GetPlayerFromCharacter(target.Parent)
            if enemyPlayer and enemyPlayer ~= LocalPlayer then
                if enemyPlayer.Team ~= LocalPlayer.Team then
                    mouse1click()
                    task.wait(0.1)
                end
            end
        end
    end
end)

Rayfield:Notify({
    Title = "Operation One Loaded",
    Content = "Rayfield interface suite successfully active.",
    Duration = 5,
    Image = 4483362458,
})
