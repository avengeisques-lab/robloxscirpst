--[[
BloxStrike Rayfield UI Script
Features: Rage Combat, Visuals/ESP, Movement, Config Support
]]--

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
Name = "BloxStrike | Premium Hub",
Icon = 0, -- Standard icon
LoadingTitle = "BloxStrike Interface Suite",
LoadingSubtitle = "by p7zu",
Theme = "Default", -- Options: Default, Amethyst, Amber, Bloom, DarkBlue, Green, Light, Ocean, Serenity

DisableRayfieldPrompts = false,
DisableBuildWarnings = false,

ConfigurationSaving = {
Enabled = true,
FolderName = "BloxStrikeConfigs",
FileName = "MainConfig"
},

Discord = {
Enabled = false,
Invite = "noinvitelink",
RememberJoins = true
},

KeySystem = false,
KeySettings = {
Title = "BloxStrike Key",
Subtitle = "Key System",
Note = "No key required for this build",
FileName = "BloxKey",
SaveKey = true,
GrabKeyFromSite = false,
Key = {"1234"}
}
})

-- Tabs Setup
local CombatTab = Window:CreateTab("Rage / Combat", 4483362458)
local VisualsTab = Window:CreateTab("Visuals (ESP)", 4483362458)
local MiscTab = Window:CreateTab("Misc & Movement", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- ==================== COMBAT / RAGE TAB ====================
CombatTab:CreateSection("Rage Bot Settings")

local AimbotToggle = CombatTab:CreateToggle({
Name = "Rage Aimbot (Silent/Snap)",
CurrentValue = false,
Flag = "RageAimbot",
Callback = function(Value)
print("Rage Aimbot toggled:", Value)
end,
})

local AimPartDropdown = CombatTab:CreateDropdown({
Name = "Target Hitbox",
Options = {"Head", "HumanoidRootPart", "Chest"},
CurrentOption = {"Head"},
MultipleOptions = false,
Flag = "TargetHitbox",
Callback = function(Option)
print("Target hit part changed to:", Option[1])
end,
})

local FovSlider = CombatTab:CreateSlider({
Name = "Aimbot FOV Radius",
Range = {30, 300},
Increment = 5,
Suffix = "px",
CurrentValue = 90,
Flag = "AimbotFOV",
Callback = function(Value)
print("FOV set to:", Value)
end,
})

CombatTab:CreateSection("Weapon Modifiers")

local RecoilToggle = CombatTab:CreateToggle({
Name = "No Recoil / No Spread",
CurrentValue = false,
Flag = "NoRecoil",
Callback = function(Value)
print("No Recoil toggled:", Value)
end,
})

local RapidFireToggle = CombatTab:CreateToggle({
Name = "Rapid Fire (Fast Reload/Fire)",
CurrentValue = false,
Flag = "RapidFire",
Callback = function(Value)
print("Rapid Fire toggled:", Value)
end,
})

-- ==================== VISUALS TAB ====================
VisualsTab:CreateSection("ESP Player Settings")

local BoxEspToggle = VisualsTab:CreateToggle({
Name = "Player Box ESP",
CurrentValue = false,
Flag = "BoxESP",
Callback = function(Value)
print("Box ESP:", Value)
end,
})

local NameEspToggle = VisualsTab:CreateToggle({
Name = "Player Names & Health",
CurrentValue = false,
Flag = "NameESP",
Callback = function(Value)
print("Name ESP:", Value)
end,
})

local ChamsToggle = VisualsTab:CreateToggle({
Name = "Chams / Wallhack Fill",
CurrentValue = false,
Flag = "ChamsToggle",
Callback = function(Value)
print("Chams toggled:", Value)
end,
})

local ChameleonColor = VisualsTab:CreateColorPicker({
Name = "Chams Color",
Color = Color3.fromRGB(255, 0, 0),
Flag = "ChamsColor",
Callback = function(Value)
print("Chams color changed:", Value)
end
})

-- ==================== MISC TAB ====================
MiscTab:CreateSection("Movement & Utilities")

local BhopToggle = MiscTab:CreateToggle({
Name = "Bunny Hop (Auto-Jump)",
CurrentValue = false,
Flag = "BhopToggle",
Callback = function(Value)
print("Bhop toggled:", Value)
end,
})

local WalkspeedSlider = MiscTab:CreateSlider({
Name = "Custom WalkSpeed",
Range = {16, 32},
Increment = 1,
Suffix = "studs",
CurrentValue = 16,
Flag = "WalkSpeedSlider",
Callback = function(Value)
local player = game.Players.LocalPlayer
if player.Character and player.Character:FindFirstChild("Humanoid") then
player.Character.Humanoid.WalkSpeed = Value
end
end,
})

-- ==================== SETTINGS TAB ====================
SettingsTab:CreateSection("UI Configuration")

local UnloadButton = SettingsTab:CreateButton({
Name = "Unload UI",
Callback = function()
Rayfield:Destroy()
end,
})

-- Load configuration settings automatically on startup
Rayfield:LoadConfiguration()
