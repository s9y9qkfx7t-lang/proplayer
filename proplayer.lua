-- Global Values
getgenv().WalkSpeed = false
getgenv().JumpPower = false
getgenv().PermTpTool = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  WalkSpeed = 16,
  JumpPower = 50,
  Teleport = {
    Player = "No player selected"
  }
}

-- Functions
local function ReturnPlayers()
  local Players = {}
  for _, p in pairs(game:GetService("Players"):GetPlayers()) do
    if p ~= eu then
      table.insert(Players, p.Name)
    end
  end
  return Players
end
local function GetTP()
  pcall(function()
    local mouse = eu:GetMouse()
    local tool = Instance.new("Tool")
    tool.RequiresHandle = false
    tool.Name = "Teleport Tool"
    tool.ToolTip = "Equip and click somewhere to teleport - Triangulare"
    -- tool.TextureId = "rbxassetid://17091459839"
    
    tool.Activated:Connect(function()
      local pos = mouse.Hit.Position + Vector3.new(0, 2.5, 0)
      eu.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
    end)
    
    tool.Parent = eu.Backpack
  end)
end
local function DelTP()
  pcall(function()
    for _, tool in pairs(eu.Character:GetChildren()) do
      if tool:IsA("Tool") and tool.Name == "Teleport Tool" then
        tool:Destroy()
      end
    end
    for _, tool in pairs(eu.Backpack:GetChildren()) do
      if tool:IsA("Tool") and tool.Name == "Teleport Tool" then
        tool:Destroy()
      end
    end
  end)
end
local function PermTpTool()
  while getgenv().PermTpTool and task.wait(1) do
    pcall(function()
      if not eu.Backpack:FindFirstChild("Teleport Tool") and not eu.Character:FindFirstChild("Teleport Tool") then
        GetTP()
      end
    end)
  end
end
local function WalkSpeed()
  while getgenv().WalkSpeed and task.wait(0.1) do
    pcall(function()
      if eu.Character.Humanoid.WalkSpeed ~= Settings.WalkSpeed then
        eu.Character.Humanoid.WalkSpeed = Settings.WalkSpeed
      end
    end)
  end
end
local function JumpPower()
  while getgenv().JumpPower and task.wait(0.1) do
    pcall(function()
      if eu.Character.Humanoid.JumpPower ~= Settings.JumpPower then
        eu.Character.Humanoid.JumpPower = Settings.JumpPower
      end
    end)
  end
end

-- Tabs
local Tabs = {
  Movement = Window:Tab({ Title = "Movement", Icon = "chevrons-up"}),
  Teleport = Window:Tab({ Title = "Teleport", Icon = "shell"}),
  Script = Window:Tab({ Title = "Script", Icon = "scroll"})
}

-- Movement
Tabs.Movement:Section({ Title = "WalkSpeed" })
Tabs.Movement:Toggle({
  Title = "Loop WalkSpeed",
  Value = false,
  Callback = function(state)
    getgenv().WalkSpeed = state
    WalkSpeed()
  end
})
Tabs.Movement:Input({
  Title = "WalkSpeed",
  Value = tostring(Settings.WalkSpeed),
  Placeholder = "Numbers only, ex.: 16",
  Callback = function(input)
    Settings.WalkSpeed = tonumber(input) or 16
  end
})
Tabs.Movement:Section({ Title = "JumpPower" })
Tabs.Movement:Toggle({
  Title = "Loop JumpPower",
  Value = false,
  Callback = function(state)
    getgenv().JumpPower = state
    JumpPower()
  end
})
Tabs.Movement:Input({
  Title = "JumpPower",
  Value = tostring(Settings.JumpPower),
  Placeholder = "Numbers only, ex.: 50",
  Callback = function(input)
    Settings.JumpPower = tonumber(input) or 50
  end
})

-- Teleport
Tabs.Teleport:Section({ Title = "Teleport to Player" })
local PlayerDropdown = Tabs.Teleport:Dropdown({
  Title = "Selected Player",
  Values = ReturnPlayers(),
  Value = Settings.Teleport.Player,
  Callback = function(option)
    Settings.Teleport.Player = option
  end
})
Tabs.Teleport:Button({
  Title = "Teleport to Player",
  Desc = "Teleports you to the selected player.",
  Callback = function()
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
      if p ~= eu and p.Character and p.Character.HumanoidRootPart and p.Name == Settings.Teleport.Player then
        eu.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
        break
      end
    end
  end
})
Tabs.Teleport:Button({
  Title = "Refresh List",
  Desc = "Refreshs the player list.",
  Callback = function()
    print("Wainting to update...")
  end
})
Tabs.Teleport:Section({ Title = "Teleport Tool" })
Tabs.Teleport:Button({
  Title = "Get Tool",
  Desc = "Gives you the teleport tool.",
  Callback = function()
    GetTP()
  end
})
Tabs.Teleport:Button({
  Title = "Remove Tool",
  Desc = "Removes the teleport tool.",
  Callback = function()
    DelTP()
  end
})
Tabs.Teleport:Toggle({
  Title = "Permanent Tool",
  Desc = "Auto get teleport tool.",
  Value = false,
  Callback = function(state)
    getgenv().PermTpTool = state
    PermTpTool()
  end
})

-- Script
Tabs.Script:Section({ Title = "Loader" })
Tabs.Script:Button({
  Title = "Load Dex [ Mobile ]",
  Desc = "Executes Mobile Dex Explorer.",
  Callback = function()
    loadstring(game:HttpGet("https://gist.githubusercontent.com/dannythehacker/1781582ab545302f2b34afc4ec53e811/raw/ee5324771f017073fc30e640323ac2a9b3bfc550/dark%2520dex%2520v4"))()
  end
})
Tabs.Script:Button({
  Title = "Load IY",
  Desc = "Executes Infinite Yield.",
  Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
  end
})
Tabs.Script:Button({
  Title = "Load Simple Spy",
  Desc = "Launches the Simple Spy tool to monitor remote event traffic.",
  Callback = function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Simple-Spy-Mobile-Script-Restored-22732"))()
  end
})

Window:SelectTab(1)
