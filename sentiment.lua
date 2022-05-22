---@diagnostic disable: deprecated
-- Setup Service variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

-- Import OrionLib and create Window
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Sentiment", HidePremium = false, SaveConfig = true, ConfigFolder = "SentimentConfig"})
local Orion = CoreGui:WaitForChild("Orion")

-- Read and create Config files
if isfolder("SentimentConfig") then
	if not isfolder("SentimentConfig/Core") then
		makefolder("SentimentConfig/Core")
	end
	if not isfolder("SentimentConfig/Scripts") then
		makefolder("SentimentConfig/Scripts")
	end
	if not isfolder("SentimentConfig/Songs") then
		makefolder("SentimentConfig/Songs")
	end
	if not isfile("SentimentConfig/Core/disclaimer.txt") then
		writefile("SentimentConfig/Core/disclaimer.txt", "Please do not edit the contents of these files.\nThese files are either core files for the script or config files you can change in-game.")
	end
	if not isfile("SentimentConfig/Core/color.r") then
        writefile("SentimentConfig/Core/color.r", "0.45490196347236633")
    end
    if not isfile("SentimentConfig/Core/color.g") then
        writefile("SentimentConfig/Core/color.g", "0.4117647111415863")
    end
    if not isfile("SentimentConfig/Core/color.b") then
        writefile("SentimentConfig/Core/color.b", "0.9137254953384399")
    end
end

local Label = nil

-- Setup PlayLocalSound function for playing sounds
local function PlayLocalSound (assetid)
	local sound = Instance.new("Sound")

	sound.SoundId = assetid
	sound.Parent = nil

	SoundService:PlayLocalSound(sound)
end

-- Setup sounds table for playing notifications/UI sounds
local function Sounds(Number)
	if Number == 1 then -- friend notification
		PlayLocalSound("rbxassetid://5515669992")
	elseif Number == 0 then -- boot sound
		PlayLocalSound("rbxassetid://9656007913")
	elseif Number == 2 then -- notify 2
		PlayLocalSound("rbxassetid://8503530582")
	elseif Number == 3 then -- slider tick
		PlayLocalSound("rbxassetid://9055474333")
	end
end

-- Play boot sound
Sounds(0)

-- Create LocalPlayer tab
local Tab = Window:MakeTab({
	Name = "LocalPlayer",
	Icon = "rbxassetid://7072716196",
	PremiumOnly = false
})

-- Create slider for walkspeed
local SelectedWS
Tab:AddSlider({
	Name = "Walkspeed",
	Min = 16,
	Max = 500,
	Default = 16,
	Increment = 1,
	Color = Color3.new(tonumber(readfile("SentimentConfig/Core/color.r")), tonumber(readfile("SentimentConfig/Core/color.g")), tonumber(readfile("SentimentConfig/Core/color.b"))),
	ValueName = "Speed",
	Callback = function(Value)
		Sounds(3)
		SelectedWS = Value
		LocalPlayer.Character.Humanoid.WalkSpeed = Value
	end    
})

-- Create slider for jump power
Tab:AddSlider({
	Name = "JumpPower",
	Min = 50,
	Max = 500,
	Default = 50,
	Increment = 1,
	Color = Color3.new(tonumber(readfile("SentimentConfig/Core/color.r")), tonumber(readfile("SentimentConfig/Core/color.g")), tonumber(readfile("SentimentConfig/Core/color.b"))),
	ValueName = "Speed",
	Callback = function(Value)
		Sounds(3)
		SelectedWS = Value
		LocalPlayer.Character.Humanoid.JumpPower = Value
	end    
})

-- Loop walkspeed function initialize
local LoopWSToggle = false
local LoopWSFunction = nil
local function LoopWS()
	if not LoopWSToggle then
		LoopWSToggle = true
		LoopWSFunction = RunService.RenderStepped:Connect(function()
			LocalPlayer.Character.Humanoid.WalkSpeed = SelectedWS
		end)
	else
		LoopWSToggle = false
		LoopWSFunction:Disconnect()
	end
end

-- Create toggle for walkspeed function
Tab:AddToggle({
	Name = "Loop Walkspeed",
	Default = false,
	Color = Color3.new(tonumber(readfile("SentimentConfig/Core/color.r")), tonumber(readfile("SentimentConfig/Core/color.g")), tonumber(readfile("SentimentConfig/Core/color.b"))),
	Callback = function(Value)
		LoopWS()
	end
})
LoopWS()

-- Create slider to change workspace gravity value 
Tab:AddSlider({
	Name = "Gravity",
	Min = 0,
	Max = 200,
	Default = 200,
	Color = Color3.new(tonumber(readfile("SentimentConfig/Core/color.r")), tonumber(readfile("SentimentConfig/Core/color.g")), tonumber(readfile("SentimentConfig/Core/color.b"))),
	Increment = 1,
	ValueName = "Gravity",
	Callback = function(Value)
		Sounds(3)
	    workspace.Gravity = Value
	end    
})

-- Create FOV slider
Tab:AddSlider({
	Name = "Field of View",
	Color = Color3.new(tonumber(readfile("SentimentConfig/Core/color.r")), tonumber(readfile("SentimentConfig/Core/color.g")), tonumber(readfile("SentimentConfig/Core/color.b"))),
	Min = 10,
	Max = 120,
	Default = 70,
	Increment = 1,
	ValueName = "FOV",
	Callback = function(Value)
		Sounds(3)
        workspace.CurrentCamera.FieldOfView = Value
	end    
})

-- Create anti-idle toggle
Tab:AddButton({
	Name = "Anti-Idle",
	Callback = function()
    	OrionLib:MakeNotification({
			Name = "Anti-Idle",
			Content = "Successfully ran.",
			Image = "rbxassetid://6031302993",
			Time = 15
		})
		Sounds(2)
		LocalPlayer.Idled:Connect(function()
			VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
			task.wait(1)
	        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
		end)
  	end 
})

Tab:AddButton({
	Name = "Anti-ClientKick", 
	Callback = function()
		OrionLib:MakeNotification({
			Name = "Client Kick Disabler",
			Content = "Client anti kick ran. NOTE: THIS WILL ONLY DISABLE ATTEMPTED KICKS FROM THE CLIENT, NOT THE SERVER.",
			Image = "rbxassetid://6031302993",
			Time = 5
		}) 
		Sounds(2)
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ImUltik/Sentiment/main/Sex"))()
	end
})

-- Create FPS cap slider
Tab:AddSlider({
	Name = "Set FPS Cap",
	Min = 30,
	Max = 500,
	Default = 120,
	Color = Color3.new(tonumber(readfile("SentimentConfig/Core/color.r")), tonumber(readfile("SentimentConfig/Core/color.g")), tonumber(readfile("SentimentConfig/Core/color.b"))),
	Increment = 1,
	ValueName = "FPS",
	Callback = function(Value)
		Sounds(3)
		setfpscap(Value)
	end    
})

-- Add Server Hop Button
Tab:AddButton({
	Name = "Server Hop",
	Callback = function()
		OrionLib:MakeNotification({
            Name = "Changing Server",
            Content = "See you later!",
            Image = "rbxassetid://6031243328",
            Time = 20
        })
        Sounds(2)
        task.wait(1)
		local Module = loadstring(game:HttpGet"https://raw.githubusercontent.com/LeoKholYt/roblox/main/lk_serverhop.lua")()
	    Module:Teleport(game.PlaceId)
  	end 
})

-- Add rejoin server button
Tab:AddButton({
	Name = "Rejoin",
	Callback = function()
        OrionLib:MakeNotification({
        	Name = "Rejoining",
        	Content = "Goodbye",
        	Image = "rbxassetid://6035047381",
        	Time = 20
        })
        Sounds(2)
        task.wait(1)
        loadstring(game:HttpGet"https://raw.githubusercontent.com/Exunys/Rejoin-Game/main/Rejoin%20Game.lua")()
  	end
})

-- On player join server, notify if they are a friend
Players.PlayerAdded:Connect(function(Player)
    if Player:IsFriendsWith(LocalPlayer.UserId) then
        OrionLib:MakeNotification({
            Name = "Friends",
            Content = "Your friend, " .. Player.Name .. ", has joined the game!",
            Image = "rbxassetid://6034287518",
            Time = 15
        })
	    Sounds(1)
    end
end)

-- Notify the user and welcome them back
OrionLib:MakeNotification({
	Name = "Welcome back, " .. LocalPlayer.Name,
	Content = "It's high noon.",
	Image = "rbxassetid://6035030079",
	Time = 15
})

local Tab = Window:MakeTab({
	Name = "Admin Cmds",
	Icon = "rbxassetid://6031229350",
	PremiumOnly = false
})

local FloatLoop

local commands = {
	test = {
		Description = "Test command",
		Callback = function (args)
			print(table.concat(args, " "))
		end,
		HiddenInDisplay = true
	},
	fly = {
		Description = "fly magic right",
		Callback = function (args) 

			local character = LocalPlayer.Character
			if character then
				local humanoid = character:FindFirstChildWhichIsA("Humanoid")
				if humanoid then
					local root = humanoid.RootPart

					if root then
						local originalPosition = root.Position
						root.Position = Vector3.new(1000,1000,1000)
						task.wait(1)
						root.Anchored = true

						local flyspeed = 1
						if tonumber(args[1]) ~= nil then
							flyspeed = tonumber(args[1])
						end
						local fakePart = Instance.new("Part", workspace)
						fakePart.Anchored = true
						fakePart.CanCollide = false
						fakePart.Size = Vector3.new(1,1,1)
						fakePart.Position = originalPosition
						if workspace.CurrentCamera then
							workspace.CurrentCamera.CameraSubject = fakePart
						else
							OrionLib:MakeNotification({
								Name = "Error",
								Content = "Camera does not exist!",
								Image = "rbxassetid://7733658271",
								Time = 15
							})
							Sounds(2)
						end
					else
						OrionLib:MakeNotification({
							Name = "Error",
							Content = "RootPart does not exist!",
							Image = "rbxassetid://7733658271",
							Time = 15
						})
						Sounds(2)
					end
				else
					OrionLib:MakeNotification({
						Name = "Error",
						Content = "Humanoid does not exist!",
						Image = "rbxassetid://7733658271",
						Time = 15
					})
					Sounds(2)
				end
			else
				OrionLib:MakeNotification({
					Name = "Error",
					Content = "Character does not exist!",
					Image = "rbxassetid://7733658271",
					Time = 15
				})
				Sounds(2)
			end
		end,
		HiddenInDisplay = false
	}
}

Tab:AddTextbox({
	Name = "Command Bar",
	Default = "Enter command",
	TextDisappear = true,
	Callback = function(Value)
		for i,v in pairs(commands) do
---@diagnostic disable-next-line: undefined-field
			local commandSplit = string.split(Value, " ")
			if string.lower(commandSplit[1]) == string.lower(i) then
				v.Callback(commandSplit) -- removes command from args table
			end
		end
	end	  
})

for i,v in pairs(commands) do
	if not v.HiddenInDisplay then
		Tab:AddLabel(i)
	end
end

local Tab = Window:MakeTab({
	Name = "Verified Scripts",
	Icon = "rbxassetid://7072706536",
	PremiumOnly = false
})

Tab:AddParagraph("Most Used Hub", "Solaris, best free and paid script. loads of features")

Tab:AddButton({
	Name = "Solaris Hub",
	Callback = function()
		loadstring(game:HttpGet('https://solarishub.dev/script.lua',true))()
  	end    
})

Tab:AddDropdown({
	Name = "Solaris Games",
	Default = "Phantom Forces",
	Options = {"Phantom Forces", "AUT" , "Arsenal", "Bad Business", "Big Paintball", "Blade Quest", "Clicker Madness", "Counter Blox", "Energy Assault", "Da Hood", "Jailbreak", "KAT", "Kings Legacy SS", "Murder Mystery", "Notoriety", "SCP Roleplay", "Shindo Life", "TOH", "Kings Legacy"},
	Callback = function(Value)
		
	end    
})

Tab:AddParagraph("Universal", "For all games")

Tab:AddButton({
	Name = "mollermethod",
	Callback = function()
      	loadstring (game:HttpGetAsync 'https://mthd.ml') {}
  	end    
})

Tab:AddButton({
	Name = "Orca",
	Callback = function()
		loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/richie0866/orca/master/public/snapshot.lua"))()
		OrionLib:MakeNotification({
        	Name = "Thank you for using Orca!",
        	Content = "Made by 0866#3049",
        	Image = "rbxassetid://6031302916",
        	Time = 10
        })
        Sounds(2)
  	end    
})

Tab:AddButton({
	Name = "Fates Admin",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/fatesc/fates-admin/main/main.lua"))();
  	end    
})

Tab:AddButton({
	Name = "Infinite Yield",
	Callback = function()
      	loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
  	end    
})

Tab:AddButton({
	Name = "OpenHub",
	Callback = function()
      	loadstring(game:HttpGet"https://raw.githubusercontent.com/ManuSoftware34/OpenHub/main/Latest")()
  	end    
})

Tab:AddParagraph("Simulator", "Simulator Games")

Tab:AddButton({
	Name = "Hades Hub (Sonic Speed Sim)",
	Callback = function()
      	loadstring(game:HttpGet("https://raw.githubusercontent.com/HadesRblx/src/master/HadesHub.lua", true))()
  	end    
})

Tab:AddButton({
	Name = "KJ HUB (Anime Fighters Sim)",
	Callback = function()
		loadstring(game.HttpGet(game, "https://raw.githubusercontent.com/KiJinGaming/FreeScript/main/KJHub.lua"))();
  	end    
})

Tab:AddButton({
	Name = "SAZA HUB (PET SIM X)",
	Callback = function()
      	loadstring(game:HttpGet"https://scriptblox.com/raw/SAZA-HUB_496")()
  	end    
})

Tab:AddParagraph("AutoPlay", "AutoPlay For games")

Tab:AddButton({
	Name = "Wally AutoPlayer (FUNKYFRIDAY)",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/funky-friday-autoplay/main/main.lua"))()
  	end    
})

Tab:AddParagraph("FPS Games", "Arsenal, Phantom Forces, Counterblox style")

Tab:AddButton({
	Name = "Elite Hub (Criminality)",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/T-byte-sketch/Elite-V3/main/Elite%20V3'))()
  	end    
})

Tab:AddButton({
	Name = "InnoHub (Arsenal)",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Innocentallity/Scripts/main/InnoHubNewerNewCauseSkids"))();
  	end    
})

local Tab = Window:MakeTab({
	Name = "Your Scripts",
	Icon = "rbxassetid://7072705696",
	PremiumOnly = false
})

Tab:AddParagraph("Tutorial on how to add scripts:", "To add scripts, go to the SentimentConfig folder and then next go in Scripts. After you have done this, add TXT or LUA files containing the script.")

for Index, Scripts in ipairs(listfiles("SentimentConfig/Scripts")) do
	Scripts = string.gsub(Scripts, [[SentimentConfig/Scripts\]], "")
	Tab:AddButton({
		Name = Scripts,
		Callback = function()
			loadstring(readfile("SentimentConfig/Scripts/" .. Scripts))() --
		end
	})
end

local Tab = Window:MakeTab({
	Name = "Develop Scripts",
	Icon = "rbxassetid://6034789883",
	PremiumOnly = false
})

Tab:AddParagraph("Hey Developer, here's a quick note:", "This is a tab where you can create scripts, using DarkDex, Hydroxide, SimpleSpy and more, You can request scripts in the discord server. Anyways not all scripts will work on your executor, unless you use Script-Ware. Script-Ware will have it's own edition of Dex. Thank you!")

Tab:AddButton({
	Name = "DarkDex",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua", true))()
  	end    
})

Tab:AddButton({
	Name = "Hydroxide (Remote Spy)",
	Callback = function()
      	local owner = "Upbolt"
        local branch = "revision"
        local function webImport(file)
            return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format(owner, branch, file)), file .. '.lua')()
        end
        webImport("init")
  	end    
})

Tab:AddButton({
	Name = "SimpleSpy",
	Callback = function()
      	loadstring(game:HttpGet("https://github.com/exxtremestuffs/SimpleSpySource/raw/master/SimpleSpy.lua"))()
  	end    
})

local Tab = Window:MakeTab({
    Name = "Music",
    Icon = "rbxassetid://6026660075",
    PremiumOnly = false
})

Tab:AddParagraph("How to use", "Add MP3 File(s) inside workspace and open the folder named SentimentConfig and go to Songs, then place the MP3 File there and re-execute script.")

local Song = Instance.new("Sound")
Song.Name = "Sound"
Song.SoundId = ""
Song.Volume = 1
Song.Parent = workspace
local Reverb = Instance.new("ReverbSoundEffect")
Reverb.Parent = Song
Reverb.Enabled = false
local Distortion = Instance.new("DistortionSoundEffect")
Distortion.Parent = Song
Distortion.Enabled = false

local Songs = listfiles("SentimentConfig/Songs")

for Index, SongFiles in ipairs(Songs) do
	Songs[Index] = string.match(SongFiles, "([^/\\]+)[/\\]*$")
end

local SongDropdown = Tab:AddDropdown({
	Name = "Song Selection",
	Default = "",
	Options = Songs,
	Callback = function(Value)	
	    if getcustomasset then
		    Song.SoundId = getcustomasset("SentimentConfig/Songs/" .. Value) 
	    elseif getsynasset then
	        Song.SoundId = getsynasset("SentimentConfig/Songs/" .. Value)
	    end
	end      
})

local function RefreshSongs()
	Songs = listfiles("SentimentConfig/Songs")
	for Index, SongFiles in ipairs(Songs) do
		Songs[Index] = string.match(SongFiles, "([^/\\]+)[/\\]*$")
	end
	SongDropdown:Refresh(Songs, true)
end

local Progress = Tab:AddLabel("Progress: 00:00 - 00:00")

RunService.RenderStepped:Connect(function()
	Progress:Set("Progress: " .. math.floor(Song.TimePosition) .. " seconds out of " .. math.floor(Song.TimeLength) .. " seconds")
end)

Tab:AddButton({
    Name = "Play",
    Callback = function()  
        Song:Play()
	end
})

Tab:AddButton({
    Name = "Resume",
    Callback = function()
        Song:Resume()
	end    
})

Tab:AddButton({
    Name = "Pause",
    Callback = function()
        Song:Pause()
	end    
})

Tab:AddButton({
    Name = "Stop",
    Callback = function()
        Song:Stop()
	end    
})

Tab:AddSlider({
	Name = "Volume",
	Min = 0.5,
	Max = 10,
	Default = 1,
	Color = Color3.new(tonumber(readfile("SentimentConfig/Core/color.r")), tonumber(readfile("SentimentConfig/Core/color.g")), tonumber(readfile("SentimentConfig/Core/color.b"))),
	Increment = 0.5,
	ValueName = "Volume",
	Callback = function(Value)
		Sounds(3)
		Song.Volume = Value
	end    
})

Tab:AddToggle({
	Name = "Loop",
	Default = false,
	Color = Color3.new(tonumber(readfile("SentimentConfig/Core/color.r")), tonumber(readfile("SentimentConfig/Core/color.g")), tonumber(readfile("SentimentConfig/Core/color.b"))),
	Callback = function(Value)
		Song.Looped = Value
	end
})

Tab:AddToggle({
	Name = "Reverb",
	Default = false,
	Color = Color3.new(tonumber(readfile("SentimentConfig/Core/color.r")), tonumber(readfile("SentimentConfig/Core/color.g")), tonumber(readfile("SentimentConfig/Core/color.b"))),
	Callback = function(Value)
		Reverb.Enabled = Value
	end
})

Tab:AddToggle({
	Name = "Distortion",
	Default = false,
	Color = Color3.new(tonumber(readfile("SentimentConfig/Core/color.r")), tonumber(readfile("SentimentConfig/Core/color.g")), tonumber(readfile("SentimentConfig/Core/color.b"))),
	Callback = function(Value)
		Distortion.Enabled = Value
	end
})

local Tab = Window:MakeTab({
	Name = "Settings",
	Icon = "rbxassetid://7072721682",
	PremiumOnly = false
})

Tab:AddLabel("Re-execute Sentiment to apply colors.")

Tab:AddColorpicker({
	Name = "UI Color",
	Default = Color3.new(tonumber(readfile("SentimentConfig/Core/color.r")), tonumber(readfile("SentimentConfig/Core/color.g")), tonumber(readfile("SentimentConfig/Core/color.b"))),
	Callback = function(Color)
	    writefile("SentimentConfig/Core/color.r", tostring(Color.R))
	    writefile("SentimentConfig/Core/color.g", tostring(Color.G))
	    writefile("SentimentConfig/Core/color.b", tostring(Color.B))
	end	  
})

Tab:AddBind({
    Name = "Toggle UI",
    Default = Enum.KeyCode.LeftAlt,
    Hold = false,
    Callback = function()
        local Sound = Instance.new("Sound")
		Sound.SoundId = "rbxassetid://8458408918"
		Sound.Parent = workspace
		Sound:Play()
        if Orion then
        	Orion.Enabled = not Orion.Enabled
        end
    end    
})

Tab:AddButton({
    Name = "Refresh Song Files",
    Callback = function()
        RefreshSongs()
	end    
})

Tab:AddButton({
    Name = "Delete Config (common fix)",
    Callback = function()
        delfolder("SentimentConfig")
	end    
})

local Tab = Window:MakeTab({
	Name = "Server Info",
	Icon = "rbxassetid://7072721644",
	PremiumOnly = false
})

Tab:AddLabel("Place: " .. MarketplaceService:GetProductInfo(game.PlaceId).Name)
Tab:AddLabel("Place ID: " .. game.PlaceId)
Tab:AddLabel("Server Job ID: " .. game.JobId)
local PlayerAmount = Tab:AddLabel("Players: undefined")
Tab:AddLabel("Maximum Players: " .. Players.MaxPlayers)
local ServerAge = Tab:AddLabel("Server Age: undefined")

RunService.RenderStepped:Connect(function()
	PlayerAmount:Set("Players: " .. #Players:GetPlayers())
	local Seconds = math.floor(workspace.DistributedGameTime)
	local Minutes = math.floor(workspace.DistributedGameTime / 60)
	local Hours = math.floor(workspace.DistributedGameTime / 60 / 60)
	Seconds = Seconds - (Minutes * 60)
	Minutes = Minutes - (Hours * 60)
	if string.len(Seconds) == 1 and not string.find(Seconds, "0") then
		Seconds = "0" .. Seconds
	elseif string.len(Seconds) == 1 and string.find(Seconds, "0") then
		Seconds = "00"
	end
	if Hours < 1 then 
		if Minutes < 1 then
			ServerAge:Set("Server Age: 00:" .. Seconds)
		else
			ServerAge:Set("Server Age: " .. Minutes .. ":" .. Seconds)
		end
	else
		ServerAge:Set("Server Age: " .. Hours .. ":" .. Minutes .. ":" .. Seconds)
	end
end) -- if anyone is seeing this i fucking hate this codeblock
---i se
local PreventCopy = true
Tab:AddDropdown({
	Name = "Invite",
	Default = "Console Link",
	Options = {"Console Link"},
	Callback = function(Value)
		if not PreventCopy then
			if Value == "Console Link" then
				setclipboard("Roblox.GameLauncher.joinGameInstance(" .. game.PlaceId .. ", '" .. game.JobId .. "')") -- will be more in future
			end
		end
	end
})
task.spawn(function()
	task.wait(3)
	PreventCopy = false
end)

local Tab = Window:MakeTab({
	Name = "User Info",
	Icon = "rbxassetid://6023426915",
	PremiumOnly = false
})

Tab:AddDropdown({
	Name = "Executor",
	Default = identifyexecutor(),
	Options = {identifyexecutor()},
	Callback = function(Value)
		
	end    
})

Tab:AddDropdown({
	Name = "Username",
	Default = LocalPlayer.Name,
	Options = {LocalPlayer.Name},
	Callback = function(Value)

	end    
})

Tab:AddDropdown({
	Name = "Permissions",
	Default = "Developer: False",
	Options = {"Blacklist: False", "Whitelist: False", "Developer: False"},
	Callback = function(Value)

	end    
})

local Tags = {
    [1558968057] = "Owner",
    [3247089925] = "Canvas",
    [94147627] = "Clown", -- isaac
	[1155355889] = "UltraBloxer108",
	[3009136872] = "nil#1111",
    [2922850806] = "Friends",
}

for Index, TextLabel in pairs(Orion:GetDescendants()) do
    if TextLabel:IsA("TextLabel") then
        if TextLabel.Text == "Standard" or TextLabel.Text == "Premium" then
            Label = TextLabel
			Label.Text = "User"
        end
    end
end

for Id, Name in pairs(Tags) do
    if LocalPlayer.UserId == Id then
        Label.Text = Name
    end
end

local Tab = Window:MakeTab({
	Name = "Credits",
	Icon = "rbxassetid://7072717857",
	PremiumOnly = false
})

Tab:AddDropdown({
	Name = "Script Developers",
	Default = "Ultik#0001",
	Options = {"Ultik#0001", "Extrovert#1785", "isaac deez bungo#0110", "nil#1111", "Perception#7960", "05_4#2430", "Smiley#1054", "Bea#7453"},
	Callback = function(Value)
		
	end 
})

Tab:AddParagraph("Library", "Orion by Sirius Software | discord.gg/sirius")
Tab:AddParagraph("Made for", "Script-Ware | https://script-ware.com")
Tab:AddParagraph("mollermethod", "https://discord.gg/jncvgVrTcY")
Tab:AddParagraph("Solaris", "discord.gg/solaris")
Tab:AddParagraph("Orca", "Made By 0866#3049")
Tab:AddParagraph("Other Credits", "Unknown")
Tab:AddButton({
	Name = "Copy Discord Server",
	Callback = function()
      	setclipboard("discord.gg/P8Spu7zRmm")
  	end    
})

-- Initialize OrionLib gui
---https://discord.gg/jncvgVrTcY :)
OrionLib:Init()
