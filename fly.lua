-- Надежный скрипт полета через CFrame
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Настройки
local flying = false
local speed = 50
local guiEnabled = true

-- Создание GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGuiFixed"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "✈️ Fly Fixed"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = frame

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(1, -20, 0, 40)
flyButton.Position = UDim2.new(0, 10, 0, 35)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
flyButton.Text = "Включить полет"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 16
flyButton.Font = Enum.Font.GothamBold
flyButton.Parent = frame

-- Логика кнопки
flyButton.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        flyButton.Text = "Выключить полет"
        flyButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        humanoid.PlatformStand = true -- Отключаем ходьбу
    else
        flyButton.Text = "Включить полет"
        flyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        humanoid.PlatformStand = false
    end
end)

-- Основной цикл полета
RunService.RenderStepped:Connect(function()
    if not flying then return end
    
    local camera = workspace.CurrentCamera
    local moveDirection = Vector3.new(0, 0, 0)
    
    -- Получаем векторы камеры
    local lookVector = camera.CFrame.LookVector
    local rightVector = camera.CFrame.RightVector
    
    -- WASD
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
    
    -- Вверх/Вниз
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        moveDirection = moveDirection + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        moveDirection = moveDirection - Vector3.new(0, 1, 0)
    end
    
    -- Применяем движение напрямую к CFrame
    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit * (speed / 10) -- Делим на 10 для плавности
        humanoidRootPart.CFrame = humanoidRootPart.CFrame + moveDirection
    end
    
    -- Поворачиваем персонажа лицом к камере (опционально)
    -- humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + lookVector)
end)

print("✅ Исправленный скрипт полета запущен!")
