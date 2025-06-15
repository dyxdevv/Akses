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
    if nowe == true then
        nowe = false
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
        speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
    else 
        nowe = true
        for i = 1, speeds do
            spawn(function()
                local hb = game:GetService("RunService").Heartbeat
                tpwalking = true
                local chr = game.Players.LocalPlayer.Character
                local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                    if hum.MoveDirection.Magnitude > 0 then
                        chr:TranslateBy(hum.MoveDirection * (speeds / 10))
                    end
                end
            end)
        end
        game.Players.LocalPlayer.Character.Animate.Disabled = true
        local Char = game.Players.LocalPlayer.Character
        local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
        for i,v in next, Hum:GetPlayingAnimationTracks() do
            v:AdjustSpeed(0)
        end
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
        speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
        speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
    end

    if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
        local plr = game.Players.LocalPlayer
        local torso = plr.Character.Torso
        local flying = true
        local deb = true
        local ctrl = {f = 0, b = 0, l = 0, r = 0}
        local lastctrl = {f = 0, b = 0, l = 0, r = 0}
        local maxspeed = speeds * 10 -- Adjusted for better speed scaling
        local speed = 0

        local bg = Instance.new("BodyGyro", torso)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = torso.CFrame
        local bv = Instance.new("BodyVelocity", torso)
        bv.velocity = Vector3.new(0,0.1,0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        if nowe == true then
            plr.Character.Humanoid.PlatformStand = true
        end
        while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
            game:GetService("RunService").RenderStepped:Wait()
            if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                speed = speed+.5+(speed/maxspeed)
                if speed > maxspeed then
                    speed = maxspeed
                end
            elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                speed = speed-1
                if speed < 0 then
                    speed = 0
                end
            end
            if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
            elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
            else
                bv.velocity = Vector3.new(0,0,0)
            end
            -- Keep the character upright: set the BodyGyro CFrame with no pitch or roll, only yaw from camera
            local camCF = game.Workspace.CurrentCamera.CoordinateFrame
            local lookVector = camCF.lookVector
            local newCFrame = CFrame.new(torso.Position, torso.Position + Vector3.new(lookVector.X, 0, lookVector.Z)) -- Yaw only
            bg.cframe = newCFrame
        end
        ctrl = {f = 0, b = 0, l = 0, r = 0}
        lastctrl = {f = 0, b = 0, l = 0, r = 0}
        speed = 0
        bg:Destroy()
        bv:Destroy()
        plr.Character.Humanoid.PlatformStand = false
        game.Players.LocalPlayer.Character.Animate.Disabled = false
        tpwalking = false
    else
        local plr = game.Players.LocalPlayer
        local UpperTorso = plr.Character.UpperTorso
        local flying = true
        local deb = true
        local ctrl = {f = 0, b = 0, l = 0, r = 0}
        local lastctrl = {f = 0, b = 0, l = 0, r = 0}
        local maxspeed = speeds * 10 -- Adjusted for better speed scaling
        local speed = 0

        local bg = Instance.new("BodyGyro", UpperTorso)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = UpperTorso.CFrame
        local bv = Instance.new("BodyVelocity", UpperTorso)
        bv.velocity = Vector3.new(0,0.1,0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        if nowe == true then
            plr.Character.Humanoid.PlatformStand = true
        end
        while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
            wait()
            if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                speed = speed+.5+(speed/maxspeed)
                if speed > maxspeed then
                    speed = maxspeed
                end
            elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                speed = speed-1
                if speed < 0 then
                    speed = 0
                end
            end
            if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
            elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
            else
                bv.velocity = Vector3.new(0,0,0)
            end
            -- Keep the character upright: set the BodyGyro CFrame with no pitch or roll, only yaw from camera
            local camCF = game.Workspace.CurrentCamera.CoordinateFrame
            local lookVector = camCF.lookVector
            local newCFrame = CFrame.new(UpperTorso.Position, UpperTorso.Position + Vector3.new(lookVector.X, 0, lookVector.Z)) -- Yaw only
            bg.cframe = newCFrame
        end
        ctrl = {f = 0, b = 0, l = 0, r = 0}
        lastctrl = {f = 0, b = 0, l = 0, r = 0}
        speed = 0
        bg:Destroy()
        bv:Destroy()
        plr.Character.Humanoid.PlatformStand = false
        game.Players.LocalPlayer.Character.Animate.Disabled = false
        tpwalking = false
    end
end

-- Character added event
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
    wait(0.7)
    game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
    game.Players.LocalPlayer.Character.Animate.Disabled = false
    nowe = false
    tpwalking = false
end)

-- Improved chat handler with fixed flyspeed command
game:GetService("Players").LocalPlayer.Chatted:Connect(function(message)
    local isCmd, cmd = isCommand(message)
    if isCmd then
        -- Split command into parts
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
                if nowe then
                    -- Fix: spawn only one tpwalking thread if not already running
                    if not tpwalking then
                        tpwalking = true
                        spawn(function()
                            local hb = game:GetService("RunService").Heartbeat
                            local chr = game.Players.LocalPlayer.Character
                            local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                            while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                                if hum.MoveDirection.Magnitude > 0 then
                                    chr:TranslateBy(hum.MoveDirection * (speeds / 10))
                                end
                            end
                        end)
                    end
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
end)

-- Initial notification with commands
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Fly System Loaded",
    Text = "Commands: fly, flyspeed [1-10000], unfly\nPrefixes: ; . / # : ?",
    Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150",
    Duration = 5
})
