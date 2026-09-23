local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Feature States
getgenv().BloxStrikeSettings = {
   BoxESP = false,
   NameESP = false,
   Chams = false,
   ChamsColor = Color3.fromRGB(255, 0, 0),
   RageAimbot = false,
   TargetHitbox = "Head",
   AimbotFOV = 90,
   NoRecoil = false,
   RapidFire = false,
   Bhop = false,
   WalkSpeed = 16
}

local Window = Rayfield:CreateWindow({
   Name = "BloxStrike | Premium Hub",
   LoadingTitle = "BloxStrike Interface Suite",
   LoadingSubtitle = "by p7zu",
   Theme = "Default",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BloxStrikeConfigs",
      FileName = "MainConfig"
   },
   KeySystem = false,
})

-- Tabs Setup
local CombatTab = Window:CreateTab("Rage / Combat", 4483362458)
local VisualsTab = Window:CreateTab("Visuals (ESP)", 4483362458)
local MiscTab = Window:CreateTab("Misc & Movement", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- ==================== COMBAT / RAGE TAB ====================
CombatTab:CreateSection("Rage Bot Settings")

CombatTab:CreateToggle({
   Name = "Rage Aimbot (Camera Snap)",
   CurrentValue = false,
   Flag = "RageAimbot",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.RageAimbot = Value
   end,
})

CombatTab:CreateDropdown({
   Name = "Target Hitbox",
   Options = {"Head", "HumanoidRootPart", "Chest"},
   CurrentOption = {"Head"},
   MultipleOptions = false,
   Flag = "TargetHitbox",
   Callback = function(Option)
      getgenv().BloxStrikeSettings.TargetHitbox = Option[1]
   end,
})

CombatTab:CreateSlider({
   Name = "Aimbot FOV Radius",
   Range = {30, 300},
   Increment = 5,
   Suffix = "px",
   CurrentValue = 90,
   Flag = "AimbotFOV",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.AimbotFOV = Value
   end,
})

CombatTab:CreateSection("Weapon Modifiers")

CombatTab:CreateToggle({
   Name = "No Recoil / No Spread",
   CurrentValue = false,
   Flag = "NoRecoil",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.NoRecoil = Value
   end,
})

-- ==================== VISUALS TAB ====================
VisualsTab:CreateSection("ESP Player Settings")

VisualsTab:CreateToggle({
   Name = "Player Box ESP (Drawing API)",
   CurrentValue = false,
   Flag = "BoxESP",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.BoxESP = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "Chams / Highlight Fill",
   CurrentValue = false,
   Flag = "ChamsToggle",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.Chams = Value
   end,
})

VisualsTab:CreateColorPicker({
   Name = "Chams Color",
   Color = Color3.fromRGB(255, 0, 0),
   Flag = "ChamsColor",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.ChamsColor = Value
   end
})

-- ==================== MISC TAB ====================
MiscTab:CreateSection("Movement & Utilities")

MiscTab:CreateToggle({
   Name = "Bunny Hop (Auto-Jump)",
   CurrentValue = false,
   Flag = "BhopToggle",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.Bhop = Value
   end,
})

MiscTab:CreateSlider({
   Name = "Custom WalkSpeed",
   Range = {16, 32},
   Increment = 1,
   Suffix = "studs",
   CurrentValue = 16,
   Flag = "WalkSpeedSlider",
   Callback = function(Value)
      getgenv().BloxStrikeSettings.WalkSpeed = Value
   end,
})

-- ==================== SETTINGS TAB ====================
SettingsTab:CreateSection("UI Configuration")
SettingsTab:CreateButton({
   Name = "Unload UI",
   Callback = function()
      Rayfield:Destroy()
   end,
})

-- ==================== BACKEND EXECUTION LOGIC ====================

-- Storage for drawing objects
local activeDrawings = {}

local function createBox(player)
   local box = Drawing.new("Square")
   box.Visible = false
   box.Color = Color3.fromRGB(255, 255, 255)
   box.Thickness = 1.5
   box.Filled = false
   activeDrawings[player] = box
end

Players.PlayerRemoving:Connect(function(player)
   if activeDrawings[player] then
      activeDrawings[player]:Remove()
      activeDrawings[player] = nil
   end
end)

-- Main Render Loop for ESP, Aimbot, and Movement
RunService.RenderStepped:Connect(function()
   -- WalkSpeed & Bhop handling
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

   -- Box ESP loop
   for _, player in ipairs(Players:GetPlayers()) do
      if player ~= LocalPlayer then
         if not activeDrawings[player] and getgenv().BloxStrikeSettings.BoxESP then
            createBox(player)
         end
         
         local box = activeDrawings[player]
         if box then
            if getgenv().BloxStrikeSettings.BoxESP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
               local hrp = player.Character.HumanoidRootPart
               local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
               
               if onScreen then
                  local size = math.clamp(2500 / vector.Z, 15, 300)
                  box.Size = Vector2.new(size * 0.6, size)
                  box.Position = Vector2.new(vector.X - box.Size.X / 2, vector.Y - box.Size.Y / 2)
                  box.Visible = true
               else
                  box.Visible = false
               end
            else
               box.Visible = false
            end
         end
      end
   end

   -- Simple Rage Aimbot Snap Logic
   if getgenv().BloxStrikeSettings.RageAimbot then
      local nearestTarget = nil
      local shortestDistance = getgenv().BloxStrikeSettings.AimbotFOV

      for _, player in ipairs(Players:GetPlayers()) do
         if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(getgenv().BloxStrikeSettings.TargetHitbox) then
            local targetPart = player.Character[getgenv().BloxStrikeSettings.TargetHitbox]
            local vector, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
            
            if onScreen then
               local mouseLocation = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
               local distance = (Vector2.new(vector.X, vector.Y) - mouseLocation).Magnitude
               
               if distance < shortestDistance then
                  shortestDistance = distance
                  nearestTarget = targetPart
               end
            end
         end
      end

      if nearestTarget then
         Camera.CFrame = CFrame.new(Camera.CFrame.Position, nearestTarget.Position)
      end
   end
end)

-- Chams Loop (Highlight Instance implementation)
RunService.Heartbeat:Connect(function()
   for _, player in ipairs(Players:GetPlayers()) do
      if player ~= LocalPlayer and player.Character then
         local highlight = player.Character:FindFirstChild("BloxStrikeChams")
         if getgenv().BloxStrikeSettings.Chams then
            if not highlight then
               highlight = Instance.new("Highlight")
               highlight.Name = "BloxStrikeChams"
               highlight.Adornee = player.Character
               highlight.Parent = player.Character
            end
            highlight.FillColor = getgenv().BloxStrikeSettings.ChamsColor
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.Enabled = true
         else
            if highlight then
               highlight.Enabled = false
            end
         end
      end
   end
end)

Rayfield:LoadConfiguration()
