local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer
local currentCamera = workspace.CurrentCamera

local function createESP(part:BasePart, color, infos)
	local BillboardGui = Instance.new("BillboardGui", part)
	BillboardGui.Size = UDim2.new(5,0,5,0)
	BillboardGui.AlwaysOnTop = true

	local Frame = Instance.new("Frame", BillboardGui)
	Frame.BackgroundColor3 = color
	Frame.BorderSizePixel = 0
	Frame.Transparency = 0.5
	Frame.Size = UDim2.new(1,0,1,0)

	local UIListLayout = Instance.new("UIListLayout", Frame)
	UIListLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
	UIListLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

	local UIPadding = Instance.new("UIPadding", Frame)
	UIPadding.PaddingBottom = UDim.new(0.04, 0)
	UIPadding.PaddingLeft = UDim.new(0.04, 0)
	UIPadding.PaddingRight = UDim.new(0.04, 0)
	UIPadding.PaddingTop = UDim.new(0.04, 0)

	for _, string in pairs(infos) do
		local label = Instance.new("TextLabel", Frame)
		label.Text = string
		label.TextScaled = true
		label.FontFace.Bold = true
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.new(1,1,1)
	end

	return BillboardGui
end

local function getCharacter()
	return plr.Character or plr.CharacterAdded:Wait()
end

local function tpChar(Position:Vector3)
	local char = getCharacter()
	char:MoveTo(Position)
end

local function determineRole(char:Model)
	local success, result = pcall(function()
		if char:GetAttribute("LivesGiven") then
			if char:GetAttribute("LivesGiven") > 1 then
				return "sheriff"
			else
				return "criminal"
			end
		else
			return "npc"
		end
	end)
	if success then return result end
end

local function getCharacters()
	local results = {}
	for _, v in pairs(workspace:GetChildren()) do
		if v:IsA("Model") and v:FindFirstChild("Humanoid") then
			local role = determineRole(v)
			results[v] = role
		end
	end
	return results
end

local function cleanESP(espTable)
	for _, v in pairs(espTable) do
		local success, result = pcall(function()
			v:Destroy()
		end)
		if not success then warn(result) end
	end
end

local function getCharactersWithRole(role:string)
	local allCharacters = getCharacters()
	local results = {}
	for character, cRole in pairs(allCharacters) do
		local humanoid:Humanoid = character.Humanoid
		if cRole == role then
			table.insert(results, character)
		end
	end
	
	return results
end

local Module_Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/caelmn/myscripts/refs/heads/main/Aimbot.lua"))()

--// UI Setup
local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))() -- https://xheptcofficial.gitbook.io/kavo-library
local Window = UILib.CreateLib("NPC or Die | By Nullix", "DarkTheme")

local tab_Game = Window:NewTab("Game")
local tab_Visual = Window:NewTab("Visual")
local tab_Character = Window:NewTab("Character")

local game_Section_Aimbot = tab_Game:NewSection("Aimbot")
local visual_Section_Main = tab_Visual:NewSection("Main")
local character_Section_Main = tab_Character:NewSection("Main")

--== Buttons n stuff ==--

--//GAME

--aimbot

local crim_Aimbot = Module_Aimbot.new()

game_Section_Aimbot:NewToggle("Criminal Aimbot", "Aimbot on all the Criminals.", function(state)
	if state then
		local criminals = getCharactersWithRole("criminal")
		crim_Aimbot:lockOnCharacters(criminals)
	else
		crim_Aimbot:stop()
	end
end)

game_Section_Aimbot:NewToggle("Raycast", "Raycast to check if the Criminals are visible.", function(state)
	crim_Aimbot.raycastEnabled = state
end)

--//VISUAL

local esp_Criminal = {}
visual_Section_Main:NewToggle("Criminal ESP", "See all of the Criminals.", function(state)
	if state then
		local criminals = getCharactersWithRole("criminal")
		for _, character in pairs(criminals) do
			local esp = createESP(character.PrimaryPart, Color3.new(1, 0.615686, 0), {character.Name, "Criminal"})
			table.insert(esp_Criminal, esp)
		end
	else
		cleanESP(esp_Criminal)
	end
end)

local esp_Sheriff = {}
visual_Section_Main:NewToggle("Sheriff ESP", "See all of the Sherrifs.", function(state)
	if state then
		local sheriffs = getCharactersWithRole("sheriff")
		for _, character in pairs(sheriffs) do
			local esp = createESP(character.PrimaryPart, Color3.new(0, 0.34902, 1), {character.Name, "Sheriff"})
			table.insert(esp_Sheriff, esp)
		end
	else
		cleanESP(esp_Sheriff)
	end
end)

-- character

local staminaLock = false
character_Section_Main:NewToggle("Infinite Stamina", "Never run out of stamina.", function(state)
	staminaLock = state
	if staminaLock then
		local sprintMod = plr.PlayerGui.Modules.Gameplay.Stamina
		local sprint = require(sprintMod)
		task.spawn(function()
			while staminaLock do
				if sprintMod then
					sprint.StaminaPercentage = 100
					task.wait(0.1)
				else
					sprint = require(plr.PlayerGui.Modules.Gameplay.Stamina)
				end
			end
		end)
	end
end)
