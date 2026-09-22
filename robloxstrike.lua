-- BloxStrike Script with Rayfield UI
-- Features: Aimbot, ESP, Visual Effects, and more

print("BloxStrike: Starting script...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

-- Wait for player to load
if not Players.LocalPlayer then
    print("BloxStrike: Waiting for LocalPlayer...")
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
end

local LocalPlayer = Players.LocalPlayer
print("BloxStrike: LocalPlayer found: " .. LocalPlayer.Name)

-- Rayfield UI Library with error handling
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/linen018/Rayfield/main/source.lua"))()
end)

if not success then
    warn("Failed to load Rayfield UI library: " .. tostring(Rayfield))
    warn("Trying alternative source...")
    success, Rayfield = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/Rayfield.lua"))()
    end)
    if not success then
        error("Failed to load Rayfield UI library from all sources. Script cannot run.")
    end
end

-- Configuration
local Config = {
    Aimbot = {
        Enabled = false,
        FOV = 100,
        Smoothness = 0.1,
        TargetPart = "Head",
        TeamCheck = true,
        VisibilityCheck = true
    },
    ESP = {
        Enabled = false,
        ShowHealth = true,
        ShowDistance = true,
        ShowName = true,
        BoxColor = Color3.fromRGB(255, 0, 0),
        TracerColor = Color3.fromRGB(0, 255, 0),
        MaxDistance = 500
    },
    Visuals = {
        ChamsEnabled = false,
        ChamsColor = Color3.fromRGB(255, 0, 255),
        ChamsTransparency = 0.5,
        FullBright = false
    },
    Misc = {
        WalkSpeed = 16,
        JumpPower = 50,
        InfiniteJump = false,
        NoClip = false
    }
}

-- Variables
local Mouse = LocalPlayer:GetMouse() or {X = 0, Y = 0}
local CurrentTarget = nil
local ESPObjects = {}
local ChamsObjects = {}

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "BloxStrike Premium",
    LoadingTitle = "BloxStrike",
    LoadingSubtitle = "by Devin",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BloxStrike",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "none",
        RememberJoins = true
    },
    KeySystem = false
})

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)

-- Aimbot Section
local AimbotSection = MainTab:CreateSection("Aimbot")

MainTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false,
    Flag = "AimbotEnabled",
    Callback = function(Value)
        Config.Aimbot.Enabled = Value
    end
})

MainTab:CreateSlider({
    Name = "FOV",
    Range = {10, 360},
    Increment = 10,
    CurrentValue = 100,
    Flag = "AimbotFOV",
    Callback = function(Value)
        Config.Aimbot.FOV = Value
    end
})

MainTab:CreateSlider({
    Name = "Smoothness",
    Range = {0.01, 1},
    Increment = 0.01,
    CurrentValue = 0.1,
    Flag = "AimbotSmoothness",
    Callback = function(Value)
        Config.Aimbot.Smoothness = Value
    end
})

MainTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "HumanoidRootPart", "Torso", "Left Leg", "Right Leg"},
    CurrentOption = "Head",
    Flag = "AimbotTargetPart",
    Callback = function(Option)
        Config.Aimbot.TargetPart = Option
    end
})

MainTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Flag = "AimbotTeamCheck",
    Callback = function(Value)
        Config.Aimbot.TeamCheck = Value
    end
})

MainTab:CreateToggle({
    Name = "Visibility Check",
    CurrentValue = true,
    Flag = "AimbotVisibilityCheck",
    Callback = function(Value)
        Config.Aimbot.VisibilityCheck = Value
    end
})

-- ESP Section
local ESPSection = MainTab:CreateSection("ESP")

MainTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "ESPEnabled",
    Callback = function(Value)
        Config.ESP.Enabled = Value
        if not Value then
            ClearESP()
        end
    end
})

MainTab:CreateToggle({
    Name = "Show Health",
    CurrentValue = true,
    Flag = "ESPShowHealth",
    Callback = function(Value)
        Config.ESP.ShowHealth = Value
    end
})

MainTab:CreateToggle({
    Name = "Show Distance",
    CurrentValue = true,
    Flag = "ESPShowDistance",
    Callback = function(Value)
        Config.ESP.ShowDistance = Value
    end
})

MainTab:CreateToggle({
    Name = "Show Name",
    CurrentValue = true,
    Flag = "ESPShowName",
    Callback = function(Value)
        Config.ESP.ShowName = Value
    end
})

MainTab:CreateSlider({
    Name = "Max Distance",
    Range = {50, 1000},
    Increment = 50,
    CurrentValue = 500,
    Flag = "ESPMaxDistance",
    Callback = function(Value)
        Config.ESP.MaxDistance = Value
    end
})

-- Visuals Tab
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

local VisualsSection = VisualsTab:CreateSection("Visual Effects")

VisualsTab:CreateToggle({
    Name = "Enable Chams",
    CurrentValue = false,
    Flag = "ChamsEnabled",
    Callback = function(Value)
        Config.Visuals.ChamsEnabled = Value
        if not Value then
            ClearChams()
        end
    end
})

VisualsTab:CreateColorPicker({
    Name = "Chams Color",
    Color = Color3.fromRGB(255, 0, 255),
    Flag = "ChamsColor",
    Callback = function(Value)
        Config.Visuals.ChamsColor = Value
    end
})

VisualsTab:CreateSlider({
    Name = "Chams Transparency",
    Range = {0, 1},
    Increment = 0.1,
    CurrentValue = 0.5,
    Flag = "ChamsTransparency",
    Callback = function(Value)
        Config.Visuals.ChamsTransparency = Value
    end
})

VisualsTab:CreateToggle({
    Name = "Full Bright",
    CurrentValue = false,
    Flag = "FullBright",
    Callback = function(Value)
        Config.Visuals.FullBright = Value
        if Value then
            game.Lighting.Brightness = 2
            game.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            game.Lighting.EnvironmentDiffuseScale = 1
        else
            game.Lighting.Brightness = 1
            game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            game.Lighting.EnvironmentDiffuseScale = 1
        end
    end
})

-- Misc Tab
local MiscTab = Window:CreateTab("Misc", 4483362458)

local MovementSection = MiscTab:CreateSection("Movement")

MiscTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 100},
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        Config.Misc.WalkSpeed = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

MiscTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 200},
    Increment = 5,
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        Config.Misc.JumpPower = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = Value
        end
    end
})

MiscTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function(Value)
        Config.Misc.InfiniteJump = Value
    end
})

MiscTab:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Flag = "NoClip",
    Callback = function(Value)
        Config.Misc.NoClip = Value
    end
})

-- Functions
function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = Config.Aimbot.FOV

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player.Character and player.Character:FindFirstChild(Config.Aimbot.TargetPart) then
                -- Team check
                if Config.Aimbot.TeamCheck then
                    local playerTeam = player.Team
                    local localTeam = LocalPlayer.Team
                    if playerTeam and localTeam and playerTeam == localTeam then
                        continue
                    end
                end

                local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character[Config.Aimbot.TargetPart].Position)
                local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

                if distance < shortestDistance and onScreen then
                    if Config.Aimbot.VisibilityCheck then
                        local rayParams = RaycastParams.new()
                        rayParams.FilterType = Enum.RaycastFilterType.Exclude
                        rayParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
                        
                        local rayResult = Workspace:Raycast(Camera.CFrame.Position, (player.Character[Config.Aimbot.TargetPart].Position - Camera.CFrame.Position).Unit * 1000, rayParams)
                        
                        if rayResult and rayResult.Instance and rayResult.Instance:IsDescendantOf(player.Character) then
                            closestPlayer = player
                            shortestDistance = distance
                        end
                    else
                        closestPlayer = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end

    return closestPlayer
end

function UpdateAimbot()
    if Config.Aimbot.Enabled then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(Config.Aimbot.TargetPart) then
            local targetPos = target.Character[Config.Aimbot.TargetPart].Position
            local currentCFrame = Camera.CFrame
            local lookAt = CFrame.lookAt(currentCFrame.Position, targetPos)
            Camera.CFrame = currentCFrame:Lerp(lookAt, Config.Aimbot.Smoothness)
        end
    end
end

function CreateESP(player)
    if ESPObjects[player] then return end

    local esp = {
        Box = Drawing.new("Square"),
        Tracer = Drawing.new("Line"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Text"),
        Distance = Drawing.new("Text")
    }

    esp.Box.Thickness = 1
    esp.Box.Color = Config.ESP.BoxColor
    esp.Box.Filled = false
    esp.Box.Transparency = 1

    esp.Tracer.Thickness = 1
    esp.Tracer.Color = Config.ESP.TracerColor
    esp.Tracer.Transparency = 1

    esp.Name.Size = 14
    esp.Name.Color = Color3.new(1, 1, 1)
    esp.Name.Outline = true
    esp.Name.Center = true

    esp.Health.Size = 14
    esp.Health.Color = Color3.fromRGB(0, 255, 0)
    esp.Health.Outline = true
    esp.Health.Center = true

    esp.Distance.Size = 14
    esp.Distance.Color = Color3.fromRGB(255, 255, 0)
    esp.Distance.Outline = true
    esp.Distance.Center = true

    ESPObjects[player] = esp
end

function UpdateESP(player)
    local esp = ESPObjects[player]
    if not esp or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    local humanoid = player.Character:FindFirstChild("Humanoid")
    if not humanoid then return end

    local rootPart = player.Character.HumanoidRootPart
    local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
    local distance = (Camera.CFrame.Position - rootPart.Position).Magnitude

    if distance > Config.ESP.MaxDistance or not onScreen then
        for _, drawing in pairs(esp) do
            drawing.Visible = false
        end
        return
    end

    local scale = 1 / (distance * math.tan(math.rad(Camera.FieldOfView / 2))) * 1000
    local boxSize = Vector2.new(4 * scale, 6 * scale)

    esp.Box.Size = boxSize
    esp.Box.Position = Vector2.new(screenPos.X - boxSize.X / 2, screenPos.Y - boxSize.Y / 2)
    esp.Box.Visible = true

    esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
    esp.Tracer.To = Vector2.new(screenPos.X, screenPos.Y + boxSize.Y / 2)
    esp.Tracer.Visible = true

    if Config.ESP.ShowName then
        esp.Name.Text = player.Name
        esp.Name.Position = Vector2.new(screenPos.X, screenPos.Y - boxSize.Y / 2 - 20)
        esp.Name.Visible = true
    else
        esp.Name.Visible = false
    end

    if Config.ESP.ShowHealth then
        local healthPercent = humanoid.Health / humanoid.MaxHealth
        esp.Health.Text = tostring(math.floor(humanoid.Health)) .. "/" .. tostring(math.floor(humanoid.MaxHealth))
        esp.Health.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
        esp.Health.Position = Vector2.new(screenPos.X, screenPos.Y - boxSize.Y / 2 - 35)
        esp.Health.Visible = true
    else
        esp.Health.Visible = false
    end

    if Config.ESP.ShowDistance then
        esp.Distance.Text = tostring(math.floor(distance)) .. " studs"
        esp.Distance.Position = Vector2.new(screenPos.X, screenPos.Y + boxSize.Y / 2 + 10)
        esp.Distance.Visible = true
    else
        esp.Distance.Visible = false
    end
end

function ClearESP()
    for player, esp in pairs(ESPObjects) do
        for _, drawing in pairs(esp) do
            drawing:Remove()
        end
    end
    ESPObjects = {}
end

function CreateChams(player)
    if ChamsObjects[player] then return end

    if player.Character then
        local highlight = Instance.new("Highlight")
        highlight.Name = "BloxStrikeChams"
        highlight.FillColor = Config.Visuals.ChamsColor
        highlight.OutlineColor = Config.Visuals.ChamsColor
        highlight.FillTransparency = Config.Visuals.ChamsTransparency
        highlight.OutlineTransparency = 0
        highlight.Adornee = player.Character
        highlight.Parent = player.Character
        ChamsObjects[player] = highlight
    end
end

function ClearChams()
    for player, highlight in pairs(ChamsObjects) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
    end
    ChamsObjects = {}
end

-- Event Handlers
Players.PlayerAdded:Connect(function(player)
    if Config.ESP.Enabled then
        CreateESP(player)
    end
    if Config.Visuals.ChamsEnabled then
        CreateChams(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        for _, drawing in pairs(ESPObjects[player]) do
            drawing:Remove()
        end
        ESPObjects[player] = nil
    end
    if ChamsObjects[player] then
        if ChamsObjects[player].Parent then
            ChamsObjects[player]:Destroy()
        end
        ChamsObjects[player] = nil
    end
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    -- Aimbot
    UpdateAimbot()

    -- ESP
    if Config.ESP.Enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if not ESPObjects[player] then
                    CreateESP(player)
                end
                UpdateESP(player)
            end
        end
    end

    -- Chams
    if Config.Visuals.ChamsEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                if not ChamsObjects[player] then
                    CreateChams(player)
                end
            end
        end
    end

    -- NoClip
    if Config.Misc.NoClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Config.Misc.InfiniteJump then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Character Spawn Handler
LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.WalkSpeed = Config.Misc.WalkSpeed
        humanoid.JumpPower = Config.Misc.JumpPower
    end
end)

-- Initialize
-- Apply initial settings if character exists
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
    LocalPlayer.Character.Humanoid.WalkSpeed = Config.Misc.WalkSpeed
    LocalPlayer.Character.Humanoid.JumpPower = Config.Misc.JumpPower
end

-- Wrap notification in pcall to prevent errors
pcall(function()
    Rayfield:Notify({
        Title = "BloxStrike Loaded",
        Content = "Script successfully loaded! Enjoy!",
        Duration = 5,
        Image = 4483362458
    })
end)

print("BloxStrike Premium loaded successfully!")
print("Press the UI button to access features")
