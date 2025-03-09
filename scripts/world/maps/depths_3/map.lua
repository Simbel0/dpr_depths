local Depths_3, super = Class(Map)

function Depths_3:onEnter()
    super.onEnter(self)

    if Game:getFlag("depths_savepoint_custcene_seen") then
        local sx, sy = Game.world:getEvent(1):getPosition()
        sx = sx + Game.world:getEvent(1).width
        sy = sy + Game.world:getEvent(1).height
        local slayer = Game.world:getEvent(1):getLayer()
        Game.world:getEvent(1):remove()
        local sp = Game.world:addChild(Savepoint(sx, sy, {text="* The devasted darkness looms above you.[wait:4] You are filled with a strange power."}))
        sp:setLayer(slayer)
    end

    if not self:getFlag("seen_starry") then
        self.starry = Sprite("npcs/starry/look_eyes", 1390, 127)
        self.starry:pause()
        self.starry.layer = WORLD_LAYERS["top"]
        Game.world:addChild(self.starry)
    end
end

function Depths_3:update()
    super.update(self)
    if not self:getFlag("seen_starry") and self.starry then
        if Game.world.camera.x+Game.world.camera.width/2 > self.starry.x then
            self:setFlag("seen_starry", true)
            self.starry:play(nil, false, function(self) self:remove() end)
        end
    end
end

return Depths_3