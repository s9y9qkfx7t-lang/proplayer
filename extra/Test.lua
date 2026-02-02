local Window = WindUI:CreateWindow({
  Title = "Triangulare | " .. (InitializeName or "Undefined"),
  Icon = "triangle",
  Author = "by Moligrafi",
  Folder = "Triangulare",
  Size = UDim2.fromOffset(620, 400),
  Transparent = true,
  Theme = "Dark",
  User = {
    Enabled = true
  },
  SideBarWidth = 200,
  HasOutline = true
})
task.spawn(function()
  Window:CreateTopbarButton("Donate", "hand-coins", function()
    Window:Dialog({
      Title = "Support",
      Content = "Would you like to support the hub and its developers? To keep it free and keyless.\n\nShowcasers can get their video pinged in our discord server.\n\nSelect the option that best fits you.",
      Icon = "hand-coins",
      Buttons = {
        {
          Title = "No, I don't want to support this",
          Variant = "Tertiary",
          Icon = "x",
          Callback = function()
            WindUI:Notify({
              Title = "Thanks...",
              Content = "That's optional.",
              Icon = "frown",
              Duration = 3,
            })
          end
        },
        {
          Title = "Yes, i would like to contribute",
          Variant = "Secondary",
          Icon = "code-xml",
          Callback = function()
            Window:Dialog({
              Title = "Contributor",
              Content = "Nice! The server link was copied to your clipboard! Open a ticket to get the instructions, anyone is welcome! :D",
              Icon = "code",
              Buttons = {
                {
                  Title = "Thanks for the opportunity",
                  Icon = "smile",
                  Variant = "Tertiary"
                }
              }
            })
            
            setclipboard("https://discord.gg/q7xBfkwdjc")
            WindUI:Notify({
              Title = "Link copied!",
              Content = "Paste the link in your browser.",
              Duration = 3,
              Icon = "clipboard"
            })
          end
        },
        {
          Title = "Yes, i would like to showcase",
          Variant = "Secondary",
          Icon = "monitor-play",
          Callback = function()
            Window:Dialog({
              Title = "Showcaser",
              Content = "Nice! The server link was copied to your clipboard, after you showcase the script open a ticket and send your video link, you'll get your video pinged in the showcasers channel and we'll give you a special showcaser role! :D",
              Icon = "monitor-play",
              Buttons = {
                {
                  Title = "Yes, i'll send the link",
                  Icon = "link",
                  Variant = "Tertiary"
                }
              }
            })
            
            setclipboard("https://discord.gg/q7xBfkwdjc")
            WindUI:Notify({
              Title = "Link copied!",
              Content = "Paste the link in your browser.",
              Duration = 3,
              Icon = "clipboard"
            })
          end
        },
        {
          Title = "Yes, sure, money?",
          Icon = "banknote",
          Callback = function()
            setclipboard("https://discord.gg/q7xBfkwdjc")
            WindUI:Notify({
              Title = "Link copied!",
              Content = "Paste the link in your browser.",
              Icon = "clipboard",
              Duration = 3,
            })
          end
        },
      }
    })
  end, 990)
  Window:Tag({
    Title = "Keyless",
    Icon = "lock-keyhole-open",
    Color = Color3.fromRGB(40, 187, 103),
    Radius = 9
  })
  Window:Tag({
    Title = "Free",
    Icon = "banknote-x",
    Color = Color3.fromRGB(40, 187, 103),
    Radius = 9
  })

  WindUI:Notify({
    Title = "Welcome!",
    Content = "Free & Keyless. Support us to keep it this way!",
    Icon = "shield-check",
    Duration = 5
  })
  task.wait(math.random(300, 600))
  WindUI:Notify({
    Title = "Enjoying the script?",
    Content = "Consider donating or showcasing to support our work! Feel free to report any issues or suggest new features!",
    Icon = "heart",
    Duration = 8
  })
end)
