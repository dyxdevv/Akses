local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Configuration
local FLY_SPEED = 1
local MAX_FLY_SPEED = 10000
local isFlying = false
local flyControls = {
    BodyGyro = nil,
    BodyVelocity = nil
}

-- Find torso based on avatar type (R6 or R15)
local function getTorso()
    if Character:FindFirstChild("UpperTorso") then
        return Character:FindFirstChild("UpperTorso") -- R15
    elseif Character:FindFirstChild("Torso") then
        return Character:FindFirstChild("Torso") -- R6
    end
    return nil
end

-- Cleanup flying components
local function cleanupFly()
    if flyControls.BodyGyro then
        flyControls.BodyGyro:Destroy()
        flyControls.BodyGyro = nil
    end
    
    if flyControls.BodyVelocity then
        flyControls.BodyVelocity:Destroy()
        flyControls.BodyVelocity = nil
    end
    
    Humanoid.PlatformStand = false
    Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
end

-- Main fly function
local function startFlying()
    local torso = getTorso()
    if not torso then return end
    
    -- Create flight controls
    flyControls.BodyGyro = Instance.new("BodyGyro")
    flyControls.BodyVelocity = Instance.new("BodyVelocity")
    
    -- Configure BodyGyro
    flyControls.BodyGyro.P = 90000
    flyControls.BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyControls.BodyGyro.cframe = torso.CFrame
    flyControls.BodyGyro.Parent = torso
    
    -- Configure BodyVelocity
    flyControls.BodyVelocity.velocity = Vector3.new(0, 0.1, 0)
    flyControls.BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    flyControls.BodyVelocity.Parent = torso
    
    Humanoid.PlatformStand = true
    
    -- Flight loop
    coroutine.wrap(function()
        while isFlying and torso and torso.Parent do
            RunService.Heartbeat:Wait()
            
            local camera = workspace.CurrentCamera
            local moveDir = Vector3.new(0, 0, 0)
            
            -- Get movement input
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + camera.CFrame.RightVector
            end
            
            -- Apply movement
            if moveDir.Magnitude > 0 then
                flyControls.BodyVelocity.velocity = moveDir.Unit * FLY_SPEED
            else
                flyControls.BodyVelocity.velocity = Vector3.new(0, 0.1, 0)
            end
            
            -- Update orientation
            flyControls.BodyGyro.cframe = camera.CFrame
        end
        
        -- Cleanup when done flying
        cleanupFly()
    end)()
end

-- Toggle flying state
local function toggleFly(enable)
    if enable == nil then
        enable = not isFlying
    end
    
    isFlying = enable
    
    if isFlying then
        startFlying()
        StarterGui:SetCore("SendNotification", {
            Title = "Fly Enabled",
            Text = "Speed: "..FLY_SPEED,
            Duration = 2
        })
    else
        cleanupFly()
        StarterGui:SetCore("SendNotification", {
            Title = "Fly Disabled",
            Text = "Flight turned off",
            Duration = 2
        })
    end
end

-- Handle chat commands
Player.Chatted:Connect(function(message)
    local msg = message:lower()
    
    if msg == ";fly" then
        toggleFly(true)
    elseif msg:sub(1,5) == ";fly " then
        local newSpeed = tonumber(msg:sub(6))
        if newSpeed then
            FLY_SPEED = math.clamp(newSpeed, 1, MAX_FLY_SPEED)
        end
        toggleFly(true)
    elseif msg == ";unfly" or msg == ";nofly" then
        toggleFly(false)
    elseif msg == ";flyspeed" then
        StarterGui:SetCore("SendNotification", {
            Title = "Current Fly Speed",
            Text = "Speed: "..FLY_SPEED,
            Duration = 3
        })
    end
end)

-- Handle character changes
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    
    -- Auto disable fly on respawn
    if isFlying then
        isFlying = false
        cleanupFly()
    end
end)

-- Initial notification
StarterGui:SetCore("SendNotification", {
    Title = "Fly Script Loaded",
    Text = "Commands: ;fly [speed], ;unfly, ;flyspeed",
    Duration = 5,
    Button1 = "OK"
})

-- Keyboard controls (optional)
local UserInputService = game:GetService("UserInputService")
local shiftHeld = false

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.LeftShift then
        shiftHeld = true
    end
end)

UserInputService.InputEnded:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.LeftShift then
        shiftHeld = false
    end
end)