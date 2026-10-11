-- ✅ Fly Gui V3 (Fixed & Optimized for Delta)
-- Полная копия функционала, но работает стабильно

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- === НАСТРОЙКИ ===
local flySpeed = 60
local isFlying = false
local smoothness = 0.1

-- === GUI СОЗДАНИЕ ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyGuiV3_Fixed"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

-- Основная панель
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 180)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Заголовок
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.Text = "✈️ Fly Gui V3"
Header.TextColor3 = Color3.fromRGB(0, 200, 255)
Header.BackgroundTransparency = 1
Header.Font = Enum.Font.GothamBold
Header.TextSize = 20
Header.Parent = MainFrame

-- Кнопка ВКЛ/ВЫКЛ
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, -20, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0, 45)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleBtn.Text = "ВКЛЮЧИТЬ ПОЛЕТ"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 16
ToggleBtn.Parent = MainFrame

-- Ползунок скорости (Визуальный)
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, -20, 0, 20)
SpeedLabel.Position = UDim2.new(0, 10, 0, 100)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Скорость: 60"
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 14
SpeedLabel.Parent = MainFrame

local SliderBar = Instance.new("Frame")
SliderBar.Size = UDim2.new(1, -20, 0, 8)
SliderBar.Position = UDim2.new(0, 10, 0, 125)
SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SliderBar.Parent = MainFrame

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0.5, 0, 1, 0) -- Начальная позиция
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
SliderFill.Parent = SliderBar

-- === ЛОГИКА ПОЛЕТА ===
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

ToggleBtn.MouseButton1Click:Connect(function()
    isFlying = not isFlying
    
    if isFlying then
        ToggleBtn.Text = "ВЫКЛЮЧИТЬ ПОЛЕТ"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        humanoid.PlatformStand = true
    else
        ToggleBtn.Text = "ВКЛЮЧИТЬ ПОЛЕТ"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        humanoid.PlatformStand = false
    end
end)

-- Управление скоростью через клик по полоске
SliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local function updateSpeed(inputObj)
            local pos = inputObj.Position.X
            local relative = math.clamp((pos - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            flySpeed = math.floor(relative * 100) + 10
            SliderFill.Size = UDim2.new(relative, 0, 1, 0)
            SpeedLabel.Text = "Скорость: " .. flySpeed
        end
        
        updateSpeed(input)
        
        local connection
        connection = input.Changed:Connect(function(prop)
            if prop == "Position" then
                updateSpeed(input)
            end
        end)
        
        input.Changed:Connect(function(prop)
            if prop == "UserInputState" and input.UserInputState == Enum.UserInputState.End then
                connection:Disconnect()
            end
        end)
    end
end)

-- Основной цикл движения
RunService.RenderStepped:Connect(function()
    if not isFlying then return end
    
    local camera = workspace.CurrentCamera
    local moveDir = Vector3.new(0, 0, 0)
    
    -- Получаем векторы камеры
    local look = camera.CFrame.LookVector
    local right = camera.CFrame.RightVector
    
    -- WASD
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + look end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - look end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - right end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + right end
    
    -- Вверх/Вниз
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
    
    -- Применяем движение
    if moveDir.Magnitude > 0 then
        humanoidRootPart.CFrame = humanoidRootPart.CFrame + (moveDir.Unit * (flySpeed / 10))
    end
end)

print("✅ Fly Gui V3 успешно загружен!")
