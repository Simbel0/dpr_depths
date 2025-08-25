local RockButton, super = Class(Event)

function RockButton:init(data)
    data = data or {}
    super.init(self, data)

    local properties = data.properties or {}
    self.world_id = data.id

    self.controller = nil

    self.cutscene = properties["cutscene"] or "rockbuttons.default"

    self:setSprite("world/events/rock_tumor")

    self.solid = true
    self:setHitbox(0, self.height/2, self.width, self.height/2)
end

function RockButton:onLoad()
    print("onLoad", self.world_id, self:isActivated())
    self.sprite:setFrame(self:isActivated() and 2 or 1)
end

function RockButton:getDebugInfo()
    local info = super.getDebugInfo(self)
    table.insert(info, "Controller: "..(self.controller and Utils.getClassName(self.controller) or "nil"))
    table.insert(info, "Activated: "..self:isActivated())
    table.insert(info, "Cutscene: "..self.cutscene)
    return info
end

function RockButton:setController(controller)
    self.controller = controller
    print("setController", self.world_id, self:isActivated())
    if self.controller and self:isActivated() then
        print(self.world_id, "increases flag")
        Game:addFlag(self.controller.flag)
    end
end

function RockButton:activate()
    print("activate", self.world_id, "activate button")
    if self.controller then
        Game:addFlag(self.controller.flag)
    end
    self:setFlag("activated", true)
    self.sprite:setFrame(2)
end

function RockButton:isActivated()
    return self:getFlag("activated", false)
end

function RockButton:onInteract(player, dir)
    print("onInteract", self.world_id, self.controller and Game:getFlag(self.controller.flag, -1) or "no controller")
    if self:isActivated() then return true end
    Game.world:startCutscene(self.cutscene, player, self, self.controller and self.controller.flag or nil)
    return true
end

return RockButton