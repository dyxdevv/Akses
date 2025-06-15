-- Fly Script dengan kontrol penuh 3D memakai chat commands (/fly, /flyspeed, /unfly)
-- Sesuai dengan logic script GUI asli Anda, tapi tanpa GUI, lewat chat

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local flying = false
local speeds = 1 -- kecepatan fly, minimal 1
local tpwalking = false

local bg, bv

local function notify(title, text)
    StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150";
        Duration = 5;
    })
end

local humanoidStates = {
    Enum.HumanoidStateType.Climbing,
    Enum.HumanoidStateType.FallingDown,
    Enum.HumanoidStateType.Flying,
    Enum.HumanoidStateType.Freefall,
    Enum.HumanoidStateType.GettingUp,
    Enum.HumanoidStateType.Jumping,
    Enum.HumanoidStateType.Landed,
    Enum.HumanoidStateType.Physics,
    Enum.HumanoidStateType.PlatformStanding,
    Enum.HumanoidStateType.Ragdoll,
    Enum.HumanoidStateType.Running,
    Enum.HumanoidStateType.RunningNoPhysics,
    Enum.HumanoidStateType.Seated,
    Enum.HumanoidStateType.StrafingNoPhysics,
    Enum.HumanoidStateType.Swimming,
}

local function disableHumanoidStates(hum)
    for _, state in pairs(humanoidStates) do
        hum:SetStateEnabled(state, false)
    end
    hum.PlatformStand = true
    player.Character.Animate.Disabled = true
    for _,track in pairs(hum:GetPlayingAnimationTracks()) do
        track:AdjustSpeed(0)
    end
end

local function enableHumanoidStates(hum)
    for _, state in pairs(humanoidStates) do
        hum:SetStateEnabled(state, true)
    end
    hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
    hum.PlatformStand = false
    player.Character.Animate.Disabled = false
end

local function startTpWalking(speed)
    tpwalking = false
    wait(0.1)
    tpwalking = true
    for i=1, speed do
        spawn(function()
            local hb = RunService.Heartbeat
            local chr = player.Character
            local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
            while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                if hum.MoveDirection.Magnitude > 0 then
                    chr:TranslateBy(hum.MoveDirection)
                end
            end
        end)
    end
end

local function flyLoop()
    local chr = player.Character
    if not chr then return end
    local hum = chr:FindFirstChildWhichIsA("Humanoid")
    if not hum then return end

    local rigType = hum.RigType
    local bodyPart = nil
    if rigType == Enum.HumanoidRigType.R6 then
        bodyPart = chr:FindFirstChild("Torso")
    else
        bodyPart = chr:FindFirstChild("UpperTorso")
    end
    if not bodyPart then return end

    bg = Instance.new("BodyGyro", bodyPart)
    bg.P = 9e4
    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.cframe = bodyPart.CFrame

    bv = Instance.new("BodyVelocity", bodyPart)
    bv.velocity = Vector3.new(0, 0.1, 0)
    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

    hum.PlatformStand = true

    while flying and hum.Health > 0 do
        RunService.RenderStepped:Wait()
        -- Input detections
        local ctrl = {f=0, b=0, l=0, r=0, up=0, down=0}

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then ctrl.f = 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then ctrl.b = -1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then ctrl.l = -1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then ctrl.r = 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then ctrl.up = 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then ctrl.down = -1 end

        -- Calculate movement vector
        local cameraCFrame = workspace.CurrentCamera.CFrame
        local moveVector = (cameraCFrame.LookVector * (ctrl.f + ctrl.b)) + 
                           ((cameraCFrame * CFrame.new(ctrl.l + ctrl.r, 0, 0)).p - cameraCFrame.p)
        moveVector = moveVector.Unit * (moveVector.Magnitude > 0 and speeds * 50 or 0) -- horizontal velocity

        -- Vertical movement (up/down)
        local verticalVelocity = (ctrl.up + ctrl.down) * speeds * 50

        -- Final velocity vector considering vertical movement
        bv.velocity = Vector3.new(moveVector.X, verticalVelocity, moveVector.Z)

        -- Keep BodyGyro aligned with camera rotation
        bg.cframe = cameraCFrame

    end

    bg:Destroy()
    bv:Destroy()
    hum.PlatformStand = false
    player.Character.Animate.Disabled = false
    tpwalking = false
end

local function startFly()
    if flying then
        notify("Fly Script", "You are already flying!")
        return
    end
    flying = true
    disableHumanoidStates(humanoid)
    startTpWalking(speeds)
    coroutine.wrap(flyLoop)()
    notify("Fly Activated", "Flying started at speed ".. tostring(speeds))
end

local function stopFly()
    if not flying then
        notify("Fly Script", "You are not flying!")
        return
    end
    flying = false
    tpwalking = false
    if bg then bg:Destroy() bg = nil end
    if bv then bv:Destroy() bv = nil end
    enableHumanoidStates(humanoid)
    notify("Fly Deactivated", "Flying stopped.")
end

local function setFlySpeed(value)
    local num = tonumber(value)
    if num and num >= 1 then
        speeds = num
        notify("Fly Script", "Fly speed set to ".. tostring(num))
        if flying then
            tpwalking = false
            wait(0.1)
            startTpWalking(speeds)
        end
    else
        notify("Error", "Speed must be a number greater or equal to 1")
    end
end

player.Chatted:Connect(function(message)
    local args = string.split(message, " ")
    local cmd = args[1]:lower()
    if cmd == "/fly" then
        startFly()
    elseif cmd == "/unfly" then
        stopFly()
    elseif cmd == "/flyspeed" then
        if args[2] then
            setFlySpeed(args[2])
        else
            notify("Fly Script", "Usage: /flyspeed <number>")
        end
    end
end)

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    flying = false
    tpwalking = false
    enableHumanoidStates(humanoid)
end)

notify("Fly Script Loaded", "Commands: /fly, /unfly, /flyspeed <number>")