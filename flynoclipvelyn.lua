-- Fly & Noclip Script with GUI Controls
-- Loadstring: loadstring(game:HttpGet("https://raw.githubusercontent.com/USERNAME/REPO/main/FlyNoclip.lua"))()

-- Configuration
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Default Settings
local settings = {
    flyEnabled = false,
    noclipEnabled = false,
    flySpeed = 50,
    maxSpeed = 300,
    minSpeed = 10,
    controls = {
        up = "E",
        down = "Q",
        forward = "W",
        back = "S",
        left = "A",
        right = "D"
    }
}

-- Fly Variables
local flying = false
local bodyVelocity
local bodyGyro
local camera = workspace.CurrentCamera

-- Noclip Variables
local noclip = false
local connections = {}

-- Load GUI Library
local Library
local success, err = pcall(function()
    Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
end)

if not success then
    Library = loadstring(game:HttpGet("https://pastebin.com/raw/v6nZq6yY"))()
end

-- Create GUI
local Window = Library.CreateLib("Fly & Noclip Controller", "DarkTheme")

-- Fly Tab
local FlyTab = Window:NewTab("Fly Controls")
local FlySection = FlyTab:NewSection("Fly Settings")

local FlyToggle = FlySection:NewToggle("Enable Fly", "Toggle flying mode", function(state)
    settings.flyEnabled = state
    if state then
        activateFly()
    else
        deactivateFly()
    end
end)

local SpeedSlider = FlySection:NewSlider("Fly Speed", "Adjust fly speed (10-300)", 300, 10, function(value)
    settings.flySpeed = value
    if bodyVelocity then
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
end)
SpeedSlider:SetValue(50)

local ControlsSection = FlyTab:NewSection("Keybinds")
ControlsSection:NewKeybind("Fly Up", "Key to fly up", Enum.KeyCode.E, function()
    -- Keybind for up
end)

ControlsSection:NewKeybind("Fly Down", "Key to fly down", Enum.KeyCode.Q, function()
    -- Keybind for down
end)

-- Noclip Tab
local NoclipTab = Window:NewTab("Noclip")
local NoclipSection = NoclipTab:NewSection("Noclip Settings")

local NoclipToggle = NoclipSection:NewToggle("Enable Noclip", "Toggle noclip mode", function(state)
    settings.noclipEnabled = state
    if state then
        activateNoclip()
    else
        deactivateNoclip()
    end
end)

local InfoTab = Window:NewTab("Info")
local InfoSection = InfoTab:NewSection("Instructions")
InfoSection:NewLabel("Fly Controls:")
InfoSection:NewLabel("W/S/A/D - Move")
InfoSection:NewLabel("E/Q - Up/Down")
InfoSection:NewLabel("Shift - Increase Speed")
InfoSection:NewLabel("Ctrl - Decrease Speed")

-- Fly Functions
function activateFly()
    if flying then return end
    
    flying = true
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.PlatformStand = true
    
    -- Create BodyVelocity and BodyGyro
    bodyVelocity = Instance.new("BodyVelocity")
    bodyGyro = Instance.new("BodyGyro")
    
    bodyVelocity.Parent = character.HumanoidRootPart
    bodyGyro.Parent = character.HumanoidRootPart
    
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = character.HumanoidRootPart.CFrame
    
    -- Fly control loop
    local flyConnection
    flyConnection = RunService.Heartbeat:Connect(function(delta)
        if not flying or not character or not character:FindFirstChild("HumanoidRootPart") then
            if flyConnection then
                flyConnection:Disconnect()
            end
            return
        end
        
        local direction = Vector3.new(0, 0, 0)
        
        -- Movement controls
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
            direction = direction + Vector3.new(0, -1, 0)
        end
        
        -- Speed modifiers
        local currentSpeed = settings.flySpeed
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            currentSpeed = currentSpeed * 2
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            currentSpeed = currentSpeed / 2
        end
        
        -- Normalize and apply
        if direction.Magnitude > 0 then
            direction = direction.Unit * currentSpeed
        end
        
        bodyVelocity.Velocity = direction
        bodyGyro.CFrame = camera.CFrame
    end)
end

function deactivateFly()
    flying = false
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
        
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        if bodyGyro then
            bodyGyro:Destroy()
            bodyGyro = nil
        end
    end
end

-- Noclip Functions
function activateNoclip()
    if noclip then return end
    
    noclip = true
    local character = LocalPlayer.Character
    if not character then return end
    
    -- Disable collisions
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    -- Monitor for new parts
    local connection = character.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end)
    
    table.insert(connections, connection)
end

function deactivateNoclip()
    noclip = false
    local character = LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    
    -- Clean up connections
    for _, connection in pairs(connections) do
        connection:Disconnect()
    end
    connections = {}
end

-- Auto re-enable on character reset
LocalPlayer.CharacterAdded:Connect(function(character)
    if settings.flyEnabled then
        wait(1)
        activateFly()
    end
    if settings.noclipEnabled then
        wait(1)
        activateNoclip()
    end
end)

-- Clean up on script termination
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.P and not processed then
        deactivateFly()
        deactivateNoclip()
        Window:Destroy()
    end
end)

-- Initialize if toggles are on
if settings.flyEnabled then
    FlyToggle:Set(true)
end
if settings.noclipEnabled then
    NoclipToggle:Set(true)
end

print("Fly & Noclip Script Loaded!")
print("Press P to close GUI and disable features")
