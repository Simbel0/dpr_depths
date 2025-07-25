local Dummy, super = Class(EnemyBattler)

function Dummy:init()
    super.init(self)

    -- Enemy name
    self.name = ""
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("dark_lump")
    self:setAnimation("idle")

    self:addFX(OutlineFX({57/255, 28/255, 53/255}))

    -- Enemy health
    self.max_health = Utils.random(-200, 10000)
    self.health = Utils.random(-200, 10000)
    -- Enemy attack (determines bullet damage)
    self.attack = 10
    -- Enemy defense (usually 0)
    self.defense = 0
    -- Enemy reward
    self.money = 0

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 0

    self.tired_percentage = -1

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "basic",
        "aiming",
        "movingarena"
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "Do know me?"
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "It cries out what it can't remember."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* ...",
        "* ???",
        "* !!!",
    }

    -- Register act called "Smile"
    self:registerAct("Smile", "It's fine")
    -- Register party act with Ralsei called "Tell Story"
    -- (second argument is description, usually empty)

    local battlers = {}
    for i,v in ipairs(Game.battle.party) do
        if i > 1 then
            table.insert(battlers, v.chara.id)
        end
    end

    self:registerAct("SmileX", "We love\nyou", battlers)
end

function Dummy:onAct(battler, name)
    if name == "Smile" then
        self:addMercy(40)
        return "* You smile.[wait:5]\n* "..self.name.." likes it."

    elseif name == "SmileX" then
        for _, enemy in ipairs(Game.battle.enemies) do
            enemy:addMercy(40*#Game.battle.party)
        end
        return "* Everyone smiled at the enemies![wait:5]\n* They feel more at ease..."

    elseif name == "Standard" then --X-Action
        self:addMercy(20)
        return "* "..battler.chara:getName().." smiled without much understanding."
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

function Dummy:onSpareable()
    super.onSpareable(self)

    self.name = "Unknown"

    self.text = {
        "* It doesn't remember but is ready to accept it."
    }

    self.dialogue = {
        "Thank you."
    }
end

function Dummy:onDefeat(damage, battler)
    self:onDefeatFatal(damage, battler)
end

return Dummy