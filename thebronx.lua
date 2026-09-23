-- // Safe Rayfield Loader \\ --
local Success, Rayfield = pcall(function()
   return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not Success or not Rayfield then
   warn("Failed to load Rayfield UI library. Check your executor's HttpGet permissions.")
   return
end

local Window = Rayfield:CreateWindow({
   Name = "The Bronx: Duels | Rage Hub",
   LoadingTitle = "Initializing Combat System...",
   LoadingSubtitle = "by p7zu",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = "BronxDuelsConfig",
      FileName = "Config"
   },
   Discord = { Enabled = false },
   KeySystem = false
})

-- // Services \\ --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- // Variables & Settings \\ --
getgenv().RageSettings = {
   AimbotEnabled = false,
   TeamCheck = true,
   AimPart = "Head",
   Smoothness = 0.2, -- Lower = faster/snappier (Rage mode)
   FOVSize = 150,
   ESPEnabled = false
}

-- // FOV Circle \\ --
local FOVCircle
pcall(function()
   FOVCircle = Drawing.new("Circle")
   FOVCircle.Visible = false
   FOVCircle.Transparency = 0.7
   FOVCircle.Thickness = 1.5
   FOVCircle.Color = Color3.fromRGB(255, 0, 0)
   FOVCircle.Filled = false
end)

RunService.RenderStepped:Connect(function()
   if FOVCircle then
      FOVCircle.Radius = getgenv().RageSettings.FOVSize
      FOVCircle.Position = UserInputService:GetMouseLocation()
      FOVCircle.Visible = getgenv().RageSettings.AimbotEnabled
   end
end)

-- // Target Finder \\ --
local function GetClosestPlayer()
   local target = nil
   local shortestDist = getgenv().RageSettings.FOVSize

   for _, player in ipairs(Players:GetPlayers()) do
      if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
         if getgenv().RageSettings.TeamCheck and player.Team == LocalPlayer.Team then continue end

         local part = player.Character:FindFirstChild(getgenv().RageSettings.AimPart)
         if part then
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
               local mouseDist = (Vector2.new(screenPos.X, screenPos.Y) - UserInputService:GetMouseLocation()).Magnitude
               if mouseDist < shortestDist then
                  shortestDist = mouseDist
                  target = player
               end
            end
         end
      end
   end
   return target
end

-- // Combat Loop (Rage / Aimbot) \\ --
RunService.RenderStepped:Connect(function()
   if getgenv().RageSettings.AimbotEnabled then
      local target = GetClosestPlayer()
      if target and target.Character and target.Character:FindFirstChild(getgenv().RageSettings.AimPart) then
         local targetPart = target.Character[getgenv().RageSettings.AimPart]
         local currentCFrame = Camera.CFrame
         local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
         
         Camera.CFrame = currentCFrame:Lerp(targetCFrame, getgenv().RageSettings.Smoothness)
      end
   end
end)

-- // ESP System \\ --
local function CreateESP(player)
   if player == LocalPlayer then return end
   
   local successBox, box = pcall(function()
      local b = Drawing.new("Square")
      b.Visible = false
      b.Color = Color3.fromRGB(255, 255, 255)
      b.Thickness = 1
      b.Filled = false
      return b
   end)

   if not successBox then return end

   local connection
   connection = RunService.RenderStepped:Connect(function()
      if not getgenv().RageSettings.ESPEnabled or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or player.Character.Humanoid.Health <= 0 then
         box.Visible = false
         if not player.Parent then
            box:Remove()
            connection:Disconnect()
         end
         return
      end

      local rootPart = player.Character.HumanoidRootPart
      local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

      if onScreen then
         local size = (Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 3, 0)).Y)
         local boxSize = Vector2.new(2000 / vector.Z, math.abs(size))
         local boxPos = Vector2.new(vector.X - boxSize.X / 2, vector.Y - boxSize.Y / 2)

         box.Size = boxSize
         box.Position = boxPos
         box.Visible = true
      else
         box.Visible = false
      end
   end)
end

Players.PlayerAdded:Connect(CreateESP)
for _, p in ipairs(Players:GetPlayers()) do CreateESP(p) end

-- // Rayfield UI Tabs \\ --
local CombatTab = Window:CreateTab("Combat / Rage", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

-- // Combat Elements \\ --
CombatTab:CreateToggle({
   Name = "Enable Aimbot (Rage)",
   CurrentValue = false,
   Flag = "AimbotToggle",
   Callback = function(Value)
      getgenv().RageSettings.AimbotEnabled = Value
   end,
})

CombatTab:CreateDropdown({
   Name = "Target Hitbox",
   Options = {"Head", "HumanoidRootPart"},
   CurrentOption = "Head",
   Flag = "AimPartDropdown",
   Callback = function(Option)
      getgenv().RageSettings.AimPart = Option
   end,
})

CombatTab:CreateSlider({
   Name = "FOV Radius",
   Range = {50, 400},
   Increment = 5,
   CurrentValue = 150,
   Suffix = "px",
   Flag = "FOVSizeFlag",
   Callback = function(Value)
      getgenv().RageSettings.FOVSize = Value
   end,
})

CombatTab:CreateSlider({
   Name = "Aim Smoothness (Rage Speed)",
   Range = {0.01, 1},
   Increment = 0.01,
   CurrentValue = 0.2,
   Suffix = "",
   Flag = "SmoothnessSlider",
   Callback = function(Value)
      getgenv().RageSettings.Smoothness = Value
   end,
})

CombatTab:CreateToggle({
   Name = "Team Check",
   CurrentValue = true,
   Flag = "TeamCheckToggle",
   Callback = function(Value)
      getgenv().RageSettings.TeamCheck = Value
   end,
})

-- // Visuals Elements \\ --
VisualsTab:CreateToggle({
   Name = "Player Box ESP",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(Value)
      getgenv().RageSettings.ESPEnabled = Value
   end,
})

Rayfield:Notify({
   Title = "Hub Loaded Successfully",
   Content = "The Bronx: Duels script is ready.",
   Duration = 5,
   Image = 4483362458,
})
