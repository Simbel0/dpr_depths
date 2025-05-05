local Depths_6, super = Class(Map)

function Depths_6:onEnter()
    super.onEnter(self)

    if Game:getFlag("depths_stalac_assault") then
        Game.world:setBattle(true)
    end

    self.timer:every(0.5, function()
        if Game.world:inBattle() then
            for i=1,3 do
                Game.world:spawnBullet("dark_stalactite", Utils.random(Game.world.player.x-SCREEN_WIDTH/4, Game.world.player.x+SCREEN_WIDTH), Utils.random(770, 880), Utils.random(0.2, 0.6), i==1)
            end
        end
    end)

    if Game:getFlag("depths_intro_done") then
        if not Game:getFlag("depths_stalac_after_pos") then
            Game:setFlag("depths_stalac_after_pos", {})
        end

        for i=1,50 do
            local x, y
            local pos = Game:getFlag("depths_stalac_after_pos", {})
            if pos[i] then
                x = pos[i][1]
                y = pos[i][2]
            else
                x = Utils.random(840, 1055)
                y = Utils.random(240, 345)
                Game.flags["depths_stalac_after_pos"][i] = {x, y}
            end
            local sp = Sprite("bullets/stalac_debris", x, y)
            sp.layer = WORLD_LAYERS["bullets"]
            sp:setScale(2)
            sp:setOrigin(0.5)
            Game.world:addChild(sp)
        end
    end
end

return Depths_6