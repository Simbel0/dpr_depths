local Depths_7, super = Class(Map)

function Depths_7:onEnter()
    super.onEnter(self)

    if Game:getFlag("depths_intro_done") and not Game:getFlag("depths_starry_in_party") then
        Game.world:spawnNPC("starry", 515, 505, {cutscene = "starry_npc.depths_7"})
    end
end

return Depths_7