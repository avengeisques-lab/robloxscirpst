local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Feature Configuration Table
getgenv().BloxStrikeSettings = {
   -- General / Security
   TeamCheck = true,

   -- Legit Bot
   LegitAimbot = false,
   LegitKey = Enum.UserInputType.MouseButton2, -- Right Click
   LegitSmoothness = 5,
   LegitFOV = 120,
   LegitHitbox = "Head",

   -- Rage Bot
   RageAimbot = false,
   RageHitbox = "Head",
   RageFOV = 300,

   -- Visuals: Box ESP
   BoxESP = false,
   BoxColor = Color3.fromRGB(255, 255, 255),

   -- Visuals: Name & Health ESP
   NameESP = false,
   HealthBar = false,

   -- Visuals: Real Chams (Material Override / SurfaceAppearance replacement style)
   Chams = false,
   ChamsFillColor = Color3.fromRGB(255, 0, 0),
   ChamsOutlineColor = Color3.fromRGB(255, 255, 255),

   -- Misc
   Bhop = false,
   WalkSpeed = 16
}

local Window = Rayfield:CreateWindow({
   Name = "BloxStrike | Advanced Hub",
   LoadingTitle = "BloxStrike Suite",
   LoadingSubtitle = "by p7zu",
   Theme = "Default",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BloxStrikeConfigs",
      FileName = "AdvancedConfig"
   },
   KeySystem = false,
})

-- Tabs Setup
local LegitTab = Window:CreateTab("Legit", 4483362458)
local RageTab = Window:CreateTab("Rage", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- ==================== LEGIT TAB ====================
LegitTab:CreateSection("Legit Aimbot")

LegitTab:CreateToggle({
   Name = "Enable Legit Aimbot",
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
   CurrentValue = 5,
   Flag = "LegitSmooth",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.LegitSmoothness = Value
   end,
})

LegitTab:CreateSlider({
   Name = "FOV Radius",
   Range = {30, 400},
   Increment = 5,
   Suffix = "px",
   CurrentValue = 120,
   Flag = "LegitFOV",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.LegitFOV = Value
   end,
})

-- ==================== RAGE TAB ====================
RageTab:CreateSection("Rage Bot")

RageTab:CreateToggle({
   Name = "Enable Rage Aimbot (Snap)",
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
   CurrentValue = 300,
   Flag = "RageFOV",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.RageFOV = Value
   end,
})

-- ==================== VISUALS TAB ====================
VisualsTab:CreateSection("ESP & Chams Controls")

VisualsTab:CreateToggle({
   Name = "Team Check (Ignore Teammates)",
   CurrentValue = true,
   Flag = "TeamCheck",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.TeamCheck = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "Player Box ESP",
   CurrentValue = false,
   Flag = "BoxESP",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.BoxESP = Value
   end,
})

VisualsTab:CreateColorPicker({
   Name = "Box ESP Color",
   Color = Color3.fromRGB(255, 255, 255),
   Flag = "BoxColor",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.BoxColor = Value
   end
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
   Name = "Real Chams (Through Walls)",
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
   end
})

-- ==================== MISC TAB ====================
MiscTab:CreateSection("Movement")

MiscTab:CreateToggle({
   Name = "Bunny Hop",
   CurrentValue = false,
   Flag = "Bhop",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.Bhop = Value
   end,
})

MiscTab:CreateSlider({
   Name = "WalkSpeed Multiplier",
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
SettingsTab:CreateSection("Configuration")
SettingsTab:CreateButton({
   Name = "Unload UI & Clear",
   Callback = function()
      Rayfield:Destroy()
   end,
})

-- ==================== BACKEND EXECUTION & DRAWING API ====================

local espCache = {}

local function createDrawingObjects(player)
   local obj = {}
   obj.Box = Drawing.new("Square")
   obj.Box.Visible = false
   obj.Box.Thickness = 1.5
   obj.Box.Filled = false

   obj.NameText = Drawing.new("Text")
   obj.NameText.Visible = false
   obj.NameText.Size = 14
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

   espCache[player] = obj
end

local function removeDrawingObjects(player)
   if espCache[player] then
      for _, drawing in pairs(espCache[player]) do
         drawing:Remove()
      end
      espCache[player] = nil
   end
end

Players.PlayerRemoving:Connect(removeDrawingObjects)

-- Utility to verify team boundaries safely
local function isEnemy(player)
   if not getgenv().BloxStrikeSettings.TeamCheck then return true end
   if player.Team and LocalPlayer.Team then
      return player.Team ~= LocalPlayer.Team
   end
   return true
end

-- Render loop for Visuals (Boxes, Names, Health) & Aim targets
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

   -- Handle ESP Drawings
   for _, player in ipairs(Players:GetPlayers()) do
      if player ~= LocalPlayer then
         if not espCache[player] then
            createDrawingObjects(player)
         end

         local cache = espCache[player]
         local targetChar = player.Character
         local hrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
         local humanoid = targetChar and targetChar:FindFirstChild("Humanoid")

         local shouldShow = getgenv().BloxStrikeSettings.BoxESP or getgenv().BloxStrikeSettings.NameESP
         if shouldShow and targetChar and hrp and humanoid and humanoid.Health > 0 and isEnemy(player) then
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
               local head = targetChar:FindFirstChild("Head")
               local headVector = head and Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)) or vector
               local legVector = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
               
               local height = math.abs(headVector.Y - legVector.Y)
               local width = height * 0.55
               local boxPos = Vector2.new(vector.X - width / 2, headVector.Y)
               local boxSize = Vector2.new(width, height)

               -- Box ESP Update
               if getgenv().BloxStrikeSettings.BoxESP then
                  cache.Box.Size = boxSize
                  cache.Box.Position = boxPos
                  cache.Box.Color = getgenv().BloxStrikeSettings.BoxColor
                  cache.Box.Visible = true
               else
                  cache.Box.Visible = false
               end

               -- Name & Health ESP Update
               if getgenv().BloxStrikeSettings.NameESP then
                  cache.NameText.Text = player.Name .. " [" .. math.floor(humanoid.Health) .. "HP]"
                  cache.NameText.Position = Vector2.new(vector.X, boxPos.Y - 18)
                  cache.NameText.Visible = true

                  -- Health bar layout
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
            else
               cache.Box.Visible = false
               cache.NameText.Visible = false
               cache.HealthBar.Visible = false
               cache.HealthBarOutline.Visible = false
            end
         else
            cache.Box.Visible = false
            cache.NameText.Visible = false
            cache.HealthBar.Visible = false
            cache.HealthBarOutline.Visible = false
         end
      end
   end

   -- Rage Aimbot Logic (Instant Screen Snap)
   if getgenv().BloxStrikeSettings.RageAimbot then
      local bestTarget = nil
      local shortestDist = getgenv().BloxStrikeSettings.RageFOV
      local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

      for _, player in ipairs(Players:GetPlayers()) do
         if player ~= LocalPlayer and isEnemy(player) then
            local char = player.Character
            local hitbox = char and char:FindFirstChild(getgenv().BloxStrikeSettings.RageHitbox)
            local hum = char and char:FindFirstChild("Humanoid")
            
            if hitbox and hum and hum.Health > 0 then
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
         Camera.CFrame = CFrame.new(Camera.CFrame.Position, bestTarget.Position)
      end
   end
end)

-- Legit Aimbot (Interpolated Smooth Mouse Tracking on Right-Click)
RunService.Heartbeat:Connect(function()
   if not getgenv().BloxStrikeSettings.LegitAimbot then return end
   
   -- Check if holding aim key (Right Mouse Button)
   local UserInputService = game:GetService("UserInputService")
   if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end

   local bestTarget = nil
   local shortestDist = getgenv().BloxStrikeSettings.LegitFOV
   local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

   for _, player in ipairs(Players:GetPlayers()) do
      if player ~= LocalPlayer and isEnemy(player) then
         local char = player.Character
         local hitbox = char and char:FindFirstChild(getgenv().BloxStrikeSettings.LegitHitbox)
         local hum = char and char:FindFirstChild("Humanoid")
         
         if hitbox and hum and hum.Health > 0 then
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
      local currentMousePos = centerScreen
      local changeX = (targetPos.X - currentMousePos.X) / getgenv().BloxStrikeSettings.LegitSmoothness
      local changeY = (targetPos.Y - currentMousePos.Y) / getgenv().BloxStrikeSettings.LegitSmoothness
      
      mousemoverel(changeX, changeY)
   end
end)

-- Real Chams Loop via Instance Highlights
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

Rayfield:LoadConfiguration()
