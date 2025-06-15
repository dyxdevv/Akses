local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        
        humanoid.Health = 0 -- Kills the player immediately
        
        -- Display the ban message
        game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(
            string.upper(
                "You were kicked from this game: Exploiting is a bannable offense. "..
                "This action log has been submitted to ROBLOX.\n\n"..
                "(Error Code: 267)"
            )
        )
        
        -- Disconnect the player after a short delay
        delay(2, function()
            player:Kick(string.upper(
                "You were kicked from this game: Exploiting is a bannable offense. "..
                "This action log has been submitted to ROBLOX.\n\n"..
                "(Error Code: 267)"
            ))
        end)
    end)
end

-- Connect for existing and new players
game.Players.PlayerAdded:Connect(onPlayerAdded)
for _, player in ipairs(game.Players:GetPlayers()) do
    onPlayerAdded(player)
end