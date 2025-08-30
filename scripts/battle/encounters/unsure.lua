local Dummy, super = Class(Encounter)

function Dummy:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* Don't come closer please."

    -- Battle music ("battle" is rude buster)
    self.music = "amalgam"
    -- Enables the purple grid battle background
    self.background = true

    -- Add the dummy enemy to the encounter
    self.enemy = self:addEnemy("unsure")
    self.track_hps = {}

    --- Uncomment this line to add another!
    --self:addEnemy("dummy")
end

function Dummy:onStateChange(old, new)
    if new == "DEFENDING" then
        for i,battler in ipairs(Game.battle.party) do
            self.track_hps[battler.chara.id] = battler.chara.health
        end
    end
end

function Dummy:createSoul(...)
    local soul = super.createSoul(self, ...)
    soul.onDamage = function(selfb, bullet, dmg)
        if dmg > 0 and self.enemy.bear_mode == "night" then
            local amount = 25
            for id,health in pairs(self.track_hps) do
                if health~=Game.battle:getPartyBattler(id).chara.health and health-dmg <= 0 then
                    amount = 100
                    break
                end
            end
            self.enemy:addMercy(amount)
        end
    end
    return soul
end

return Dummy