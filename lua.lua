-- BloxStrike Custom UI Script
-- Features: Aimbot, ESP, Visual Effects, and more
-- No external dependencies

print("BloxStrike: Starting script...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

-- Wait for player
if not Players.LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
end

local LocalPlayer = Players.LocalPlayer
print("BloxStrike: LocalPlayer found: " .. LocalPlayer.Name)

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
local ESPObjects = {}
local ChamsObjects = {}
local ScreenGui = nil
local MainFrame = nil
local ToggleButtons = {}
local Sliders = {}
local Dropdowns = {}

-- Create UI
function CreateUI()
    local success, err = pcall(function()
        ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "BloxStrikeUI"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.Parent = game:GetService("CoreGui")
        
        -- Main Frame
        MainFrame = Instance.new("Frame")
        MainFrame.Name = "MainFrame"
        MainFrame.Size = UDim2.new(0, 450, 0, 350)
        MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
        MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        MainFrame.BorderSizePixel = 0
        MainFrame.Parent = ScreenGui
        
        -- Title Bar
        local TitleBar = Instance.new("Frame")
        TitleBar.Name = "TitleBar"
        TitleBar.Size = UDim2.new(1, 0, 0, 40)
        TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        TitleBar.BorderSizePixel = 0
        TitleBar.Parent = MainFrame
        
        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        Title.Size = UDim2.new(1, 0, 1, 0)
        Title.BackgroundTransparency = 1
        Title.Text = "BloxStrike Premium"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 18
        Title.Font = Enum.Font.GothamBold
        Title.Parent = TitleBar
        
        -- Tab Buttons
        local TabButtons = Instance.new("Frame")
        TabButtons.Name = "TabButtons"
        TabButtons.Size = UDim2.new(1, 0, 0, 40)
        TabButtons.Position = UDim2.new(0, 0, 0, 40)
        TabButtons.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        TabButtons.BorderSizePixel = 0
        TabButtons.Parent = MainFrame
        
        local tabs = {"Main", "Visuals", "Misc"}
        local tabWidth = 150
        
        for i, tabName in ipairs(tabs) do
            local TabButton = Instance.new("TextButton")
            TabButton.Name = tabName .. "Tab"
            TabButton.Size = UDim2.new(0, tabWidth, 1, 0)
            TabButton.Position = UDim2.new(0, (i-1) * tabWidth, 0, 0)
            TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            TabButton.BorderSizePixel = 0
            TabButton.Text = tabName
            TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            TabButton.TextSize = 14
            TabButton.Font = Enum.Font.Gotham
            TabButton.Parent = TabButtons
            
            TabButton.MouseButton1Click:Connect(function()
                SwitchTab(tabName)
            end)
        end
        
        -- Content Frame
        local ContentFrame = Instance.new("Frame")
        ContentFrame.Name = "ContentFrame"
        ContentFrame.Size = UDim2.new(1, 0, 1, -80)
        ContentFrame.Position = UDim2.new(0, 0, 0, 80)
        ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        ContentFrame.BorderSizePixel = 0
        ContentFrame.Parent = MainFrame
        
        -- Create Tab Contents
        CreateMainTab(ContentFrame)
        CreateVisualsTab(ContentFrame)
        CreateMiscTab(ContentFrame)
        
        -- Make draggable
        MakeDraggable(MainFrame, TitleBar)
        
        -- Hide by default
        MainFrame.Visible = false
        
        -- Toggle key
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.RightControl then
                MainFrame.Visible = not MainFrame.Visible
            end
        end)
        
        print("BloxStrike: UI created successfully")
    end)
    
    if not success then
        warn("BloxStrike: Failed to create UI: " .. tostring(err))
    end
end

function MakeDraggable(frame, handle)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputType == Enum.UserInputType.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function SwitchTab(tabName)
    local ContentFrame = MainFrame.ContentFrame
    
    -- Clear current content
    for _, child in pairs(ContentFrame:GetChildren()) do
        if child.Name ~= "TabButtons" then
            child:Destroy()
        end
    end
    
    -- Create new content
    if tabName == "Main" then
        CreateMainTab(ContentFrame)
    elseif tabName == "Visuals" then
        CreateVisualsTab(ContentFrame)
    elseif tabName == "Misc" then
        CreateMiscTab(ContentFrame)
    end
end

function CreateToggle(name, parent, configTable, configKey, yOffset)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Size = UDim2.new(1, -20, 0, 35)
    container.Position = UDim2.new(0, 10, 0, yOffset)
    container.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0, 300, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local toggle = Instance.new("TextButton")
    toggle.Name = "Toggle"
    toggle.Size = UDim2.new(0, 50, 0, 25)
    toggle.Position = UDim2.new(1, -60, 0.5, -12.5)
    toggle.BackgroundColor3 = configTable[configKey] and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100)
    toggle.BorderSizePixel = 0
    toggle.Text = configTable[configKey] and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextSize = 12
    toggle.Font = Enum.Font.GothamBold
    toggle.Parent = container
    
    toggle.MouseButton1Click:Connect(function()
        configTable[configKey] = not configTable[configKey]
        toggle.BackgroundColor3 = configTable[configKey] and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 100, 100)
        toggle.Text = configTable[configKey] and "ON" or "OFF"
        
        -- Special handling
        if name == "Enable ESP" and not configTable[configKey] then
            ClearESP()
        end
        if name == "Enable Chams" and not configTable[configKey] then
            ClearChams()
        end
        if name == "Full Bright" then
            if configTable[configKey] then
                game.Lighting.Brightness = 2
                game.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            else
                game.Lighting.Brightness = 1
                game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            end
        end
    end)
    
    return yOffset + 40
end

function CreateSlider(name, parent, configTable, configKey, min, max, increment, yOffset)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Size = UDim2.new(1, -20, 0, 50)
    container.Position = UDim2.new(0, 10, 0, yOffset)
    container.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. tostring(configTable[configKey])
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Name = "SliderBg"
    sliderBg.Size = UDim2.new(1, 0, 0, 10)
    sliderBg.Position = UDim2.new(0, 0, 0, 25)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = container
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new((configTable[configKey] - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "SliderButton"
    sliderButton.Size = UDim2.new(1, 0, 1, 0)
    sliderButton.BackgroundTransparency = 1
    sliderButton.Text = ""
    sliderButton.Parent = sliderBg
    
    local isDragging = false
    
    sliderButton.MouseButton1Down:Connect(function()
        isDragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = sliderBg.AbsolutePosition
            local sliderSize = sliderBg.AbsoluteSize
            
            local percent = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
            local value = min + (max - min) * percent
            value = math.floor(value / increment) * increment
            
            configTable[configKey] = value
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            label.Text = name .. ": " .. tostring(value)
            
            -- Special handling
            if name == "Walk Speed" and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = value
            end
            if name == "Jump Power" and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.JumpPower = value
            end
        end
    end)
    
    return yOffset + 55
end

function CreateDropdown(name, parent, configTable, configKey, options, yOffset)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Size = UDim2.new(1, -20, 0, 35)
    container.Position = UDim2.new(0, 10, 0, yOffset)
    container.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0, 150, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local dropdown = Instance.new("TextButton")
    dropdown.Name = "Dropdown"
    dropdown.Size = UDim2.new(0, 200, 0, 25)
    dropdown.Position = UDim2.new(0, 160, 0.5, -12.5)
    dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    dropdown.BorderSizePixel = 0
    dropdown.Text = configTable[configKey]
    dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdown.TextSize = 12
    dropdown.Font = Enum.Font.Gotham
    dropdown.Parent = container
    
    local dropdownOpen = false
    local dropdownFrame = nil
    
    dropdown.MouseButton1Click:Connect(function()
        dropdownOpen = not dropdownOpen
        
        if dropdownOpen then
            dropdownFrame = Instance.new("Frame")
            dropdownFrame.Name = "DropdownFrame"
            dropdownFrame.Size = UDim2.new(0, 200, 0, #options * 30)
            dropdownFrame.Position = UDim2.new(0, 160, 1, 5)
            dropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            dropdownFrame.BorderSizePixel = 0
            dropdownFrame.ZIndex = 10
            dropdownFrame.Parent = container
            
            for i, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Name = option
                optionButton.Size = UDim2.new(1, 0, 0, 30)
                optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
                optionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
                optionButton.BorderSizePixel = 0
                optionButton.Text = option
                optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                optionButton.TextSize = 12
                optionButton.Font = Enum.Font.Gotham
                optionButton.ZIndex = 11
                optionButton.Parent = dropdownFrame
                
                optionButton.MouseButton1Click:Connect(function()
                    configTable[configKey] = option
                    dropdown.Text = option
                    dropdownOpen = false
                    if dropdownFrame then
                        dropdownFrame:Destroy()
                        dropdownFrame = nil
                    end
                end)
                
                optionButton.MouseEnter:Connect(function()
                    optionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                end)
                
                optionButton.MouseLeave:Connect(function()
                    optionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
                end)
            end
        else
            if dropdownFrame then
                dropdownFrame:Destroy()
                dropdownFrame = nil
            end
        end
    end)
    
    return yOffset + 40
end

function CreateMainTab(parent)
    local yOffset = 10
    
    -- Aimbot Section
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Name = "AimbotSection"
    sectionLabel.Size = UDim2.new(1, 0, 0, 25)
    sectionLabel.Position = UDim2.new(0, 10, 0, yOffset)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = "AIMBOT"
    sectionLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
    sectionLabel.TextSize = 16
    sectionLabel.Font = Enum.Font.GothamBold
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Parent = parent
    yOffset = yOffset + 30
    
    yOffset = CreateToggle("Enable Aimbot", parent, Config.Aimbot, "Enabled", yOffset)
    yOffset = CreateSlider("FOV", parent, Config.Aimbot, "FOV", 10, 360, 10, yOffset)
    yOffset = CreateSlider("Smoothness", parent, Config.Aimbot, "Smoothness", 0.01, 1, 0.01, yOffset)
    yOffset = CreateDropdown("Target Part", parent, Config.Aimbot, "TargetPart", {"Head", "HumanoidRootPart", "Torso", "Left Leg", "Right Leg"}, yOffset)
    yOffset = CreateToggle("Team Check", parent, Config.Aimbot, "TeamCheck", yOffset)
    yOffset = CreateToggle("Visibility Check", parent, Config.Aimbot, "VisibilityCheck", yOffset)
    
    -- ESP Section
    yOffset = yOffset + 10
    local espSection = Instance.new("TextLabel")
    espSection.Name = "ESPSection"
    espSection.Size = UDim2.new(1, 0, 0, 25)
    espSection.Position = UDim2.new(0, 10, 0, yOffset)
    espSection.BackgroundTransparency = 1
    espSection.Text = "ESP"
    espSection.TextColor3 = Color3.fromRGB(0, 150, 255)
    espSection.TextSize = 16
    espSection.Font = Enum.Font.GothamBold
    espSection.TextXAlignment = Enum.TextXAlignment.Left
    espSection.Parent = parent
    yOffset = yOffset + 30
    
    yOffset = CreateToggle("Enable ESP", parent, Config.ESP, "Enabled", yOffset)
    yOffset = CreateToggle("Show Health", parent, Config.ESP, "ShowHealth", yOffset)
    yOffset = CreateToggle("Show Distance", parent, Config.ESP, "ShowDistance", yOffset)
    yOffset = CreateToggle("Show Name", parent, Config.ESP, "ShowName", yOffset)
    yOffset = CreateSlider("Max Distance", parent, Config.ESP, "MaxDistance", 50, 1000, 50, yOffset)
end

function CreateVisualsTab(parent)
    local yOffset = 10
    
    -- Visual Effects Section
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Name = "VisualsSection"
    sectionLabel.Size = UDim2.new(1, 0, 0, 25)
    sectionLabel.Position = UDim2.new(0, 10, 0, yOffset)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = "VISUAL EFFECTS"
    sectionLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
    sectionLabel.TextSize = 16
    sectionLabel.Font = Enum.Font.GothamBold
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Parent = parent
    yOffset = yOffset + 30
    
    yOffset = CreateToggle("Enable Chams", parent, Config.Visuals, "ChamsEnabled", yOffset)
    yOffset = CreateSlider("Chams Transparency", parent, Config.Visuals, "ChamsTransparency", 0, 1, 0.1, yOffset)
    yOffset = CreateToggle("Full Bright", parent, Config.Visuals, "FullBright", yOffset)
end

function CreateMiscTab(parent)
    local yOffset = 10
    
    -- Movement Section
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Name = "MovementSection"
    sectionLabel.Size = UDim2.new(1, 0, 0, 25)
    sectionLabel.Position = UDim2.new(0, 10, 0, yOffset)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = "MOVEMENT"
    sectionLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
    sectionLabel.TextSize = 16
    sectionLabel.Font = Enum.Font.GothamBold
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Parent = parent
    yOffset = yOffset + 30
    
    yOffset = CreateSlider("Walk Speed", parent, Config.Misc, "WalkSpeed", 16, 100, 1, yOffset)
    yOffset = CreateSlider("Jump Power", parent, Config.Misc, "JumpPower", 50, 200, 5, yOffset)
    yOffset = CreateToggle("Infinite Jump", parent, Config.Misc, "InfiniteJump", yOffset)
    yOffset = CreateToggle("NoClip", parent, Config.Misc, "NoClip", yOffset)
end

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
                local mousePos = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
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
CreateUI()

-- Apply initial settings if character exists
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
    LocalPlayer.Character.Humanoid.WalkSpeed = Config.Misc.WalkSpeed
    LocalPlayer.Character.Humanoid.JumpPower = Config.Misc.JumpPower
end

print("BloxStrike Premium loaded successfully!")
print("Press Right Control to toggle the UI")
