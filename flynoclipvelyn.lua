-- Fly & Noclip Script MOBILE with OPEN/CLOSE
-- Loadstring: loadstring(game:HttpGet("https://raw.githubusercontent.com/gueshn/VELYN/refs/heads/main/flynoclipvelyn.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- STATE
local flying = false
local noclip = false
local speed = 50
local bodyVelocity, bodyGyro
local leftStickVector = Vector2.new(0, 0)
local rightStickVector = Vector2.new(0, 0)
local guiVisible = true

-- CREATE ALL GUI ELEMENTS
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobileFlyGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- TOGGLE BUTTON (KECIL DI POJOK)
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Text = "⚙️"
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
toggleButton.BackgroundTransparency = 0.3
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 24
toggleButton.ZIndex = 10
toggleButton.Parent = screenGui

-- MAIN PANEL (AWALNYA TERBUKA)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 250, 0, 180)
mainFrame.Position = UDim2.new(0.05, 0, 0.6, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(100, 100, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

-- CLOSE BUTTON DI PANEL
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Text = "✕"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.Parent = mainFrame

-- FLY BUTTON
local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Text = "✈️ FLY: OFF"
flyButton.Size = UDim2.new(0.8, 0, 0, 40)
flyButton.Position = UDim2.new(0.1, 0, 0.15, 0)
flyButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Font = Enum.Font.GothamBold
flyButton.TextSize = 16
flyButton.Parent = mainFrame

-- NOCLIP BUTTON
local noclipButton = Instance.new("TextButton")
noclipButton.Name = "NoclipButton"
noclipButton.Text = "👻 NOCLIP: OFF"
noclipButton.Size = UDim2.new(0.8, 0, 0, 40)
noclipButton.Position = UDim2.new(0.1, 0, 0, 75)
noclipButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipButton.Font = Enum.Font.GothamBold
noclipButton.TextSize = 16
noclipButton.Parent = mainFrame

-- SPEED CONTROLS
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(0.8, 0, 0, 40)
speedFrame.Position = UDim2.new(0.1, 0, 0, 125)
speedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
speedFrame.BorderSizePixel = 0
speedFrame.Parent = mainFrame

local speedText = Instance.new("TextLabel")
speedText.Text = "SPEED: " .. speed
speedText.Size = UDim2.new(0.5, 0, 1, 0)
speedText.BackgroundTransparency = 1
speedText.TextColor3 = Color3.fromRGB(100, 255, 100)
speedText.Font = Enum.Font.Gotham
speedText.TextSize = 14
speedText.TextXAlignment = Enum.TextXAlignment.Left
speedText.Parent = speedFrame

local speedDown = Instance.new("TextButton")
speedDown.Text = "➖"
speedDown.Size = UDim2.new(0.2, 0, 1, 0)
speedDown.Position = UDim2.new(0.6, 0, 0, 0)
speedDown.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
speedDown.Font = Enum.Font.GothamBold
speedDown.TextSize = 18
speedDown.Parent = speedFrame

local speedUp = Instance.new("TextButton")
speedUp.Text = "➕"
speedUp.Size = UDim2.new(0.2, 0, 1, 0)
speedUp.Position = UDim2.new(0.8, 0, 0, 0)
speedUp.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
speedUp.Font = Enum.Font.GothamBold
speedUp.TextSize = 18
speedUp.Parent = speedFrame

-- TOGGLE GUI FUNCTION
function toggleGUI()
    guiVisible = not guiVisible
    mainFrame.Visible = guiVisible
    
    if guiVisible then
        toggleButton.Text = "⚙️"
        toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    else
        toggleButton.Text = "⚙️"
        toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    end
end

-- UPDATE GUI FUNCTION
function updateGUI()
    if flying then
        flyButton.Text = "✈️ FLY: ON"
        flyButton.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
    else
        flyButton.Text = "✈️ FLY: OFF"
        flyButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    end
    
    if noclip then
        noclipButton.Text = "👻 NOCLIP: ON"
        noclipButton.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
    else
        noclipButton.Text = "👻 NOCLIP: OFF"
        noclipButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    end
    
    speedText.Text = "SPEED: " .. speed
end

-- FLY FUNCTIONS (FIXED)
function startFly()
    if flying then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        repeat task.wait() until character:FindFirstChild("HumanoidRootPart")
        rootPart = character:FindFirstChild("HumanoidRootPart")
    end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    flying = true
    humanoid.PlatformStand = true
    
    -- CREATE BODYVELOCITY & BODYGYRO
    bodyVelocity = Instance.new("BodyVelocity")
    bodyGyro = Instance.new("BodyGyro")
    
    bodyVelocity.Parent = rootPart
    bodyGyro.Parent = rootPart
    
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000) -- Pakai angka lebih kecil buat HP
    bodyVelocity.Velocity = Vector3.new(0, 0.5, 0) -- Sedikit upward force
    
    bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.P = 1000
    bodyGyro.D = 100
    
    updateGUI()
end

function stopFly()
    if not flying then return end
    
    flying = false
    
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
    
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    
    updateGUI()
end

-- NOCLIP FUNCTIONS
function startNoclip()
    if noclip then return end
    noclip = true
    
    local character = LocalPlayer.Character
    if not character then return end
    
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    updateGUI()
end

function stopNoclip()
    noclip = false
    
    local character = LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    
    updateGUI()
end

-- BUTTON CLICKS
toggleButton.MouseButton1Click:Connect(toggleGUI)
closeButton.MouseButton1Click:Connect(toggleGUI)

flyButton.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
    else
        startFly()
    end
end)

noclipButton.MouseButton1Click:Connect(function()
    if noclip then
        stopNoclip()
    else
        startNoclip()
    end
end)

speedDown.MouseButton1Click:Connect(function()
    speed = math.clamp(speed - 10, 10, 300)
    updateGUI()
end)

speedUp.MouseButton1Click:Connect(function()
    speed = math.clamp(speed + 10, 10, 300)
    updateGUI()
end)

-- FLY MOVEMENT LOOP (FIXED)
RunService.Heartbeat:Connect(function(delta)
    if not flying then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart or not bodyVelocity or not bodyGyro then return end
    
    local direction = Vector3.new(0, 0, 0)
    
    -- MOBILE VIRTUAL STICK (SIMULASI)
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        direction = direction + workspace.CurrentCamera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        direction = direction - workspace.CurrentCamera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        direction = direction - workspace.CurrentCamera.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        direction = direction + workspace.CurrentCamera.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.E) then
        direction = direction + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
        direction = direction + Vector3.new(0, -1, 0)
    end
    
    -- Apply speed
    if direction.Magnitude > 0 then
        direction = direction.Unit * speed
        bodyVelocity.Velocity = direction
    else
        -- Hover effect
        bodyVelocity.Velocity = Vector3.new(0, 0.5, 0)
    end
    
    -- Update gyro untuk menghadap kamera
    bodyGyro.CFrame = workspace.CurrentCamera.CFrame
end)

-- AUTO REAPPLY
LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(1)
    
    if flying then
        startFly()
    end
    if noclip then
        startNoclip()
    end
end)

-- MOBILE GESTURE: SWIPE TO OPEN/CLOSE
local touchStartPos = nil
UserInputService.TouchStarted:Connect(function(touch)
    touchStartPos = touch.Position
end)

UserInputService.TouchEnded:Connect(function(touch)
    if not touchStartPos then return end
    
    local swipeDistance = (touch.Position - touchStartPos).Magnitude
    if swipeDistance > 50 then
        toggleGUI()
    end
    
    touchStartPos = nil
end)

-- KEYBOARD SHORTCUT: F5 TO TOGGLE
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.F5 then
        toggleGUI()
    end
end)

-- INITIALIZE
updateGUI()

print("✅ Mobile Fly & Noclip Script LOADED!")
print("⚙️ Tap gear button to show/hide controls")
print("✈️ Tap FLY button to toggle flying")
print("👻 Tap NOCLIP button to toggle noclip")
print("➖➕ Tap buttons to adjust speed (10-300)")
