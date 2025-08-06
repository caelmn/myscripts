local Aimbot = {}
Aimbot.__index = Aimbot

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local localPlr = Players.LocalPlayer
local currentCamera = workspace.CurrentCamera

local function getLocalCharacter()
	return localPlr.Character or localPlr.CharacterAdded:Wait()
end

local function getClosestCharacter(characters)
	local closest = nil
	local shortestDistance = math.huge

	local localCharacter = getLocalCharacter()
	
	local success, result = pcall(function()
		for _, character in ipairs(characters) do
			if character.PrimaryPart and character ~= localCharacter and character.Humanoid.Health > 0 then
				local distance = (character.PrimaryPart.Position - localCharacter.PrimaryPart.Position).Magnitude
				if distance < shortestDistance then
					shortestDistance = distance
					closest = character
				end
			end
		end
	end)
	
	if not success then warn(result) end

	return closest
end

local function getClosestPart(parts)
	local origin = getLocalCharacter().PrimaryPart
	if not origin then return nil end

	local closest = nil
	local shortestDistance = math.huge

	for _, part in ipairs(parts) do
		if part:IsA("BasePart") then
			local distance = (part.Position - origin.Position).Magnitude
			if distance < shortestDistance then
				shortestDistance = distance
				closest = part
			end
		end
	end

	return closest
end

local function isVisible(part)
	local localCharacter = getLocalCharacter()
	local origin = localCharacter.PrimaryPart.Position
	local direction = (part.Position - origin)

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	raycastParams.FilterDescendantsInstances = { part.Parent, localCharacter }
	raycastParams.IgnoreWater = true

	local result = workspace:Raycast(origin, direction, raycastParams)

	return (not result) or result.Instance == part
end

function Aimbot.new()
	local self = setmetatable({}, Aimbot)
	self.runConnection = nil
	self.currentTarget = nil
	self.raycastEnabled = false
	
	self.runConnection = RunService.RenderStepped:Connect(function()
		if self.currentTarget then
			localPlr.CameraMode = Enum.CameraMode.LockFirstPerson
			
			local part = self.currentTarget
			if self.raycastEnabled then
				if not isVisible(part) then return end
			end
			
			local camPos = currentCamera.CFrame.Position
			local targetPos = part.Position
			local newLook = (targetPos - camPos).Unit
			currentCamera.CFrame = CFrame.new(camPos, camPos + newLook)
		end
	end)
	
	return self
end

function Aimbot:_disconnectLoop()
	if self.loopRunConnection then
		self.loopRunConnection:Disconnect()
		self.loopRunConnection = nil
	end
end

function Aimbot:lockOnPart(part)
	self:_disconnectLoop()

	self.currentTarget = part
end

function Aimbot:lockOnCharacters(characters)
	self:_disconnectLoop()

	self.loopRunConnection = RunService.Heartbeat:Connect(function()
		local closestCharacter = getClosestCharacter(characters)
		if closestCharacter then
			self.currentTarget = closestCharacter.PrimaryPart
		end
	end)
end

function Aimbot:lockOnParts(parts)
	self:_disconnectLoop()


	self.loopRunConnection = RunService.Heartbeat:Connect(function()
		local closestPart = getClosestPart(parts)
		if closestPart then
			self.currentTarget = closestPart
		end
	end)
end

function Aimbot:stop()
	if self.runConnection then
		self.runConnection:Disconnect()
	end

	if self.loopRunConnection then
		self.loopRunConnection:Disconnect()
	end
	
	localPlr.CameraMode = Enum.CameraMode.Classic
end

return Aimbot
