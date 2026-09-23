local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Feature Configuration & State Table
getgenv().BloxStrikeSettings = {
   -- Core Filters
   TeamCheck = true,
   WallCheck = true,
   
   -- Legit Bot
   LegitAimbot = false,
   LegitSmoothness = 6,
   LegitFOV = 100,
   LegitHitbox = "Head",

   -- Rage Bot
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
   InfiniteJump = false
}

local Window = Rayfield:CreateWindow({
   Name = "BloxStrike | Elite Suite v3",
   LoadingTitle = "BloxStrike Loading Suite",
   LoadingSubtitle = "by p7zu",
   Theme = "Default",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BloxStrikeConfigs",
      FileName = "EliteConfigv3"
   },
   KeySystem = false,
})

-- Tabs Setup
local LegitTab = Window:CreateTab("Legit", 4483362458)
local RageTab = Window:CreateTab("Rage", 4483362458)
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

-- ==================== RAGE TAB ====================
RageTab:CreateSection("Rage Configuration")

RageTab:CreateToggle({
   Name = "Enable Rage Bot (Silent Snap)",
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

-- ==================== SETTINGS TAB ====================
SettingsTab:CreateSection("Interface Management")
SettingsTab:CreateButton({
   Name = "Unload UI & Clean Drawings",
   Callback = function()
      Rayfield:Destroy()
   end,
})

-- ==================== BACKEND EXECUTION LOGIC ====================

local espCache = {}

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
   return result == nil -- Returns true if nothing blocks line of sight
end

-- Jump connection for Infinite Jump
UserInputService.JumpRequest:Connect(function()
   if getgenv().BloxStrikeSettings.InfiniteJump then
      local char = LocalPlayer.Character
      if char and char:FindFirstChildOfClass("Humanoid") then
         char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
      end
   end
end)

-- Main Render Loop for ESP, Chams, and Movement
RunService.RenderStepped:Connect(function()
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

   -- Handle ESP Drawings & Skeletons
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

         local shouldShow = getgenv().BloxStrikeSettings.BoxESP or getgenv().BloxStrikeSettings.NameESP or getgenv().BloxStrikeSettings.SkeletonESP
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
            end
         else
            cache.Box.Visible = false
            cache.NameText.Visible = false
            cache.HealthBar.Visible = false
            cache.HealthBarOutline.Visible = false
            for _, line in ipairs(cache.SkeletonLines) do line.Visible = false end
         end
      end
   end

   -- Fixed Rage Aimbot Logic (Stable, No Wild Flicks, Checks Visibility)
   if getgenv().BloxStrikeSettings.RageAimbot then
      local bestTarget = nil
      local shortestDist = getgenv().BloxStrikeSettings.RageFOV
      local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

      for _, player in ipairs(Players:GetPlayers()) do
         if player ~= LocalPlayer and isEnemy(player) then
            local char = player.Character
            local hitbox = char and char:FindFirstChild(getgenv().BloxStrikeSettings.RageHitbox)
            local hum = char and char:FindFirstChild("Humanoid")
            
            if hitbox and hum and hum.Health > 0 and isVisible(hitbox) then
               local pos, onScreen = Camera:WorldToViewportPoint(hitbox.Position)
               if onScreen then
                  local dist = (Vector2.new(pos.X, pos.Y) - centerScreen).Magnitude
                  if dist < shortestDist then
                     shortestDist = dist
                     bestTarget = hitbox
                  end
               end
            end
         end
      end

      if bestTarget then
         local targetCFrame = CFrame.new(Camera.CFrame.Position, bestTarget.Position)
         Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 0.45)
      end
   end
end)

-- Legit Aimbot Execution Loop (Smooth Mouse Control)
RunService.Heartbeat:Connect(function()
   if not getgenv().BloxStrikeSettings.LegitAimbot then return end
   if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end

   local bestTarget = nil
   local shortestDist = getgenv().BloxStrikeSettings.LegitFOV
   local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

   for _, player in ipairs(Players:GetPlayers()) do
      if player ~= LocalPlayer and isEnemy(player) then
         local char = player.Character
         local hitbox = char and char:FindFirstChild(getgenv().BloxStrikeSettings.LegitHitbox)
         local hum = char and char:FindFirstChild("Humanoid")
         
         if hitbox and hum and hum.Health > 0 and isVisible(hitbox) then
            local pos, onScreen = Camera:WorldToViewportPoint(hitbox.Position)
            if onScreen then
               local dist = (Vector2.new(pos.X, pos.Y) - centerScreen).Magnitude
               if dist < shortestDist then
                  shortestDist = dist
                  bestTarget = hitbox
               end
            end
         end
      end
   end

   if bestTarget then
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
