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

-- Import OrionLib and createq Window
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Satella", HidePremium = true, SaveConfig = true, ConfigFolder = "SatellaUniversal"})
local Orion = CoreGui:WaitForChild("Orion")

-- Read and create Config files
if isfolder("SatellaUniversal") then
	if not isfolder("/Core") then
		makefolder("SatellaUniversal/Core")
	end
	if not isfolder("SatellaUniversal/Scripts") then
		makefolder("SatellaUniversal/Scripts")
	end
	if not isfolder("SatellaUniversal/Songs") then
		makefolder("SatellaUniversal/Songs")
	end
	if not isfile("SatellaUniversal/Core/disclaimer.txt") then
		writefile("SatellaUniversal/Core/disclaimer.txt", "Please do not edit the contents of these files.\nThese files are either core files for the script or config files you can change in-game.")
	end
	if not isfile("SatellaUniversal/Core/color.r") then
        writefile("SatellaUniversal/Core/color.r", "0.45490196347236633")
    end
    if not isfile("SatellaUniversal/Core/color.g") then
        writefile("SatellaUniversal/Core/color.g", "0.4117647111415863")
    end
    if not isfile("SatellaUniversal/Core/color.b") then
        writefile("SatellaUniversal/Core/color.b", "0.9137254953384399")
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
	Icon = "rbxassetid://7743875962",
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
	Color = Color3.new(tonumber(readfile("SatellaUniversal/Core/color.r")), tonumber(readfile("SatellaUniversal/Core/color.g")), tonumber(readfile("SatellaUniversal/Core/color.b"))),
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
	Color = Color3.new(tonumber(readfile("SatellaUniversal/Core/color.r")), tonumber(readfile("SatellaUniversal/Core/color.g")), tonumber(readfile("SatellaUniversal/Core/color.b"))),
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
	Color = Color3.new(tonumber(readfile("SatellaUniversal/Core/color.r")), tonumber(readfile("SatellaUniversal/Core/color.g")), tonumber(readfile("SatellaUniversal/Core/color.b"))),
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
	Color = Color3.new(tonumber(readfile("SatellaUniversal/Core/color.r")), tonumber(readfile("SatellaUniversal/Core/color.g")), tonumber(readfile("SatellaUniversal/Core/color.b"))),
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
	Color = Color3.new(tonumber(readfile("SatellaUniversal/Core/color.r")), tonumber(readfile("SatellaUniversal/Core/color.g")), tonumber(readfile("SatellaUniversal/Core/color.b"))),
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
	Color = Color3.new(tonumber(readfile("SatellaUniversal/Core/color.r")), tonumber(readfile("SatellaUniversal/Core/color.g")), tonumber(readfile("SatellaUniversal/Core/color.b"))),
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
	Name = "Visuals",
	Icon = "rbxassetid://7733774602",
	PremiumOnly = false
})

local Tab = Window:MakeTab({
	Name = "Aimbot",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})


local Tab = Window:MakeTab({
    Name = "Music",
    Icon = "rbxassetid://6026660075",
    PremiumOnly = false
})

Tab:AddParagraph("How to use", "Add MP3 File(s) inside workspace and open the folder named SatellaUniversal and go to Songs, then place the MP3 File there and re-execute script.")

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

local Songs = listfiles("SatellaUniversal/Songs")

for Index, SongFiles in ipairs(Songs) do
	Songs[Index] = string.match(SongFiles, "([^/\\]+)[/\\]*$")
end

local SongDropdown = Tab:AddDropdown({
	Name = "Song Selection",
	Default = "",
	Options = Songs,
	Callback = function(Value)	
	    if getcustomasset then
		    Song.SoundId = getcustomasset("SatellaUniversal/Songs/" .. Value) 
	    elseif getsynasset then
	        Song.SoundId = getsynasset("SatellaUniversal/Songs/" .. Value)
	    end
	end      
})

local function RefreshSongs()
	Songs = listfiles("SatellaUniversal/Songs")
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
	Color = Color3.new(tonumber(readfile("SatellaUniversal/Core/color.r")), tonumber(readfile("SatellaUniversal/Core/color.g")), tonumber(readfile("SatellaUniversal/Core/color.b"))),
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
	Color = Color3.new(tonumber(readfile("SatellaUniversal/Core/color.r")), tonumber(readfile("SatellaUniversal/Core/color.g")), tonumber(readfile("SatellaUniversal/Core/color.b"))),
	Callback = function(Value)
		Song.Looped = Value
	end
})

Tab:AddToggle({
	Name = "Reverb",
	Default = false,
	Color = Color3.new(tonumber(readfile("SatellaUniversal/Core/color.r")), tonumber(readfile("SatellaUniversal/Core/color.g")), tonumber(readfile("SatellaUniversal/Core/color.b"))),
	Callback = function(Value)
		Reverb.Enabled = Value
	end
})

Tab:AddToggle({
	Name = "Distortion",
	Default = false,
	Color = Color3.new(tonumber(readfile("SatellaUniversal/Core/color.r")), tonumber(readfile("SatellaUniversal/Core/color.g")), tonumber(readfile("SatellaUniversal/Core/color.b"))),
	Callback = function(Value)
		Distortion.Enabled = Value
	end
})

local Tab = Window:MakeTab({
	Name = "Your Scripts",
	Icon = "rbxassetid://7733779730",
	PremiumOnly = false
})

Tab:AddParagraph("Tutorial on how to add scripts:", "To add scripts, go to the SatellaUniversal folder and then next go in Scripts. After you have done this, add TXT or LUA files containing the script.")

for Index, Scripts in ipairs(listfiles("SatellaUniversal/Scripts")) do
	Scripts = string.gsub(Scripts, [[SatellaUniversal/Scripts\]], "")
	Tab:AddButton({
		Name = Scripts,
		Callback = function()
			loadstring(readfile("SatellaUniversal/Scripts/" .. Scripts))() --
		end
	})
end

local Tab = Window:MakeTab({
	Name = "Develop Scripts",
	Icon = "rbxassetid://7734002839",
	PremiumOnly = false
})

Tab:AddParagraph("Hey Developer, here's a quick note:", "This is a tab where you can create scripts, using DarkDex, Hydroxide, SimpleSpy and more, You can request scripts in the discord server. Anyways not all scripts will work on your executor, unless you use Script-Ware. Script-Ware will have it's own edition of Dex. Thank you!")

Tab:AddButton({
	Name = "DarkDex",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/mainUniversal/BypassedDarkDexV3.lua", true))()
  	end    
})

Tab:AddButton({
	Name = "Hydroxide (Remote Spy)",
	Callback = function()
      	local owner = "Upbolt"
        local branch = "reSatella"
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
	Name = "Server Info",
	Icon = "rbxassetid://7072721644",
	PremiumOnly = false
})

Tab:AddLabel("Place: " .. MarketplaceService:GetProductInfo(game.PlaceId).Name)
Tab:AddLabel("Place ID: " .. game.PlaceId)
Tab:AddLabel("Server Job ID: " .. game.JobId)
local PlayerAmount = Tab:AddLabel("Players: undefined")
Tab:AddLabel("Maximum Players: " .. Players.MaxPlayers)
local ServerAge = Tab:AddLabel("In server: undefined")

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
			ServerAge:Set("In Server: 00:" .. Seconds)
		else
			ServerAge:Set("In Server: " .. Minutes .. ":" .. Seconds)
		end
	else
		ServerAge:Set("In Server: " .. Hours .. ":" .. Minutes .. ":" .. Seconds)
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
	Name = "Settings",
	Icon = "rbxassetid://7072721682",
	PremiumOnly = false
})

Tab:AddLabel("Re-execute Satella to apply colors.")

Tab:AddColorpicker({
	Name = "UI Color",
	Default = Color3.new(tonumber(readfile("SatellaUniversal/Core/color.r")), tonumber(readfile("SatellaUniversal/Core/color.g")), tonumber(readfile("SatellaUniversal/Core/color.b"))),
	Callback = function(Color)
	    writefile("SatellaUniversal/Core/color.r", tostring(Color.R))
	    writefile("SatellaUniversal/Core/color.g", tostring(Color.G))
	    writefile("SatellaUniversal/Core/color.b", tostring(Color.B))
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
        delfolder("SatellaUniversal")
	end    
})


-- Initialize OrionLib gui
--hi ultik
OrionLib:Init()
