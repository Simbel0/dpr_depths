local RockToggleController, super = Class(ToggleController, "rocktoggle")

function RockToggleController:init(data)
    super.super.init(self)

    local properties = data.properties or {}

    self.flag = properties["flag"]

    self.buttons_ids = Utils.parsePropertyList("button", properties)

    self.target_objs = Utils.parsePropertyList("target", properties)
end

function RockToggleController:onLoad()
    self.targets = {}
    self.target_colliders = {}
    for _,obj in ipairs(self.target_objs) do
        local target = self.world.map:getEvent(obj.id)
        if target then
            table.insert(self.targets, target)
        else
            local collider_target = self.world.map:getHitbox(obj.id)
            if collider_target then
                table.insert(self.target_colliders, collider_target)
            end
        end
    end

    self.buttons = {}
    for i,obj in ipairs(self.buttons_ids) do
        local button = self.world.map:getEvent(obj.id)
        if button then
            table.insert(self.buttons, button)
            button:setController(self)
        end
    end

    if self.active then
        self:updateTargets()
    end
end

function RockToggleController:updateTargets()
    local flag = Game:getFlag(self.flag, 0)
    local success = (flag ~= nil and flag >= #self.buttons or false)
    --print(flag, #self.buttons, success)
    if success then
        for _,target in ipairs(self.targets) do
            target.active = true
            target.visible = true
            target.collidable = true
        end
        for _,target in ipairs(self.target_colliders) do
            target.collidable = false
        end

        for i,button in ipairs(self.buttons) do
            if button.sprite.frame ~= 2 then
                button.sprite:setFrame(2)
            end
        end
    else
        for _,target in ipairs(self.targets) do
            target.active = false
            target.visible = false
            target.collidable = false
        end
        for _,target in ipairs(self.target_colliders) do
            target.collidable = true
        end
    end
end

return RockToggleController