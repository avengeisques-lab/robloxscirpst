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
    -- Silent Aim (Metamethod Ray Redirect)
    SilentAimEnabled = false,
    SilentAimFOV = 180,
    PredictionFactor = 0.12,
    HitPart = "Head",
    TeamCheck = true,
    
    -- Visual / FOV Circle
    ShowSilentFOV = true,
    
    -- Combat (Camera Assist)
    AimbotEnabled = false,
    AimbotFOV = 140,
    Smoothness = 2,
    NoRecoil = false,
    
    -- Visuals / ESP
    BoxESP = false,
    NameESP = false,
    ModFOV = false,
    CustomFOV = 90,
    
    -- Character Mods
    Noclip = false,
    FlyEnabled = false,
    FlySpeed = 50,
    Invisibility = false,
    SpeedEnabled = false,
    CustomSpeed = 16,
}

-- ESP Storage & FOV Circle
local ESPDrawingCache = {}
local SilentFOVDrawing = Drawing.new("Circle")
SilentFOVDrawing.Visible = false
SilentFOVDrawing.Color = Color3.fromRGB(0, 150, 255)
SilentFOVDrawing.Thickness = 1.5
SilentFOVDrawing.Filled = false
SilentFOVDrawing.Transparency = 0.8

-- Create Rayfield Window Interface
local Window = Rayfield:CreateWindow({
    Name = "OPERATION: ONE | TTK & Hardpoint Suite",
    LoadingTitle = "Loading Silent Aim Modules...",
    LoadingSubtitle = "by p7zu",
    Theme = "DarkBlue",
    
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "OperationOneConfigs",
        FileName = "HardpointConfigV8"
    },
    KeySystem = false,
})

-- Tabs
local CombatTab = Window:CreateTab("Combat & Silent", "crosshair")
local VisualsTab = Window:CreateTab("Visuals & ESP", "eye")
local MiscTab = Window:CreateTab("Movement & Misc", "sliders")

----------------------------------------------------------------
-- COMBAT TAB
----------------------------------------------------------------
CombatTab:CreateSection("Real Silent Aim (Ray Redirection)")

CombatTab:CreateToggle({
    Name = "Enable Silent Aim",
    CurrentValue = false,
    Flag = "SilentAimToggle",
    Callback = function(Value)
        getgenv().OperationConfig.SilentAimEnabled = Value
        SilentFOVDrawing.Visible = Value and getgenv().OperationConfig.ShowSilentFOV
    end,
})

CombatTab:CreateToggle({
    Name = "Show Silent FOV Circle",
    CurrentValue = true,
    Flag = "SilentFOVCircleToggle",
    Callback = function(Value)
        getgenv().OperationConfig.ShowSilentFOV = Value
        SilentFOVDrawing.Visible = Value and getgenv().OperationConfig.SilentAimEnabled
    end,
})

CombatTab:CreateSlider({
    Name = "Silent FOV Radius",
    Range = {50, 500},
    Increment = 5,
    Suffix = "px",
    CurrentValue = 180,
    Flag = "SilentAimFOV",
    Callback = function(Value)
        getgenv().OperationConfig.SilentAimFOV = Value
        SilentFOVDrawing.Radius = Value
    end,
})

CombatTab:CreateDropdown({
    Name = "Silent Target Hitpart",
    Options = {"Head", "HumanoidRootPart"},
    CurrentOption = "Head",
    Flag = "SilentHitPartDropdown",
    Callback = function(Option)
        getgenv().OperationConfig.HitPart = Option[1] or Option
    end,
})

CombatTab:CreateSection("Classic Camera Lock (Optional)")

CombatTab:CreateToggle({
    Name = "Enable Camera Lock",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(Value)
        getgenv().OperationConfig.AimbotEnabled = Value
    end,
})

CombatTab:CreateSlider({
    Name = "Camera Snap Smoothness",
    Range = {1, 10},
    Increment = 0.5,
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

CombatTab:CreateSection("Weapon Modifications")

CombatTab:CreateToggle({
    Name = "Hard Universal No Recoil / Spread",
    CurrentValue = false,
    Flag = "NoRecoilToggle",
    Callback = function(Value)
        getgenv().OperationConfig.NoRecoil = Value
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
-- MOVEMENT & MISC TAB
----------------------------------------------------------------
MiscTab:CreateSection("Target Elimination (Kill Feature)")

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
    Name = "Select Target to Eliminate",
    Options = playerList,
    CurrentOption = "",
    Flag = "KillDropdown",
    Callback = function(Option)
        selectedTargetPlayer = Option[1] or Option
    end,
})

MiscTab:CreateButton({
    Name = "Instantly Kill Selected Player",
    Callback = function()
        if selectedTargetPlayer then
            local targetObj = Players:FindFirstChild(selectedTargetPlayer)
            if targetObj and targetObj.Character then
                local humanoid = targetObj.Character:FindFirstChildOfClass("Humanoid")
                local rootPart = targetObj.Character:FindFirstChild("HumanoidRootPart")
                if humanoid and rootPart then
                    local oldPos = rootPart.CFrame
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local myRoot = LocalPlayer.Character.HumanoidRootPart
                        myRoot.CFrame = rootPart.CFrame
                        task.wait(0.05)
                        humanoid.Health = 0
                        myRoot.CFrame = oldPos
                        Rayfield:Notify({Title = "Elimination", Content = "Successfully executed " .. selectedTargetPlayer, Duration = 2})
                    else
                        humanoid.Health = 0
                        Rayfield:Notify({Title = "Elimination", Content = "Forced health down for " .. selectedTargetPlayer, Duration = 2})
                    end
                else
                    Rayfield:Notify({Title = "Elimination", Content = "Target humanoid missing or already dead.", Duration = 2})
                end
            else
                Rayfield:Notify({Title = "Elimination", Content = "Target character not found.", Duration = 2})
            end
        else
            Rayfield:Notify({Title = "Elimination", Content = "No player selected in dropdown.", Duration = 2})
        end
    end,
})

MiscTab:CreateSection("Flight & Movement")

MiscTab:CreateToggle({
    Name = "Enable Flight (Fly)",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        getgenv().OperationConfig.FlyEnabled = Value
    end,
})

MiscTab:CreateSlider({
    Name = "Flight Speed",
    Range = {16, 200},
    Increment = 5,
    Suffix = " studs/s",
    CurrentValue = 50,
    Flag = "FlySpeedVal",
    Callback = function(Value)
        getgenv().OperationConfig.FlySpeed = Value
    end,
})

MiscTab:CreateToggle({
    Name = "Invisibility (Transparency Bypass)",
    CurrentValue = false,
    Flag = "InvisToggle",
    Callback = function(Value)
        getgenv().OperationConfig.Invisibility = Value
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = Value and 1 or 0
                elseif part:IsA("Decal") then
                    part.Transparency = Value and 1 or 0
                end
            end
        end
    end,
})

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
-- BACKEND ENGINE & SILENT AIM METAMETHOD HOOK
----------------------------------------------------------------

local function GetSilentAimTarget()
    local targetPart = nil
    local shortestDistance = getgenv().OperationConfig.SilentAimFOV
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
                    local pPart = character:FindFirstChild(getgenv().OperationConfig.HitPart) or character:FindFirstChild("HumanoidRootPart")
                    if pPart then
                        local screenPoint, onScreen = Camera:WorldToViewportPoint(pPart.Position)
                        if onScreen then
                            local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                targetPart = pPart
                            end
                        end
                    end
                end
            end
        end
    end
    return targetPart
end

local function GetCameraLockTarget()
    local targetPart = nil
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
                    local pPart = character:FindFirstChild(getgenv().OperationConfig.HitPart) or character:FindFirstChild("HumanoidRootPart")
                    if pPart then
                        local screenPoint, onScreen = Camera:WorldToViewportPoint(pPart.Position)
                        if onScreen then
                            local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                targetPart = pPart
                            end
                        end
                    end
                end
            end
        end
    end
    return targetPart
end

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

-- Hook into __namecall to transparently redirect Raycasts / FindPartOnRay calls to the silent aim target
local OldNameCall
OldNameCall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if getgenv().OperationConfig.SilentAimEnabled and not checkcaller() then
        local targetPart = GetSilentAimTarget()
        if targetPart then
            if method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRayWithWhitelist" then
                local originRay = args[1]
                if typeof(originRay) == "Ray" then
                    local predictedPos = targetPart.Position
                    if targetPart.AssemblyLinearVelocity then
                        predictedPos = predictedPos + (targetPart.AssemblyLinearVelocity * getgenv().OperationConfig.PredictionFactor)
                    end
                    
                    local newDirection = (predictedPos - originRay.Origin).Unit * originRay.Direction.Magnitude
                    args[1] = Ray.new(originRay.Origin, newDirection)
                    return OldNameCall(self, unpack(args))
                end
            elseif method == "Raycast" then
                local originPos = args[1]
                if typeof(originPos) == "Vector3" then
                    local predictedPos = targetPart.Position
                    if targetPart.AssemblyLinearVelocity then
                        predictedPos = predictedPos + (targetPart.AssemblyLinearVelocity * getgenv().OperationConfig.PredictionFactor)
                    end
                    
                    local originalDir = args[2]
                    if typeof(originalDir) == "Vector3" then
                        args[2] = (predictedPos - originPos).Unit * originalDir.Magnitude
                        return OldNameCall(self, unpack(args))
                    end
                end
            end
        end
    end
    
    return OldNameCall(self, ...)
end)

-- Main RenderLoop execution
RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    SilentFOVDrawing.Position = mousePos
    
    if getgenv().OperationConfig.ModFOV then
        Camera.FieldOfView = getgenv().OperationConfig.CustomFOV
    end

    -- Optional Camera Snap Assist Loop
    if getgenv().OperationConfig.AimbotEnabled then
        local targetPart = GetCameraLockTarget()
        if targetPart then
            local camPos = Camera.CFrame.Position
            local predictedPos = targetPart.Position
            if targetPart.AssemblyLinearVelocity then
                predictedPos = predictedPos + (targetPart.AssemblyLinearVelocity * 0.1)
            end
            local smoothVal = math.max(0.5, getgenv().OperationConfig.Smoothness)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(camPos, predictedPos), 1 / smoothVal)
        end
    end

    -- Hard Universal No Recoil / Spread Blocker
    if getgenv().OperationConfig.NoRecoil then
        local char = LocalPlayer.Character
        if char then
            for _, tool in ipairs(char:GetChildren()) do
                if tool:IsA("Tool") then
                    for _, descendant in ipairs(tool:GetDescendants()) do
                        if descendant:IsA("NumberValue") or descendant:IsA("IntValue") then
                            local nameLower = descendant.Name:lower()
                            if nameLower:find("recoil") or nameLower:find("spread") or nameLower:find("kick") or nameLower:find("shake") or nameLower:find("bloom") then
                                descendant.Value = 0
                            end
                        end
                    end
                end
            end
        end

        for _, vmChild in ipairs(Camera:GetChildren()) do
            if vmChild:IsA("Model") or vmChild:IsA("Part") then
                for _, descendant in ipairs(vmChild:GetDescendants()) do
                    if descendant:IsA("Vector3Value") or descendant:IsA("CFrameValue") then
                        descendant.Value = descendant.Value * 0
                    end
                end
            end
        end
    end

    -- ESP Rendering Loop
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

-- Character physics modifiers loop
RunService.Stepped:Connect(function()
    local character = LocalPlayer.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if getgenv().OperationConfig.SpeedEnabled and humanoid then
            humanoid.WalkSpeed = getgenv().OperationConfig.CustomSpeed
        end

        if getgenv().OperationConfig.Noclip then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end

        if getgenv().OperationConfig.FlyEnabled and humanoidRootPart and humanoid then
            humanoid.PlatformStand = true
            local camCFrame = Camera.CFrame
            local moveVector = Vector3.new()

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + camCFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - camCFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - camCFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + camCFrame.RightVector end

            if moveVector.Magnitude > 0 then
                moveVector = moveVector.Unit * getgenv().OperationConfig.FlySpeed
            end

            humanoidRootPart.AssemblyLinearVelocity = Vector3.new(moveVector.X, moveVector.Y + 1, moveVector.Z)
        else
            if humanoid then humanoid.PlatformStand = false end
        end

        if getgenv().OperationConfig.Invisibility then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 1
                elseif part:IsA("Decal") then
                    part.Transparency = 1
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
