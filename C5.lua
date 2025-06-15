-- Comprehensive Fly Script with chat commands: /fly, /flyspeed <number>, /unfly
-- Logic and mechanics follow your original GUI fly script exactly
-- Supports R6 and R15 rigs, humanoid states enabled/disabled
-- Author: AI assistant adapting your GUI script to chat commands

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local flying = false
local speeds = 1 -- initial fly speed multiplier, can be changed with /flyspeed
local tpwalking = false

local flyCoroutine

-- List of humanoid states to disable for flying
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
	Enum.HumanoidStateType.Swimming
}

-- Sends notification with OK button
local function notify(title, text)
	StarterGui:SetCore("SendNotification", {
		Title = title;
		Text = text;
		Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150";
		Duration = 10;
		Button1 = "OK";
	})
end

-- Enable humanoid states (restore normal behavior)
local function enableHumanoidStates(hum)
	for _, state in pairs(humanoidStates) do
		hum:SetStateEnabled(state, true)
	end
	hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	hum.PlatformStand = false
	player.Character.Animate.Disabled = false
end

-- Disable humanoid states for flying
local function disableHumanoidStates(hum)
	for _, state in pairs(humanoidStates) do
		hum:SetStateEnabled(state, false)
	end
	hum.PlatformStand = true
	player.Character.Animate.Disabled = true
	-- Stop animations
	for _, track in pairs(hum:GetPlayingAnimationTracks()) do
		track:AdjustSpeed(0)
	end
end

-- Starts tpwalking coroutines based on speed multiplier
local function startTpWalking(speed)
	tpwalking = false
	wait(0.1)
	tpwalking = true
	for i = 1, speed do
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

-- Main fly control loop, handles R6 and R15 rigs
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

	local bg = Instance.new("BodyGyro", bodyPart)
	bg.P = 9e4
	bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
	bg.cframe = bodyPart.CFrame

	local bv = Instance.new("BodyVelocity", bodyPart)
	bv.velocity = Vector3.new(0,0.1,0)
	bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

	if flying then
		hum.PlatformStand = true
	end
	
	local ctrl = {f = 0, b = 0, l = 0, r = 0}
	local lastctrl = {f = 0, b = 0, l = 0, r = 0}
	local maxspeed = 50
	local speed = 0

	while flying and hum.Health > 0 do
		RunService.RenderStepped:Wait()
		
		-- Process input from UserInputService
		ctrl.f = UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0
		ctrl.b = UserInputService:IsKeyDown(Enum.KeyCode.S) and -1 or 0
		ctrl.l = UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0
		ctrl.r = UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0

		if (ctrl.l + ctrl.r ~= 0) or (ctrl.f + ctrl.b ~= 0) then
			speed = speed + 0.5 + (speed / maxspeed)
			if speed > maxspeed then speed = maxspeed end
		elseif not ((ctrl.l + ctrl.r ~= 0) or (ctrl.f + ctrl.b ~= 0)) and speed ~= 0 then
			speed = speed - 1
			if speed < 0 then speed = 0 end
		end

		if (ctrl.l + ctrl.r ~= 0) or (ctrl.f + ctrl.b ~= 0) then
			bv.velocity = ((workspace.CurrentCamera.CFrame.LookVector * (ctrl.f + ctrl.b)) + ((workspace.CurrentCamera.CFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0).p) - workspace.CurrentCamera.CFrame.p))*speed*speeds
			lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
		elseif (ctrl.l + ctrl.r == 0) and (ctrl.f + ctrl.b == 0) and speed ~= 0 then
			bv.velocity = ((workspace.CurrentCamera.CFrame.LookVector * (lastctrl.f + lastctrl.b)) + ((workspace.CurrentCamera.CFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * 0.2, 0).p) - workspace.CurrentCamera.CFrame.p))*speed*speeds
		else
			bv.velocity = Vector3.new(0,0,0)
		end

		bg.cframe = workspace.CurrentCamera.CFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
	end

	-- Cleanup on fly end
	ctrl = {f = 0, b = 0, l = 0, r = 0}
	lastctrl = {f = 0, b = 0, l = 0, r = 0}
	speed = 0
	bg:Destroy()
	bv:Destroy()
	hum.PlatformStand = false
	player.Character.Animate.Disabled = false
	tpwalking = false
end

-- Initiates flying
local function startFly()
	if flying then
		notify("Fly Script", "You are already flying!")
		return
	end
	flying = true
	disableHumanoidStates(humanoid)
	startTpWalking(speeds)
	flyCoroutine = coroutine.create(flyLoop)
	coroutine.resume(flyCoroutine)
	notify("Fly Activated", "Flying started at speed "..tostring(speeds))
end

-- Stops flying
local function stopFly()
	if not flying then
		notify("Fly Script", "You are not flying!")
		return
	end
	flying = false
	tpwalking = false
	if flyCoroutine and coroutine.status(flyCoroutine) ~= "dead" then
		coroutine.resume(flyCoroutine) -- To exit loop if waiting
	end
	enableHumanoidStates(humanoid)
	notify("Fly Deactivated", "Flying stopped.")
end

-- Change flying speed
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
		notify("Error", "Speed must be a number >= 1")
	end
end

-- Chat command handling
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

-- Reset flying on character respawn
player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	flying = false
	tpwalking = false
	enableHumanoidStates(humanoid)
end)

notify("Fly Script Loaded", "Commands: /fly, /unfly, /flyspeed <number>")
