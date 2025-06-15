local prefix = {";", ".", "/", "#", ":", "?"}
local speeds = 1
local nowe = false
local tpwalking = false
local speaker = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Function to check if message starts with any prefix
local function isCommand(message)
    for _, p in ipairs(prefix) do
        if message:sub(1, #p) == p then
            return true, message:sub(#p + 1)
        end
    end
    return false, message
end

-- Table to track controls state; Using 0/1 for pressed/unpressed
local ctrl = {f = 0, b = 0, l = 0, r = 0}

-- Update control states on input began
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local key = input.KeyCode
    if key == Enum.KeyCode.W then ctrl.f = 1
    elseif key == Enum.KeyCode.S then ctrl.b = 1
    elseif key == Enum.KeyCode.A then ctrl.l = 1
    elseif key == Enum.KeyCode.D then ctrl.r = 1
    end
end)

-- Update control states on input ended
UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local key = input.KeyCode
    if key == Enum.KeyCode.W then ctrl.f = 0
    elseif key == Enum.KeyCode.S then ctrl.b = 0
    elseif key == Enum.KeyCode.A then ctrl.l = 0
    elseif key == Enum.KeyCode.D then ctrl.r = 0
    end
end)

-- Fly function
local function toggleFly()
    if nowe == true then
        -- Disable fly
        nowe = false
        tpwalking = false
        local humanoid = speaker.Character and speaker.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
        if speaker.Character then
            speaker.Character.Animate.Disabled = false
        end
    else 
        -- Enable fly
        nowe = true
        tpwalking = true
        if speaker.Character then
            speaker.Character.Animate.Disabled = true
        end
        
        local Char = speaker.Character
        local Hum = Char and (Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController"))
        if Hum then
            Hum.PlatformStand = true
            for _, v in next, Hum:GetPlayingAnimationTracks() do
                v:AdjustSpeed(0)
            end
        end

        local rootPart = Char and (Char:FindFirstChild("HumanoidRootPart") or (Char and Char.PrimaryPart)
        if not rootPart then
            nowe = false
            tpwalking = false
            if speaker.Character then
                speaker.Character.Animate.Disabled = false
            end
            return
        end

        local bg = Instance.new("BodyGyro", rootPart)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = rootPart.CFrame
        
        local bv = Instance.new("BodyVelocity", rootPart)
        bv.velocity = Vector3.new(0, 0, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

        local maxspeed = speeds * 50
        local speed = 0

        while nowe == true and speaker.Character and speaker.Character:FindFirstChildOfClass("Humanoid") and speaker.Character.Humanoid.Health > 0 and rootPart.Parent do
            RunService.RenderStepped:Wait()

            -- Update speed smoothly
            if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                speed = speed + 0.5 + (speed / maxspeed)
                if speed > maxspeed then speed = maxspeed end
            else
                speed = speed - 1
                if speed < 0 then speed = 0 end
            end

            local cam = workspace.CurrentCamera
            if cam then
                -- Calculate movement direction based on camera orientation
                local forward = (ctrl.f - ctrl.b) * speed
                local right = (ctrl.r - ctrl.l) * speed
                
                local camCF = cam.CFrame
                local moveVector = (camCF.LookVector * forward) + (camCF.RightVector * right)
                moveVector = moveVector + Vector3.new(0, (UserInputService:IsKeyDown(Enum.KeyCode.Space) and speed or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and speed or 0), 0)
                
                bv.velocity = moveVector
                bg.cframe = camCF
            else
                bv.velocity = Vector3.new(0, 0, 0)
                bg.cframe = rootPart.CFrame
            end
        end

        -- Clean up after flying ends
        bg:Destroy()
        bv:Destroy()
        if speaker.Character and speaker.Character:FindFirstChildOfClass("Humanoid") then
            speaker.Character.Humanoid.PlatformStand = false
        end
        if speaker.Character then
            speaker.Character.Animate.Disabled = false
        end
        tpwalking = false
        nowe = false
    end
end

-- Character added event to reset states
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
    wait(0.7)
    local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.PlatformStand = false
    end
    if game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character.Animate.Disabled = false
    end
    nowe = false
    tpwalking = false
end)

-- Chat command handler
game:GetService("Players").LocalPlayer.Chatted:Connect(function(message)
    local isCmd, cmd = isCommand(message)
    if isCmd then
        local parts = {}
        for part in cmd:gmatch("%S+") do
            table.insert(parts, part:lower())
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
end)

-- Initial notification with commands
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Fly System Loaded",
    Text = "Commands: fly, flyspeed [1-10000], unfly\nPrefixes: ; . / # : ?",
    Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150",
    Duration = 5
})