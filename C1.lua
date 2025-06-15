local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

-- Configuration
local MAX_SPEED = 10000
local currentSpeed = 1
local isFlying = false
local flightParts = {}
local PREFIXES = {";", "/", "#", ":", "?", "."} -- Supported prefixes

-- Get flight part (works for R6/R15)
local function getFlightPart()
    local char = Players.LocalPlayer.Character
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
end

-- Toggle flight mode
local function toggleFlight(enable)
    if enable == isFlying then return end
    
    -- Cleanup existing flight parts
    for _, part in pairs(flightParts) do
        pcall(function() part:Destroy() end)
    end
    flightParts = {}
    
    local flightPart = getFlightPart()
    if not flightPart then return end
    
    isFlying = enable
    
    if isFlying then
        -- Initialize flight controls
        local success, bg, bv = pcall(function()
            local bg = Instance.new("BodyGyro")
            bg.Name = "FlightGyro"
            bg.P = 90000 + (currentSpeed * 1000)
            bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.CFrame = flightPart.CFrame
            bg.Parent = flightPart
            
            local bv = Instance.new("BodyVelocity")
            bv.Name = "FlightVelocity"
            bv.Velocity = Vector3.new(0, 0.1, 0)
            bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Parent = flightPart
            
            return bg, bv
        end)
        
        if not success then return end
        
        flightParts = {bg, bv}
        local humanoid = flightPart.Parent:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
            humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
        end
        
        -- Flight movement loop
        coroutine.wrap(function()
            while isFlying and flightPart and flightPart.Parent do
                RunService.Heartbeat:Wait()
                
                local moveVec = Vector3.new(
                    UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0,
                    UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and -1 or 0,
                    UserInputService:IsKeyDown(Enum.KeyCode.W) and -1 or UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0
                )
                
                if bv and bv.Parent then
                    bv.Velocity = workspace.CurrentCamera.CFrame:VectorToWorldSpace(moveVec * currentSpeed * 50)
                end
                if bg and bg.Parent then
                    bg.CFrame = workspace.CurrentCamera.CFrame
                end
            end
            
            -- Cleanup when done
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
            humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
        end
        
        StarterGui:SetCore("SendNotification", {
            Title = "✈️ FLY DISABLED",
            Duration = 2
        })
    end
end

-- Process chat commands
local function processCommand(msg)
    if not msg or type(msg) ~= "string" then return end
    
    msg = msg:lower():gsub("%s+", " "):trim()
    if msg == "" then return end
    
    -- Check for prefixes
    local prefix = msg:sub(1,1)
    if table.find(PREFIXES, prefix) then
        msg = msg:sub(2):trim()
    end
    
    -- Command handling
    if msg == "fly" then
        toggleFlight(not isFlying)
    elseif msg:match("^flyspeed%s+%d+$") then
        local newSpeed = tonumber(msg:match("%d+"))
        if newSpeed then
            currentSpeed = math.clamp(newSpeed, 1, MAX_SPEED)
            StarterGui:SetCore("SendNotification", {
                Title = "⚡ SPEED SET",
                Text = "Now: "..currentSpeed,
                Duration = 2
            })
            if isFlying then
                toggleFlight(false)
                toggleFlight(true)
            end
        end
    elseif msg:match("^%d+$") then -- Just number
        currentSpeed = math.clamp(tonumber(msg), 1, MAX_SPEED)
        toggleFlight(true)
    elseif msg == "unfly" then
        toggleFlight(false)
    elseif msg == "help" or msg == "cmds" then
        StarterGui:SetCore("SendNotification", {
            Title = "FLY COMMANDS",
            Text = "fly - Toggle\nflyspeed [1-10000]\nunfly - Stop\nPrefixes: ; / # : ? .",
            Duration = 5
        })
    end
end

-- Initialize
local function initialize()
    -- Chat command handler
    Players.LocalPlayer.Chatted:Connect(processCommand)
    
    -- Auto-cleanup on character change
    Players.LocalPlayer.CharacterAdded:Connect(function(char)
        toggleFlight(false)
    end)
    
    -- Show help on start
    StarterGui:SetCore("SendNotification", {
        Title = "FLY SYSTEM READY",
        Text = "Type 'help' for commands",
        Duration = 5
    })
end

-- Start with error protection
pcall(initialize)