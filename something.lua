-- Operation One Functional Tactical Suite
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

getgenv().OpOneSettings = {
    ESPEnabled = false,
    FOV = 120,
    FOVEnabled = false,
    Triggerbot = false
}

local Window = Rayfield:CreateWindow({
    Name = "Operation One | Direct Hook Suite",
    LoadingTitle = "Loading Core Systems...",
    LoadingSubtitle = "by p7zu",
    Theme = "Default",
    ConfigurationSaving = { Enabled = true, FolderName = "OpOneCore", FileName = "Settings" },
    KeySystem = false,
})

local CombatTab = Window:CreateTab("Combat", "crosshair")
local VisualsTab = Window:CreateTab("Visuals", "eye")

CombatTab:CreateToggle({
    Name = "Active Triggerbot",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().OpOneSettings.Triggerbot = Value
    end,
})

CombatTab:CreateToggle({
    Name = "FOV Circle",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().OpOneSettings.FOVEnabled = Value
    end,
})

CombatTab:CreateSlider({
    Name = "FOV Radius",
    Range = {30, 400},
    Increment = 5,
    Suffix = "px",
    CurrentValue = 120,
    Callback = function(Value)
        getgenv().OpOneSettings.FOV = Value
    end,
})

VisualsTab:CreateToggle({
    Name = "Player Box / Highlight ESP",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().OpOneSettings.ESPEnabled = Value
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local highlight = p.Character:FindFirstChild("OpOneHighlight")
                if Value and not highlight then
                    local hl = Instance.new("Highlight")
                    hl.Name = "OpOneHighlight"
                    hl.Adornee = p.Character
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.Parent = p.Character
                elseif not Value and highlight then
                    highlight:Destroy()
                end
            end
        end
    end,
})

-- FOV Ring Drawing
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Transparency = 0.7
FOVCircle.Color = Color3.fromRGB(255, 255, 255)

RunService.RenderStepped:Connect(function()
    if getgenv().OpOneSettings.FOVEnabled then
        FOVCircle.Visible = true
        FOVCircle.Radius = getgenv().OpOneSettings.FOV
        FOVCircle.Position = UserInputService:GetMouseLocation()
    else
        FOVCircle.Visible = false
    end

    -- Direct Tool Activation Triggerbot Loop
    if getgenv().OpOneSettings.Triggerbot then
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Target
        if target and target.Parent then
            local enemyModel = target.Parent:FindFirstChild("Humanoid")
            local enemyPlayer = Players:GetPlayerFromCharacter(target.Parent)
            if enemyModel and enemyPlayer and enemyPlayer ~= LocalPlayer then
                if enemyPlayer.Team ~= LocalPlayer.Team then
                    local char = LocalPlayer.Character
                    if char then
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then
                            tool:Activate()
                        end
                    end
                end
            end
        end
    end
end)

Rayfield:Notify({
    Title = "Injected Successfully",
    Content = "Operation One system hooks are now active.",
    Duration = 4,
})
