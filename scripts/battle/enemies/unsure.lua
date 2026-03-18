local Unsure, super = Class(EnemyBattler)

function Unsure:init()
    super.init(self)

    -- Enemy name
    self.name = "?????"
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
    self.defense = -500
    -- Enemy reward
    self.money = 0

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 0

    self.tired_percentage = 0.1

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "basic",
        "aiming",
        "movingarena",
        --"arenaafraid", -- Tentacle comes from the left. Each time it advances, the arena goes back as well (but slow enough for the tentacle to catch up)
        --"frontattack" -- unsure is on top of the arena
        --"faces" -- unsure sends circle-shaped bullets from the white hole in its head
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "..."
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "As strong as a bear, as fragile as an ant."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* Worry about it.",
        "* ????? raises its arms in self-defense.[wait:2]\nIt has none.",
        "* The ground is shaking.[wait:2] Or is it ??????",
        "* It growls like a bear.[wait:2]\n* Fight back.",
        "* It growls like a bear.[wait:2]\n* Lay low.",
        "* It growls like a bear.[wait:2]\n* Good night.",
        "* It growls like a bear.[wait:2]\n* Fight back.",
        "* It growls like a bear.[wait:2]\n* Lay low.",
        "* It growls like a bear.[wait:2]\n* Good night.",
        "* It protects                                                                           ?"
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* It feels crushed."
    self.tired_text = "* It doesn't feel anything."
    self.spareable_text = "* It feels unsure...[wait:2] That's the most certain it has ever been."

    self.bear_mode = ""

    self.approched = 0
    self.insult = 0
    self.hugged = false
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

function Unsure:getEncounterText()
    local text = super.getEncounterText(self)

    if text:lower():find("lay low") or self.health <= (self.max_health * self.low_health_percentage) then
        self.bear_mode = "lay"
    elseif text:lower():find("fight back") then
        self.bear_mode = "fight"
    elseif text:lower():find("good night") then
        self.bear_mode = "night"
    else
        self.bear_mode = ""
    end

    return text
end

function Unsure:onHurt(amount, battler)
    if self.bear_mode == "fight" then
        self:addMercy(25)
    end
    super.onHurt(self, amount, battler)
end

function Unsure:onAct(battler, name)
    if name == "Approach" then
        if self.hugged or self.mercy >= 100  or self.insult >= 5 then
            return "* But there was no need."
        end
        Game.battle.music.pitch = Game.battle.music.pitch + 0.1
        self.defense = self.defense - 50
        self.approched = self.approched + 1
        self:shake(self.approched, 0, 0, (1/30)/self.approched)
        if self.approched == 1 then
            return "* You slowly approch "..self.name..".[wait:2] It's shaking."
        elseif self.approched == 2 then
            return "* You approch "..self.name.." even more.[wait:2] It's shaking harder."
        elseif self.approched == 3 then
            return "* You get as close to "..self.name.." as can be.[wait:2] It's shaking so much."
        else
            local question = ""
            for i=1,self.approched do
                question = question.."?"
            end
            return "* Where are you going"..question
        end
    elseif name == "Nothing" then
        if self.hugged or self.mercy >= 100  or self.insult >= 5 then
            return "* The party does nothing."
        end
        if self.bear_mode == 'lay' then
            self:addMercy(35)
            return "* The party does nothing.[wait:2] "..self.name.." feels more relaxed."
        else
            self:addMercy(5)
            return "* The party does nothing.[wait:2] "..self.name.." stays vigilant."
        end
    elseif name == "Hug" then
        if self.hugged or self.mercy >= 100  or self.insult >= 5 then
            return "* But there was no need."
        end
        if self.approched < 3 then
            return "* You're too far,[wait:2] so far.[wait:2] It shakes just thinking about you."
        else
            Game.battle.music:pause()
            Game.battle.timer:afterCond(function()
                return not TableUtils.contains({"BATTLETEXT", "ACTIONS"}, Game.battle:getState())
            end, function()
                self:addMercy(99)
                self:stopShake()
                Game.battle.music:setPitch(1)
                Game.battle.music:resume()
                self.hugged = true
            end)
            return {
                "* You hug it against its will.[wait:2]\n* Well that's not very nice.",
                "* You tell it that everything will be alright.",
                "* You tell it that its pain,[wait:2] its fear,[wait:2] its uncertainness...",
                "* Soon,[wait:2] it will all be over.",
                "* You don't even understand why you said that.",
                "* But it calmed it,[wait:2] strangely."
            }
        end
    elseif name == "Insult" then
        self:addMercy(-5)
        self.insult = self.insult + 1
        if self.insult == 1 then
            return "* You insult it.[wait:2]\n* Such cruelty."
        elseif self.insult == 2 then
            return "* You insult it.[wait:2]\n* But why?"
        elseif self.insult == 3 then
            return "* You insult it.[wait:2]\n* It cries.[wait:10]\n* No it can't."
        elseif self.insult == 4 then
            return "* You insult it.[wait:2]\n* You insult it."
        elseif self.insult == 5 then
            return {"* You insult yourself.[wait:2] What kind of person are you?[wait:2] Why would you do this?", "* ...[wait:5]You didn't do that?"}
        elseif self.insult == 6 then
            self:setTired(true)
            return "* You insult it.[wait:2]\n* It doesn't feel a need to listen anymore."
        else
            return "* It falls on desperate ears."
        end
    elseif name == "Crush" then
        if self.hugged or self.mercy >= 100  or self.insult >= 5 then
            return "* But there was no need."
        end
        self.bear_mode = "night"
        self.attack = self.attack + 10
        self.defense = self.defense - 10
        return {
            "* You imitate the mouvement of crushing an ant.",
            "* It shakes in fear but growls back at you.[wait:2]\n* Good night."
        }
    elseif name == "Standard" then --X-Action
        -- Give the enemy 50% mercy
        -- self:addMercy(5)
        return "* But "..battler.chara:getName().." didn't know what to do."
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

function Unsure:onDefeat(damage, battler)
    self:onDefeatFatal(damage, battler)
end

function Unsure:spare()
    local anim = self.actor:getAnimation("transition")
    anim.frames = {"15-1"}
    anim.next = nil
    anim.callback = function() super.spare(self) end
    self:setAnimation(anim)
end

return Unsure