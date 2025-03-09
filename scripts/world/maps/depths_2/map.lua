local Depths_2, super = Class(Map)

function Depths_2:onEnter()
    super.onEnter(self)

    self:updatePuzzleState()
end

function Depths_2:updatePuzzleState()
    if Game:getFlag("eyes_puzzle_solved") then
        self:getTileLayer("eyes_dark").tile_opacity = 1
        self:getTileLayer("eyes_clear").tile_opacity = 0

        for i,magical_glass in ipairs(Game.world.map:getEvents("sprite")) do
            magical_glass.visible = true
        end

        self:getHitbox("temp").collidable = false
    else
        self:getTileLayer("eyes_dark").tile_opacity = 0
        self:getTileLayer("eyes_clear").tile_opacity = 1

        for i,magical_glass in ipairs(Game.world.map:getEvents("sprite")) do
            magical_glass.visible = false
        end

        self:getHitbox("temp").collidable = true
    end
    self:getTileLayer("eyes_dark").drawn = false
    self:getTileLayer("eyes_clear").drawn = false
end

return Depths_2