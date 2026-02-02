local Lib = {
  Listeners = {}
}

local Players = game:GetService("Players")
local eu = Players.LocalPlayer

-- Management
local function GetFolder(parent, name)
  local Min = parent:FindFirstChild("LexSP")
  if not Min then
    Min = Instance.new("Folder")
    Min.Name = "LexSP"
    Min.Parent = parent
  end
  
  local Folder = Min:FindFirstChild(name)
  if not Folder then
    Folder = Instance.new("Folder")
    Folder.Name = name
    Folder.Parent = Min
  end
  
  return Folder
end

function Lib:BasicESP(data)
  local parent, section = data.Parent
  local Blacklist = { "Name", "Parent", "Adornee" }
  local Folder = GetFolder(parent, data.Name)
  
  section = data.Highlight
  if section then
    local highlight = Folder:FindFirstChild("Luz")
    if highlight then
      local Colors = {
        "FillColor", "OutlineColor"
      }
      
      for _, color in Colors do
        if not section[color] and section.Color and highlight[color] ~= section.Color then
          highlight[color] = section.Color
        end
      end
      
      for key, value in next, section do
        if not table.find(Blacklist, key) and not table.find({ "Color" }, key) and highlight[key] ~= value then
          highlight[key] = value
        end
      end
    else
      highlight = Instance.new("Highlight")
      highlight.Name = "Luz"
      
      -- Color
      local color = section.Color or Color3.fromRGB(0, 0, 255)
      highlight.FillColor, highlight.OutlineColor = section.FillColor or color, section.OutlineColor or color
      
      -- Transparency
      highlight.FillTransparency, highlight.OutlineTransparency = section. FillTransparency or 0.6 ,section.OutlineTransparency or 0
      
      highlight.Adornee = parent
      highlight.Parent = Folder
    end
  end
  
  section = data.TextLabel
  if section then
    local bGui = Folder:FindFirstChild("BillboardGui")
    if bGui then bGui:Destroy() end
    
    bGui = Instance.new("BillboardGui")
    
    bGui.MaxDistance = section.MaxDistance or 1500
    bGui.Size = section.BSize or UDim2.new(0, 200, 0, 50)
    bGui.ExtentsOffset = section.ExtentsOffset or Vector3.new(0, 0, 0)
    bGui.AlwaysOnTop = true
    
    bGui.Adornee = section.Adornee or parent
    bGui.Parent = Folder
    
    local label = bGui:FindFirstChild("TextLabel")
    if label then label:Destroy() end
    
    label = Instance.new("TextLabel")
    label.Name = "TextLabel"
    label.Text = section.Text or "Undefined"
    label.TextColor3 = section.TextColor3 or Color3.fromRGB(255, 125, 0)
    label.TextSize = section.TextSize or 15
    label.Font = section.Font or Enum.Font.GothamBold
    label.TextSize = section.TextSize or 20
    label.BackgroundTransparency = section.BackgroundTransparency or 1
    label.Size = section.Size or UDim2.new(1, 0, 1, 0)
    label.Parent = bGui
  end
  
  section = data.Tracer
  if section then
    local from, to = section.From, section.To
    
    local origin = from:FindFirstChild("Nucleo")
    if not origin then
      origin = Instance.new("Attachment")
      origin.Name = "Nucleo"
      origin.Parent = from
    end
    
    local destiny = to:FindFirstChild("Nucleo")
    if not destiny then
      destiny = Instance.new("Attachment")
      destiny.Name = "Nucleo"
      destiny.Parent = to
    end
    
    local beam = Folder:FindFirstChild("Tracer")
    if beam then
      section.Attachment0 = origin
      section.Attachment1 = destiny
      
      for key, value in next, section do
        if not table.find(Blacklist, key) and not table.find({ "From", "To" }, key) and beam[key] ~= value then
          beam[key] = value
        end
      end
    else
      beam = Instance.new("Beam")
      beam.Name = "Tracer"
      
      beam.Attachment0 = origin
      beam.Attachment1 = destiny
      
      beam.Color = section.Color or ColorSequence.new(Color3.fromRGB(255, 125, 0))
      
      beam.FaceCamera = section.FaceCamera or true
      beam.Width0 = section.Width0 or 0.15
      beam.Width1 = section.Width1 or 0.15
      
      beam.Parent = Folder
    end
  end
  
  if #Folder:GetChildren() <= 0 then Folder:Destroy() end
  
--[[  return {
    Disable = function(self)
      parent.Luz.Enabled = false
    end,
    Enable = function(self)
      parent.Luz.Enabled = true
    end,
  }--]]
end

local Gokka = loadstring(game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/extra/Gokka.lua"))()
function Lib:RegisterListener(data)
  local from, name, validate = data.From, data.Name, data.Validate
  
  local function Proceed(obj)
    local ok, esp = validate(obj)
    if ok then
      esp.Name = name .. "-auto"
      esp.Parent = obj
      
      Lib:BasicESP(esp)
    end
  end
  
  for _, obj in next, from:GetChildren() do
    Proceed(obj)
  end
  
  Gokka:Connect({
    Name = name,
    Parent = from,
    Signal = "ChildAdded",
    Callback = function(obj)
      Proceed(obj)
    end
  })
end

function Lib:Hi()
  print("Hello!")
end

return Lib
