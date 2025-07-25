local AreaShot, super = Class(Wave)

function AreaShot:onStart()
    self.timer:everyInstant(0.3, function()
        local x = Utils.random()<0.5 and Game.battle.arena.left or Game.battle.arena.right
        local y = Utils.random(Game.battle.arena.top+10, Game.battle.arena.bottom-10)

        local dir = x < SCREEN_WIDTH/2 and "left" or "right"

        x, y = Game.battle:getRelativePos(x, y, Game.battle.arena.mask)

        local bullet = self:spawnBulletTo(Game.battle.arena.mask, "lump/areaspike", x, y, dir)
    end)
end

function AreaShot:update()
    -- Code here gets called every frame

    super.update(self)
end

return AreaShot