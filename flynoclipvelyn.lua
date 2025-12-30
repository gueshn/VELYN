-- Fly & Noclip Script MOBILE VERSION
-- Loadstring: loadstring(game:HttpGet("https://raw.githubusercontent.com/gueshn/VELYN/refs/heads/main/flynoclipvelyn.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ContextActionService = game:GetService("ContextActionService")

-- SETTINGS
local FLY_SPEED = 50
local MAX_SPEED = 300
local MIN_SPEED = 10

-- STATE
local flying = false
local noclip = false
local speed = FLY_SPEED
local bodyVelocity, bodyGyro
local touchControls = {}
local mobile = UserInputService.TouchEnabled

-- MOBILE GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobileFlyGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- MAIN FRAME (BISA DIGESER)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 200)
mainFrame.Position = UDim2.new(0.05, 0, 0.7, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(100, 100, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Selectable = true
mainFrame.Parent = screenGui

-- TITLE
local title = Instance.new("TextLabel")
title.Text = "✈️ FLY CONTROLS (DRAG)"
title.Size = UDim2.new(1, -20, 0, 35)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
title.TextColor3 = Color3.fromRGB(100, 200, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = mainFrame

-- FLY BUTTON
local flyButton = Instance.new("TextButton")
flyButton.Text = "🚀 FLY: OFF"
flyButton.Size = UDim2.new(0.9, 0, 0, 40)
flyButton.Position = UDim2.new(0.05, 0, 0, 50)
flyButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Font = Enum.Font.GothamBold
flyButton.TextSize = 14
flyButton.Parent = mainFrame

-- NOCLIP BUTTON
local noclipButton = Instance.new("TextButton")
noclipButton.Text = "👻 NOCLIP: OFF"
noclipButton.Size = UDim2.new(0.9, 0, 0, 40)
noclipButton.Position = UDim2.new(0.05, 0, 0, 100)
noclipButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipButton.Font = Enum.Font.GothamBold
noclipButton.TextSize = 14
noclipButton.Parent = mainFrame

-- SPEED CONTROLS
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(0.9, 0, 0, 50)
speedFrame.Position = UDim2.new(0.05, 0, 0, 150)
speedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
speedFrame.BorderSizePixel = 0
speedFrame.Parent = mainFrame

local speedText = Instance.new("TextLabel")
speedText.Text = "SPEED: " .. speed
speedText.Size = UDim2.new(1, 0, 0, 25)
speedText.BackgroundTransparency = 1
speedText.TextColor3 = Color3.fromRGB(100, 255, 100)
speedText.Font = Enum.Font.Gotham
speedText.TextSize = 14
speedText.Parent = speedFrame

local speedDown = Instance.new("TextButton")
speedDown.Text = "➖"
speedDown.Size = UDim2.new(0.2, 0, 0, 20)
speedDown.Position = UDim2.new(0, 5, 0, 25)
speedDown.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
speedDown.Font = Enum.Font.GothamBold
speedDown.TextSize = 16
speedDown.Parent = speedFrame

local speedUp = Instance.new("TextButton")
speedUp.Text = "➕"
speedUp.Size = UDim2.new(0.2, 0, 0, 20)
speedUp.Position = UDim2.new(0.8, -5, 0, 25)
speedUp.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
speedUp.Font = Enum.Font.GothamBold
speedUp.TextSize = 16
speedUp.Parent = speedFrame

-- MOBILE MOVEMENT STICKS (FOR FLY CONTROL)
if mobile then
    -- LEFT STICK (MOVEMENT)
    local leftStick = Instance.new("Frame")
    leftStick.Size = UDim2.new(0, 120, 0, 120)
    leftStick.Position = UDim2.new(0.1, 0, 0.7, 0)
    leftStick.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    leftStick.BackgroundTransparency = 0.5
    leftStick.BorderSizePixel = 0
    leftStick.Visible = false
    leftStick.Parent = screenGui
    
    local leftStickInner = Instance.new("Frame")
    leftStickInner.Size = UDim2.new(0, 50, 0, 50)
    leftStickInner.Position = UDim2.new(0.29, 0, 0.29, 0)
    leftStickInner.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    leftStickInner.BackgroundTransparency = 0.3
    leftStickInner.BorderSizePixel = 0
    leftStickInner.Parent = leftStick
    
    -- RIGHT STICK (UP/DOWN)
    local rightStick = Instance.new("Frame")
    rightStick.Size = UDim2.new(0, 100, 0, 100)
    rightStick.Position = UDim2.new(0.7, 0, 0.7, 0)
    rightStick.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    rightStick.BackgroundTransparency = 0.5
    rightStick.BorderSizePixel = 0
    rightStick.Visible = false
    rightStick.Parent = screenGui
    
    local rightStickInner = Instance.new("Frame")
    rightStickInner.Size = UDim2.new(0, 40, 0, 40)
    rightStickInner.Position = UDim2.new(0.3, 0, 0.3, 0)
    rightStickInner.BackgroundColor3 = Color3.fromRGB(255, 150, 100)
    rightStickInner.BackgroundTransparency = 0.3
    rightStickInner.BorderSizePixel = 0
    rightStickInner.Parent = rightStick
    
    touchControls.leftStick = leftStick
    touchControls.leftStickInner = leftStickInner
    touchControls.rightStick = rightStick
    touchControls.rightStickInner = rightStickInner
end

-- UPDATE GUI
function updateGUI()
    if flying then
        flyButton.Text = "🚀 FLY: ON"
        flyButton.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
    else
        flyButton.Text = "🚀 FLY: OFF"
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
    
    -- Show/hide sticks
    if touchControls.leftStick then
        touchControls.leftStick.Visible = flying
        touchControls.rightStick.Visible = flying
    end
end

-- FLY FUNCTIONS
function startFly()
    if flying then return end
    flying = true
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    humanoid.PlatformStand = true
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyGyro = Instance.new("BodyGyro")
    
    bodyVelocity.Parent = rootPart
    bodyGyro.Parent = rootPart
    
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = rootPart.CFrame
    
    updateGUI()
end

function stopFly()
    flying = false
    
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
    
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    
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
    speed = math.clamp(speed - 10, MIN_SPEED, MAX_SPEED)
    updateGUI()
end)

speedUp.MouseButton1Click:Connect(function()
    speed = math.clamp(speed + 10, MIN_SPEED, MAX_SPEED)
    updateGUI()
end)

-- TOUCH INPUT FOR MOBILE STICKS
if mobile then
    local leftTouch = nil
    local rightTouch = nil
    
    UserInputService.TouchStarted:Connect(function(touch, processed)
        if processed then return end
        
        -- Check left stick
        local leftPos = touchControls.leftStick.AbsolutePosition
        local leftSize = touchControls.leftStick.AbsoluteSize
        if touch.Position.X >= leftPos.X and touch.Position.X <= leftPos.X + leftSize.X
           and touch.Position.Y >= leftPos.Y and touch.Position.Y <= leftPos.Y + leftSize.Y then
            leftTouch = touch
        end
        
        -- Check right stick
        local rightPos = touchControls.rightStick.AbsolutePosition
        local rightSize = touchControls.rightStick.AbsoluteSize
        if touch.Position.X >= rightPos.X and touch.Position.X <= rightPos.X + rightSize.X
           and touch.Position.Y >= rightPos.Y and touch.Position.Y <= rightPos.Y + rightSize.Y then
            rightTouch = touch
        end
    end)
    
    UserInputService.TouchEnded:Connect(function(touch)
        if touch == leftTouch then
            leftTouch = nil
            -- Center left stick
            local tween = TweenService:Create(touchControls.leftStickInner, TweenInfo.new(0.2), {Position = UDim2.new(0.29, 0, 0.29, 0)})
            tween:Play()
        end
        if touch == rightTouch then
            rightTouch = nil
            -- Center right stick
            local tween = TweenService:Create(touchControls.rightStickInner, TweenInfo.new(0.2), {Position = UDim2.new(0.3, 0, 0.3, 0)})
            tween:Play()
        end
    end)
    
    -- Update stick positions
    RunService.Heartbeat:Connect(function()
        if leftTouch then
            local leftPos = touchControls.leftStick.AbsolutePosition
            local leftSize = touchControls.leftStick.AbsoluteSize
            local center = leftPos + leftSize / 2
            local offset = (leftTouch.Position - center) / (leftSize.X / 2)
            offset = Vector2.new(math.clamp(offset.X, -1, 1), math.clamp(offset.Y, -1, 1))
            
            touchControls.leftStickInner.Position = UDim2.new(0.29 + offset.X * 0.2, 0, 0.29 + offset.Y * 0.2, 0)
        end
        
        if rightTouch then
            local rightPos = touchControls.rightStick.AbsolutePosition
            local rightSize = touchControls.rightStick.AbsoluteSize
            local center = rightPos + rightSize / 2
            local offset = (rightTouch.Position - center) / (rightSize.X / 2)
            offset = Vector2.new(math.clamp(offset.X, -1, 1), math.clamp(offset.Y, -1, 1))
            
            touchControls.rightStickInner.Position = UDim2.new(0.3 + offset.X * 0.2, 0, 0.3 + offset.Y * 0.2, 0)
        end
    end)
end

-- FLY MOVEMENT LOOP
RunService.Heartbeat:Connect(function()
    if not flying then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart or not bodyVelocity or not bodyGyro then return end
    
    local direction = Vector3.new(0, 0, 0)
    
    -- Mobile stick controls
    if mobile and leftTouch and touchControls.leftStickInner then
        local leftOffset = (touchControls.leftStickInner.Position - UDim2.new(0.29, 0, 0.29, 0))
        direction = direction + (workspace.CurrentCamera.CFrame.RightVector * (leftOffset.X.Offset * 5))
        direction = direction - (workspace.CurrentCamera.CFrame.LookVector * (leftOffset.Y.Offset * 5))
    end
    
    -- Mobile up/down stick
    if mobile and rightTouch and touchControls.rightStickInner then
        local rightOffset = (touchControls.rightStickInner.Position - UDim2.new(0.3, 0, 0.3, 0))
        direction = direction + (Vector3.new(0, 1, 0) * (rightOffset.Y.Offset * 3))
    end
    
    -- Keyboard fallback (for testing)
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + workspace.CurrentCamera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - workspace.CurrentCamera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - workspace.CurrentCamera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + workspace.CurrentCamera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.E) then direction = direction + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.Q) then direction = direction + Vector3.new(0, -1, 0) end
    
    -- Apply speed
    if direction.Magnitude > 0 then
        direction = direction.Unit * speed
        bodyVelocity.Velocity = direction
    else
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
    
    bodyGyro.CFrame = workspace.CurrentCamera.CFrame
end)

-- AUTO RE-APPLY ON RESPAWN
LocalPlayer.CharacterAdded:Connect(function()
    if flying then
        task.wait(1)
        startFly()
    end
    if noclip then
        task.wait(1)
        startNoclip()
    end
end)

-- INITIAL UPDATE
updateGUI()
print("✅ Mobile Fly & Noclip Script LOADED!")
print("📱 Drag the control panel to move it!")
print("🚀 Tap buttons to toggle features")
