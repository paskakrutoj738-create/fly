-- ✅ УНИВЕРСАЛЬНЫЙ СКРИПТ: ПОЛЕТ + ESP (MM2 Compatible)
-- Работает стабильно, без глюков физики

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- === НАСТРОЙКИ ===
local flySpeed = 50
local espEnabled = true
local flying = false

-- === GUI ИНТЕРФЕЙС ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateHackGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

-- Главная рамка
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 150)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BackgroundTransparency = 0.1
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "🚀 Ultimate Hack"
Title.TextColor3 = Color3.fromRGB(0, 255, 100)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Frame

-- Кнопка Полета
local FlyBtn = Instance.new("TextButton")
FlyBtn.Size = UDim2.new(1, -20, 0, 40)
FlyBtn.Position = UDim2.new(0, 10, 0, 35)
FlyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FlyBtn.Text = "ПОЛЕТ: ВЫКЛ"
FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyBtn.Font = Enum.Font.GothamBold
FlyBtn.Parent = Frame

-- Кнопка ESP
local EspBtn = Instance.new("TextButton")
EspBtn.Size = UDim2.new(1, -20, 0, 40)
EspBtn.Position = UDim2.new(0, 10, 0, 80)
EspBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
EspBtn.Text = "ESP: ВКЛ"
EspBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EspBtn.Font = Enum.Font.GothamBold
EspBtn.Parent = Frame

-- === ЛОГИКА ПОЛЕТА (CFrame Method - Самый надежный) ===
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

FlyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        FlyBtn.Text = "ПОЛЕТ: ВКЛ"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        humanoid.PlatformStand = true
    else
        FlyBtn.Text = "ПОЛЕТ: ВЫКЛ"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        humanoid.PlatformStand = false
    end
end)

RunService.RenderStepped:Connect(function()
    if not flying then return end
    
    local camera = workspace.CurrentCamera
    local moveDir = Vector3.new(0, 0, 0)
    
    -- Управление
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
    
    if moveDir.Magnitude > 0 then
        humanoidRootPart.CFrame = humanoidRootPart.CFrame + (moveDir.Unit * (flySpeed / 10))
    end
end)

-- === ЛОГИКА ESP (Wallhack) ===
local espCache = {}

local function addESP(player)
    if player == LocalPlayer then return end
    
    local char = player.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- Billboard Gui
    local bg = Instance.new("BillboardGui")
    bg.Name = "ESP_Gui"
    bg.Size = UDim2.new(0, 200, 0, 50)
    bg.StudsOffset = Vector3.new(0, 3, 0)
    bg.AlwaysOnTop = true
    bg.Parent = root
    
    -- Имя
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, 0, 0.6, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLbl.TextStrokeTransparency = 0
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 16
    nameLbl.Text = player.Name
    nameLbl.Parent = bg
    
    -- Дистанция
    local distLbl = Instance.new("TextLabel")
    distLbl.Size = UDim2.new(1, 0, 0.4, 0)
    distLbl.Position = UDim2.new(0, 0, 0.6, 0)
    distLbl.BackgroundTransparency = 1
    distLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLbl.TextStrokeTransparency = 0
    distLbl.Font = Enum.Font.Gotham
    distLbl.TextSize = 14
    distLbl.Parent = bg
    
    espCache[player.UserId] = {Gui = bg, Name = nameLbl, Dist = distLbl, Root = root}
end

local function removeESP(player)
    if espCache[player.UserId] then
        espCache[player.UserId].Gui:Destroy()
        espCache[player.UserId] = nil
    end
end

-- Обновление ESP
RunService.RenderStepped:Connect(function()
    if not espEnabled then
        for _, v in pairs(espCache) do v.Gui.Enabled = false end
        return
    end
    
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local myPos = myChar.HumanoidRootPart.Position
    
    for uid, data in pairs(espCache) do
        if data.Root and data.Root.Parent then
            local dist = (myPos - data.Root.Position).Magnitude
            data.Gui.Enabled = true
            data.Dist.Text = string.format("%.1f m", dist)
            
            -- Цвет меняется от расстояния
            if dist < 15 then
                data.Name.TextColor3 = Color3.fromRGB(255, 50, 50) -- Красный если близко
            else
                data.Name.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        else
            data.Gui.Enabled = false
        end
    end
end)

-- Подключение игроков
Players.PlayerAdded:Connect(addESP)
Players.PlayerRemoving:Connect(removeESP)
for _, p in pairs(Players:GetPlayers()) do addESP(p) end

-- Переключатель ESP
EspBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspBtn.Text = espEnabled and "ESP: ВКЛ" or "ESP: ВЫКЛ"
    EspBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(50, 50, 50)
end)

print("✅ Скрипт загружен! Ищите панель в левом верхнем углу.")
