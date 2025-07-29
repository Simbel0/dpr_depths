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
end

function Mod:postLoad(dlc_swapping)
    if dlc_swapping and Game:getFlag("depths_intro_done") then
        Kristal.modswap_destination = {"depths_7", "warpbin"}
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

function Mod:spawnStarryText(state)
    local text = Text("FILE [UNKNOWN] "..(state == "save" and "SAVED" or "LOADED"))
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