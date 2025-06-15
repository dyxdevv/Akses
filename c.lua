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
local nowe = false
local tpwalking = false
local speeds = 1

-- Find torso based on avatar type (R6 or R15)
local function getTorso()
    if Character:FindFirstChild("UpperTorso") then
        return Character:FindFirstChild("UpperTorso") -- R15
    elseif Character:FindFirstChild("Torso") then
        return Character:FindFirstChild("Torso") -- R6
    end
    return nil
end

-- Enable all humanoid states
local function enableHumanoidStates()
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
    Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
end

-- Disable all humanoid states
local function disableHumanoidStates()
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
    Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
end

-- Cleanup flying components
local function cleanupFly()
    nowe = false
    tpwalking = false
    enableHumanoidStates()
    Humanoid.PlatformStand = false
    Character.Animate.Disabled = false
end

-- Main fly function
local function startFlying()
    nowe = true
    tpwalking = false
    
    -- Start multiple fly threads based on speed
    for i = 1, speeds do
        spawn(function()
            local hb = RunService.Heartbeat    
            tpwalking = true
            while tpwalking and hb:Wait() and Character and Humanoid and Humanoid.Parent do
                if Humanoid.MoveDirection.Magnitude > 0 then
                    Character:TranslateBy(Humanoid.MoveDirection)
                end
            end
        end)
    end
    
    Character.Animate.Disabled = true
    local Hum = Character:FindFirstChildOfClass("Humanoid") or Character:FindFirstChildOfClass("AnimationController")
    
    for _,v in next, Hum:GetPlayingAnimationTracks() do
        v:AdjustSpeed(0)
    end
    
    disableHumanoidStates()
    
    -- R6 flight system
    if Humanoid.RigType == Enum.HumanoidRigType.R6 then
        local torso = Character:FindFirstChild("Torso")
        if not torso then return end
        
        local ctrl = {f = 0, b = 0, l = 0, r = 0}
        local lastctrl = {f = 0, b = 0, l = 0, r = 0}
        local maxspeed = 50
        local speed = 0

        local bg = Instance.new("BodyGyro", torso)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = torso.CFrame
        
        local bv = Instance.new("BodyVelocity", torso)
        bv.velocity = Vector3.new(0, 0.1, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        Humanoid.PlatformStand = true
        
        coroutine.wrap(function()
            while nowe and Humanoid.Health > 0 do
                RunService.RenderStepped:Wait()

                if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                    speed = speed + 0.5 + (speed/maxspeed)
                    speed = math.min(speed, maxspeed)
                elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                    speed = math.max(speed - 1, 0)
                end
                
                if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                    bv.velocity = ((workspace.CurrentCamera.CFrame.lookVector * (ctrl.f+ctrl.b)) + 
                                  ((workspace.CurrentCamera.CFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*0.2,0).p) - 
                                  workspace.CurrentCamera.CFrame.p)) * speed
                    lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                    bv.velocity = ((workspace.CurrentCamera.CFrame.lookVector * (lastctrl.f+lastctrl.b)) + 
                                  ((workspace.CurrentCamera.CFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*0.2,0).p) - 
                                  workspace.CurrentCamera.CFrame.p)) * speed
                else
                    bv.velocity = Vector3.new(0, 0, 0)
                end
                
                bg.cframe = workspace.CurrentCamera.CFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed), 0, 0)
            end
            
            bg:Destroy()
            bv:Destroy()
            Humanoid.PlatformStand = false
        end)()
    else
        -- R15 flight system
        local upperTorso = Character:FindFirstChild("UpperTorso")
        if not upperTorso then return end
        
        local ctrl = {f = 0, b = 0, l = 0, r = 0}
        local lastctrl = {f = 0, b = 0, l = 0, r = 0}
        local maxspeed = 50
        local speed = 0

        local bg = Instance.new("BodyGyro", upperTorso)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = upperTorso.CFrame
        
        local bv = Instance.new("BodyVelocity", upperTorso)
        bv.velocity = Vector3.new(0, 0.1, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        Humanoid.PlatformStand = true
        
        coroutine.wrap(function()
            while nowe and Humanoid.Health > 0 do
                wait()

                if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                    speed = speed + 0.5 + (speed/maxspeed)
                    speed = math.min(speed, maxspeed)
                elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                    speed = math.max(speed - 1, 0)
                end
                
                if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                    bv.velocity = ((workspace.CurrentCamera.CFrame.lookVector * (ctrl.f+ctrl.b)) + 
                                  ((workspace.CurrentCamera.CFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*0.2,0).p) - 
                                  workspace.CurrentCamera.CFrame.p)) * speed
                    lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                    bv.velocity = ((workspace.CurrentCamera.CFrame.lookVector * (lastctrl.f+lastctrl.b)) + 
                                  ((workspace.CurrentCamera.CFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*0.2,0).p) - 
                                  workspace.CurrentCamera.CFrame.p)) * speed
                else
                    bv.velocity = Vector3.new(0, 0, 0)
                end
                
                bg.cframe = workspace.CurrentCamera.CFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed), 0, 0)
            end
            
            bg:Destroy()
            bv:Destroy()
            Humanoid.PlatformStand = false
        end)()
    end
end

-- Handle chat commands
Player.Chatted:Connect(function(message)
    local msg = message:lower()
    
    if msg == ";fly" then
        if nowe then
            cleanupFly()
            StarterGui:SetCore("SendNotification", {
                Title = "Fly Disabled",
                Text = "Flight turned off",
                Duration = 2
            })
        else
            startFlying()
            StarterGui:SetCore("SendNotification", {
                Title = "Fly Enabled",
                Text = "Speed: "..speeds,
                Duration = 2
            })
        end
    elseif msg:sub(1,5) == ";fly " then
        local newSpeed = tonumber(msg:sub(6))
        if newSpeed then
            speeds = math.clamp(newSpeed, 1, MAX_FLY_SPEED)
        end
        startFlying()
        StarterGui:SetCore("SendNotification", {
            Title = "Fly Enabled",
            Text = "Speed: "..speeds,
            Duration = 2
        })
    elseif msg == ";unfly" or msg == ";nofly" then
        cleanupFly()
        StarterGui:SetCore("SendNotification", {
            Title = "Fly Disabled",
            Text = "Flight turned off",
            Duration = 2
        })
    elseif msg == ";flyspeed" then
        StarterGui:SetCore("SendNotification", {
            Title = "Current Fly Speed",
            Text = "Speed: "..speeds,
            Duration = 3
        })
    end
end)

-- Handle character changes
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    
    -- Auto disable fly on respawn
    cleanupFly()
end)

-- Initial notification
StarterGui:SetCore("SendNotification", {
    Title = "Fly Script Loaded",
    Text = "Commands:\n;fly - Toggle flight\n;fly [speed] - Fly with speed\n;unfly - Stop flying\n;flyspeed - Check speed",
    Duration = 5,
    Button1 = "OK"
})