-- Global Values
getgenv().AutoGun = false
getgenv().PullGun = false
getgenv().AutoKnife = false
getgenv().HitBox = false
getgenv().PlayerESP = false
getgenv().GunSound = false
getgenv().Triggerbot = false
getgenv().AutoSlash = false
getgenv().EquipKnife = false
getgenv().AutoTPe = false
getgenv().AutoBuy = false

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Locals
local eu = Players.LocalPlayer
local Settings = {
  Triggerbot = {
    Cooldown = 3,
    Waiting = false
  },
  Teleport = {
    Mode = "Everytime",
    CFrame = CFrame.new(-337, 76, 19)
  },
  Slash = {
    Cooldown = 0.1
  },
  Boxes = {
    Selected = "Knife Box #1",
    Price = 500
  },
  SFX = false,
  SpamSoundCooldown = 0.2,
  Cache = {
    Knife = nil,
    Gun = nil
  }
}
local HitSize = 5
local CorInocente = Color3.new(1, 0.5, 0)

-- Almost
local function GetClassOf(class)
  local Objects = { Allies = {}, Enemies = {} }
  for _, p in pairs(Players:GetPlayers()) do
    if p ~= eu and p:GetAttribute("Game") == eu:GetAttribute("Game") then
      if (class == "Enemies" or class == "Everyone") and p:GetAttribute("Team") ~= eu:GetAttribute("Team") then
        Objects.Enemies[#Objects.Enemies+1] = p
      elseif (class == "Allies" or class == "Everyone") and p:GetAttribute("Team") == eu:GetAttribute("Team") then
        Objects.Allies[#Objects.Allies+1] = p
      end
    end
  end
  if class == "Everyone" then
    return Objects
  elseif class == "Allies" then
    return Objects.Allies
  elseif class == "Enemies" then
    return Objects.Enemies
  end
end
local function ReturnItem(class, where)
  if not eu.Character or not eu:GetAttribute("Game") then return end

  local item = Settings.Cache[class]
  if item and item.Parent and (item.Parent == eu.Character or item.Parent == eu.Backpack) then
    return item.Parent == eu[where] and item
  else
    return eu[where]:FindFirstChild(class == "Gun" and eu.EquippedGun.Value or class == "Knife" and eu.EquippedKnife.Value)
  end
end
local function PlaySound(id)
  task.spawn(function()
  	local s = Instance.new("Sound")
  	s.Parent = workspace.CurrentCamera
  	s.Volume = 1
  	s.Looped = false
  	s.SoundId = "rbxassetid://" .. id
  	
  	s:Play()
  	s.Ended:Wait()
  	
  	s:Destroy()
  end)
end
-- Triggerbot
local function ScanEnemies(from)
  local EnemiesInSight = {}
  if not workspace.CurrentCamera then return EnemiesInSight end
  
  local function GetAlliesChar(allies)
    local Allies = {}
    
    for _, ally in pairs(allies) do
      if ally.Character then table.insert(Allies, ally.Character) end
    end
    
    return Allies
  end
  
  local Teams = GetClassOf("Everyone")
  for _, enemy in pairs(Teams.Enemies) do
      local char = enemy.Character
      local root = char and char:FindFirstChild("HumanoidRootPart")
      if not root then continue end

      local CamPos = workspace.CurrentCamera.CFrame.Position
      local rayParams = RaycastParams.new()
      rayParams.FilterDescendantsInstances = {eu.Character, unpack(GetAlliesChar(Teams.Allies))}
      rayParams.FilterType = Enum.RaycastFilterType.Blacklist

      local camResult = workspace:Raycast(CamPos, root.Position - CamPos, rayParams)
      if not (camResult and camResult.Instance:IsDescendantOf(char)) then continue end
      
      local hitResult = workspace:Raycast(from, root.Position - from, rayParams)
      if not (hitResult and hitResult.Instance:IsDescendantOf(char)) then continue end
      
      EnemiesInSight[enemy.Name] = {
        Enemy = enemy,
        Character = char,
        HitPosition = hitResult.Position
      }
    end

  return EnemiesInSight
end
local function Trigger()
  local Triggerbot = Settings.Triggerbot
  if not Triggerbot.Waiting then
    pcall(function()
      local Gun = ReturnItem("Gun", "Character")
      if not Gun then return end
      
      local gunPos = Gun.Handle.Position
      local EnemiesInSight = ScanEnemies(gunPos)
      
      for _, info in pairs(EnemiesInSight) do
        local hitPos = info.HitPosition
        local enemyObj = info.Enemy
        
        Gun.fire:FireServer()
        Gun.showBeam:FireServer(hitPos, gunPos, Gun.Handle)
        Gun.kill:FireServer(enemyObj, Vector3.new(hitPos))
        if Settings.SFX then PlaySound(8561500387) end
        ReplicatedStorage.LocalBeam:Fire(Gun.Handle, hitPos)
        
        -- Cooldown
        Triggerbot.Waiting = true
        task.delay(Triggerbot.Cooldown, function() Triggerbot.Waiting = false end)
        break
      end
    end)
  end
end

-- Functions
local function KillGun()
  pcall(function()
    local Gun = ReturnItem("Gun", "Character")
    for _, enemy in pairs(GetClassOf("Enemies")) do
      pcall(function()
        if Gun and enemy.Character then
          repeat
            Gun.kill:FireServer(enemy, Vector3.new(enemy.Character.Head.Position))
            task.wait(0.1)
          until not Gun or Gun.Parent ~= eu.Character or not enemy.Character
        end
      end)
    end
  end)
end
local function PlayerESP()
	while getgenv().PlayerESP and wait(0.33) do
	  pcall(function()
    	for _, players in pairs(GetClassOf("Enemies")) do
    		local player = players.Character
    		if player and player.Parent then
    			if player:FindFirstChild("Highlight") then
    				if not player.Highlight.Enabled then
    					player.Highlight.Enabled = true
    				end
    				if player.Highlight.FillColor ~= CorInocente or player.Highlight.OutlineColor ~= CorInocente then
    				  player.Highlight.FillColor = CorInocente
    				  player.Highlight.OutlineColor = CorInocente
    				end
    			else
    				local highlight = Instance.new("Highlight")
    				highlight.FillColor = CorInocente
    				highlight.OutlineColor = CorInocente
    				highlight.FillTransparency = 0.6
    				highlight.Adornee = player
    				highlight.Parent = player
    			end
    		end
    	end
		end)
	end
	if not getgenv().PlayerESP then
		for _, players in pairs(GetClassOf("Enemies")) do
			local player = players.Character
			if player and player:FindFirstChild("Highlight") then
				if player.Highlight.Enabled then
					player.Highlight.Enabled = false
				end
			end
		end
	end
end
-- Knife
local function KillKnife()
  local Enemies = GetClassOf("Enemies")
  if #Enemies < 1 then return false end
  
  for _, enemy in pairs(Enemies) do
    ReplicatedStorage.KnifeKill:FireServer(enemy, enemy)
  end
  return true
end
-- Teleport
local function MouseTP()
  local mouse = eu:GetMouse()
  local pos = mouse.Hit.Position + Vector3.new(0, 2.5, 0)
  local hrp = eu.Character.HumanoidRootPart
  
  hrp.CFrame = CFrame.new(pos, pos + hrp.CFrame.LookVector)
  if Settings.SFX then PlaySound(2428506580) end
end
local function GetTP()
  pcall(function()
    local tool = Instance.new("Tool")
    tool.RequiresHandle = false
    tool.Name = "Teleport Tool"
    tool.ToolTip = "Equip and click somewhere to teleport - Triangulare"
    
    tool.Activated:Connect(MouseTP)
    
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
-- Box
local function BuyBox()
  if eu.Cash.Value >= Settings.Boxes.Price then
    ReplicatedStorage.BuyCase:InvokeServer(Settings.Boxes.Selected)
  end
end

-- Load
task.spawn(function()
  Settings.Keybinds = {
    {
      Title = "Manual Trigger",
      Bind = "ButtonX",
      Callback = Trigger
    },
    {
      Title = "Kill All",
      Bind = "ButtonY",
      Callback = function()
        if KillKnife() and Settings.SFX then PlaySound(18694762392) end
      end
    },
    {
      Title = "Player ESP",
      Bind = "J",
      Callback = function()
        getgenv().PlayerESP = not getgenv().PlayerESP
        PlayerESP()
      end
    },
    {
      Title = "Teleport",
      Bind = "ButtonB",
      Callback = MouseTP
    }
  }
  
  local Gokka = loadstring(game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/extra/Gokka.lua"))()
  Gokka:DisconnectAll()
  
  Gokka:Connect({
    Name = "Keybinds",
    Signal = game:GetService("UserInputService").InputBegan,
    Callback = function(input, gp)
      if gp then return end
      
      for _, slot in pairs(Settings.Keybinds) do
        local bind = Enum.KeyCode[slot.Bind]
        
        if bind and input.KeyCode == bind then
          return slot.Callback()
        end
      end
    end
  })
end)

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"}),
  Gun = Window:Tab({ Title = "Gun", Icon = "skull"}),
  Knife = Window:Tab({ Title = "Knife", Icon = "sword"}),
  Boxes = Window:Tab({ Title = "Boxes", Icon = "box"}),
  Teleport = Window:Tab({ Title = "Teleport", Icon = "shell"}),
  Keybinds = Window:Tab({ Title = "Keybinds", Icon = "keyboard"}),
}
Window:SelectTab(1)

-- Menu
do
  local section = Tabs.Menu:Section({ Title = "Player ESP", Icon = "scan-eye", Opened = true })
  section:Toggle({
    Title = "Player ESP",
    Desc = "Extra Sensorial Experience.",
    Value = false,
    Callback = function(state)
      getgenv().PlayerESP = state
      PlayerESP()
    end
  })
  section:Colorpicker({
    Title = "ESP Color",
    Default = CorInocente,
    Callback = function(color)
      CorInocente = color
    end
  })
end
Tabs.Menu:Divider()
do
  local section = Tabs.Menu:Section({ Title = "Hitbox Expander", Icon = "scaling", Opened = true })
  section:Toggle({
    Title = "Expand Hitboxes",
    Desc = "Bigger hitboxes.",
    Value = false,
    Callback = function(state)
      getgenv().HitBox = state
      while getgenv().HitBox and wait(1) do
        pcall(function()
          for _, enemy in pairs(GetClassOf("Enemies")) do
            local char = enemy.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local finSize = Vector3.new(HitSize, HitSize, HitSize)
            if root and (root.Size ~= finSize or root.Transparency ~= 0.6) then
              root.Size = finSize
              root.Transparency = 0.6
            end
          end
        end)
      end
      if not getgenv().HitBox then
        for _, enemy in pairs(GetClassOf("Enemies")) do
          local char = enemy.Character
          local root = char and char:FindFirstChild("HumanoidRootPart")
          if root then 
            root.Size = Vector3.new(2, 2, 1)
            root.Transparency = 1 
          end
        end
      end
    end
  })
  section:Input({
    Title = "Hitbox Size",
    Value = "5",
    Placeholder = "Default HitBox Size = 5",
    Callback = function(input)
      HitSize = tonumber(input) or 1
    end
  })
end

-- Gun
do
  local section = Tabs.Gun:Section({ Title = "Undetectable", Icon = "megaphone-off", Opened = true })
  section:Toggle({
    Title = "Triggerbot",
    Desc = "Auto kill enemies in sight.",
    Value = false,
    Callback = function(state)
      getgenv().Triggerbot = state
      while getgenv().Triggerbot and task.wait(0.01) do
        Trigger()
      end
    end
  })
  section:Input({
    Title = "Shoot Cooldown",
    Value = "3",
    Placeholder = "In seconds, ex.: 3",
    Callback = function(input)
      Settings.Triggerbot.Cooldown = tonumber(input) or 0
    end
  })
end
Tabs.Gun:Divider()
do
  local section = Tabs.Gun:Section({ Title = "Blatant", Icon = "gavel", Opened = true })
  section:Button({
    Title = "Kill All",
    Desc = "Kills everyone using your gun.",
    Callback = function()
      KillGun()
    end
  })
  section:Toggle({
    Title = "Auto Kill",
    Desc = "Auto kills everyone.",
    Value = false,
    Callback = function(state)
      getgenv().AutoGun = state
      while getgenv().AutoGun and task.wait(1) do
        KillGun()
      end
    end
  })
  section:Toggle({
    Title = "Auto Equip Gun",
    Desc = "Automatically equips your gun.",
    Value = false,
    Callback = function(state)
      getgenv().PullGun = state
      while getgenv().PullGun and task.wait(0.25) do
        pcall(function()
          local Gun = ReturnItem("Gun", "Backpack")
          if Gun then Gun.Parent = eu.Character end
        end)
      end
    end
  })
end
Tabs.Gun:Divider()
do
  local section = Tabs.Gun:Section({ Title = "Misc", Icon = "ferris-wheel", Opened = true })
  section:Toggle({
    Title = "Spam Sound (FE)",
    Desc = "Automatically spams the shoot sound.",
    Value = false,
    Callback = function(state)
      getgenv().GunSound = state
      while getgenv().GunSound and task.wait(Settings.SpamSoundCooldown) do
        pcall(function()
          local Gun = ReturnItem("Gun", "Character")
          if Gun then Gun.fire:FireServer() end
        end)
      end
    end
  })
  section:Input({
    Title = "Sound Cooldown",
    Value = "0.2",
    Placeholder = "In seconds, ex.: 0.2",
    Callback = function(input)
      Settings.SpamSoundCooldown= tonumber(input) or 1
    end
  })
end

-- Knife
do
  local section = Tabs.Knife:Section({ Title = "Legit", Icon = "dumbbell", Opened = true })
  section:Toggle({
    Title = "Auto Slash",
    Desc = "Auto use your knife.",
    Value = false,
    Callback = function(state)
      getgenv().AutoSlash = state
      while getgenv().AutoSlash and task.wait(Settings.Slash.Cooldown) do
        pcall(function()
          local Knife = ReturnItem("Knife", "Character")
          if Knife then Knife.Slash:FireServer() end
        end)
      end
    end
  })
  section:Input({
    Title = "Slash Cooldown",
    Value = "0.1",
    Placeholder = "In seconds, ex.: 0.5",
    Callback = function(input)
      Settings.Slash.Cooldown = tonumber(input) or 1
    end
  })
end
Tabs.Knife:Divider()
do
  local section = Tabs.Knife:Section({ Title = "Blatant", Icon = "gavel", Opened = true })
  section:Button({
    Title = "Kill All",
    Desc = "Kills everyone using your knife.",
    Callback = function()
      KillKnife()
    end
  })
  section:Toggle({
    Title = "Auto Kill",
    Desc = "Auto kills everyone.",
    Value = false,
    Callback = function(state)
      getgenv().AutoKnife = state
      while getgenv().AutoKnife and task.wait(0.0) do
        KillKnife()
      end
    end
  })
  section:Toggle({
    Title = "Auto Equip Knife",
    Desc = "Automatically equips your knife.",
    Value = false,
    Callback = function(state)
      getgenv().EquipKnife = state
      while getgenv().EquipKnife and task.wait(0.0) do
        pcall(function()
          local Knife = ReturnItem("Knife", "Backpack")
          if Knife then Knife.Parent = eu.Character end
        end)
      end
    end
  })
end

-- Boxes
do
  local section = Tabs.Boxes:Section({ Title = "Selected Box", Icon = "package", Opened = true })
  section:Dropdown({
    Title = "Selected Box",
    Values = { "Knife Box #1", "Knife Box #2", "Gun Box #1", "Gun Box #2", "Mythic Box #1", "Mythic Box #2", "Mythic Box #3", "Mythic Box #4" },
    Value = Settings.Boxes.Selected,
    Callback = function(option)
      Settings.Boxes.Selected = option
      if string.find(option, "Mythic") then
        Settings.Boxes.Price = 1500
      else
        Settings.Boxes.Price = 500
      end
    end
  })
end
Tabs.Boxes:Divider()
do
  local section = Tabs.Boxes:Section({ Title = "Buy Box", Icon = "circle-dollar-sign", Opened = true })
  section:Button({
    Title = "Buy Box",
    Desc = "Buys the selected box if you have money.",
    Callback = BuyBox
  })
  section:Toggle({
    Title = "Auto Buy",
    Desc = "Auto buys the selected box.",
    Value = false,
    Callback = function(state)
      getgenv().AutoBuy = state
      while getgenv().AutoBuy and task.wait(1) do
        pcall(function()
          BuyBox()
        end)
      end
    end
  })
end

-- Teleport
do
  local section = Tabs.Teleport:Section({ Title = "Teleport to Map", Icon = "map", Opened = true })
  section:Dropdown({
    Title = "Selected Map",
    Values = {"Lobby", "Hotel", "Factory", "House", "Mansion", "MilBase", "Waiting Room"},
    Value = "Lobby",
    Callback = function(option)
      if option == "Lobby" then
        Settings.Teleport.CFrame = CFrame.new(-337, 76, 19)
      elseif option == "Factory" then
        Settings.Teleport.CFrame = CFrame.new(-1074, 113, 5437)
      elseif option == "House" then
        Settings.Teleport.CFrame = CFrame.new(408, 111, 6859)
      elseif option == "Mansion" then
        Settings.Teleport.CFrame = CFrame.new(-1175, 47, 6475)
      elseif option == "MilBase" then
        Settings.Teleport.CFrame = CFrame.new(-1186, 27, 3737)
      elseif option == "Hotel" then
        Settings.Teleport.CFrame = CFrame.new(677.19104, 95.9535522, 4991.19287)
      elseif option == "Waiting Room" then
        Settings.Teleport.CFrame = CFrame.new(1888.1405, -63.8421059, 78.9331055)
      end
    end
  })
  section:Button({
    Title = "Teleport",
    Desc = "Teleports you to the selected map.",
    Callback = function()
      pcall(function()
        eu.Character.HumanoidRootPart.CFrame = Settings.Teleport.CFrame
      end)
    end
  })
end
Tabs.Teleport:Divider()
do
  local section = Tabs.Teleport:Section({ Title = "Teleport Tool", Icon = "wrench", Opened = true })
  section:Button({
    Title = "Get Teleport Tool",
    Desc = "Gives you the teleport tool.",
    Callback = function()
      GetTP()
    end
  })
  section:Button({
    Title = "Remove Tool",
    Desc = "Removes the teleport tool.",
    Callback = function()
      DelTP()
    end
  })
  section:Toggle({
    Title = "Permanent Tool",
    Desc = "Auto get teleport tool.",
    Value = false,
    Callback = function(state)
      getgenv().AutoTPe = state
      while getgenv().AutoTPe and task.wait() do
        pcall(function()
          local function ToolsLoaded()
            local Gun = ReturnItem("Gun")
            local Knife = ReturnItem("Knife")
            
            if Gun and Knife then return true end
          end
          
          if Settings.Teleport.Mode == "Tools Load" and (eu.Backpack:FindFirstChild("Teleport Tool") or eu.Character:FindFirstChild("Teleport Tool")) and not ToolsLoaded() then
            DelTP()
          elseif not eu.Backpack:FindFirstChild("Teleport Tool") and not eu.Character:FindFirstChild("Teleport Tool") then
            if Settings.Teleport.Mode == "Tools Load" and ToolsLoaded() then
              GetTP()
            elseif Settings.Teleport.Mode == "Everytime" then
              GetTP()
            end
          end
        end)
      end
    end
  })
  section:Dropdown({
    Title = "Get Tool When",
    Values = { "Tools Load", "Everytime" },
    Value = Settings.Teleport.Mode,
    Callback = function(option)
      Settings.Teleport.Mode = option
    end
  })
end

-- Keybinds
do
  local section = Tabs.Keybinds:Section({ Title = "Keybinds", Icon = "keyboard", Opened = true })
  for _, bind in pairs(Settings.Keybinds) do
    section:Keybind({
      Title = bind.Title,
      Value = bind.Bind,
      Callback = function(v)
        for _, obj in pairs(Settings.Keybinds) do
          if obj.Title == bind.Title then
            obj.Bind = v
            return
          end
        end
      end
    })
  end
end
Tabs.Keybinds:Divider()
do
  local section = Tabs.Keybinds:Section({ Title = "Misc", Icon = "ferris-wheel", Opened = true })
  section:Toggle({
    Title = "SFX",
    Desc = "Cool sound effects.",
    Value = Settings.SFX,
    Callback = function(state)
      Settings.SFX = state
    end
  })
end
