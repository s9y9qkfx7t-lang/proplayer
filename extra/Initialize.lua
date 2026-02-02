WindUI.Services.Luache = {
  Name = "Luache",
  Icon = "shield",
  Args = { "Service", "DebugMode" },
  New = function(Service, DebugMode)
    local Luache = loadstring(game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Luache/main/Source/Library.lua"))()
    Luache:Settings({
      Service = Service,
      DebugMode = DebugMode or false,
      
      KeySystem = {
        HWIDs = {
          "9e3065db04157b8dd181680ac86b4694e024093b4828b6e9059b280d06becdec",
          "6cbe6b5db55ca1fdc7fecf279bb3d851723d739fb9a25ee48c621603080b5e77",
          "4093d4c4cb5b88e0c0e3f359ba1a3dfc33b9378e0519686c74e2658e72c3dd70",
          "9c136d2ff6f92bd0bf90cb75dc3daac37052eab876e4822186548b2af14e7bd4"
        }
      }
    })
  
    return {
      Verify = function(key)
        local boolean, message = Luache:Check(key)
        return boolean, message
      end,
      Copy = function()
        return setclipboard(Luache:GetKey())
      end,
    }
  end
}

local Window = WindUI:CreateWindow({
  Title = "Triangulare | " .. (InitializeName or "Undefined"),
  Icon = "triangle",
  Author = "by Moligrafi",
  Folder = "Triangulare",
  Size = UDim2.fromOffset(580, 400),
  Transparent = true,
  Theme = "Dark",
  User = {
    Enabled = true
  },
  SideBarWidth = 200,
  HasOutline = true,

  KeySystem = {
    Note = "Insert your key, or get one.",
    SaveKey = true,
    API = {
      {
        Type = "Luache",
        Service = "triangulare",
        DebugMode = false,
      }
    }
  }
})
