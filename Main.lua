--[[
	Service
]]
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")
local HttpService = game:GetService("HttpService")

--Output message premade

local richTextError = "<font color='rgb(255,0,0)'>[ERROR]</font>"
local richTextWarning = "<font color='rgb(255, 255, 0)'>[WARNING]</font>"
local richTextInfo = "<font color='rgb(85, 170, 255)'>[INFO]</font>"

local messageType = {
	["error"] = richTextError,
	["warning"] = richTextWarning,
	["info"] = richTextInfo,
}

local outputMessagePreMade = Instance.new("TextLabel")
outputMessagePreMade.Size = UDim2.new(.98,0,.2,0)
outputMessagePreMade.TextScaled = true
outputMessagePreMade.BackgroundTransparency = 1
outputMessagePreMade.TextColor3 = Color3.new(1, 1, 1)
outputMessagePreMade.RichText = true
outputMessagePreMade.TextXAlignment = Enum.TextXAlignment.Left

--Importing RBXL Studio Widgets
local req = HttpService:GetAsync("https://api.github.com/repos/Roblox/StudioWidgets/contents/src")
local json = HttpService:JSONDecode(req)

local targetFolder = Instance.new("Folder")
targetFolder.Name = "StudioWidgets"
targetFolder.Parent = script

for i = 1, #json do
	local file = json[i]
	if (file.type == "file") then
		local name = file.name:sub(1, #file.name-4)
		local module = targetFolder:FindFirstChild(name) or Instance.new("ModuleScript")
		module.Name = name
		module.Source = HttpService:GetAsync(file.download_url)
		module.Parent = targetFolder
	end
end

--Require of the UI Component
task.wait()
local CustomTextButton = require(script.StudioWidgets.CustomTextButton)
local CollapsibleTitledSection = require(script.StudioWidgets.CollapsibleTitledSection)
--Function

local function SyncGuiColors(objects)
	local function setColors()
		for _, guiObject in objects do
			-- Sync background color
			guiObject.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainBackground)
			-- Sync text color
			guiObject.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
		end
	end
	-- Run 'setColors()' function to initially sync colors
	setColors()
	-- Connect 'ThemeChanged' event to the 'setColors()' function
	settings().Studio.ThemeChanged:Connect(setColors)
end


--Creating the toolbar button

-- Create a new toolbar section titled "Custom Script Tools"
local toolbar = plugin:CreateToolbar("Echelon Installer")

-- Add a toolbar button named "Create Empty Script"
local toolbarButton = toolbar:CreateButton("Echelon Installer", "Open the Echelon Installer Widget", "rbxassetid://14978048121")

-- Make button clickable even if 3D viewport is hidden
toolbarButton.ClickableWhenViewportHidden = true

local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Left, -- Widget will be initialized in floating panel
	false,   -- Widget will be initially enabled
	false,  -- Don't override the previous enabled state
	200,    -- Default width of the floating window
	300,    -- Default height of the floating window
	150,    -- Minimum width of the floating window
	150     -- Minimum height of the floating window
)

-- Create new widget GUI
local mainWidget: DockWidgetPluginGui = plugin:CreateDockWidgetPluginGui("EchelonWidget", widgetInfo)
mainWidget.Title = "Echelon Installer"  -- Optional widget title

function ScriptActivation()
	print("Yo2")
	print(mainWidget.HostWidgetWasRestored)
	print(mainWidget.Enabled)
	mainWidget.Enabled = not mainWidget.Enabled
end

toolbarButton.Click:Connect(ScriptActivation)

--Creating UI Component for the Widget

--Widget Footer

local label = Instance.new("TextLabel")
label.Name = "WidgetFooter"
label.Text = "Version 1.0, Made by R14GENIE and I'm not affiliated with 'Versify' or 'Echelon', I'm just doing this funny plugin, if you an issue, please contact me on the Versify Discord."
label.Position = UDim2.new(0,0,.95,0)
label.Size = UDim2.new(1, 0, .05, 0)
label.BackgroundTransparency = 1
label.BorderSizePixel = 0
label.TextColor3 = Color3.fromRGB(131, 131, 131)
label.TextScaled = true
label.Parent = mainWidget

--Widget Top
local label = Instance.new("TextLabel")
label.Name = "WidgetTopInfo"
label.Text = "To install echelon, please select on your explorer your echelon folder you have just import."
label.Position = UDim2.new(0,0,0,0)
label.Size = UDim2.new(1, 0, .05, 0)
label.BackgroundTransparency = 1
label.BorderSizePixel = 0
label.TextColor3 = Color3.fromRGB(131, 131, 131)
label.TextScaled = true
label.Parent = mainWidget

--Text on Top of Output
local label = Instance.new("TextLabel")
label.Name = "WidgetTopInfo"
label.Text = "Plugin Output:"
label.Position = UDim2.new(0.01,0,.75,0)
label.Size = UDim2.new(.98, 0, .05, 0)
label.BackgroundTransparency = 1
label.BorderSizePixel = 0
label.TextColor3 = Color3.fromRGB(131, 131, 131)
label.TextScaled = true
label.TextXAlignment = Enum.TextXAlignment.Left
label.Parent = mainWidget

--Plugin Output

local framePluginOutput = Instance.new("Frame")
framePluginOutput.Name = "FramePluginOutput"
framePluginOutput.Size = UDim2.new(1,0,.15,0)
framePluginOutput.Position = UDim2.new(0,0,.8)
framePluginOutput.ClipsDescendants = true
framePluginOutput.Parent = mainWidget
framePluginOutput.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

local uiListLayoutForOuput = Instance.new("UIListLayout")
uiListLayoutForOuput.VerticalAlignment = Enum.VerticalAlignment.Bottom
uiListLayoutForOuput.HorizontalAlignment = Enum.HorizontalAlignment.Right
uiListLayoutForOuput.Parent = framePluginOutput


local function GetTimeWithMilliseconds()
	local ms = DateTime.now().UnixTimestampMillis


	local totalSeconds = math.floor(ms / 1000)
	local milliseconds = ms % 1000


	local seconds = totalSeconds % 60
	local minutes = math.floor(totalSeconds / 60) % 60
	local hours = math.floor(totalSeconds / 3600) % 24

	-- Fformat HH:MM:SS:Milliseconds
	local timeStr = string.format("%02d:%02d:%02d:%03d", hours, minutes, seconds, milliseconds)
	
	timeStr = "["..timeStr.."]"
	
	return timeStr
end

function UnpackInstallationPart(part: Model, targetParent)
	
	for _,child in pairs(part:GetChildren())do
		
		child.Parent = targetParent
		
	end
	
end


function GeneratePluginOutput(typeOfMessage: string, message: string)
	
	local newMessage = outputMessagePreMade:Clone()
	
	local finalText = messageType[typeOfMessage]..GetTimeWithMilliseconds()..message
	newMessage.Text = finalText
	newMessage.Parent = framePluginOutput
	
end

--Install button
local button = CustomTextButton.new(
	"InstallButton", -- name of the gui object
	"Install Echelon" -- the text displayed on the button
)

-- use the :getButton() method to return the ImageButton gui object
local buttonObject = button:GetButton()
buttonObject.Size = UDim2.new(1, 0, 0.15, 25)
buttonObject.Position = UDim2.new(0,0,.1,0)

buttonObject.MouseButton1Click:Connect(function()
	
	local selectedObjets = Selection:Get()
	
	if #selectedObjets == 0 then
		
		GeneratePluginOutput("warning","No Folder Selected")
		return
		
	end
	
	if #selectedObjets > 1 then
		
		GeneratePluginOutput("warning","Multiple Instance selected")
		return
		
	end
	
	local echelonFolder = selectedObjets[1]
	
	--Checking if that's a folder
	
	if not echelonFolder:IsA("Folder") then
		
		GeneratePluginOutput("warning","Instance Selected is not a folder")
		return
		
	end
	
	GeneratePluginOutput("info","Validating the Folder...")
	
	--Checking if that's an Echelon Files
	local Success, Data = pcall(function()
		
		local sharedRSFolder = echelonFolder.ReplicatedStorage.Shared_Echelon
			
	end)

	if not Success then
		GeneratePluginOutput("warning","Multiple Instance selected")
		return
	end
	
	
	
	--Installation Part
	
	--Checking if all part of Echelon correctly exist
	local replicatedStoragePart
	local serverScriptServicePart
	local starterGuiPart
	local starterPlayerScriptsPart
	local toolsPart
	local workspacePart
	
	--Checking part one by one
	local Success, Data = pcall(function()

		replicatedStoragePart = echelonFolder.ReplicatedStorage

	end)

	if not Success then
		GeneratePluginOutput("error","Echelon Installation Folder is missing the 'ReplicatedStorage' part")
		return
	end
	
	local Success, Data = pcall(function()

		serverScriptServicePart = echelonFolder.ServerScriptService

	end)

	if not Success then
		GeneratePluginOutput("error","Echelon Installation Folder is missing the 'ServerScriptService' part")
		return
	end
	
	local Success, Data = pcall(function()

		starterGuiPart = echelonFolder.StarterGui

	end)

	if not Success then
		GeneratePluginOutput("error","Echelon Installation Folder is missing the 'StarterGui' part")
		return
	end
	
	local Success, Data = pcall(function()

		starterPlayerScriptsPart = echelonFolder.StarterPlayerScripts

	end)

	if not Success then
		GeneratePluginOutput("error","Echelon Installation Folder is missing the 'StarterPlayerScripts' part")
		return
	end
	
	local Success, Data = pcall(function()

		toolsPart = echelonFolder.Tools

	end)

	if not Success then
		GeneratePluginOutput("error","Echelon Installation Folder is missing the 'Tools' part")
		return
	end
	
	local Success, Data = pcall(function()

		workspacePart = echelonFolder.Workspace

	end)

	if not Success then
		GeneratePluginOutput("error","Echelon Installation Folder is missing the 'Workspace' part")
		return
	end
	
	GeneratePluginOutput("info","Installation Folder Valid, starting the installation...")
	local recording = ChangeHistoryService:TryBeginRecording("MyAction")
	
	if not recording then
		
		GeneratePluginOutput("error", "ChangeHistoryService didn't start to record your action, cancelling installation, please re-try!")
		return
	end
	
	local unpackingPart = 'ReplicatedStorage'
	GeneratePluginOutput("info","Unpacking '"..unpackingPart.."'...")
	
	local Success, Data = pcall(function()

		UnpackInstallationPart(replicatedStoragePart, game:GetService("ReplicatedStorage"))

	end)

	if not Success then
		GeneratePluginOutput("error","Echelon Installation as hit when unpacking '"..unpackingPart.."' an error, please report this to R14GENIE on Versify Server! Error:"..Data)
		return
	end
	
	local unpackingPart = 'ServerScriptService'
	GeneratePluginOutput("info","Unpacking '"..unpackingPart.."'...")

	local Success, Data = pcall(function()

		UnpackInstallationPart(serverScriptServicePart, game:GetService("ServerScriptService"))

	end)

	if not Success then
		GeneratePluginOutput("error","Echelon Installation as hit when unpacking '"..unpackingPart.."' an error, please report this to R14GENIE on Versify Server! Error:"..Data)
		return
	end
	
	local unpackingPart = 'StarterGui'
	GeneratePluginOutput("info","Unpacking '"..unpackingPart.."'...")

	local Success, Data = pcall(function()

		UnpackInstallationPart(starterGuiPart, game:GetService("StarterGui"))

	end)

	if not Success then
		GeneratePluginOutput("error","Echelon Installation as hit when unpacking '"..unpackingPart.."' an error, please report this to R14GENIE on Versify Server! Error:"..Data)
		return
	end
	
	local unpackingPart = 'StarterPlayerScripts'
	GeneratePluginOutput("info","Unpacking '"..unpackingPart.."'...")

	local Success, Data = pcall(function()

		UnpackInstallationPart(starterPlayerScriptsPart, game:GetService("StarterPlayer").StarterPlayerScripts)

	end)

	if not Success then
		GeneratePluginOutput("error","Echelon Installation as hit when unpacking '"..unpackingPart.."' an error, please report this to R14GENIE on Versify Server! Error:"..Data)
		return
	end
	
	local unpackingPart = 'Tools'
	GeneratePluginOutput("info","Unpacking '"..unpackingPart.."'...")

	local Success, Data = pcall(function()

		UnpackInstallationPart(toolsPart, game:GetService("StarterPack"))

	end)

	if not Success then
		GeneratePluginOutput("error","Echelon Installation as hit when unpacking '"..unpackingPart.."' an error, please report this to R14GENIE on Versify Server! Error:"..Data)
		return
	end
	
	local unpackingPart = 'Workspace'
	GeneratePluginOutput("info","Unpacking '"..unpackingPart.."'...")

	local Success, Data = pcall(function()

		UnpackInstallationPart(workspacePart, game:GetService("Workspace"))

	end)

	if not Success then
		GeneratePluginOutput("error","Echelon Installation as hit when unpacking '"..unpackingPart.."' an error, please report this to R14GENIE on Versify Server! Error:"..Data)
		return
	end
	
	GeneratePluginOutput("info",echelonFolder.Name.." was successfully installed!")
	GeneratePluginOutput("warning","Remember, you have to re-publish all animation and if you need assistance, get on the Versify Discord!")
	
	echelonFolder:Destroy()
	ChangeHistoryService:FinishRecording(recording, Enum.FinishRecordingOperation.Commit)
end)

buttonObject.Parent = mainWidget