-- Скрипт полета с GUI для Delta
-- Нажмите кнопку "Fly" для включения/выключения
-- Используйте ползунок для изменения скорости

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Переменные полета
local flying = false
local speed = 50
local bodyVelocity = nil
local bodyGyro = nil

-- Создание GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

-- Основная рамка
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🚀 Fly Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Кнопка включения/выключения
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(1, -20, 0, 40)
flyButton.Position = UDim2.new(0, 10, 0, 35)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
flyButton.Text = "Включить полет"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 16
flyButton.Font = Enum.Font.GothamBold
flyButton.Parent = frame

-- Ползунок скорости
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 80)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Скорость: 50"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = frame

local slider = Instance.new("Frame")
slider.Size = UDim2.new(1, -20, 0, 10)
slider.Position = UDim2.new(0, 10, 0, 100)
slider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
slider.Parent = frame

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0.5, 0, 1, 0)
sliderButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
sliderButton.Text = ""
sliderButton.Parent = slider

-- Функции полета
local function startFlying()
	if bodyVelocity then return end
	
	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bodyVelocity.Velocity = Vector3.new(0, 0, 0)
	bodyVelocity.Parent = humanoidRootPart
	
	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	bodyGyro.D = 100
	bodyGyro.P = 10000
	bodyGyro.Parent = humanoidRootPart
	
	humanoid.PlatformStand = true
end

local function stopFlying()
	if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
	if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
	humanoid.PlatformStand = false
end

-- Обработка кнопки
flyButton.MouseButton1Click:Connect(function()
	flying = not flying
	
	if flying then
		startFlying()
		flyButton.Text = "Выключить полет"
		flyButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
	else
		stopFlying()
		flyButton.Text = "Включить полет"
		flyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
	end
end)

-- Обработка ползунка скорости
local dragging = false
sliderButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or 
	   input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
	end
end)

sliderButton.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or 
	   input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
	                 input.UserInputType == Enum.UserInputType.Touch) then
		local mousePos = input.Position.X
		local sliderWidth = slider.AbsoluteSize.X
		local relativePos = math.clamp((mousePos - slider.AbsolutePosition.X) / sliderWidth, 0, 1)
		
		sliderButton.Size = UDim2.new(relativePos, 0, 1, 0)
		speed = math.floor(relativePos * 100) + 10
		speedLabel.Text = "Скорость: " .. speed
	end
end)

-- Основной цикл управления
RunService.RenderStepped:Connect(function()
	if not flying then return end
	
	local camera = workspace.CurrentCamera
	local moveDirection = Vector3.new(0, 0, 0)
	
	-- Получаем направление камеры
	local lookVector = camera.CFrame.LookVector
	local rightVector = camera.CFrame.RightVector
	
	-- Управление WASD
	if UserInputService:IsKeyDown(Enum.KeyCode.W) then
		moveDirection = moveDirection + lookVector
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then
		moveDirection = moveDirection - lookVector
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then
		moveDirection = moveDirection - rightVector
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then
		moveDirection = moveDirection + rightVector
	end
	
	-- Управление высотой (Пробел/Shift)
	if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
		moveDirection = moveDirection + Vector3.new(0, 1, 0)
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
		moveDirection = moveDirection - Vector3.new(0, 1, 0)
	end
	
	-- Применяем движение
	if moveDirection.Magnitude > 0 then
		moveDirection = moveDirection.Unit * speed
		bodyVelocity.Velocity = moveDirection
	end
	
	-- Поворачиваем персонажа в сторону камеры
	bodyGyro.CFrame = camera.CFrame
end)

print("✅ GUI полета загружен!")