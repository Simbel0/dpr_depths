function Mod:init()
    print("Loaded "..self.info.name.."!")

    --- Temporarily suspends execution of the cutscene script until multiple functions all return true.
    ---@param ... function Any amount of functions that returns a function for wait().
    ---@return any ... Any values passed into the adjacent Cutscene:resume(...) call. 
    Utils.hook(Cutscene, "waitMultiple", function(orig, self, ...)
        local waitholder = {...}
        self.wait_func = function()
            for i,wait in ipairs(waitholder) do
                if not wait() then
                    return false
                end
            end
            return true
        end

        return coroutine.yield()
    end)

    ---@param followerInParty bool
    Utils.hook(Game, "hasFollower", function(orig, self, chara)
        if isClass(chara) then
            chara = chara.actor.id
        end
        for i,v in ipairs(self.temp_followers) do
            if type(v) == "table" then
                if v[1] == chara then
                    return true
                end
            elseif v == chara then
                return true
            end
        end
        return false
    end)
end

function Mod:postLoad(dlc_swapping)
    if dlc_swapping and Game:getFlag("depths_intro_done") then
        Kristal.modswap_destination = {"depths_7", "warpbin"}
    end

    if Game:getFlag("depths_starry_in_party") and not Game:hasFollower("starry") then
        Game:addFollower("starry")
    end
end

function Mod:unload()
    if Game:getFlag("depths_starry_in_party") then
        Game:removeFollower("starry")
    end
end

function Mod:onMapMusic(map, music)
    if music == "creepylandscape" and Game:getFlag("depths_intro_done") then
        return "deeplandscape"
    end

    if (map.id == "depths_4" or map.id == "depths_5" or map.id == "depths_6") and Game:getFlag("depths_stalac_assault") then
        return "creepychase"
    end
end

function Mod.spawnStarryText(action)
    local text = Text("FILE [UNKNOWN] "..action)
    text:setParallax(0)
    text:setScreenPos(3, 3)
    text:setLayer(WORLD_LAYERS["top"])
    text.alpha = 5
    text:setGraphics({
        fade_to = 0,
        fade = 0.1,
        fade_callback = function(self) self:remove() end
    })
    Game.world:addChild(text)
end