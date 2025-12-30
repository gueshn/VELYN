-- Fly & Noclip Script SIMPLE WORKING VERSION
-- Loadstring: loadstring(game:HttpGet("https://raw.githubusercontent.com/gueshn/VELYN/refs/heads/main/flynoclipvelyn.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- SIMPLE GUI TANPA BUKA TUTUP
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyControls"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 160)
mainFrame.Position = UDim2.new(0.02, 0, 0.7, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(100, 100, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- FLY BUTTON
local flyButton = Instance.new("TextButton")
flyButton.Text = "✈️ FLY: OFF"
flyButton.Size = UDim2.new(0.9, 0, 0, 40)
flyButton.Position = UDim2.new(0.05, 0, 0.05, 0)
flyButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Font = Enum.Font.GothamBold
flyButton.TextSize = 16
flyButton.Parent = mainFrame

-- NOCLIP BUTTON
local noclipButton = Instance.new("TextButton")
noclipButton.Text = "👻 NOCLIP: OFF"
noclipButton.Size = UDim2.new(0.9, 0, 0, 40)
noclipButton.Position = UDim2.new(0.05, 0, 0, 55)
noclipButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipButton.Font = Enum.Font.GothamBold
noclipButton.TextSize = 16
noclipButton.Parent = mainFrame

-- SPEED INFO
local speedLabel = Instance.new("TextLabel")
speedLabel.Text = "SPEED: 50"
speedLabel.Size = UDim2.new(0.9, 0, 0, 30)
speedLabel.Position = UDim2.new(0.05, 0, 0, 105)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 14
speedLabel.Parent = mainFrame

-- FLY VARIABLES
local flying = false
local noclip = false
local speed = 50
local bodyVel, bodyGyro

-- UPDATE GUI
function updateButtons()
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
    
    speedLabel.Text = "SPEED: " .. speed
end

-- FLY SYSTEM YANG BENER WORK
function enableFly()
    if flying then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    flying = true
    humanoid.PlatformStand = true
    
    -- CREATE BODY VELOCITY & GYRO
    bodyVel = Instance.new("BodyVelocity")
    bodyGyro = Instance.new("BodyGyro")
    
    bodyVel.Parent = rootPart
    bodyGyro.Parent = rootPart
    
    bodyVel.MaxForce = Vector3.new(40000, 40000, 40000)
    bodyVel.Velocity = Vector3.new(0, 0, 0)
    
    bodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.P = 1000
    
    updateButtons()
end

function disableFly()
    if not flying then return end
    
    flying = false
    
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
    
    if bodyVel then bodyVel:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    
    updateButtons()
end

-- NOCLIP SYSTEM
function enableNoclip()
    if noclip then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    noclip = true
    
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    updateButtons()
end

function disableNoclip()
    if not noclip then return end
    
    noclip = false
    
    local character = LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    
    updateButtons()
end

-- BUTTON CLICKS
flyButton.MouseButton1Click:Connect(function()
    if flying then
        disableFly()
    else
        enableFly()
    end
end)

noclipButton.MouseButton1Click:Connect(function()
    if noclip then
        disableNoclip()
    else
        enableNoclip()
    end
end)

-- MOBILE ANALOG SIMULATION
local virtualStick = {
    forward = false,
    back = false,
    left = false,
    right = false,
    up = false,
    down = false
}

-- KEYBOARD CONTROLS FOR TESTING
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then virtualStick.forward = true end
    if input.KeyCode == Enum.KeyCode.S then virtualStick.back = true end
    if input.KeyCode == Enum.KeyCode.A then virtualStick.left = true end
    if input.KeyCode == Enum.KeyCode.D then virtualStick.right = true end
    if input.KeyCode == Enum.KeyCode.E then virtualStick.up = true end
    if input.KeyCode == Enum.KeyCode.Q then virtualStick.down = true end
    
    -- SPEED CONTROLS
    if input.KeyCode == Enum.KeyCode.LeftBracket then
        speed = math.max(10, speed - 10)
        updateButtons()
    end
    if input.KeyCode == Enum.KeyCode.RightBracket then
        speed = math.min(300, speed + 10)
        updateButtons()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then virtualStick.forward = false end
    if input.KeyCode == Enum.KeyCode.S then virtualStick.back = false end
    if input.KeyCode == Enum.KeyCode.A then virtualStick.left = false end
    if input.KeyCode == Enum.KeyCode.D then virtualStick.right = false end
    if input.KeyCode == Enum.KeyCode.E then virtualStick.up = false end
    if input.KeyCode == Enum.KeyCode.Q then virtualStick.down = false end
end)

-- FLY MOVEMENT LOOP (INI YANG BIKIN GERAK)
RunService.Heartbeat:Connect(function()
    if not flying or not bodyVel or not bodyGyro then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    -- GET MOVEMENT DIRECTION
    local direction = Vector3.new(0, 0, 0)
    local camera = workspace.CurrentCamera
    
    if virtualStick.forward then
        direction = direction + camera.CFrame.LookVector
    end
    if virtualStick.back then
        direction = direction - camera.CFrame.LookVector
    end
    if virtualStick.left then
        direction = direction - camera.CFrame.RightVector
    end
    if virtualStick.right then
        direction = direction + camera.CFrame.RightVector
    end
    if virtualStick.up then
        direction = direction + Vector3.new(0, 1, 0)
    end
    if virtualStick.down then
        direction = direction + Vector3.new(0, -1, 0)
    end
    
    -- APPLY SPEED
    if direction.Magnitude > 0 then
        direction = direction.Unit * speed
    end
    
    -- APPLY TO BODYVELOCITY
    bodyVel.Velocity = direction
    
    -- KEEP UPRIGHT
    bodyGyro.CFrame = camera.CFrame
end)

-- MOBILE TOUCH BUTTONS FOR ANALOG
if UserInputService.TouchEnabled then
    -- FORWARD BUTTON
    local forwardBtn = Instance.new("TextButton")
    forwardBtn.Text = "W"
    forwardBtn.Size = UDim2.new(0, 60, 0, 60)
    forwardBtn.Position = UDim2.new(0.7, 0, 0.8, 0)
    forwardBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
    forwardBtn.BackgroundTransparency = 0.5
    forwardBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    forwardBtn.Font = Enum.Font.GothamBold
    forwardBtn.TextSize = 20
    forwardBtn.Parent = screenGui
    
    forwardBtn.TouchTap:Connect(function()
        virtualStick.forward = not virtualStick.forward
        forwardBtn.BackgroundColor3 = virtualStick.forward and 
            Color3.fromRGB(60, 200, 60) or Color3.fromRGB(100, 100, 200)
    end)
    
    -- UP/DOWN BUTTONS
    local upBtn = Instance.new("TextButton")
    upBtn.Text = "E"
    upBtn.Size = UDim2.new(0, 50, 0, 50)
    upBtn.Position = UDim2.new(0.85, 0, 0.7, 0)
    upBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    upBtn.BackgroundTransparency = 0.5
    upBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    upBtn.Font = Enum.Font.GothamBold
    upBtn.TextSize = 18
    upBtn.Parent = screenGui
    
    upBtn.TouchTap:Connect(function()
        virtualStick.up = not virtualStick.up
        upBtn.BackgroundColor3 = virtualStick.up and 
            Color3.fromRGB(60, 200, 60) or Color3.fromRGB(100, 200, 100)
    end)
end

-- AUTO REAPPLY ON RESPAWN
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if flying then enableFly() end
    if noclip then enableNoclip() end
end)

-- INITIAL UPDATE
updateButtons()

print("✅ Fly & Noclip Script LOADED!")
print("✈️ Tap FLY button to toggle flying")
print("👻 Tap NOCLIP button to toggle noclip")
print("WASD/EQ = Move | [/] = Speed | Panel can be dragged")
