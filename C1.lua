local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

-- Configuration
local MAX_FLY_SPEED = 10000
local PREFIXES = {";", "/", ".", "!", "-", "fly "} -- Supported command prefixes
local currentSpeed = 1
local isFlying = false
local flightParts = {}

-- Safe part detection
local function getFlightPart()
    local character = Players.LocalPlayer.Character
    if not character then return nil end
    
    return character:FindFirstChild("HumanoidRootPart") 
        or character:FindFirstChild("UpperTorso") 
        or character:FindFirstChild("Torso")
end

-- Robust flight control
local function toggleFlight(enable)
    if enable == isFlying then return end
    
    -- Cleanup any existing flight objects
    if not enable then
        for _, obj in pairs(flightParts) do
            pcall(function() obj:Destroy() end)
        end
        flightParts = {}
    end
    
    local flightPart = getFlightPart()
    if not flightPart then return end
    
    isFlying = enable
    
    if isFlying then
        -- Initialize flight controls with error handling
        local success, bg, bv = pcall(function()
            local bg = Instance.new("BodyGyro")
            bg.Name = "FlightGyro"
            bg.P = 90000 + (currentSpeed * 1000)
            bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.Parent = flightPart
            
            local bv = Instance.new("BodyVelocity")
            bv.Name = "FlightVelocity"
            bv.Velocity = Vector3.new(0, 0.1, 0)
            bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Parent = flightPart
            
            return bg, bv
        end)
        
        if not success then
            warn("Flight initialization failed")
            isFlying = false
            return
        end
        
        flightParts = {bg, bv}
        local humanoid = flightPart.Parent:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
        end
        
        -- Flight loop with error protection
        coroutine.wrap(function()
            while isFlying and flightPart and flightPart.Parent do
                local success = pcall(function()
                    RunService.Heartbeat:Wait()
                    local cam = workspace.CurrentCamera
                    if not cam then return end
                    
                    local moveVec = Vector3.new(
                        UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0,
                        UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and -1 or 0,
                        UserInputService:IsKeyDown(Enum.KeyCode.W) and -1 or UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0
                    )
                    
                    if bv and bv.Parent then
                        bv.Velocity = cam.CFrame:VectorToWorldSpace(moveVec * currentSpeed * 50)
                    end
                    if bg and bg.Parent then
                        bg.CFrame = cam.CFrame
                    end
                end)
                
                if not success then break end
            end
            
            -- Cleanup
            toggleFlight(false)
        end)()
        
        StarterGui:SetCore("SendNotification", {
            Title = "✈️ FLY ENABLED",
            Text = "Speed: "..currentSpeed,
            Duration = 2
        })
    else
        local humanoid = flightPart.Parent:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
        
        StarterGui:SetCore("SendNotification", {
            Title = "✈️ FLY DISABLED",
            Duration = 2
        })
    end
end

-- Command processor with full error handling
local function processCommand(msg)
    if not msg or type(msg) ~= "string" then return end
    
    msg = msg:lower():gsub("%s+", " "):trim()
    if msg == "" then return end
    
    -- Extract command
    local command, numberPart = msg:match("^(%a+)%s?(%d*)$") or msg:match("^(%d+)$")
    if not command then return end
    
    -- Handle numeric commands (like "50")
    if tonumber(command) then
        currentSpeed = math.clamp(tonumber(command), 1, MAX_FLY_SPEED)
        toggleFlight(true)
        return
    end
    
    -- Check prefixes
    for _, prefix in ipairs(PREFIXES) do
        if msg:sub(1, #prefix) == prefix then
            command = msg:sub(#prefix + 1)
            break
        end
    end
    
    -- Process commands
    if command == "fly" then
        toggleFlight(not isFlying)
    elseif command:match("^%d+$") then
        currentSpeed = math.clamp(tonumber(command), 1, MAX_FLY_SPEED)
        toggleFlight(true)
    elseif command:match("^fly%s+%d+") then
        currentSpeed = math.clamp(tonumber(command:match("%d+")), 1, MAX_FLY_SPEED)
        toggleFlight(true)
    elseif command == "stop" or command == "unfly" or command == "off" then
        toggleFlight(false)
    elseif command == "speed" then
        StarterGui:SetCore("SendNotification", {
            Title = "CURRENT SPEED",
            Text = "🚀 "..currentSpeed,
            Duration = 3
        })
    end
end

-- Safe event connections
local function initialize()
    -- Handle chat commands
    local chatConnection
    chatConnection = Players.LocalPlayer.Chatted:Connect(function(msg)
        pcall(processCommand, msg)
    end)
    
    -- Auto-cleanup on character change
    local charConnection
    charConnection = Players.LocalPlayer.CharacterAdded:Connect(function(char)
        pcall(toggleFlight, false)
    end)
    
    -- Cleanup on script termination
    return function()
        pcall(function()
            chatConnection:Disconnect()
            charConnection:Disconnect()
            toggleFlight(false)
        end)
    end
end

-- Initialize with error protection
local cleanup
local success, err = pcall(function()
    cleanup = initialize()
    StarterGui:SetCore("SendNotification", {
        Title = "FLY SYSTEM READY",
        Text = "Prefixes: ; / . ! -\nCommands: fly [speed], stop, speed",
        Duration = 6
    })
end)

if not success then
    warn("Initialization failed: "..tostring(err))
end

-- Optional cleanup hook (for module scripts)
if cleanup then
    return cleanup
end