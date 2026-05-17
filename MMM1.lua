local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local lp = Players.LocalPlayer

-- === СОСТОЯНИЕ ФУНКЦИЙ ===
local Config = {
    ESP = false,
    Aim = false,
    Boost = false,
    Stats = false,
    AntiAFK = false,
    UnlockFPS = false,
    AntiFling = false,
    BoostSpeed = 0.08
}

local selectedPlayer = nil

-- === СОЗДАНИЕ GUI ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "iMe_Menu"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 280, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- RGB-рамка
local stroke = Instance.new("UIStroke")
stroke.Parent = MainFrame
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Color = Color3.fromRGB(255, 100, 200)

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(100, 65, 255)
Title.Text = "iMe Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Кнопка-бургер
local BurgerButton = Instance.new("TextButton")
BurgerButton.Name = "BurgerButton"
BurgerButton.Parent = ScreenGui
BurgerButton.Size = UDim2.new(0, 36, 0, 36)
BurgerButton.Position = UDim2.new(0, 10, 0, 10)
BurgerButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
BurgerButton.Text = "☰"
BurgerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BurgerButton.TextSize = 20
BurgerButton.Font = Enum.Font.GothamBold
BurgerButton.BorderSizePixel = 0
BurgerButton.ZIndex = 10
local BurgerCorner = Instance.new("UICorner")
BurgerCorner.CornerRadius = UDim.new(0, 6)
BurgerCorner.Parent = BurgerButton

BurgerButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if not MainFrame.Visible then
        PlayerListFrame.Visible = false
    end
end)

-- Параметры сетки кнопок
local btnWidth = 120
local btnHeight = 32
local startY = 40
local gapY = 38
local col1X = 15
local col2X = 145

-- Функция создания обычной кнопки (ESP, Aim, Boost, Stats)
local function CreateButton(name, position, toggleKey)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Parent = MainFrame
    btn.Size = UDim2.new(0, btnWidth, 0, btnHeight)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        Config[toggleKey] = not Config[toggleKey]
        if Config[toggleKey] then
            btn.BackgroundColor3 = Color3.fromRGB(70, 130, 70)
            btn.Text = name .. ": ON"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            btn.Text = name .. ": OFF"
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)
    return btn
end

-- Обычные переключатели
CreateButton("Player ESP", UDim2.new(0, col1X, 0, startY), "ESP")
CreateButton("Aim Look", UDim2.new(0, col2X, 0, startY), "Aim")
CreateButton("Boost Speed", UDim2.new(0, col1X, 0, startY + gapY), "Boost")
CreateButton("Stats", UDim2.new(0, col2X, 0, startY + gapY), "Stats")

-- ===== КАСТОМНЫЕ КНОПКИ =====
-- Anti-AFK
local antiAfkBtn = Instance.new("TextButton")
antiAfkBtn.Name = "Anti-AFK"
antiAfkBtn.Parent = MainFrame
antiAfkBtn.Size = UDim2.new(0, btnWidth, 0, btnHeight)
antiAfkBtn.Position = UDim2.new(0, col1X, 0, startY + gapY*2)
antiAfkBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
antiAfkBtn.Text = "Anti-AFK: OFF"
antiAfkBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
antiAfkBtn.Font = Enum.Font.Gotham
antiAfkBtn.TextSize = 13
antiAfkBtn.BorderSizePixel = 0
Instance.new("UICorner", antiAfkBtn).CornerRadius = UDim.new(0, 5)

-- Unlock FPS
local unlockFpsBtn = Instance.new("TextButton")
unlockFpsBtn.Name = "UnlockFPS"
unlockFpsBtn.Parent = MainFrame
unlockFpsBtn.Size = UDim2.new(0, btnWidth, 0, btnHeight)
unlockFpsBtn.Position = UDim2.new(0, col2X, 0, startY + gapY*2)
unlockFpsBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
unlockFpsBtn.Text = "Unlock FPS: OFF"
unlockFpsBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
unlockFpsBtn.Font = Enum.Font.Gotham
unlockFpsBtn.TextSize = 13
unlockFpsBtn.BorderSizePixel = 0
Instance.new("UICorner", unlockFpsBtn).CornerRadius = UDim.new(0, 5)

-- Anti-Fling
local antiFlingBtn = Instance.new("TextButton")
antiFlingBtn.Name = "AntiFling"
antiFlingBtn.Parent = MainFrame
antiFlingBtn.Size = UDim2.new(0, btnWidth, 0, btnHeight)
antiFlingBtn.Position = UDim2.new(0, col1X, 0, startY + gapY*3)
antiFlingBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
antiFlingBtn.Text = "Anti-Fling: OFF"
antiFlingBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
antiFlingBtn.Font = Enum.Font.Gotham
antiFlingBtn.TextSize = 13
antiFlingBtn.BorderSizePixel = 0
Instance.new("UICorner", antiFlingBtn).CornerRadius = UDim.new(0, 5)

-- Player List
local playerListBtn = Instance.new("TextButton")
playerListBtn.Name = "PlayerListBtn"
playerListBtn.Parent = MainFrame
playerListBtn.Size = UDim2.new(0, btnWidth, 0, btnHeight)
playerListBtn.Position = UDim2.new(0, col2X, 0, startY + gapY*3)
playerListBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
playerListBtn.Text = "Player List"
playerListBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
playerListBtn.Font = Enum.Font.Gotham
playerListBtn.TextSize = 13
playerListBtn.BorderSizePixel = 0
Instance.new("UICorner", playerListBtn).CornerRadius = UDim.new(0, 5)

-- Teleport
local teleportBtn = Instance.new("TextButton")
teleportBtn.Name = "TeleportBtn"
teleportBtn.Parent = MainFrame
teleportBtn.Size = UDim2.new(0, btnWidth, 0, btnHeight)
teleportBtn.Position = UDim2.new(0, col1X, 0, startY + gapY*4)
teleportBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
teleportBtn.Text = "Teleport"
teleportBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
teleportBtn.Font = Enum.Font.Gotham
teleportBtn.TextSize = 13
teleportBtn.BorderSizePixel = 0
Instance.new("UICorner", teleportBtn).CornerRadius = UDim.new(0, 5)

-- Фрейм списка игроков (дочерний MainFrame)
local PlayerListFrame = Instance.new("Frame")
PlayerListFrame.Name = "PlayerListFrame"
PlayerListFrame.Parent = MainFrame
PlayerListFrame.Size = UDim2.new(0, 150, 0, 200)
PlayerListFrame.Position = UDim2.new(1, 5, 0, 0)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.Visible = false
Instance.new("UICorner", PlayerListFrame).CornerRadius = UDim.new(0, 6)

local listScrolling = Instance.new("ScrollingFrame")
listScrolling.Name = "ScrollingFrame"
listScrolling.Parent = PlayerListFrame
listScrolling.Size = UDim2.new(1, 0, 1, 0)
listScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
listScrolling.ScrollBarThickness = 6
listScrolling.BackgroundTransparency = 1

-- Метка для FPS и пинга
local StatsLabel = Instance.new("TextLabel")
StatsLabel.Name = "StatsLabel"
StatsLabel.Parent = ScreenGui
StatsLabel.Size = UDim2.new(0, 210, 0, 40)
StatsLabel.Position = UDim2.new(1, -220, 0, 50)
StatsLabel.BackgroundTransparency = 1
StatsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatsLabel.TextSize = 16
StatsLabel.Font = Enum.Font.Gotham
StatsLabel.TextXAlignment = Enum.TextXAlignment.Right
StatsLabel.Visible = false

-- Переменные для FPS и Anti-AFK
local lastFrameTime = tick()
local lastStatsUpdate = tick()
local antiAFKThread = nil

-- Функция Anti-AFK
local function startAntiAFK()
    if antiAFKThread then
        task.cancel(antiAFKThread)
        antiAFKThread = nil
    end
    if not Config.AntiAFK then return end

    antiAFKThread = task.spawn(function()
        while Config.AntiAFK do
            wait(180)
            if not Config.AntiAFK then break end
            local char = lp.Character
            if char and char:FindFirstChild("Humanoid") then
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, nil)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, nil)
            end
        end
    end)
end

-- Функция разблокировки FPS
local function applyFPSUnlock()
    if Config.UnlockFPS then
        local success = false
        if setfpscap then
            pcall(function() setfpscap(10000) success = true end)
        end
        if not success and settings and settings().Rendering then
            pcall(function() settings().Rendering.FrameRateCap = 10000 success = true end)
        end
        if not success then
            pcall(function() RunService:SetFrameRateCap(10000) success = true end)
        end
        if not success then
            warn("Не удалось разблокировать FPS")
            Config.UnlockFPS = false
            unlockFpsBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            unlockFpsBtn.Text = "Unlock FPS: OFF"
            unlockFpsBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    else
        pcall(function()
            if setfpscap then setfpscap(60)
            elseif settings and settings().Rendering then settings().Rendering.FrameRateCap = 60
            elseif RunService.SetFrameRateCap then RunService:SetFrameRateCap(60) end
        end)
    end
end

-- Обработчики кастомных кнопок
antiAfkBtn.MouseButton1Click:Connect(function()
    Config.AntiAFK = not Config.AntiAFK
    if Config.AntiAFK then
        antiAfkBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 70)
        antiAfkBtn.Text = "Anti-AFK: ON"
        antiAfkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        startAntiAFK()
    else
        antiAfkBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        antiAfkBtn.Text = "Anti-AFK: OFF"
        antiAfkBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        if antiAFKThread then
            task.cancel(antiAFKThread)
            antiAFKThread = nil
        end
    end
end)

unlockFpsBtn.MouseButton1Click:Connect(function()
    Config.UnlockFPS = not Config.UnlockFPS
    if Config.UnlockFPS then
        unlockFpsBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 70)
        unlockFpsBtn.Text = "Unlock FPS: ON"
        unlockFpsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        unlockFpsBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        unlockFpsBtn.Text = "Unlock FPS: OFF"
        unlockFpsBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
    applyFPSUnlock()
end)

antiFlingBtn.MouseButton1Click:Connect(function()
    Config.AntiFling = not Config.AntiFling
    if Config.AntiFling then
        antiFlingBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 70)
        antiFlingBtn.Text = "Anti-Fling: ON"
        antiFlingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        antiFlingBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        antiFlingBtn.Text = "Anti-Fling: OFF"
        antiFlingBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

-- Заполнение списка игроков с DisplayName
local function updatePlayerList()
    for _, child in ipairs(listScrolling:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local yOffset = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= lp then
            local display = "@" .. p.Name
            if p.DisplayName ~= p.Name then
                display = display .. " (" .. p.DisplayName .. ")"
            end
            local btn = Instance.new("TextButton")
            btn.Name = p.Name
            btn.Parent = listScrolling
            btn.Size = UDim2.new(1, -10, 0, 28)
            btn.Position = UDim2.new(0, 5, 0, yOffset)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.Text = display
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 13
            btn.BorderSizePixel = 0
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
            btn.MouseButton1Click:Connect(function()
                selectedPlayer = p
                for _, b in ipairs(listScrolling:GetChildren()) do
                    if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(50, 50, 50) end
                end
                btn.BackgroundColor3 = Color3.fromRGB(70, 130, 70)
                teleportBtn.Text = "TP to " .. p.Name
            end)
            yOffset += 32
        end
    end
    listScrolling.CanvasSize = UDim2.new(0, 0, 0, math.max(yOffset, 200))
end

playerListBtn.MouseButton1Click:Connect(function()
    PlayerListFrame.Visible = not PlayerListFrame.Visible
    if PlayerListFrame.Visible then
        updatePlayerList()
    end
end)

teleportBtn.MouseButton1Click:Connect(function()
    if not selectedPlayer then return end
    local targetChar = selectedPlayer.Character
    if not targetChar or not targetChar:FindFirstChild("HumanoidRootPart") then
        warn("Игрок не загружен или вне игры")
        return
    end
    local myChar = lp.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    myChar.HumanoidRootPart.CFrame = CFrame.new(targetChar.HumanoidRootPart.Position + Vector3.new(0, 2, 0))
end)

-- === ЛОГИКА ФУНКЦИЙ ===
local function updateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local hl = p.Character:FindFirstChild("iMe_ESP")
            if hl then
                hl.Enabled = Config.ESP
            else
                local newHl = Instance.new("Highlight")
                newHl.Name = "iMe_ESP"
                newHl.Parent = p.Character
                newHl.Enabled = Config.ESP
                newHl.FillColor = Color3.fromRGB(255, 0, 0)
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    updateESP()
    
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end
    local hrp = char.HumanoidRootPart
    local hum = char.Humanoid

    -- Boost Speed
    if Config.Boost and hum.MoveDirection.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * Config.BoostSpeed)
    end

    -- Aim Look
    if Config.Aim then
        local target = nil
        local dist = math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if d < dist then
                    dist = d
                    target = p
                end
            end
        end
        if target then
            local targetPos = target.Character.HumanoidRootPart.Position
            hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z))
        end
    end

    -- Anti-Fling
    if Config.AntiFling then
        if hum.MoveDirection.Magnitude == 0 then
            hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
            hrp.RotVelocity = Vector3.new(0, hrp.RotVelocity.Y, 0)
        end
    end

    -- RGB-рамка
    if MainFrame.Visible then
        local t = tick()
        local r = 127 + 127 * math.sin(t * 0.8)
        local g = 127 + 127 * math.sin(t * 0.6 + 2)
        local b = 127 + 127 * math.sin(t * 0.7 + 4)
        stroke.Color = Color3.fromRGB(r, g, b)
    end

    -- FPS и Ping
    local now = tick()
    if Config.Stats then
        StatsLabel.Visible = true
        if now - lastStatsUpdate >= 0.01 then
            local delta = now - lastFrameTime
            local fps = (delta > 0) and (1 / delta) or 60
            local ping = lp:GetNetworkPing() * 1000
            StatsLabel.Text = string.format("FPS: %.3f | Ping: %.3f ms", fps, ping)
            lastStatsUpdate = now
        end
    else
        StatsLabel.Visible = false
    end
    lastFrameTime = now
end)

-- Перемещение меню
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

-- Инициализация
if Config.AntiAFK then startAntiAFK() end
if Config.UnlockFPS then applyFPSUnlock() end
