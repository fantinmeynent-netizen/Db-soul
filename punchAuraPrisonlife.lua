local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 320)
frame.Position = UDim2.new(0.02, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1, -10, 0, 40)
toggle.Position = UDim2.new(0, 5, 0, 5)
toggle.Text = "OFF"
toggle.BackgroundColor3 = Color3.fromRGB(200,0,0)

local list = Instance.new("ScrollingFrame", frame)
list.Size = UDim2.new(1, -10, 0, 260)
list.Position = UDim2.new(0, 5, 0, 50)
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.ScrollBarThickness = 5

local layout = Instance.new("UIListLayout", list)
layout.Padding = UDim.new(0,5)

local whitelist = {}
local running = false

local function refreshCanvas()
	list.CanvasSize = UDim2.new(0,0,0, #list:GetChildren()*35)
end

local function createPlayerButton(plr)
	local b = Instance.new("TextButton", list)
	b.Size = UDim2.new(1, -10, 0, 30)
	b.Text = plr.Name
	b.BackgroundColor3 = Color3.fromRGB(60,60,60)

	b.MouseButton1Click:Connect(function()
		if whitelist[plr.Name] then
			whitelist[plr.Name] = nil
			b.BackgroundColor3 = Color3.fromRGB(60,60,60)
		else
			whitelist[plr.Name] = true
			b.BackgroundColor3 = Color3.fromRGB(0,170,0)
		end
	end)

	refreshCanvas()
end

for _,plr in pairs(Players:GetPlayers()) do
	if plr ~= lp then createPlayerButton(plr) end
end

Players.PlayerAdded:Connect(function(plr)
	if plr ~= lp then createPlayerButton(plr) end
end)

Players.PlayerRemoving:Connect(function(plr)
	whitelist[plr.Name] = nil
	for _,b in ipairs(list:GetChildren()) do
		if b:IsA("TextButton") and b.Text == plr.Name then
			b:Destroy()
		end
	end
	refreshCanvas()
end)

toggle.MouseButton1Click:Connect(function()
	running = not running
	if running then
		toggle.Text = "ON"
		toggle.BackgroundColor3 = Color3.fromRGB(0,200,0)
	else
		toggle.Text = "OFF"
		toggle.BackgroundColor3 = Color3.fromRGB(200,0,0)
	end
end)

task.spawn(function()
	while true do
		if running then
			for _,plr in pairs(Players:GetPlayers()) do
				if plr ~= lp and not whitelist[plr.Name] then
					RS.meleeEvent:FireServer(plr)
				end
			end
		end
		task.wait(0.05)
	end
end)
