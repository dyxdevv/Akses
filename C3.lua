local prefix = {";", ".", "/", "#", ":", "?"}
local speeds = 1
local nowe = false
local tpwalking = false
local speaker = game:GetService("Players").LocalPlayer

-- Function to check if message starts with any prefix
local function isCommand(message)
    for _, p in ipairs(prefix) do
        if message:sub(1, #p) == p then
            return true, message:sub(#p + 1)
        end
    end
    return false, message
end

-- Fly function
local function toggleFly()
    if not speaker.Character or not speaker.Character:FindFirstChildOfClass("Humanoid") then return end
    
    if nowe then
        -- Disable fly
        nowe = false
        local humanoid = speaker.Character:FindFirstChildOfClass("Humanoid")
        
        -- Re-enable all states
        for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
            humanoid:SetStateEnabled(state, true)
        end
        
        humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
        humanoid.PlatformStand = false
        
        if speaker.Character:FindFirstChild("Animate") then
            speaker.Character.Animate.Disabled = false
        end
        
        tpwalking = false
    else
        -- Enable fly
        nowe = true
        local humanoid = speaker.Character:FindFirstChildOfClass("Humanoid")
        
        -- Disable unwanted states
        for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
            humanoid:SetStateEnabled(state, false)
        end
        
        humanoid.PlatformStand = true
        
        if speaker.Character:FindFirstChild("Animate") then
            speaker.Character.Animate.Disabled = true
        end
        
        -- Stop animations
        local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid:FindFirstChildOfClass("AnimationController")
        if animator then
            for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                track:AdjustSpeed(0)
            end
        end
        
        -- Start flight movement
        tpwalking = false
        for i = 1, math.clamp(speeds, 1, 100) do
            task.spawn(function()
                local hb = game:GetService("RunService").Heartbeat
                tpwalking = true
                while tpwalking and hb:Wait() and speaker.Character and humanoid and humanoid.Parent do
                    if humanoid.MoveDirection.Magnitude > 0 then
                        speaker.Character:TranslateBy(humanoid.MoveDirection * (speeds / 10))
                    end
                end
            end)
        end
        
        humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
    end
end

-- Handle character added/respawn
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.7) -- Wait for character to fully load
    if char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").PlatformStand = false
        if char:FindFirstChild("Animate") then
            char.Animate.Disabled = false
        end
    end
    nowe = false
    tpwalking = false
end)

-- Improved chat command handler
local function handleChatCommand(message)
    local isCmd, cmd = isCommand(message)
    if not isCmd then return end
    
    -- Trim whitespace and split into parts
    cmd = string.gsub(cmd, "^%s*(.-)%s*$", "%1")
    local parts = {}
    for part in string.gmatch(cmd, "%S+") do
        table.insert(parts, string.lower(part))
    end
    
    if #parts == 0 then return end
    
    if parts[1] == "fly" then
        toggleFly()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Fly System",
            Text = "Fly " .. (nowe and "enabled" or "disabled"),
            Duration = 2
        })
    elseif parts[1] == "unfly" then
        if nowe then
            toggleFly()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Fly System",
                Text = "Fly disabled",
                Duration = 2
            })
        end
    elseif parts[1] == "flyspeed" and #parts >= 2 then
        local newSpeed = tonumber(parts[2])
        if newSpeed and newSpeed >= 1 and newSpeed <= 10000 then
            speeds = newSpeed
            if nowe then
                -- Restart fly with new speed
                local wasFlying = nowe
                if wasFlying then toggleFly() end
                if wasFlying then toggleFly() end
            end
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Fly System",
                Text = "Speed set to " .. speeds,
                Duration = 2
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Fly System",
                Text = "Invalid speed (1-10000)",
                Duration = 2
            })
        end
    elseif parts[1] == "flycmds" or parts[1] == "flyhelp" then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Fly Commands",
            Text = "fly - Toggle flight\nflyspeed [1-10000] - Set speed\nunfly - Disable flight",
            Duration = 5
        })
    end
end

-- Connect chat listener
game:GetService("Players").LocalPlayer.Chatted:Connect(handleChatCommand)

-- Initial notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Fly System Loaded",
    Text = "Commands: fly, flyspeed [1-10000], unfly\nPrefixes: ; . / # : ?",
    Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150",
    Duration = 5
})