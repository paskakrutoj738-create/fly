-- MM2 Full Cheat
-- Kill All, Coins, ESP, Fly, Speed, Godmode, Auto-Win

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ===== GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MM2Cheat"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local function makeButton(text, pos, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 140, 0, 45)
    btn.Position = pos
    btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 30)
    btn.BackgroundTransparency = 0.2
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    return btn
end

local killAllBtn = makeButton("KILL ALL", UDim2.new(0, 20, 0, 100), Color3.fromRGB(180, 20, 20))
local coinsBtn = makeButton("COINS", UDim2.new(0, 20, 0, 155), Color3.fromRGB(200, 160, 0))
local espBtn = makeButton("ESP: OFF", UDim2.new(0, 20, 0, 210))
local flyBtn = makeButton("FLY: OFF", UDim2.new(0, 20, 0, 265))
local speedBtn = makeButton("SPEED: OFF", UDim2.new(0, 20, 0, 320))
local godBtn = makeButton("GOD: OFF", UDim2.new(0, 20, 0, 375))
local winBtn = makeButton("AUTO WIN", UDim2.new(0, 20, 0, 430), Color3.fromRGB(20, 150, 20))

-- ===== KILL ALL =====
killAllBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            for _, item in ipairs(backpack:GetChildren()) do
                if item:IsA("Tool") and item.Name:lower():find("knife") then
                    item.Parent = char
                    tool = item
                    break
                end
            end
        end
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local target = plr.Character:FindFirstChild("HumanoidRootPart")
            if target then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = target.CFrame * CFrame.new(0, 0, 2)
                    task.wait(0.1)
                    if tool then
                        tool:Activate()
                    end
                    firetouchinterest = firetouchinterest or function() end
                    firetouchinterest(hrp, target, 0)
                    task.wait(0.05)
                    firetouchinterest(hrp, target, 1)
                end
            end
        end
    end
end)

-- ===== COINS =====
coinsBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Coin" or obj.Name == "CoinContainer" then
            if obj:IsA("BasePart") then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = obj.CFrame
                    task.wait(0.05)
                end
            end
        end
    end
end)

-- ===== ESP =====
local espEnabled = false
local highlights = {}

local function clearESP()
    for _, hl in ipairs(highlights) do
        hl:Destroy()
    end
    highlights = {}
end

local function applyESP(plr)
    if plr == LocalPlayer then return end
    local char = plr.Character
    if not char then return end
    local role = "Innocent"
    local isMurderer = false
    local isSheriff = false

    local backpack = plr:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item.Name:lower():find("knife") then isMurderer = true end
            if item.Name:lower():find("gun") or item.Name:lower():find("revolver") then isSheriff = true end
        end
    end

    local color = Color3.fromRGB(0, 255, 0)
    if isMurderer then color = Color3.fromRGB(255, 0, 0) role = "Murderer" end
    if isSheriff then color = Color3.fromRGB(0, 100, 255) role = "Sheriff" end

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local hl = Instance.new("Highlight")
            hl.Adornee = part
            hl.FillColor = color
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0
            hl.Parent = part
            table.insert(highlights, hl)
        end
    end
end

local function startESP()
    espEnabled = true
    espBtn.Text = "ESP: ON"
    for _, plr in ipairs(Players:GetPlayers()) do
        applyESP(plr)
    end
end

local function stopESP()
    espEnabled = false
    espBtn.Text = "ESP: OFF"
    clearESP()
end

espBtn.MouseButton1Click:Connect(function()
    if espEnabled then stopESP() else startESP() end
end)

-- ===== FLY =====
local flyEnabled = false
local flySpeed = 60
local flyBV, flyBG

local function startFly()
    flyEnabled = true
    flyBtn.Text = "FLY: ON"
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBV.Velocity = Vector3.zero
    flyBV.Parent = hrp

    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBG.P = 9e4
    flyBG.CFrame = hrp.CFrame
    flyBG.Parent = hrp
end

local function stopFly()
    flyEnabled = false
    flyBtn.Text = "FLY: OFF"
    if flyBV then flyBV:Destroy() end
    if flyBG then flyBG:Destroy() end
end

RunService.RenderStepped:Connect(function()
    if not flyEnabled then return end
    local camCF = Camera.CFrame
    local dir = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + camCF.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - camCF.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - camCF.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + camCF.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end

    if flyBV then
        flyBV.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
    end
    if flyBG then
        flyBG.CFrame = camCF
    end
end)

flyBtn.MouseButton1Click:Connect(function()
    if flyEnabled then stopFly() else startFly() end
end)

-- ===== SPEED =====
local speedEnabled = false
local originalSpeed = 16

local function setSpeed(speed)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = speed end
end

speedBtn.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    speedBtn.Text = speedEnabled and "SPEED: ON" or "SPEED: OFF"
    setSpeed(speedEnabled and 80 or originalSpeed)
end)

-- ===== GODMODE =====
local godEnabled = false

godBtn.MouseButton1Click:Connect(function()
    godEnabled = not godEnabled
    godBtn.Text = godEnabled and "GOD: ON" or "GOD: OFF"
end)

RunService.Heartbeat:Connect(function()
    if not godEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Health = hum.MaxHealth
    end
end)

-- ===== AUTO WIN =====
winBtn.MouseButton1Click:Connect(function()
    LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(2)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = hum.MaxHealth end
    end)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            pcall(function()
                plr.Character:BreakJoints()
            end)
        end
    end
end)

print("MM2 Full Cheat loaded.")
