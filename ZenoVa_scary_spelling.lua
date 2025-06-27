--[[ Don't stole my code and adding your credit, atleast use my credit and You're good]]--
--[[ idk if legit glitched and made into instant ]]--
local plrs = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local selectedMode = "normal" -- change ur mode here


local words = {
    "taco",
    "icecream",
    "roblox",
    "stop",
    "butter",
    "astronomy",
    "Archeologist",
    "basketball",
    "trophy",
    "fjord",
    "breeze",
    "obby",
    "sunflower",
    "sandcastle",
    "donkey",
    "soccer",
    "tunnel",
    "mountain",
    "goldfish",
    "investigator",
    "paleontology",
    "killerwin",
    "home",
    "sand",
    "bell",
    "egg",
    "prank",
    "puzzle",
    "finger",
    "popcorn",
    "kangaroo",
    "umbrella",
    "volcanoes",
    "architecture",
    "adaptation",
    "winner",
    "goat",
    "lamp",
    "cloud",
    "hat",
    "nest",
    "yt",
    "sweater",
    "hunger",
    "pencil",
    "basket",
    "campfire",
    "lighthouse",
    "strawberry",
    "cornfield",
    "hedgehog",
    "mathematics",
    "civilization",
    "receipt",
    "ball",
    "pink",
    "rock",
    "cup",
    "mastermind",
    "happy",
    "cookie",
    "peanut",
    "family",
    "sunflower",
    "teacup",
    "treasure",
    "meteorology",
    "determination",
    "apple",
    "sock",
    "bag",
    "nuke",
    "special",
    "kite",
    "bed",
    "eat",
    "corn",
    "blue",
    "lava",
    "picnic",
    "shadow",
    "power",
    "jungle",
    "ladder",
    "snowflake",
    "chimney",
    "genius",
    "responsibility",
    "electricity",
    "creativity",
    "investigator",
    "deoxyribonucleic",
    "temperamental",
    "heterogeneous",
    "bureaucracy",
    "note",
    "bread",
    "window",
    "castle",
    "railroad",
    "scissors",
    "courage",
    "innovation",
    "exploration",
    "sun",
    "moon",
    "red",
    "bird",
    "simulator",
    "google",
    "chair",
    "purple",
    "butterfly",
    "pancakes",
    "dinosaur",
    "microscope",
    "engineering",
    "surveillance",
    "sagacious",
    "perfidious",
    "dog",
    "cake",
    "carrot",
    "rabbit",
    "yellow",
    "squirrel",
    "university",
    "landscape",
    "environment",
    "gauge",
    "box",
    "frog",
    "train",
    "rocket",
    "banana",
    "toothbrush",
    "carousel",
    "spectacular",
    "nonchalant",
    "handkerchief",
    "pet",
    "drum",
    "pizza",
    "bottle",
    "handshake",
    "skyscraper",
    "giraffe",
    "sustainability",
    "cytokinesis",
    "pot",
    "car",
    "book",
    "feather",
    "philosopher",
    "serendipity",
    "myriad",
    "rain",
    "cat",
    "green",
    "horror",
    "pineapple",
    "birthday",
    "technology",
    "unconstitutional",
    "parliamentary",
    "hot",
    "duck",
    "orange",
    "porcupine",
    "chat",
    "boat",
    "garden",
    "turtle",
    "friendship",
    "jellyfish",
    "flashlight",
    "enthusiasm",
    "discombobulate",
    "dragonfly",
    "look",
    "blanket",
    "snowstorm",
"adaptation",
"adventure",
"apple",
"architecture",
"bag",
"ball",
"banana",
"basket",
"bed",
"bell",
"big",
"bird",
"birthday",
"blanket",
"blue",
"blueberry",
"boat",
"box",
"bread",
"breeze",
"butterfly",
"button",
"cake",
"campfire",
"car",
"carousel",
"cartography",
"castle",
"cat",
"chair",
"chat",
"chimney",
"civilization",
"clock",
"cloud",
"cold",
"cookie",
"corn",
"cornfield",
"courage",
"cow",
"creativity",
"cup",
"determination",
"dinosaur",
"discombobulate",
"dog",
"donkey",
"dragonfly",
"drum",
"duck",
"eat",
"egg",
"electricity",
"encyclopedia",
"engineering",
"enthusiasm",
"environment",
"exploration",
"extemporaneous",
"family",
"fan",
"fast",
"feather",
"finger",
"fish",
"flag",
"flashlight",
"freeze",
"friend",
"friendship",
"frog",
"fun",
"garden",
"gauge",
"waterfall",
"genius",
"giraffe",
"goat",
"goldfish",
"google",
"grape",
"green",
"hamburger",
"handkerchief",
"handshake",
"happy",
"hat",
"hedgehog",
"heterogeneous",
"home",
"horror",
"hot",
"hunger",
"icecream",
"incongruous",
"innovation",
"investigator",
"jellyfish",
"juxtaposition",
"jungle",
"kaleidoscope",
"kangaroo",
"killerwin",
"kite",
"ladder",
"lamp",
"landscape",
"lava",
"leaf",
"Letter",
"light",
"lighthouse",
"spectacular",
"look",
"mastermind",
"mathematics",
"meteorology",
"microscope",
"milk",
"moon",
"mountain",
"myriad",
"nest",
"nightmare",
"note",
"notebook",
"nuke",
"obby",
"orange",
"paleontology",
"pancakes",
"parachute",
"peanut",
"pencil",
"perfidious",
"pet",
"phenomenon",
"philosopher",
"picnic",
"pink",
"pizza",
"pot",
"power",
"prank",
"practice",
"prehistoric",
"purple",
"puzzle",
"quintessential",
"rabbit",
"railroad",
"rain",
"receipt",
"red",
"rejuvenate",
"revolution",
"rhythm",
"rocket",
"rock",
"sagacious",
"sand",
"sandcastle",
"scissors",
"serendipity",
"shadow",
"shoe",
"simulator",
"skyscraper",
"snowflake",
"snowstorm",
"sock",
"soccer",
"special",
"spectacular",
"squirrel",
"star",
"stop",
"strawberry",
"summer",
"sun",
"sunflower",
"surveillance",
"sweater",
"taco",
"teacup",
"technology",
"temperamental",
"toothbrush",
"toy",
"train",
"treasure",
"tree",
"treetop",
"troll",
"trophy",
"tunnel",
"turtle",
"ubiquitous",
"umbrella",
"university",
"volcanoes",
"window",
"winner",
"key",
"yellow",
"steam",
"youtube",
"honeycomb",
"achievement",
"tantamount", 
"sagacious",
"kaleidoscope",
"forest",
"hydroelectric",
"pen"
}

local uniqueWords = {}
local filteredWords = {}

for _, word in pairs(words) do
    local lowerWord = word:lower()
    if not uniqueWords[lowerWord] then
        table.insert(filteredWords, word)
        uniqueWords[lowerWord] = true
    end
end
words = filteredWords --[[ ← ugly filter ]]--
local function teller()
    local p = plrs.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "teller"
    gui.ResetOnSpawn = false
    gui.Parent = p.PlayerGui    

    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, 100, 0, 75)  -- Setengah dari ukuran sebelumnya
    f.Position = UDim2.new(0.5, -150, 0.2, -125) -- Adjusted position to center
    f.BackgroundColor3 = Color3.fromRGB(40,40,40)
    f.BackgroundTransparency = 0.2
    f.BorderSizePixel = 2
    f.Active = true
    f.Draggable = true
    f.Parent = gui    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = f  
    local handle = Instance.new("Frame") 
    handle.Size = UDim2.new(1,0,0,25)
    handle.Position = UDim2.new(0,0,0,0)
    handle.BackgroundColor3 = Color3.fromRGB(30,30,30)
    handle.BackgroundTransparency = 0
    handle.BorderSizePixel = 0
    handle.Parent = f    
    local handle_corner = Instance.new("UICorner")
    handle_corner.CornerRadius = UDim.new(0,10)
    handle_corner.Parent = handle    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,1,0)
    title.BackgroundTransparency = 1
    title.Text = "ZenoVa | helper" --[[ Change your helper name here ]]--
    title.TextColor3 = Color3.fromRGB(255,255,255) 
    title.TextSize = 14 -- change ur size if u r bilnd
    title.Font = Enum.Font.SourceSansBold
    title.Parent = handle    
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(1, -20, 0, 30)
    buttonContainer.Position = UDim2.new(0, 10, 0.85, -5)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = f
    local function createModeButton(text, position, mode)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.3, 0, 1, 0)
        button.Position = position
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 12
        button.Font = Enum.Font.SourceSansBold
        button.Parent = buttonContainer
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 5)
        buttonCorner.Parent = button
        
        button.MouseButton1Click:Connect(function()
            selectedMode = mode
            -- color (u can custom this)
            for _, btn in ipairs(buttonContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                end
            end
            button.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        end)
    end

    createModeButton("Normal", UDim2.new(0, 0, 0, 0), "normal")
    createModeButton("Legit", UDim2.new(0.35, 0, 0, 0), "legit")
    createModeButton("Instant", UDim2.new(0.7, 0, 0, 0), "instant")

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1,-20,0.5,0)
    txt.Position = UDim2.new(0,10,0.25,0) 
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.fromRGB(255,255,255)
    txt.TextSize = 24
    txt.Font = Enum.Font.SourceSansBold
    txt.Parent = f
    txt.TextWrapped = true    

    local shadow = Instance.new("Frame")
    shadow.Size = f.Size + UDim2.new(0,4,0,4)
    shadow.Position = UDim2.new(0,-2,0,-2)
    shadow.BackgroundColor3 = Color3.new(0,0,0)
    shadow.BackgroundTransparency = 0.7
    shadow.ZIndex = f.ZIndex - 1
    shadow.Parent = f    

    local shadow_corner = Instance.new("UICorner")
    shadow_corner.CornerRadius = UDim.new(0,12)
    shadow_corner.Parent = shadow    

    return txt
end

local isTyping = false
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function sendGradualInput(word)
    if isTyping then return end
    isTyping = true
    -- safety handled
    local args = { [1] = "updateAnswer", [2] = word }
    ReplicatedStorage:WaitForChild("Events"):WaitForChild("GameEvent"):FireServer(unpack(args))
    local typingText = workspace.Map.Functional.Screen.SurfaceGui.MainFrame.MainGameContainer.MainTxtContainer:WaitForChild("TypingText")
    local playerText = workspace.Map.Functional.Screen.SurfaceGui.MainFrame.MainGameContainer.MainTxtContainer:WaitForChild("PlayerText")
    local startIndex = #typingText.Text + 1
    
    -- Check if it local player turn (glitches)
    if playerText.Text == Players.LocalPlayer.Name then
        for i = startIndex, #word do
            local currentPart = word:sub(1, i)
            local args = { [1] = "updateAnswer", [2] = currentPart }
            ReplicatedStorage:WaitForChild("Events"):WaitForChild("GameEvent"):FireServer(unpack(args))
            -- Update board text for visual feedback
            typingText.Text = currentPart
            task.wait(0.2)
        end
    else
        for i = startIndex, #word do
            local currentPart = word:sub(1, i)
            local args = { [1] = "updateAnswer", [2] = currentPart }
            ReplicatedStorage:WaitForChild("Events"):WaitForChild("GameEvent"):FireServer(unpack(args))
            task.wait(0.2)
        end
    end
    
    local args = { [1] = "submitAnswer", [2] = word }
    ReplicatedStorage:WaitForChild("Events"):WaitForChild("GameEvent"):FireServer(unpack(args))
    isTyping = false
end

local wordLabel = teller()

local function updateSuggestions(inputText)
    local currentText = inputText:lower():gsub("%s+", "")
    
    if currentText == "" then
        wordLabel.Text = "Type something plz"
        return
    end

    local matches = {}
    for _, word in ipairs(words) do
        if word:lower():sub(1, #currentText) == currentText then
            table.insert(matches, word)
        end
    end

    local playerText = workspace.Map.Functional.Screen.SurfaceGui.MainFrame.MainGameContainer.MainTxtContainer:WaitForChild("PlayerText")
    local isLocalPlayerTurn = (playerText.Text == Players.LocalPlayer.Name)

    if #matches == 1 then
        local word = matches[1]
        if selectedMode == "instant" then
            local args = { [1] = "updateAnswer", [2] = word }
            ReplicatedStorage:WaitForChild("Events"):WaitForChild("GameEvent"):FireServer(unpack(args))
            task.wait(0.1)
            args = { [1] = "submitAnswer", [2] = word }
            ReplicatedStorage:WaitForChild("Events"):WaitForChild("GameEvent"):FireServer(unpack(args))
            wordLabel.Text = "✔️ Answered: " .. word
        elseif selectedMode == "legit" and not isTyping then
            task.spawn(function()
                sendGradualInput(word)
            end)
            wordLabel.Text = isLocalPlayerTurn and "🔄 Typing: " .. word or "🔄 Typing: " .. word
        else -- normal
            wordLabel.Text = "Found: " .. word
        end
    elseif #matches > 1 then
        table.sort(matches)
        wordLabel.Text = table.concat(matches, "\n")
    else
        wordLabel.Text = "idk, add this word to my table plz"
    end
end

local typingText = workspace.Map.Functional.Screen.SurfaceGui.MainFrame.MainGameContainer.MainTxtContainer:WaitForChild("TypingText")

typingText:GetPropertyChangedSignal("Text"):Connect(function()
    updateSuggestions(typingText.Text)
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Open Source",
    Text = "Helper: Sometimes i can be wrong sorry :<"
})
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Just want tell you",
    Text = "Normal mode only show the word. Thanks"
})