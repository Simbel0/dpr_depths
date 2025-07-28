local ArenaSpike, super = Class(Bullet)

function ArenaSpike:init(x, y, dir, size)
    -- Last argument = sprite path
    super.init(self, x, y)

    self.dir = dir

    self.spike_size = 0

    self.collider = ColliderGroup(self, {
        CircleCollider(self, 0, 0, 2),
        PolygonCollider(self, {
            {0, 0.5},
            {0, -0.5},
            {self.spike_size, 0}
        })
    })
    self.debug_rect = {0, 0, 10, 10}

    self.siner = Utils.random(100)

    self.destroy_on_hit = false
end

function ArenaSpike:update()
    -- For more complicated bullet behaviours, code here gets called every update
    self.siner = self.siner + DTMULT
    super.update(self)
end

function ArenaSpike:draw()
    local r, g, b = unpack{0, 0.75, 0}
    Draw.setColor(r, g, b, self.alpha)
    love.graphics.circle("fill", 0, 0, 5)

    self.spike_size = Utils.ease(0, 60, math.abs(math.sin(self.siner*0.05)), "inOutQuad") --Utils.wave(math.sin(self.siner*0.2), 0, 60)
    self.collider.colliders[2].points[3][1] = self.dir == "left" and math.max(self.spike_size - 12, 0) or math.min(60, -self.spike_size + 12)

    local spike_x = self.spike_size
    if self.dir == "right" then
        spike_x = -spike_x
    end

    love.graphics.polygon("fill",
         0,5,
         0,-5,
         spike_x,0
    )

    super.draw(self)
end

return ArenaSpike