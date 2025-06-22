local a = "的"
local b = "一"
local c = "是"
local d = "不"
local e = "了"
local f = "人"
local g = "我"
local h = "在"
local i = "有"
local j = "他"
local k = "这"
local l = "为"
local m = "之"
local n = "大"
local o = "来"
local p = "以"
local q = "个"
local r = "中"
local s = "上"
local t = "们"
local u = "到"
local v = "说"
local w = "国"
local x = "和"
local y = "地"
local z = "也"

local function convert(str)
    str = str:lower()
    return str:gsub("[a-z]", {
        a = a, b = b, c = c, d = d, e = e, f = f, g = g, h = h, i = i, j = j,
        k = k, l = l, m = m, n = n, o = o, p = p, q = q, r = r, s = s, t = t,
        u = u, v = v, w = w, x = x, y = y, z = z
    })
end

local function unconvert(str)
    str = str:lower()
    return str:gsub(".", {
        [a] = "a", [b] = "b", [c] = "c", [d] = "d", [e] = "e", [f] = "f", [g] = "g", [h] = "h", [i] = "i", [j] = "j",
        [k] = "k", [l] = "l", [m] = "m", [n] = "n", [o] = "o", [p] = "p", [q] = "q", [r] = "r", [s] = "s", [t] = "t",
        [u] = "u", [v] = "v", [w] = "w", [x] = "x", [y] = "y", [z] = "z"
    })
end

local function chat(str)
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(str, "All")
end

-- UI Creation
local player = game:GetService("Players").LocalPlayer
if not player then return end

-- Create ScreenGui
local SG = Instance.new("ScreenGui")
SG.Name = "ZenoChatBypasser"
SG.Parent = player:WaitForChild("PlayerGui")
SG.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Parent = SG
frame.Size = UDim2.new(0.25, 0, 0.25, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.75, 0)
frame.Active = true
frame.Draggable = true
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0

-- Corner rounding
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Parent = frame
titleBar.Size = UDim2.new(1, 0, 0.15, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Parent = titleBar
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0.15, 0, 0, 0)
title.Text = "ZenoVA | Chat Bypasser"
title.TextColor3 = Color3.fromRGB(100, 220, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = titleBar
closeButton.Size = UDim2.new(0.15, 0, 1, 0)
closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.Position = UDim2.new(1, 0, 0, 0)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 20
closeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
closeButton.BorderSizePixel = 0
closeButton.AutoButtonColor = false

-- Close button hover effects
closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
end)

closeButton.MouseButton1Click:Connect(function()
    SG:Destroy()
end)

-- Text input box
local textbox = Instance.new("TextBox")
textbox.Name = "InputBox"
textbox.Parent = frame
textbox.Size = UDim2.new(0.9, 0, 0.6, 0)
textbox.Position = UDim2.new(0.05, 0, 0.2, 0)
textbox.AnchorPoint = Vector2.new(0, 0)
textbox.TextScaled = true
textbox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
textbox.PlaceholderText = "Type your message here..."
textbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
textbox.ClearTextOnFocus = false
textbox.TextWrapped = true
textbox.BorderSizePixel = 0

local textboxCorner = Instance.new("UICorner")
textboxCorner.CornerRadius = UDim.new(0, 6)
textboxCorner.Parent = textbox

-- Send button
local sendButton = Instance.new("TextButton")
sendButton.Name = "SendButton"
sendButton.Parent = frame
sendButton.Size = UDim2.new(0.4, 0, 0.15, 0)
sendButton.Position = UDim2.new(0.3, 0, 0.85, 0)
sendButton.Text = "Send"
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton.TextSize = 14
sendButton.Font = Enum.Font.GothamBold
sendButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
sendButton.BorderSizePixel = 0

local sendButtonCorner = Instance.new("UICorner")
sendButtonCorner.CornerRadius = UDim.new(0, 6)
sendButtonCorner.Parent = sendButton

-- Button hover effects
sendButton.MouseEnter:Connect(function()
    sendButton.BackgroundColor3 = Color3.fromRGB(90, 150, 220)
end)

sendButton.MouseLeave:Connect(function()
    sendButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
end)

-- Send functionality
local function sendMessage()
    local message = textbox.Text
    if message and message ~= "" then
        chat("三"..convert(message))
        textbox.Text = ""
    end
end

sendButton.MouseButton1Click:Connect(sendMessage)
textbox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        sendMessage()
    end
end)

-- Chat message processing
local function processMessage(msg)
    wait(0.5) -- Give time for the message to fully load
    
    if msg:IsA("TextLabel") and msg.Text:match("三") then
        msg.TextColor3 = Color3.new(1, 0.85, 0) -- Gold color for bypassed messages
        local processed = unconvert(msg.Text:gsub("三", ""))
        msg.Text = processed
    end
end

-- Hook into both regular chat and bubble chat
player.PlayerGui:WaitForChild("Chat").Frame.ChatChannelParentFrame.Frame_MessageLogDisplay.Scroller.ChildAdded:Connect(function(child)
    if child:IsA("Frame") and child:FindFirstChild("TextLabel") then
        processMessage(child.TextLabel)
    end
end)

if game:GetService("CoreGui"):FindFirstChild("BubbleChat") then
    game:GetService("CoreGui").BubbleChat.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("TextLabel") then
            processMessage(descendant)
        end
    end)
end