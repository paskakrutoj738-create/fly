-- MM2 Full Cheat + FlyGUI V3 Style Fly + Fling
-- Kill All, Coins, ESP, Fly (V3 style), Speed, Godmode, Auto-Win, Fling

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

local function makeButton(text, pos, color, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 140, 0, 45)
    btn.Position = pos
    btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 30)
    btn.BackgroundTransparency = 0.2
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent or screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    return btn
end

local killAllBtn = makeButton("KILL ALL", UDim2.new(0, 20, 0, 100), Color3.fromRGB(180, 20, 20))
local coinsBtn = makeButton("COINS", UDim2.new(0, 20, 0, 155), Color3.fromRGB(200, 160, 0))
local espBtn = makeButton("ESP: OFF", UDim2.new(0, 20, 0, 210))
local speedBtn = makeButton("SPEED: OFF", UDim2.new(0, 20, 0, 265))
local godBtn = makeButton("GOD: OFF", UDim2.new(0, 20, 0, 320))
local winBtn = makeButton("AUTO WIN", UDim2.new(0, 20, 0, 375), Color3.fromRGB(20, 150, 20))
local flingBtn = makeButton("FLING: OFF", UDim2.new(0, 20, 0, 430), Color3.fromRGB(255, 100, 0))

-- ===== FlyGUI V3 Style Fly Panel =====
local flyGui = Instance.new("ScreenGui")
flyGui.Name = "FlyGUIV3"
flyGui.ResetOnSpawn = false
flyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local flyFrame = Instance.new("Frame")
flyFrame.Size = UDim2.new(0, 280, 0, 140)
flyFrame.Position = UDim2.new(0, 180, 0, 100)
flyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
flyFrame.BorderSizePixel = 2
flyFrame.Active = true
flyFrame.Draggable = true
flyFrame.Parent = flyGui

local flyTitle = Instance.new("TextLabel")
flyTitle.Text = "Fly GUI V3"
flyTitle.Size = UDim2.new(1, 0, 0, 35)
flyTitle.Position = UDim2.new(0, 0, 0, 0)
flyTitle.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
flyTitle.TextScaled = true
flyTitle.Font = Enum.Font.SourceSansBold
flyTitle.TextColor3 = Color3.new(0, 0, 0)
flyTitle.BorderSizePixel = 2
flyTitle.Parent = flyFrame

local function makeFlyBtn(text, pos, color)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Position = pos
    btn.Size = UDim2.new(0, 80, 0, 40)
    btn.TextScaled = true
    btn.Font = Enum.Font.SourceSansBold
    btn.TextColor3 = Color3.new(0, 0, 0)
    btn.BackgroundColor3 = color
    btn.BorderSizePixel = 2
    btn.Parent = flyFrame
    return btn
end

local flyToggleBtn = makeFlyBtn("FLY", UDim2.new(0, 10, 0, 45), Color3.fromRGB(100, 255, 200))
local flyUpBtn = makeFlyBtn("UP", UDim2.new(0, 95, 0, 45), Color3.fromRGB(100, 255, 200))
local flyDownBtn = makeFlyBtn("DOWN", UDim2.new(0, 180, 0, 45), Color3.fromRGB(255, 150, 150))
local flyPlusBtn = makeFlyBtn("+", UDim2.new(0, 10, 0, 90), Color3.fromRGB(80, 120, 255))
local flyMinusBtn = makeFlyBtn("-", UDim2.new(0, 95, 0, 90), Color3.fromRGB(80, 120, 255))

-- ===== FLY (V3 Style) =====
local flyEnabled = false
local flySpeed = 60
local flyVelocity = 0
local flyBV, flyBG
local flyUp = false
local flyDown = false

local function startFly()
    if flyEnabled then return end
    flyEnabled = true
    flyToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)

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
    flyToggleBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 200)
    flyUp = false
    flyDown = false
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
    if flyUp then dir = dir + Vector3.new(0, 1, 0) end
    if flyDown then dir = dir - Vector3.new(0, 1, 0) end

    if flyBV then
        flyBV.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
    end
    if flyBG then
        flyBG.CFrame = camCF
    end
end)

flyToggleBtn.MouseButton1Click:Connect(function()
    if flyEnabled then stopFly() else startFly() end
end)

flyUpBtn.MouseButton1Down:Connect(function() flyUp = true end)
flyUpBtn.MouseButton1Up:Connect(function() flyUp = false end)
flyDownBtn.MouseButton1Down:Connect(function() flyDown = true end)
flyDownBtn.MouseButton1Up:Connect(function() flyDown = false end)

flyPlusBtn.MouseButton1Click:Connect(function()
    flySpeed = math.min(flySpeed + 20, 500)
end)

flyMinusBtn.MouseButton1Click:Connect(function()
    flySpeed = math.max(flySpeed - 20, 10)
end)

-- ===== FLING =====
local flingEnabled = false
local flingConnections = {}

local function flingPlayer(plr)
    if plr == LocalPlayer then return end
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    local bAV = Instance.new("BodyAngularVelocity")
    bAV.AngularVelocity = Vector3.new(0, 99999, 0)
    bAV.MaxTorque = Vector3.new(0, math.huge, 0)
    bAV.Parent = hrp

    local bV = Instance.new("BodyVelocity")
    bV.Velocity = Vector3.new(99999, 99999, 99999)
    bV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bV.Parent = hrp

    table.insert(flingConnections, bAV)
    table.insert(flingConnections, bV)
end

local function stopFlingAll()
    for _, obj in ipairs(flingConnections) do
        pcall(function() obj:Destroy() end)
    end
    flingConnections = {}
end

flingBtn.MouseButton1Click:Connect(function()
    flingEnabled = not flingEnabled
    flingBtn.Text = flingEnabled and "FLING: ON" or "FLING: OFF"
    flingBtn.BackgroundColor3 = flingEnabled and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 100, 0)

    if flingEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            flingPlayer(plr)
        end
    else
        stopFlingAll()
    end
end)

-- ===== KILL ALL (same as before) =====
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
                    if tool then tool:Activate() end
                    local fti = firetouchinterest or function() end
                    fti(hrp, target, 0)
                    task.wait(0.05)
                    fti(hrp, target, 1)
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
        if (obj.Name == "Coin" or obj.Name == "CoinContainer") and obj:IsA("BasePart") then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = obj.CFrame task.wait(0.05) end
        end
    end
end)

-- ===== ESP =====
local espEnabled = false
local highlights = {}

local function clearESP()
    for _, hl in ipairs(highlights) do hl:Destroy() end
    highlights = {}
end

local function applyESP(plr)
    if plr == LocalPlayer then return end
    local char = plr.Character
    if not char then return end
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
    if isMurderer then color = Color3.fromRGB(255, 0, 0) end
    if isSheriff then color = Color3.fromRGB(0, 100, 255) end

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

espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    if espEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do applyESP(plr) end
    else
        clearESP()
    end
end)

-- ===== SPEED =====
local speedEnabled = false
speedBtn.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    speedBtn.Text = speedEnabled and "SPEED: ON" or "SPEED: OFF"
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = speedEnabled and 80 or 16 end
    end
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
    if hum then hum.Health = hum.MaxHealth end
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
            pcall(function() plr.Character:BreakJoints() end)
        end
    end
end)

print("MM2 Full Cheat + FlyGUI V3 + Fling loaded.")
