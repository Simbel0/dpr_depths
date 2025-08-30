local Dummy, super = Class(EnemyBattler)

function Dummy:init()
    super.init(self)

    -- Enemy name
    self.name = "?????"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("unsure")

    self:setAnimation("transition")
    self.width = 70
    self.height = 70

    -- Enemy health
    self.max_health = 9999
    self.health = 9999
    -- Enemy attack (determines bullet damage)
    self.attack = 10
    -- Enemy defense (usually 0)
    self.defense = -1000
    -- Enemy reward
    self.money = 0

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 0

    self.tired_percentage = 0.1

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "basic",
        "aiming",
        "movingarena"
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "..."
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "Looks as strong as it is fragile."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* Worry about it.",
        "* ????? raises its arms in self-defense.[wait:5]\nIt has none.",
        "* The ground is shaking. Or is it ??????",
        "* It growls like a bear.\n* Fight back.",
        "* It growls like a bear.\n* Lay low.",
        "* It growls like a bear.\n* Good night.",
        "* It protects                                                                           ?"
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* It feels crushed."

    self.bear_mode = ""

    
    self:registerAct("Approach")
    self:registerAct("Hug")
    self:registerAct("Insult")
    self:registerAct("Crush")
    local party = {}
    for i,v in ipairs(Game.battle.party) do
        table.insert(party, v.chara.id)
    end
    self:registerAct("Nothing", nil, party, 1)
end

function Dummy:getEncounterText()
    local text = super.getEncounterText(self)

    if text:lower():find("fight back") then
        self.bear_mode = "fight"
    elseif text:lower():find("lay low") then
        self.bear_mode = "lay"
    elseif text:lower():find("good night") then
        self.bear_mode = "night"
    else
        self.bear_mode = ""
    end

    return text
end

function Dummy:onHurt(amount, battler)
    if self.bear_mode == "fight" then
        self:addMercy(25)
    end
    super.onHurt(self, amount, battler)
end

function Dummy:onAct(battler, name)
    if name == "Nothing" then
        if self.bear_mode == 'lay' then
            self:addMercy(35)
            return "* The party does nothing. "..self.name.." feels more relaxed."
        else
            self:addMercy(5)
            return "* The party does nothing. "..self.name.." stays vigilant."
        end
    elseif name == "Standard" then --X-Action
        -- Give the enemy 50% mercy
        -- self:addMercy(5)
        return "* But "..battler.chara:getName().." doesn't know what to do."
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

function Dummy:onDefeat(damage, battler)
    self:onDefeatFatal(damage, battler)
end

return Dummy