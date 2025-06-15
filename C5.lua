-- Fly script via chat commands: /fly, /flyspeed, /unfly
-- Mirip fungsi fly GUI script Anda tapi non-GUI dan via chat
-- By AI assistant adapting your original script logic

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local flying = false
local flySpeed = 1
local flyThreads = {}
local tpwalking = false

StarterGui:SetCore("SendNotification", {
	Title = "FLY SCRIPT LOADED";
	Text = "Use /fly, /flyspeed <number>, /unfly commands";
	Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150";
	Duration = 5;
})

-- Function to send notifications with OK button
local function notify(title,text)
	StarterGui:SetCore("SendNotification",{
		Title = title;
		Text = text;
		Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150";
		Duration = 10;
		Button1 = "OK";
	})
end

-- Function to enable humanoid states when flying is off
local function enableHumanoidStates(hum)
	local enumStates = {
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
	for _, state in pairs(enumStates) do
		hum:SetStateEnabled(state, true)
	end
	hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	hum.PlatformStand = false
	player.Character.Animate.Disabled = false
end

-- Function to disable humanoid states for fly
local function disableHumanoidStates(hum)
	local enumStates = {
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
	for _, state in pairs(enumStates) do
		hum:SetStateEnabled(state, false)
	end
	hum.PlatformStand = true
	player.Character.Animate.Disabled = true
	-- Stop all animations
	for _,v in pairs(hum:GetPlayingAnimationTracks()) do
		v:AdjustSpeed(0)
	end
end

-- Starts the tpwalking loops mimicking original spawn threads
local function startTpWalking(speed)
	tpwalking = false -- kill any existing loops
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

-- Fly main control for R6 / R15 rigs with BodyGyro and BodyVelocity
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

	local bg = Instance.new("BodyGyro")
	bg.P = 90000
	bg.maxTorque = Vector3.new(9000000000, 9000000000, 9000000000)
	bg.cframe = bodyPart.CFrame
	bg.Parent = bodyPart

	local bv = Instance.new("BodyVelocity")
	bv.velocity = Vector3.new(0, 0.1, 0)
	bv.maxForce = Vector3.new(9000000000, 9000000000, 9000000000)
	bv.Parent = bodyPart

	while flying and hum.Health > 0 do
		RunService.RenderStepped:Wait()

		local ctrl = {f=0, b=0, l=0, r=0}
		-- Movement inputs detection by UserInputService
		local UserInput = game:GetService("UserInputService")
		if UserInput:IsKeyDown(Enum.KeyCode.W) then ctrl.f = 1 end
		if UserInput:IsKeyDown(Enum.KeyCode.S) then ctrl.b = -1 end
		if UserInput:IsKeyDown(Enum.KeyCode.A) then ctrl.l = -1 end
		if UserInput:IsKeyDown(Enum.KeyCode.D) then ctrl.r = 1 end

		-- Calculate velocity following camera orientation with flySpeed
		local moveDir = (workspace.CurrentCamera.CFrame.LookVector * (ctrl.f + ctrl.b)) 
			+ ((workspace.CurrentCamera.CFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b)*0.2, 0).p) - workspace.CurrentCamera.CFrame.p)

		bv.velocity = moveDir.Unit * flySpeed * 16 -- 16 studs/sec base speed scale

		bg.cframe = workspace.CurrentCamera.CFrame
	end

	bg:Destroy()
	bv:Destroy()
	
	enableHumanoidStates(hum)
end

local function startFly()
	if flying then return end
	flying = true
	disableHumanoidStates(humanoid)
	startTpWalking(flySpeed)
	spawn(flyLoop)
	notify("Fly activated","Flying started at speed ".. tostring(flySpeed))
end

local function stopFly()
	if not flying then return end
	flying = false
	tpwalking = false
	enableHumanoidStates(humanoid)
	notify("Fly deactivated","Flying stopped")
end

local function setSpeed(speed)
	if type(speed) == "number" and speed > 0 then
		flySpeed = speed
		if flying then
			tpwalking = false
			wait(0.1)
			startTpWalking(flySpeed)
		end
		notify("Fly speed set","Speed set to ".. tostring(flySpeed))
	else
		notify("Invalid speed","Please enter a positive number")
	end
end

-- Character respawn handler
player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	flying = false
	tpwalking = false
	enableHumanoidStates(humanoid)
end)

-- Chat command handler
player.Chatted:Connect(function(msg)
	local args = string.split(msg, " ")
	local cmd = args[1]:lower()

	if cmd == "/fly" then
		startFly()
	elseif cmd == "/unfly" then
		stopFly()
	elseif cmd == "/flyspeed" then
		if args[2] then
			local speedArg = tonumber(args[2])
			setSpeed(speedArg)
		else
			notify("Error", "Usage: /flyspeed <number>")
		end
	end
end)
