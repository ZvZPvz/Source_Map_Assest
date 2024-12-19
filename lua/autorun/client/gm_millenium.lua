if game.GetMap() != "gm_millenium" then return end
hook.Add("InitPostEntity", "gm_millenium_player_initialize", function( ply, cmd )
    if string.match(GetConVar("gmod_language"):GetString(), "zh") then
        net.Start("zh")
        net.WriteBool(true)
        net.SendToServer()
    else
        net.Start("zh")
        net.WriteBool(false)
        net.SendToServer()
    end
end)

local haloEntities = {}

net.Receive("train_color", function()
    local ent = net.ReadEntity()
    local color = net.ReadColor()

    if IsValid(ent) then
        haloEntities[ent] = color
    end
end)

hook.Add("PreDrawHalos", "AddShieldHalos", function()
    for ent, color in pairs(haloEntities) do
        if IsValid(ent) then
            halo.Add({ent}, color, 50, 50, 2)
        else
            haloEntities[ent] = nil
        end
    end
end)