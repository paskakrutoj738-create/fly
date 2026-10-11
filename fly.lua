-- Простой и эффективный ESP для MM2
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Настройки ESP
local espSettings = {
    Enabled = true,
    BoxColor = Color3.fromRGB(255, 0, 0), -- Красный для всех
    ShowName = true,
    ShowDistance = true,
    MaxDistance = 1000
}

-- Таблица для хранения объектов ESP
local espObjects = {}

-- Функция создания ESP для игрока
local function createESP(player)
    if player == LocalPlayer then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Создаем BillboardGui (текст над головой)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = humanoidRootPart
    
    -- Текст с именем
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextSize = 16
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = billboard
    
    -- Текст с дистанцией
    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "DistLabel"
    distLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.TextStrokeTransparency = 0
    distLabel.TextSize = 14
    distLabel.Font = Enum.Font.Gotham
    distLabel.Parent = billboard
    
    -- Сохраняем ссылки
    espObjects[player.UserId] = {
        Billboard = billboard,
        NameLabel = nameLabel,
        DistLabel = distLabel,
        RootPart = humanoidRootPart
    }
end

-- Функция удаления ESP
local function removeESP(player)
    if espObjects[player.UserId] then
        local esp = espObjects[player.UserId]
        if esp.Billboard then esp.Billboard:Destroy() end
        espObjects[player.UserId] = nil
    end
end

-- Обновление ESP каждый кадр
RunService.RenderStepped:Connect(function()
    if not espSettings.Enabled then
        for _, esp in pairs(espObjects) do
            if esp.Billboard then esp.Billboard.Enabled = false end
        end
        return
    end
    
    for player, esp in pairs(espObjects) do
        if player.Character and esp.RootPart then
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - esp.RootPart.Position).Magnitude
            
            if distance < espSettings.MaxDistance then
                esp.Billboard.Enabled = true
                
                -- Обновляем текст
                if espSettings.ShowName then
                    esp.NameLabel.Text = player.Name
                else
                    esp.NameLabel.Text = ""
                end
                
                if espSettings.ShowDistance then
                    esp.DistLabel.Text = string.format("%.1f studs", distance)
                else
                    esp.DistLabel.Text = ""
                end
                
                -- Меняем цвет в зависимости от расстояния (опционально)
                if distance < 20 then
                    esp.NameLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Близко - красный
                else
                    esp.NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Далеко - белый
                end
            else
                esp.Billboard.Enabled = false
            end
        else
            esp.Billboard.Enabled = false
        end
    end
end)

-- Подключение к новым игрокам
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

-- Создаем ESP для уже существующих игроков
for _, player in pairs(Players:GetPlayers()) do
    createESP(player)
end

-- Следим за появлением персонажей
Players.LocalPlayer.CharacterAdded:Connect(function(char)
    wait(1) -- Ждем загрузки
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            removeESP(player)
            createESP(player)
        end
    end
end)

print("✅ ESP для MM2 загружен!")
