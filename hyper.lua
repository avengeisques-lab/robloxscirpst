local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Feature Configuration & State Table (Hypershot Elite Suite)
getgenv().HypershotSettings = {
   -- Core Filters
   TeamCheck = true,
   WallCheck = true,
   
   -- Silent Aim (Vector / Ray Redirection)
   SilentAim = true,
   SilentHitbox = "Head",
   SilentFOV = 450,
   ShowSilentFOV = true,
   PredictionFactor = 0.145,
   HitChance = 100,

   -- Rage / Snap Bot
   RageAimbot = false,
   RageHitbox = "Head",
   RageFOV = 350,
   RageAutoShoot = false,

   -- Visuals: ESP
   BoxESP = true,
   BoxColor = Color3.fromRGB(0, 255, 200),
   NameESP = true,
   HealthBar = true,
   SkeletonESP = true,
   SkeletonColor = Color3.fromRGB(255, 255, 255),
   Snaplines = false,
   SnaplineColor = Color3.fromRGB(0, 255, 200),

   -- Visuals: Chams / Glow
   Chams = true,
   ChamsFillColor = Color3.fromRGB(120, 0, 255),
   ChamsOutlineColor = Color3.fromRGB(0, 255, 200),

   -- Misc & Movement
   Bhop = false,
   WalkSpeed = 16,
   InfiniteJump = false,
   NoRecoil = true
}

local Window = Rayfield:CreateWindow({
   Name = "Hypershot | Elite Apex Suite v1.0",
   LoadingTitle = "Initializing Hypershot Hooks...",
   LoadingSubtitle = "by p7zu",
   Theme = "Default",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "HypershotConfigs",
      FileName = "EliteConfig"
   },
   KeySystem = false,
})

-- Tabs Setup
local SilentTab = Window:CreateTab("Silent Aim", 4483362458)
local RageTab = Window:CreateTab("Rage Bot", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local MiscTab = Window:CreateTab("Misc & Move", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- ==================== SILENT AIM TAB ====================
SilentTab:CreateSection("Silent Aim Configuration")

SilentTab:CreateToggle({
   Name = "Enable Silent Aim (Vector Redirection)",
   CurrentValue = true,
   Flag = "SilentToggle",
   Callback = function(Value)
      getgenv().HypershotSettings.SilentAim = Value
   end,
})

SilentTab:CreateToggle({
   Name = "Show Silent FOV Circle",
   CurrentValue = true,
   Flag = "SilentFOVCircle",
   Callback = function(Value)
      getgenv().HypershotSettings.ShowSilentFOV = Value
   end,
})

SilentTab:CreateDropdown({
   Name = "Target Hitbox",
   Options = {"Head", "UpperTorso", "HumanoidRootPart", "Random"},
   CurrentOption = {"Head"},
   MultipleOptions = false,
   Flag = "SilentHitbox",
   Callback = function(Option)
      getgenv().HypershotSettings.SilentHitbox = Option[1]
   end,
})

SilentTab:CreateSlider({
   Name = "Silent FOV Radius",
   Range = {50, 800},
   Increment = 10,
   Suffix = "px",
   CurrentValue = 450,
   Flag = "SilentFOV",
   Callback = function(Value)
      getgenv().HypershotSettings.SilentFOV = Value
   end,
})

SilentTab:CreateSlider({
   Name = "Air Velocity Prediction",
   Range = {0, 0.5},
   Increment = 0.005,
   Suffix = "factor",
   CurrentValue = 0.145,
   Flag = "PredictionFactor",
   Callback = function(Value)
      getgenv().HypershotSettings.PredictionFactor = Value
   end,
})

-- ==================== RAGE TAB ====================
RageTab:CreateSection("Rage Snap Configuration")

RageTab:CreateToggle({
   Name = "Enable Rage Camera Snap",
   CurrentValue = false,
   Flag = "RageToggle",
   Callback = function(Value)
      getgenv().HypershotSettings.RageAimbot = Value
   end,
})

RageTab:CreateDropdown({
   Name = "Rage Hitbox",
   Options = {"Head", "UpperTorso", "HumanoidRootPart"},
   CurrentOption = {"Head"},
   MultipleOptions = false,
   Flag = "RageHitbox",
   Callback = function(Option)
      getgenv().HypershotSettings.RageHitbox = Option[1]
   end,
})

RageTab:CreateSlider({
   Name = "Rage FOV",
   Range = {50, 600},
   Increment = 10,
   Suffix = "px",
   CurrentValue = 350,
   Flag = "RageFOV",
   Callback = function(Value)
      getgenv().HypershotSettings.RageFOV = Value
   end,
})

-- ==================== VISUALS TAB ====================
VisualsTab:CreateSection("Safety & Filters")

VisualsTab:CreateToggle({
   Name = "Team Check",
   CurrentValue = true,
   Flag = "TeamCheck",
   Callback = function(Value)
      getgenv().HypershotSettings.TeamCheck = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "Wall Check (Visible Only)",
   CurrentValue = true,
   Flag = "WallCheck",
   Callback = function(Value)
      getgenv().HypershotSettings.WallCheck = Value
   end,
})

VisualsTab:CreateSection("Player ESP Overlays")

VisualsTab:CreateToggle({
   Name = "Box ESP",
   CurrentValue = true,
   Flag = "BoxESP",
   Callback = function(Value)
      getgenv().HypershotSettings.BoxESP = Value
   end,
})

VisualsTab:CreateColorPicker({
   Name = "Box Color",
   Color = Color3.fromRGB(0, 255, 200),
   Flag = "BoxColor",
   Callback = function(Value)
      getgenv().HypershotSettings.BoxColor = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "Name & Health Bars",
   CurrentValue = true,
   Flag = "NameESP",
   Callback = function(Value)
      getgenv().HypershotSettings.NameESP = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "Skeleton Wireframe",
   CurrentValue = true,
   Flag = "SkeletonESP",
   Callback = function(Value)
      getgenv().HypershotSettings.SkeletonESP = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "Snaplines to Targets",
   CurrentValue = false,
   Flag = "Snaplines",
   Callback = function(Value)
      getgenv().HypershotSettings.Snaplines = Value
   end,
})

VisualsTab:CreateSection("Chams / Wallhack Glow")

VisualsTab:CreateToggle({
   Name = "Enable Player Chams Glow",
   CurrentValue = true,
   Flag = "ChamsToggle",
   Callback = function(Value)
      getgenv().HypershotSettings.Chams = Value
   end,
})

VisualsTab:CreateColorPicker({
   Name = "Chams Fill Color",
   Color = Color3.fromRGB(120, 0, 255),
   Flag = "ChamsFill",
   Callback = function(Value)
      getgenv().HypershotSettings.ChamsFillColor = Value
   end,
})

-- ==================== MISC TAB ====================
MiscTab:CreateSection("Movement & Utilities")

MiscTab:CreateToggle({
   Name = "Bunny Hop",
   CurrentValue = false,
   Flag = "Bhop",
   Callback = function(Value)
      getgenv().HypershotSettings.Bhop = Value
   end,
})

MiscTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfJump",
   Callback = function(Value)
      getgenv().HypershotSettings.InfiniteJump = Value
   end,
})

MiscTab:CreateSlider({
   Name = "WalkSpeed Modifier",
   Range = {16, 32},
   Increment = 1,
   Suffix = "studs",
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(Value)
      getgenv().HypershotSettings.WalkSpeed = Value
   end,
})

MiscTab:CreateToggle({
   Name = "No Recoil / Spread Suppression",
   CurrentValue = true,
   Flag = "NoRecoil",
   Callback = function(Value)
      getgenv().HypershotSettings.NoRecoil = Value
   end,
})

-- ==================== SETTINGS TAB ====================
SettingsTab:CreateSection("Interface Panel")
SettingsTab:CreateButton({
   Name = "Unload UI & Clean Drawings",
   Callback = function()
      Rayfield:Destroy()
   end,
})

-- ==================== BACKEND & SILENT HOOK ENGINE ====================

local espCache = {}
local silentFovCircle = Drawing.new("Circle")
silentFovCircle.Visible = false
silentFovCircle.Thickness = 1.5
silentFovCircle.NumSides = 64
silentFovCircle.Radius = getgenv().HypershotSettings.SilentFOV
silentFovCircle.Color = Color3.fromRGB(0, 255, 200)
silentFovCircle.Filled = false

local function createDrawingObjects(player)
   local obj = {}
   obj.Box = Drawing.new("Square")
   obj.Box.Visible = false
   obj.Box.Thickness = 1.5
   obj.Box.Filled = false

   obj.NameText = Drawing.new("Text")
   obj.NameText.Visible = false
   obj.NameText.Size = 13
   obj.NameText.Center = true
   obj.NameText.Outline = true
   obj.NameText.Color = Color3.fromRGB(255, 255, 255)

   obj.HealthBarOutline = Drawing.new("Square")
   obj.HealthBarOutline.Visible = false
   obj.HealthBarOutline.Filled = true
   obj.HealthBarOutline.Color = Color3.fromRGB(0, 0, 0)
   obj.HealthBarOutline.Thickness = 1

   obj.HealthBar = Drawing.new("Square")
   obj.HealthBar.Visible = false
   obj.HealthBar.Filled = true
   obj.HealthBar.Thickness = 1

   obj.Snapline = Drawing.new("Line")
   obj.Snapline.Visible = false
   obj.Snapline.Thickness = 1

   obj.SkeletonLines = {
      Drawing.new("Line"), -- Head to Torso
      Drawing.new("Line"), -- Torso to Left Arm
      Drawing.new("Line"), -- Torso to Right Arm
      Drawing.new("Line"), -- Torso to Left Leg
      Drawing.new("Line")  -- Torso to Right Leg
   }
   for _, line in ipairs(obj.SkeletonLines) do
      line.Visible = false
      line.Thickness = 1.5
      line.Color = Color3.fromRGB(255, 255, 255)
   end

   espCache[player] = obj
end

local function removeDrawingObjects(player)
   if espCache[player] then
      for _, item in pairs(espCache[player]) do
         if typeof(item) == "table" then
            for _, line in ipairs(item) do line:Remove() end
         else
            item:Remove()
         end
      end
      espCache[player] = nil
   end
end

Players.PlayerRemoving:Connect(removeDrawingObjects)

local function isEnemy(player)
   if not getgenv().HypershotSettings.TeamCheck then return true end
   if player.Team and LocalPlayer.Team then
      return player.Team ~= LocalPlayer.Team
   end
   return true
end

local function isVisible(targetPart)
   if not getgenv().HypershotSettings.WallCheck then return true end
   if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Head") then return true end
   
   local origin = LocalPlayer.Character.Head.Position
   local direction = (targetPart.Position - origin)
   
   local raycastParams = RaycastParams.new()
   raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
   raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
   raycastParams.IgnoreWater = true
   
   local result = Workspace:Raycast(origin, direction, raycastParams)
   return result == nil
end

local function getBestTarget(fovLimit, hitboxPreference)
   local bestTargetPart = nil
   local shortestDist = fovLimit
   local mousePos = UserInputService:GetMouseLocation()

   for _, player in ipairs(Players:GetPlayers()) do
      if player ~= LocalPlayer and isEnemy(player) then
         local char = player.Character
         local humanoid = char and char:FindFirstChild("Humanoid")
         
         if char and humanoid and humanoid.Health > 0 then
            local targetHitboxName = hitboxPreference
            if targetHitboxName == "Random" then
               local options = {"Head", "UpperTorso", "HumanoidRootPart"}
               targetHitboxName = options[math.random(1, #options)]
            end

            local hitbox = char:FindFirstChild(targetHitboxName) or char:FindFirstChild("Head")
            if hitbox and isVisible(hitbox) then
               local screenPos, onScreen = Camera:WorldToViewportPoint(hitbox.Position)
               local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
               
               if screenDist < shortestDist then
                  shortestDist = screenDist
                  bestTargetPart = hitbox
               end
            end
         end
      end
   end
   return bestTargetPart
end

-- ==================== ADVANCED SILENT AIM HOOK ====================
local rawMetatable = getrawmetatable(game)
local oldNamecall = rawMetatable.__namecall
setreadonly(rawMetatable, false)

rawMetatable.__namecall = newcclosure(function(self, ...)
   local method = getnamecallmethod()
   local args = {...}
   
   if getgenv().HypershotSettings.SilentAim and (method == "FireServer" or method == "InvokeServer") then
      local targetPart = getBestTarget(getgenv().HypershotSettings.SilentFOV, getgenv().HypershotSettings.SilentHitbox)
      if targetPart then
         -- Predict jumping / moving target trajectories precisely
         local predictedPosition = targetPart.Position + (targetPart.AssemblyLinearVelocity * getgenv().HypershotSettings.PredictionFactor)
         
         for i, v in ipairs(args) do
            if typeof(v) == "Vector3" then
               args[i] = predictedPosition
            elseif typeof(v) == "CFrame" then
               args[i] = CFrame.new(v.Position, predictedPosition)
            end
         end
      end
   end
   
   return oldNamecall(self, unpack(args))
end)

setreadonly(rawMetatable, true)

-- Infinite Jump Hook
UserInputService.JumpRequest:Connect(function()
   if getgenv().HypershotSettings.InfiniteJump then
      local char = LocalPlayer.Character
      if char and char:FindFirstChildOfClass("Humanoid") then
         char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
      end
   end
end)

-- Main Render Loop for Visuals, ESP, and Movement
RunService.RenderStepped:Connect(function()
   -- FOV Circle Drawing Update
   if getgenv().HypershotSettings.SilentAim and getgenv().HypershotSettings.ShowSilentFOV then
      silentFovCircle.Visible = true
      silentFovCircle.Radius = getgenv().HypershotSettings.SilentFOV
      silentFovCircle.Position = UserInputService:GetMouseLocation()
   else
      silentFovCircle.Visible = false
   end

   -- Movement Adjustments
   local char = LocalPlayer.Character
   if char and char:FindFirstChild("Humanoid") then
      local hum = char.Humanoid
      if getgenv().HypershotSettings.WalkSpeed > 16 then
         hum.WalkSpeed = getgenv().HypershotSettings.WalkSpeed
      end
      if getgenv().HypershotSettings.Bhop and hum.FloorMaterial ~= Enum.Material.Air then
         hum:Jump()
      end
   end

   -- ESP Render Core
   for _, player in ipairs(Players:GetPlayers()) do
      if player ~= LocalPlayer then
         if not espCache[player] then
            createDrawingObjects(player)
         end

         local cache = espCache[player]
         local targetChar = player.Character
         local hrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
         local humanoid = targetChar and targetChar:FindFirstChild("Humanoid")
         local head = targetChar and targetChar:FindFirstChild("Head")

         local shouldShow = getgenv().HypershotSettings.BoxESP or getgenv().HypershotSettings.NameESP or getgenv().HypershotSettings.SkeletonESP or getgenv().HypershotSettings.Snaplines
         if shouldShow and targetChar and hrp and head and humanoid and humanoid.Health > 0 and isEnemy(player) then
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
               local headVector = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
               local legVector = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
               
               local height = math.abs(headVector.Y - legVector.Y)
               local width = height * 0.55
               local boxPos = Vector2.new(vector.X - width / 2, headVector.Y)
               local boxSize = Vector2.new(width, height)

               -- Box ESP
               if getgenv().HypershotSettings.BoxESP then
                  cache.Box.Size = boxSize
                  cache.Box.Position = boxPos
                  cache.Box.Color = getgenv().HypershotSettings.BoxColor
                  cache.Box.Visible = true
               else
                  cache.Box.Visible = false
               end

               -- Name & Health Bars
               if getgenv().HypershotSettings.NameESP then
                  cache.NameText.Text = player.Name .. " [" .. math.floor(humanoid.Health) .. "HP]"
                  cache.NameText.Position = Vector2.new(vector.X, boxPos.Y - 16)
                  cache.NameText.Visible = true

                  local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                  local barHeight = height * healthPercent
                  
                  cache.HealthBarOutline.Position = Vector2.new(boxPos.X - 6, boxPos.Y)
                  cache.HealthBarOutline.Size = Vector2.new(3, height)
                  cache.HealthBarOutline.Visible = true

                  cache.HealthBar.Position = Vector2.new(boxPos.X - 5, boxPos.Y + (height - barHeight))
                  cache.HealthBar.Size = Vector2.new(1, barHeight)
                  cache.HealthBar.Color = Color3.fromRGB(255 - (healthPercent * 255), healthPercent * 255, 0)
                  cache.HealthBar.Visible = true
               else
                  cache.NameText.Visible = false
                  cache.HealthBar.Visible = false
                  cache.HealthBarOutline.Visible = false
               end

               -- Snaplines
               if getgenv().HypershotSettings.Snaplines then
                  cache.Snapline.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                  cache.Snapline.To = Vector2.new(vector.X, vector.Y)
                  cache.Snapline.Color = getgenv().HypershotSettings.SnaplineColor
                  cache.Snapline.Visible = true
               else
                  cache.Snapline.Visible = false
               end

               -- Skeleton ESP
               if getgenv().HypershotSettings.SkeletonESP and targetChar:FindFirstChild("UpperTorso") then
                  local torso = targetChar.UpperTorso
                  local upperTorsoScreen = Camera:WorldToViewportPoint(torso.Position)
                  local headScreen = Camera:WorldToViewportPoint(head.Position)
                  
                  cache.SkeletonLines[1].From = Vector2.new(headScreen.X, headScreen.Y)
                  cache.SkeletonLines[1].To = Vector2.new(upperTorsoScreen.X, upperTorsoScreen.Y)
                  cache.SkeletonLines[1].Color = getgenv().HypershotSettings.SkeletonColor
                  cache.SkeletonLines[1].Visible = true

                  for i = 2, 5 do
                     cache.SkeletonLines[i].Visible = false
                  end
               else
                  for _, line in ipairs(cache.SkeletonLines) do line.Visible = false end
               end
            else
               cache.Box.Visible = false
               cache.NameText.Visible = false
               cache.HealthBar.Visible = false
               cache.HealthBarOutline.Visible = false
               cache.Snapline.Visible = false
               for _, line in ipairs(cache.SkeletonLines) do line.Visible = false end
            end
         else
            cache.Box.Visible = false
            cache.NameText.Visible = false
            cache.HealthBar.Visible = false
            cache.HealthBarOutline.Visible = false
            cache.Snapline.Visible = false
            for _, line in ipairs(cache.SkeletonLines) do line.Visible = false end
         end
      end
   end

   -- Rage Snap Bot Logic
   if getgenv().HypershotSettings.RageAimbot then
      local bestTarget = getBestTarget(getgenv().HypershotSettings.RageFOV, getgenv().HypershotSettings.RageHitbox)
      if bestTarget then
         local targetCFrame = CFrame.new(Camera.CFrame.Position, bestTarget.Position)
         Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 0.6)
      end
   end
end)

-- Chams Glow Injection Loop
RunService.Heartbeat:Connect(function()
   for _, player in ipairs(Players:GetPlayers()) do
      if player ~= LocalPlayer then
         local char = player.Character
         if char then
            local highlight = char:FindFirstChild("HypershotGlowChams")
            if getgenv().HypershotSettings.Chams and isEnemy(player) then
               if not highlight then
                  highlight = Instance.new("Highlight")
                  highlight.Name = "HypershotGlowChams"
                  highlight.Adornee = char
                  highlight.Parent = char
               end
               highlight.FillColor = getgenv().HypershotSettings.ChamsFillColor
               highlight.OutlineColor = getgenv().HypershotSettings.ChamsOutlineColor
               highlight.FillTransparency = 0.3
               highlight.OutlineTransparency = 0
               highlight.Enabled = true
            else
               if highlight then
                  highlight.Enabled = false
               end
            end
         end
      end
   end
end)

Rayfield:LoadConfiguration()
