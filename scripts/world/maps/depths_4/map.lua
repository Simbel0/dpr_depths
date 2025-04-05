local Depths_4, super = Class(Map)

function Depths_4:onEnter()
    super.onEnter(self)

    if Game:getFlag("depths_stalac_assault") then
        Game.world:setBattle(true)
        Game.world.music:play("creepychase")
    end

    self.timer:every(0.5, function()
        if Game.world:inBattle() then
            for i=1,3 do
                Game.world:spawnBullet("dark_stalactite", Utils.random(Game.world.player.x-SCREEN_WIDTH/4, Game.world.player.x+SCREEN_WIDTH), Utils.random(770, 880), Utils.random(0.2, 0.6), i==1)
            end
        end
    end)
end

return Depths_4