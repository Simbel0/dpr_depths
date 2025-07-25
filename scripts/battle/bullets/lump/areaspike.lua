local ArenaSpike, super = Class(Bullet)

function ArenaSpike:init(x, y, dir)
    -- Last argument = sprite path
    super.init(self, x, y)

    self.dir = dir

    self.start_x = 5

    self.collider = ColliderGroup(self, {
        CircleCollider(self, 0, 0, 3),
        PolygonCollider(self, {
            {0, 2.5},
            {0, -2.5},
            {0, 0}
        })
    })
    self.debug_rect = {0, 0, 10, 10}

    self.bullet_timer = 0

    self.destroy_on_hit = false

    self.shoot_spike = false
    self.spike_size = 0
end

function ArenaSpike:update()
    -- For more complicated bullet behaviours, code here gets called every update
    self.bullet_timer = self.bullet_timer + 0.3*DTMULT
    super.update(self)

    if self.bullet_timer >= self.start_x + 1 and not self.shoot_spike then
        self.shoot_spike = true
        Assets.playSound("bigcut")
    end

    if self.bullet_timer >= self.start_x + 3 and self.graphics.fade_callback == nil then
        self:fadeOutAndRemove()
    end

    if self.alpha < 0.75 then
        self.collidable = false
    end
end

function ArenaSpike:draw()
    super.draw(self)

    local r, g, b = unpack{0, 0.75, 0}
    Draw.setColor(r, g, b, self.alpha)
    love.graphics.circle("fill", self.dir == "left" and math.min(-self.start_x+self.bullet_timer, 0) or math.max(self.start_x-self.bullet_timer, 0), 0, 5)

    if self.shoot_spike then
        self.spike_size = math.min(self.spike_size + 5*DTMULT, 60)
        self.collider.colliders[2].points[3][1] = self.dir == "left" and math.max(self.spike_size - 2, 0) or math.min(60, -self.spike_size + 2)

        local spike_x = self.spike_size
        if self.dir == "right" then
            spike_x = -spike_x
        end

        love.graphics.polygon("fill",
             0,5,
             0,-5,
             spike_x,0
        )
    end
end

return ArenaSpike