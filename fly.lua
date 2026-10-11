-- ✅ WORKING FLY SCRIPT WITH GUI
-- Вставьте это в Delta и нажмите Execute

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Переменные
local flying = false
local speed = 50
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- === СОЗДАНИЕ GUI ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyHackGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

-- Рамка меню
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "✈️ FLY HACK"
Title.TextColor3 = Color3.fromRGB(0, 255, 100)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Frame

-- Кнопка ВКЛ/ВЫКЛ
local Button = Instance.new("TextButton")
Button.Size = UDim2.new(1, -20, 0, 40)
Button.Position = UDim2.new(0, 10, 0, 35)
Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Button.Text = "ВКЛЮЧИТЬ"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 16
Button.Parent = Frame

-- === ЛОГИКА ===
Button.MouseButton1Click:Connect(function()
    flying = not flying
    
    if flying then
        Button.Text = "ВЫКЛЮЧИТЬ"
        Button.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        humanoid.PlatformStand = true -- Отключаем обычную ходьбу
    else
        Button.Text = "ВКЛЮЧИТЬ"
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        humanoid.PlatformStand = false
    end
end)

-- Цикл полета (самая важная часть)
RunService.RenderStepped:Connect(function()
    if not flying then return end
    
    local camera = workspace.CurrentCamera
    local moveDirection = Vector3.new(0, 0, 0)
    
    -- Направление камеры
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
    
    -- Вверх (Space) и Вниз (Shift)
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        moveDirection = moveDirection + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        moveDirection = moveDirection - Vector3.new(0, 1, 0)
    end
    
    -- Применяем движение напрямую к персонажу
    if moveDirection.Magnitude > 0 then
        humanoidRootPart.CFrame = humanoidRootPart.CFrame + (moveDirection.Unit * (speed / 10))
    end
end)

print("✅ Скрипт загружен! Нажми кнопку в левом верхнем углу.")
