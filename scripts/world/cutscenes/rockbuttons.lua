-- TODO: figure out how other party members are gonna break that rock
return {
	default = function(cutscene, player, button, flag)
		local susie = cutscene:getCharacter("susie")
		local starry = cutscene:getCharacter("starry")
		Utils.print(player, button, Game:getFlag(flag, 0))

		cutscene:detachFollowers()

		cutscene:wait(cutscene:walkTo(susie, button.x-50, button.y+40, 2, "up"))

		cutscene:wait(0.5)

		Assets.playSound("laz_c")
		cutscene:setAnimation(susie, "battle/attack")
		cutscene:wait(0.1)

		Game.world:shake()
		Assets.playSound("damage")
		Assets.playSound("damage", 1, 0.7)
		button:activate()

		cutscene:wait(1.5)

		susie:resetSprite()
		cutscene:wait(cutscene:attachFollowers())
	end,
	first_special = function(cutscene, script, player)
		print(Utils.dump(script), Utils.dump(player))

		local button = cutscene:getEvent(87)
		print(Utils.dump(button))

		local hero = cutscene:getCharacter("hero")
		local susie = cutscene:getCharacter("susie")
		local starry = cutscene:getCharacter("starry")

		cutscene:detachFollowers()

		cutscene:waitMultiple(
			cutscene:slideTo(starry, 710, 1285, 2),
			cutscene:walkTo(susie, button.x, 1350, 2, "up"),
			cutscene:walkTo(hero, 840, 1335, 2, "up")
		)

		cutscene:wait(0.5)

		cutscene:text("* ...What is this?", "nervous_side", "susie")

		cutscene:text("* I'm not sure. It's like a mushroom growing straight from the rock.", "neutral", "starry")
		cutscene:text("* It just happens here and there. I never managed to break it.", "neutral", "starry")
		cutscene:text("* Break it, huh?", "smile", "susie")

		cutscene:waitMultiple(
			cutscene:slideTo(starry, starry.x, starry.y-50),
			cutscene:walkTo(susie, starry.x, starry.y, nil, "right")
		)

		cutscene:wait(1.5)

		Assets.playSound("laz_c")
		cutscene:setAnimation(susie, "battle/attack")
		cutscene:wait(0.1)

		Game.world:shake()
		Assets.playSound("damage")
		Assets.playSound("damage", 1, 0.7)
		button:activate()

		cutscene:wait(1.5)

		cutscene:text("* Easy.", "closed_grin", "susie")

		cutscene:wait(1)

		cutscene:text("* ...", "neutral", "starry")
		cutscene:text("* Is this normal?", "neutral", "starry")

		cutscene:choicer({"That's just\nSusie", "I don't know"})

		local rect = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
		rect:setColor(0, 0, 0)
		rect.layer = 99999
		rect:setParallax(0)

		local text = Text("Unstable connection!")
		text:setScale(2)
		local tWidth = Assets.getFont("main"):getWidth("Unstable connection!")*2
		local tHeight = Assets.getFont("main"):getHeight("Unstable connection!")*2
		text.x = (SCREEN_WIDTH/2)-tWidth/2
		text.y = (SCREEN_HEIGHT/2)-tHeight
		text.layer = rect.layer+1
		text:setParallax(0)

		local function switchAlpha(a)
			rect.alpha = a
			text.alpha = a
		end

		Game.world:addChild(rect)
		Game.world:addChild(text)

		for i=1,5 do
			Assets.stopAndPlaySound("static", Utils.random(0.5, 2), Utils.random(0.2, 2))
			switchAlpha(1)
			cutscene:wait(Utils.random(0, 0.15))
			switchAlpha(0)
			cutscene:wait(Utils.random(0, 0.2))
		end
		hero:shake()
		cutscene:wait(0.5)

		rect:remove()
		text:remove()

		cutscene:text("* Yeah.", "shade", "hero")

		cutscene:text("* Heh.", "closed_grin", "susie")
		cutscene:text("* (You could have said it with more enthusiasm.)", "nervous_side", "susie")
		cutscene:wait(0.1)

		cutscene:text("* I see...", "neutral", "starry")
		cutscene:text("* There might be more of those around.", "neutral", "starry")
		cutscene:text("* Maybe breaking them will do something.", "neutral", "starry")
		cutscene:text("* Awesome! Let's do that.", "smile", "susie")

		susie:resetSprite()
		cutscene:wait(cutscene:attachFollowers())
	end
}