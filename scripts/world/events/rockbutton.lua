local RockButton, super = Class(Event)

function RockButton:init(data)
    data = data or {}
    super.init(self, data)

    local properties = data.properties or {}

    self.controller = nil

    self.cutscene = properties["cutscene"] or "rockbuttons.default"

    self:setSprite("world/events/rock_tumor")
    self.sprite:setFrame(self:getFlag("activated", false) and 2 or 1)
end

function RockButton:setController(controller)
    self.controller = controller
end

function RockButton:activate()
    self:setFlag("activated", true)
    self.sprite:setFrame(2)
end

function RockButton:onInteract(player, dir)
    Game.world:startCutscene(self.cutscene, player, self, self.controller and self.controller.flag or nil)
    return true
end

return RockButton