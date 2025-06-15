game.Players.PlayerAdded:Connect(function(player)
    player:Kick(string.upper(
        "YOU WERE KICKED FROM THIS GAME: EXPLOITING IS A BANNABLE OFFENSE. "..
        "THIS ACTION LOG HAS BEEN SUBMITTED TO ROBLOX.\n\n"..
        "(ERROR CODE: 267)"
    ))
end)