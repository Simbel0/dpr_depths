local ArenaJourney, super = Class(Wave)

function ArenaJourney:init(...)
    super.init(self, ...)

    self:setArenaSize(142, 142)
    self:setArenaPosition(SCREEN_WIDTH/2, 142/2)

    self.time = -1

    self.dir_weight = 0
end

function ArenaJourney:onStart()
    local y = (142/2)+30

    while y < SCREEN_WIDTH-64 do
        local x = (Utils.random()+self.dir_weight)<0.5 and Game.battle.arena.left or Game.battle.arena.right

        local dir = x < SCREEN_WIDTH/2 and "left" or "right"

        if dir == "left" then
            self.dir_weight = self.dir_weight + 0.05
        else
            self.dir_weight = self.dir_weight - 0.05
        end

        local bullet = self:spawnBullet("lump/arenaspikeretract", x, y, dir)

        bullet:addFX(MaskFX(Game.battle.arena), "arena_mask")

        y = y + Utils.random(34, 64)
    end

    Game.battle.arena:setPhysics({
        speed_y = 0.1,
        friction = -0.007
    })
end

function ArenaJourney:update()
    -- Code here gets called every frame

    if Game.battle.arena.y > SCREEN_WIDTH-(Game.battle.arena.height+64+15) then
        self.finished = true
    end

    super.update(self)
end

return ArenaJourney