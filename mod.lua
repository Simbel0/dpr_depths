function Mod:init()
    print("Loaded "..self.info.name.."!")
end

function Mod:postLoad(dlc_swapping)
    if dlc_swapping and Game:getFlag("depths_intro_done") then
        Kristal.modswap_destination = {"depths_7", "warpbin"}
    end
end

function Mod:onMapMusic(map, music)
    if (map.id == "depths_4" or map.id == "depths_5" or map.id == "depths_6") and Game:getFlag("depths_stalac_assault") then
        print("MUSIC")
        return "creepychase"
    end
end