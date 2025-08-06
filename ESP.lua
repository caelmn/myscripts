local ESP_Group = {}
ESP_Group.__index = ESP_Group

local ESP_Frame = {}
ESP_Frame.__index = ESP_Frame

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

function getStudsAway(part)
	local player = Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local primaryPart = character.PrimaryPart
	if not (primaryPart and part) then return nil end

	local distance = (part.Position - primaryPart.Position).Magnitude
	return math.floor(distance + 0.5)
end


local function createFrame(part)
	local BillboardGui = Instance.new("BillboardGui", part)
	BillboardGui.Size = UDim2.new(5,0,5,0)
	BillboardGui.AlwaysOnTop = true
	BillboardGui.ClipsDescendants = false
	
	local Frame = Instance.new("Frame", BillboardGui)
	Frame.Size = UDim2.fromScale(1,1)
	Frame.BackgroundTransparency = 1
	
	local UIListLayout = Instance.new("UIListLayout", Frame)
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.VerticalFlex = Enum.UIFlexAlignment.Fill
	
	return Frame
end

local function createLabel(frame:Frame)
	local label = Instance.new("TextLabel", frame)
	label.TextScaled = true
	label.FontFace = Font.fromName("Inconsolata", Enum.FontWeight.Bold)
	label.BackgroundTransparency = 1
	
	local UIStroke = Instance.new("UIStroke", label)
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	UIStroke.Thickness = 2
	
	return label
end

--== ESP GROUP ==--

function ESP_Group.new(name:string, color:Color3)
	local self = setmetatable({}, ESP_Group)
	self.name = name
	self.color = color
	self.espFrames = {}
	self.frames = {}
	
	return self
end

function ESP_Group:newFrame(part:BasePart)
	local frame = setmetatable({}, ESP_Frame)
	frame.frame = createFrame(part)
	frame.part = part
	
	frame:addLabel(self.name, self.color)
	
	table.insert(self.frames, frame)
	
	return frame
end

function ESP_Group:clear()
	for _, frame in pairs(self.frames) do
		frame:destroy()
	end
end

--== ESP FRAME ==--

function ESP_Frame:addLabel(text:string, color:Color3, id:string)
	local label = createLabel(self.frame)
	label.Text = text
	label.TextColor3 = color or Color3.new(1,1,1)
	
	return label
end

function ESP_Frame:addDistanceLabel()
	local label:TextLabel = self:addLabel("0m", Color3.new(1,1,1), "distance")
	self.runConnection = RunService.Stepped:Connect(function()
		label.Text = `{getStudsAway(self.part)}m`
	end)
end

function ESP_Frame:destroy()
	if self.runConnection then
		self.runConnection:Disconnect()
	end
	
	self.frame:Destroy()
	self = nil
end

return ESP_Group
