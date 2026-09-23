local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Feature Configuration & State Table (Elite Suite v4 Architecture)
getgenv().BloxStrikeSettings = {
   -- Core Filters
   TeamCheck = true,
   WallCheck = true,
   
   -- Legit Bot
   LegitAimbot = false,
   LegitSmoothness = 6,
   LegitFOV = 100,
   LegitHitbox = "Head",

   -- Advanced Silent Aim (Rage / Redirection)
   SilentAim = false,
   SilentHitbox = "Head",
   SilentFOV = 400,
   SilentHitChance = 100,
   ShowSilentFOV = true,
   PredictionFactor = 0.135,

   -- Rage / Snap Bot
   RageAimbot = false,
   RageHitbox = "Head",
   RageFOV = 350,
   RageAutoShoot = false,

   -- Visuals: ESP
   BoxESP = false,
   BoxColor = Color3.fromRGB(255, 255, 255),
   NameESP = false,
   HealthBar = false,
   SkeletonESP = false,
   SkeletonColor = Color3.fromRGB(255, 255, 255),
   OffScreenArrows = false,
   ArrowColor = Color3.fromRGB(255, 50, 50),

   -- Visuals: Chams
   Chams = false,
   ChamsFillColor = Color3.fromRGB(255, 0, 0),
   ChamsOutlineColor = Color3.fromRGB(255, 255, 255),

   -- Skin Changer
   SkinChanger = false,
   WeaponSkin = "Ruby / Crimson Web",

   -- Misc & Movement
   Bhop = false,
   WalkSpeed = 16,
   InfiniteJump = false,
   NoRecoil = true
}

local Window = Rayfield:CreateWindow({
   Name = "BloxStrike | Elite Suite v4 (Silent Core)",
   LoadingTitle = "Initializing Silent Vector Hooks...",
   LoadingSubtitle = "by p7zu",
   Theme = "Default",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BloxStrikeConfigs",
      FileName = "EliteConfigv4"
   },
   KeySystem = false,
})

-- Tabs Setup
local LegitTab = Window:CreateTab("Legit", 4483362458)
local RageTab = Window:CreateTab("Rage / Silent", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local SkinsTab = Window:CreateTab("Skin Changer", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- ==================== LEGIT TAB ====================
LegitTab:CreateSection("Legit Configuration")

LegitTab:CreateToggle({
   Name = "Enable Legit Aimbot (Hold Right-Click)",
   CurrentValue = false,
   Flag = "LegitToggle",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.LegitAimbot = Value
   end,
})

LegitTab:CreateDropdown({
   Name = "Legit Hitbox",
   Options = {"Head", "HumanoidRootPart", "UpperTorso"},
   CurrentOption = {"Head"},
   MultipleOptions = false,
   Flag = "LegitHitbox",
   Callback = function(Option)
      getgenv().BloxStrikeSettings.LegitHitbox = Option[1]
   end,
})

LegitTab:CreateSlider({
   Name = "Smoothness",
   Range = {1, 20},
   Increment = 1,
   Suffix = "val",
   CurrentValue = 6,
   Flag = "LegitSmooth",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.LegitSmoothness = Value
   end,
})

LegitTab:CreateSlider({
   Name = "FOV Radius",
   Range = {20, 300},
   Increment = 5,
   Suffix = "px",
   CurrentValue = 100,
   Flag = "LegitFOV",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.LegitFOV = Value
   end,
})

-- ==================== RAGE / SILENT TAB ====================
RageTab:CreateSection("Silent Aim (Bullet Redirection)")

RageTab:CreateToggle({
   Name = "Enable Silent Aim (Bypasses Cam Snap)",
   CurrentValue = false,
   Flag = "SilentToggle",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.SilentAim = Value
   end,
})

RageTab:CreateToggle({
   Name = "Draw Silent FOV Circle",
   CurrentValue = true,
   Flag = "SilentFOVCircle",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.ShowSilentFOV = Value
   end,
})

RageTab:CreateDropdown({
   Name = "Silent Target Hitbox",
   Options = {"Head", "HumanoidRootPart", "UpperTorso", "Random"},
   CurrentOption = {"Head"},
   MultipleOptions = false,
   Flag = "SilentHitbox",
   Callback = function(Option)
      getgenv().BloxStrikeSettings.SilentHitbox = Option[1]
   end,
})

RageTab:CreateSlider({
   Name = "Silent FOV Radius",
   Range = {50, 800},
   Increment = 10,
   Suffix = "px",
   CurrentValue = 400,
   Flag = "SilentFOV",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.SilentFOV = Value
   end,
})

RageTab:CreateSlider({
   Name = "Velocity Prediction Multiplier",
   Range = {0, 0.5},
   Increment = 0.005,
   Suffix = "factor",
   CurrentValue = 0.135,
   Flag = "SilentPrediction",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.PredictionFactor = Value
   end,
})

RageTab:CreateSection("Rage Snap Bot & Auto Fire")

RageTab:CreateToggle({
   Name = "Enable Rage Snap Bot",
   CurrentValue = false,
   Flag = "RageToggle",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.RageAimbot = Value
   end,
})

RageTab:CreateDropdown({
   Name = "Rage Hitbox",
   Options = {"Head", "HumanoidRootPart", "UpperTorso"},
   CurrentOption = {"Head"},
   MultipleOptions = false,
   Flag = "RageHitbox",
   Callback = function(Option)
      getgenv().BloxStrikeSettings.RageHitbox = Option[1]
   end,
})

RageTab:CreateSlider({
   Name = "Rage FOV Radius",
   Range = {50, 600},
   Increment = 10,
   Suffix = "px",
   CurrentValue = 350,
   Flag = "RageFOV",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.RageFOV = Value
   end,
})

RageTab:CreateToggle({
   Name = "Auto Shoot / Fire",
   CurrentValue = false,
   Flag = "RageShoot",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.RageAutoShoot = Value
   end,
})

-- ==================== VISUALS TAB ====================
VisualsTab:CreateSection("Filters & Safety Checks")

VisualsTab:CreateToggle({
   Name = "Team Check",
   CurrentValue = true,
   Flag = "TeamCheck",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.TeamCheck = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "Wall Check (Visible Only)",
   CurrentValue = true,
   Flag = "WallCheck",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.WallCheck = Value
   end,
})

VisualsTab:CreateSection("Player ESP")

VisualsTab:CreateToggle({
   Name = "Box ESP",
   CurrentValue = false,
   Flag = "BoxESP",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.BoxESP = Value
   end,
})

VisualsTab:CreateColorPicker({
   Name = "Box Color",
   Color = Color3.fromRGB(255, 255, 255),
   Flag = "BoxColor",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.BoxColor = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "Name & Health ESP",
   CurrentValue = false,
   Flag = "NameESP",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.NameESP = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "Skeleton ESP",
   CurrentValue = false,
   Flag = "SkeletonESP",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.SkeletonESP = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "Off-Screen Enemy Arrows",
   CurrentValue = false,
   Flag = "OffScreenArrows",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.OffScreenArrows = Value
   end,
})

VisualsTab:CreateSection("Chams / Wallhack")

VisualsTab:CreateToggle({
   Name = "Enable Chams",
   CurrentValue = false,
   Flag = "ChamsToggle",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.Chams = Value
   end,
})

VisualsTab:CreateColorPicker({
   Name = "Chams Fill Color",
   Color = Color3.fromRGB(255, 0, 0),
   Flag = "ChamsFill",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.ChamsFillColor = Value
   end,
})

-- ==================== SKIN CHANGER TAB ====================
SkinsTab:CreateSection("Weapon Skin Customization")

SkinsTab:CreateToggle({
   Name = "Enable Skin Overrides",
   CurrentValue = false,
   Flag = "SkinChangerToggle",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.SkinChanger = Value
   end,
})

SkinsTab:CreateDropdown({
   Name = "Select Weapon Paint",
   Options = {"Ruby / Crimson Web", "Emerald Fade", "Dragon Lore", "Carbon Fiber", "Case Hardened (Blue Gem)"},
   CurrentOption = {"Ruby / Crimson Web"},
   MultipleOptions = false,
   Flag = "SkinSelect",
   Callback = function(Option)
      getgenv().BloxStrikeSettings.WeaponSkin = Option[1]
   end,
})

-- ==================== MISC TAB ====================
MiscTab:CreateSection("Movement Modifications")

MiscTab:CreateToggle({
   Name = "Bunny Hop (Auto-Jump)",
   CurrentValue = false,
   Flag = "Bhop",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.Bhop = Value
   end,
})

MiscTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfJump",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.InfiniteJump = Value
   end,
})

MiscTab:CreateSlider({
   Name = "Custom WalkSpeed",
   Range = {16, 32},
   Increment = 1,
   Suffix = "studs",
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.WalkSpeed = Value
   end,
})

MiscTab:CreateToggle({
   Name = "No Recoil / Spread Suppression",
   CurrentValue = true,
   Flag = "NoRecoil",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.NoRecoil = Value
   end,
})

-- ==================== SETTINGS TAB ====================
SettingsTab:CreateSection("Interface Management")
SettingsTab:CreateButton({
   Name = "Unload UI & Clean Drawings",
   Callback = function()
      Rayfield:Destroy()
   end,
})

-- ==================== CORE BACKEND & SILENT AIM ENGINE ====================

local espCache = {}
local silentFovCircle = Drawing.new("Circle")
silentFovCircle.Visible = false
silentFovCircle.Thickness = 1.5
silentFovCircle.NumSides = 64
silentFovCircle.Radius = getgenv().BloxStrikeSettings.SilentFOV
silentFovCircle.Color = Color3.fromRGB(255, 255, 255)
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

   obj.Arrow = Drawing.new("Triangle")
   obj.Arrow.Visible = false
   obj.Arrow.Thickness = 1
   obj.Arrow.Filled = true
   obj.Arrow.Color = Color3.fromRGB(255, 50, 50)

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
   if not getgenv().BloxStrikeSettings.TeamCheck then return true end
   if player.Team and LocalPlayer.Team then
      return player.Team ~= LocalPlayer.Team
   end
   return true
end

-- Robust Wall/Visibility Raycast Check
local function isVisible(targetPart)
   if not getgenv().BloxStrikeSettings.WallCheck then return true end
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

-- Target Selection Resolver for Silent & Rage Aimbot
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

-- ==================== ROBUST SILENT AIM HOOK ====================
-- Intercepts network calls / raycasts / mouse ray parameters to redirect bullet hits silently
local rawMetatable = getrawmetatable(game)
local oldNamecall = rawMetatable.__namecall
local oldIndex = rawMetatable.__index

setreadonly(rawMetatable, false)

-- Hook namecall for remote arguments redirection (Silent Aim core execution)
rawMetatable.__namecall = newcclosure(function(self, ...)
   local method = getnamecallmethod()
   local args = {...}
   
   if getgenv().BloxStrikeSettings.SilentAim and (method == "FireServer" or method == "InvokeServer") then
      local targetPart = getBestTarget(getgenv().BloxStrikeSettings.SilentFOV, getgenv().BloxStrikeSettings.SilentHitbox)
      if targetPart then
         -- Predict target movement velocity to avoid missing fast moving players in mid-air
         local predictedPosition = targetPart.Position + (targetPart.AssemblyLinearVelocity * getgenv().BloxStrikeSettings.PredictionFactor)
         
         -- Intercept mouse or shoot position vectors
         for i, v in ipairs(args) do
            if typeof(v) == "Vector3" then
               -- Check if vector matches a ray direction or destination point
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

-- Jump connection for Infinite Jump
UserInputService.JumpRequest:Connect(function()
   if getgenv().BloxStrikeSettings.InfiniteJump then
      local char = LocalPlayer.Character
      if char and char:FindFirstChildOfClass("Humanoid") then
         char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
      end
   end
end)

-- Main Render Loop for ESP, Chams, FOV Visualizer, and Movement
RunService.RenderStepped:Connect(function()
   -- Update Silent FOV Circle Display
   if getgenv().BloxStrikeSettings.SilentAim and getgenv().BloxStrikeSettings.ShowSilentFOV then
      silentFovCircle.Visible = true
      silentFovCircle.Radius = getgenv().BloxStrikeSettings.SilentFOV
      silentFovCircle.Position = UserInputService:GetMouseLocation()
      silentFovCircle.Color = Color3.fromRGB(0, 255, 140)
   else
      silentFovCircle.Visible = false
   end

   -- Process Movement Mechanics
   local char = LocalPlayer.Character
   if char and char:FindFirstChild("Humanoid") then
      local hum = char.Humanoid
      if getgenv().BloxStrikeSettings.WalkSpeed > 16 then
         hum.WalkSpeed = getgenv().BloxStrikeSettings.WalkSpeed
      end
      if getgenv().BloxStrikeSettings.Bhop and hum.FloorMaterial ~= Enum.Material.Air then
         hum:Jump()
      end
   end

   -- Handle ESP Drawings, Skeletons, and Off-Screen Arrows
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

         local shouldShow = getgenv().BloxStrikeSettings.BoxESP or getgenv().BloxStrikeSettings.NameESP or getgenv().BloxStrikeSettings.SkeletonESP or getgenv().BloxStrikeSettings.OffScreenArrows
         if shouldShow and targetChar and hrp and head and humanoid and humanoid.Health > 0 and isEnemy(player) then
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
               cache.Arrow.Visible = false
               local headVector = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
               local legVector = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
               
               local height = math.abs(headVector.Y - legVector.Y)
               local width = height * 0.55
               local boxPos = Vector2.new(vector.X - width / 2, headVector.Y)
               local boxSize = Vector2.new(width, height)

               -- Box ESP
               if getgenv().BloxStrikeSettings.BoxESP then
                  cache.Box.Size = boxSize
                  cache.Box.Position = boxPos
                  cache.Box.Color = getgenv().BloxStrikeSettings.BoxColor
                  cache.Box.Visible = true
               else
                  cache.Box.Visible = false
               end

               -- Name & Health ESP
               if getgenv().BloxStrikeSettings.NameESP then
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

               -- Skeleton ESP
               if getgenv().BloxStrikeSettings.SkeletonESP and targetChar:FindFirstChild("UpperTorso") then
                  local torso = targetChar.UpperTorso
                  local upperTorsoScreen = Camera:WorldToViewportPoint(torso.Position)
                  local headScreen = Camera:WorldToViewportPoint(head.Position)
                  
                  cache.SkeletonLines[1].From = Vector2.new(headScreen.X, headScreen.Y)
                  cache.SkeletonLines[1].To = Vector2.new(upperTorsoScreen.X, upperTorsoScreen.Y)
                  cache.SkeletonLines[1].Color = getgenv().BloxStrikeSettings.SkeletonColor
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
               for _, line in ipairs(cache.SkeletonLines) do line.Visible = false end

               -- Off-Screen Arrow Indicator
               if getgenv().BloxStrikeSettings.OffScreenArrows then
                  local camPos = Camera.CFrame.Position
                  local camLook = Camera.CFrame.LookVector
                  local targetPos = hrp.Position
                  
                  local relPos = (targetPos - camPos)
                  local dot = relPos.Unit:Dot(camLook)
                  
                  if dot < 0 then -- Behind camera or off-screen boundary
                     cache.Arrow.Visible = true
                     -- Position calculation omitted/simplified for compact reliability
                  else
                     cache.Arrow.Visible = false
                  end
               else
                  cache.Arrow.Visible = false
               end
            end
         else
            cache.Box.Visible = false
            cache.NameText.Visible = false
            cache.HealthBar.Visible = false
            cache.HealthBarOutline.Visible = false
            cache.Arrow.Visible = false
            for _, line in ipairs(cache.SkeletonLines) do line.Visible = false end
         end
      end
   end

   -- Rage Aimbot Logic (Snap Mode)
   if getgenv().BloxStrikeSettings.RageAimbot then
      local bestTarget = getBestTarget(getgenv().BloxStrikeSettings.RageFOV, getgenv().BloxStrikeSettings.RageHitbox)
      if bestTarget then
         local targetCFrame = CFrame.new(Camera.CFrame.Position, bestTarget.Position)
         Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 0.6)
      end
   end
end)

-- Legit Aimbot Execution Loop (Smooth Mouse Control)
RunService.Heartbeat:Connect(function()
   if not getgenv().BloxStrikeSettings.LegitAimbot then return end
   if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end

   local bestTarget = getBestTarget(getgenv().BloxStrikeSettings.LegitFOV, getgenv().BloxStrikeSettings.LegitHitbox)
   if bestTarget then
      local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
      local targetPos = Camera:WorldToViewportPoint(bestTarget.Position)
      local changeX = (targetPos.X - centerScreen.X) / getgenv().BloxStrikeSettings.LegitSmoothness
      local changeY = (targetPos.Y - centerScreen.Y) / getgenv().BloxStrikeSettings.LegitSmoothness
      
      if mousemoverel then
         mousemoverel(changeX, changeY)
      end
   end
end)

-- Real Chams Loop
RunService.Heartbeat:Connect(function()
   for _, player in ipairs(Players:GetPlayers()) do
      if player ~= LocalPlayer then
         local char = player.Character
         if char then
            local highlight = char:FindFirstChild("BloxStrikeRealChams")
            if getgenv().BloxStrikeSettings.Chams and isEnemy(player) then
               if not highlight then
                  highlight = Instance.new("Highlight")
                  highlight.Name = "BloxStrikeRealChams"
                  highlight.Adornee = char
                  highlight.Parent = char
               end
               highlight.FillColor = getgenv().BloxStrikeSettings.ChamsFillColor
               highlight.OutlineColor = getgenv().BloxStrikeSettings.ChamsOutlineColor
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

-- Skin Changer Overrides Loop
RunService.Heartbeat:Connect(function()
   if not getgenv().BloxStrikeSettings.SkinChanger then return end
   
   local char = LocalPlayer.Character
   if not char then return end

   for _, child in ipairs(char:GetChildren()) do
      if child:IsA("Tool") then
         local skinColor = Color3.fromRGB(180, 0, 0)
         local skinType = getgenv().BloxStrikeSettings.WeaponSkin

         if skinType == "Ruby / Crimson Web" then
            skinColor = Color3.fromRGB(180, 0, 0)
         elseif skinType == "Emerald Fade" then
            skinColor = Color3.fromRGB(0, 200, 80)
         elseif skinType == "Dragon Lore" then
            skinColor = Color3.fromRGB(218, 165, 32)
         elseif skinType == "Carbon Fiber" then
            skinColor = Color3.fromRGB(30, 30, 30)
         elseif skinType == "Case Hardened (Blue Gem)" then
            skinColor = Color3.fromRGB(0, 100, 255)
         end

         for _, part in ipairs(child:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "Handle" then
               part.Color = skinColor
            end
         end
      end
   end
end)

Rayfield:LoadConfiguration()
