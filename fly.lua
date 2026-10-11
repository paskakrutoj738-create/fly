-- Delta Roblox Mobile: Fly + Wall Hack
-- For mobile executors

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ===== GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaMobile"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local function makeButton(text, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 0, 50)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.BackgroundTransparency = 0.3
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    return btn
end

local flyBtn = makeButton("FLY: OFF", UDim2.new(0, 20, 0, 100))
local whBtn = makeButton("WH: OFF", UDim2.new(0, 20, 0, 170))

-- ===== FLY =====
local flyEnabled = false
local flySpeed = 60
local flyBodyVelocity
local flyBodyGyro
local moveDir = Vector3.zero

local function startFly()
    if flyEnabled then return end
    flyEnabled = true
    flyBtn.Text = "FLY: ON"

    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBodyVelocity.Velocity = Vector3.zero
    flyBodyVelocity.Parent = hrp

    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBodyGyro.P = 9e4
    flyBodyGyro.CFrame = hrp.CFrame
    flyBodyGyro.Parent = hrp
end

local function stopFly()
    flyEnabled = false
    flyBtn.Text = "FLY: OFF"
    moveDir = Vector3.zero
    if flyBodyVelocity then flyBodyVelocity:Destroy() end
    if flyBodyGyro then flyBodyGyro:Destroy() end
end

RunService.RenderStepped:Connect(function()
    if not flyEnabled then return end
    local camCF = Camera.CFrame
    local dir = Vector3.zero

    if moveDir.Magnitude > 0 then
        dir = camCF:VectorToWorldSpace(moveDir)
    end

    if flyBodyVelocity then
        flyBodyVelocity.Velocity = dir * flySpeed
    end
    if flyBodyGyro then
        flyBodyGyro.CFrame = camCF
    end
end)

-- ===== JOYSTICK =====
local joyActive = false
local joyStart = Vector2.new(0, 0)
local joyCenter = UDim2.new(1, -150, 1, -150)

local joyFrame = Instance.new("Frame")
joyFrame.Size = UDim2.new(0, 200, 0, 200)
joyFrame.Position = joyCenter
joyFrame.BackgroundTransparency = 0.7
joyFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
joyFrame.Parent = screenGui

local joyCorner = Instance.new("UICorner")
joyCorner.CornerRadius = UDim.new(1, 0)
joyCorner.Parent = joyFrame

local joyKnob = Instance.new("Frame")
joyKnob.Size = UDim2.new(0, 80, 0, 80)
joyKnob.Position = UDim2.new(0.5, -40, 0.5, -40)
joyKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
joyKnob.Parent = joyFrame

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = joyKnob

local function updateJoy(input)
    local delta = input.Position - joyStart
    local mag = math.min(delta.Magnitude, 100)
    local unit = delta.Unit
    if delta.Magnitude == 0 then unit = Vector2.new(0, 0) end

    joyKnob.Position = UDim2.new(0.5, unit.X * mag - 40, 0.5, unit.Y * mag - 40)

    if mag > 10 then
        moveDir = Vector3.new(unit.X, 0, -unit.Y)
    else
        moveDir = Vector3.zero
    end
end

joyFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        joyActive = true
        joyStart = input.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if joyActive and input.UserInputType == Enum.UserInputType.Touch then
        updateJoy(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        joyActive = false
        moveDir = Vector3.zero
        joyKnob.Position = UDim2.new(0.5, -40, 0.5, -40)
    end
end)

-- ===== UP / DOWN BUTTONS =====
local upBtn = makeButton("UP", UDim2.new(1, -340, 1, -200))
local downBtn = makeButton("DOWN", UDim2.new(1, -340, 1, -130))

upBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        moveDir = moveDir + Vector3.new(0, 1, 0)
    end
end)
upBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        moveDir = moveDir - Vector3.new(0, 1, 0)
    end
end)

downBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        moveDir = moveDir - Vector3.new(0, 1, 0)
    end
end)
downBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        moveDir = moveDir + Vector3.new(0, 1, 0)
    end
end)

flyBtn.MouseButton1Click:Connect(function()
    if flyEnabled then stopFly() else startFly() end
end)

-- ===== WALL HACK =====
local whEnabled = false
local highlights = {}

local function applyWH(plr)
    if plr == LocalPlayer then return end
    local char = plr.Character
    if not char then return end

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local hl = Instance.new("Highlight")
            hl.Adornee = part
            hl.FillColor = Color3.fromRGB(255, 0, 0)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0
            hl.Parent = part
            table.insert(highlights, hl)
        end
    end
end

local function startWH()
    if whEnabled then return end
    whEnabled = true
    whBtn.Text = "WH: ON"
    for _, plr in ipairs(Players:GetPlayers()) do
        applyWH(plr)
    end
    Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function()
            wait(1)
            if whEnabled then applyWH(plr) end
        end)
    end)
end

local function stopWH()
    whEnabled = false
    whBtn.Text = "WH: OFF"
    for _, hl in ipairs(highlights) do
        hl:Destroy()
    end
    highlights = {}
end

whBtn.MouseButton1Click:Connect(function()
    if whEnabled then stopWH() else startWH() end
end)

print("Delta Mobile loaded. FLY / WH buttons + joystick")
