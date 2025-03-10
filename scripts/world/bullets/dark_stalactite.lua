local Stalactite, super = Class(WorldBullet)

function Stalactite:init(x, y, gravity, play_sound)
    super.init(self, x, y-SCREEN_HEIGHT+10, "bullets/stalac")
    self:setOrigin(0.5, 1)
    self.dest_y = y

    self.physics.gravity = gravity or 0.3

    self.damage = 20

    self.outline = self:addFX(OutlineFX())

    self.play_sound = play_sound

    self.ellipse = Ellipse(self.x, self.dest_y, 15, 7.5)
    self.ellipse.alpha = 0
    self.ellipse:setLayer(Game.world.player:getLayer())
    Game.world:addChild(self.ellipse)
end

function Stalactite:onAddToStage(stage)
    if self.play_sound then
        Assets.playSound("ui_cancel")
    end
end

function Stalactite:onRemove(parent)
    self.ellipse:remove()
end

function Stalactite:update()
    if Game.world:inBattle() and self.outline.color[4] < 1 then
        self.outline.color[4] = self.outline.color[4] + (0.08 * DTMULT)
    elseif not Game.world:inBattle() and self.outline.color[4] > 0 then
        self.outline.color[4] = self.outline.color[4] - (0.08 * DTMULT)
    end

    self.ellipse.alpha = Utils.clampMap(self.y, self.init_y, self.dest_y, 0, 0.5)

    if self.y >= self.dest_y then
        self:remove()
        Assets.playSound("shakerbreaker")
    end
    super.update(self)
end

return Stalactite