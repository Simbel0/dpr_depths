return {
	main = function(cutscene)
		local kris = cutscene:getCharacter("kris")
		local susie = cutscene:getCharacter("susie")
		local hero = cutscene:getCharacter("hero")

		if not kris and not susie then
			cutscene:endCutscene()
			return
		end

		if kris then
			-- TODO
		elseif susie and hero then
			cutscene:text("* Hey,[wait:2] Hero?", "nervous", susie)
			cutscene:text("* Yeah,[wait:2] what's up?", "neutral_closed", "hero")
			cutscene:text("* Nothing,[wait:2] it's just...", "nervous", "susie")
			cutscene:text("* This place feels awfully familliar.", "nervous_side", "susie")
			cutscene:text("* Is that so?", "neutral_closed_b", "hero")
			cutscene:text("* Yeah.[wait:4] it's just like the place where we started our first adventure.", "neutral_side", "susie")
			cutscene:text("* And where we've met Lancer for the first time.", "smirk", "susie")
			cutscene:text("* I see.[wait:4] So maybe Castle Town isn't far away?", "suspicious", "hero")
			cutscene:text("* I don't know.[wait:4] It's been a while but it's not exactly the same place.", "sus_nervous", "susie")
			cutscene:text("* Just the same walls,[wait:2] the same ground...[wait:4] The same darkness.", "sus_nervous", "susie")
			cutscene:text("* I guess what I'm trying to say is...", "nervous_side", "susie")
			cutscene:text("* This place sucks.[wait:4] Keep your guard up.", "smile", "susie")
			cutscene:text("* Alright...?", "annoyed", "hero")
		end
	end,
	susie = function(cutscene)
		local susie = cutscene:getCharacter("susie")
		local hero = cutscene:getCharacter("hero")

		if not susie and not hero then
			cutscene:endCutscene()
			return
		end

		cutscene:text("* (Wait, how does Hero know about Castle Town...?)", "nervous_side", susie)
	end,
	lancer_area = function(cutscene)
		if Game:getFlag("depths_stalac_assault") then
			cutscene:endCutscene()
			return
		end
		
		local susie = cutscene:getCharacter("susie")
		local hero = cutscene:getCharacter("hero")

		cutscene:detachFollowers()

		cutscene:wait(cutscene:walkTo(susie, 980, 790))
		cutscene:look(susie, "up")

		cutscene:wait(0.5)
		susie:shake()
		susie:setSprite("away")

		cutscene:wait(2)

		susie:setSprite("away_turn")
		cutscene:text("* ...[wait:4]Nothing.", "suspicious", "susie")

		cutscene:wait(1.5)

		susie:setSprite("walk")
		cutscene:look(susie, "left")

		cutscene:wait(0.5)

		cutscene:wait(cutscene:walkTo(susie, hero.x+hero.width+30, hero.y))

		cutscene:text("* There's nothing that can kill us up there,[wait:2] we're good.", "smile", "susie")
		cutscene:text("* Lead the way,[wait:2] Hero!", "sincere_smile", "susie")

		cutscene:wait(cutscene:attachFollowers())
		cutscene:wait(0.5)

		cutscene:text("* (I wasn't worried about this up until now??)", "shocked", "hero")
	end
}