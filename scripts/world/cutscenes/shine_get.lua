return function(cutscene, event, player, dir)
	if not Game:getFlag("depths_1_shine_get", false) then
		cutscene:text("* (There's something glowing in this hole.)")
		cutscene:text("* (Take it?)")
		if cutscene:choicer({"Yes", "No"}) == 1 then
			if Game.inventory:tryGiveItem("glowpiece") then
				Game.world:getEvent(16):remove()
				Game:setFlag("depths_1_shine_get", true)
				cutscene:text("* (You've obtained GlowPiece.)")
			end
		end
	else
		cutscene:text("* (It's dark inside.)")
	end
end