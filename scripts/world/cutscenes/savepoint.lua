return function(cutscene)
	local hero = cutscene:getCharacter("hero")
	local susie = cutscene:getCharacter("susie")

	cutscene:text("* Hold on.", "shocked", "hero")

	cutscene:detachFollowers()

	local sus_path = {
		{susie.x, susie.y},
		{810, susie.y},
		{810, 195}
	}
	local sus = cutscene:walkPath(susie, sus_path, {facing="left", time=1.5})
	local her = cutscene:walkTo(hero, 720, 195)

	cutscene:detachCamera()
	local x, y = Game.world:getEvent(1):getPosition()
	cutscene:panTo(x+10, y)

	cutscene:wait(function()
		return sus() and her()
	end)
	cutscene:wait(0.5)

	cutscene:text("* ...What's that?", "nervous", "susie")
	cutscene:text("* You can SEE it??", "shocked", "hero")
	cutscene:text("* ...Yeah?[wait:4] Why wouldn't I see a rock?", "neutral_side", "susie")
	cutscene:text("* Huh, yeah,[wait:2] right.", "neutral_opened_b", "hero")
	cutscene:text("* Hold on,[wait:2] give me a second.", "neutral_closed_b", "hero")
	cutscene:wait(0.25)
	cutscene:text("* Okay...?", "nervous", "susie")

	cutscene:wait(0.5)

	cutscene:look(hero, "down")

	cutscene:text("* "..Utils.titleCase(Game.save_name)..", can you hear me?", "neutral_closed", "hero")

	local rect = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
	rect:setColor(0, 0, 0)
	rect.layer = 99999
	rect:setParallax(0)

	local text = Text("Losing connection!")
	text:setScale(2)
	local tWidth = Assets.getFont("main"):getWidth("Losing connection!")*2
	local tHeight = Assets.getFont("main"):getHeight("Losing connection!")*2
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

	switchAlpha(0)

	local c = cutscene:choicer({"Yeah", "..."})

	local static = Assets.getSound("static")
	local function playStatic()
		static:setVolume(Utils.random(0.5, 2))
		static:setPitch(Utils.random(0.2, 2))
		static:play()
	end

	switchAlpha(1)
	playStatic()
	cutscene:wait(2/30)
	switchAlpha(0)
	cutscene:wait(2/30)
	switchAlpha(1)
	playStatic()
	cutscene:wait(1/20)
	switchAlpha(0)
	cutscene:wait(1/10)
	switchAlpha(1)
	playStatic()
	cutscene:wait(1/30)
	switchAlpha(0)
	cutscene:wait(3)

	cutscene:text("* ...", "shade", "hero")

	cutscene:wait(1)

	cutscene:look(susie, "down")

	cutscene:wait(1)
	cutscene:look(susie, "left")
	cutscene:wait(0.5)

	cutscene:text("* Uh,[wait:2] Hero?[wait:4] You're alright?", "nervous_side", "susie")
	cutscene:look(hero, "right")
	cutscene:text("* Wha-[wait:1]What?", "shocked", "hero")
	cutscene:text("* Dude,[wait:2] you were looking really out of it just now.", "suspicious", "susie")
	cutscene:text("* It'd be great if you don't knock yourself out here.", "annoyed", "susie")
	cutscene:text("* Uh yeah.[wait:4] Sorry about that.", "neutral_closed_b", "hero")
	cutscene:text("* I'm fine,[wait:2] don't worry.", "happy", "hero")
	cutscene:text("* Sure.", "neutral_side", "susie")

	cutscene:wait(0.5)
	cutscene:look(hero, "down")

	cutscene:setSpeaker("hero")
	cutscene:text("* (Well regardless of this...)", "shocked", "hero")
	cutscene:text("* (I can sense that you've answered me..."..(c==2 and "[wait:4] I think." or "")..")", "suspicious", "hero")
	cutscene:text("* (But it seems like our connection is unstable.)", "pout", "hero")
	cutscene:text("* (We might be very deep in the darkness.)", "neutral_closed", "hero")
	cutscene:text("* (So deep your ability to make choices seems to be impaired.)", "neutral_closed_b", "hero")
	cutscene:text("* (Well that doesn't change much from usual but it's annoying.)", "really", "hero")
	cutscene:text("* (In any case...)", "neutral_closed")
	cutscene:look(hero, "right")
	cutscene:wait(0.5)
	cutscene:text("* (I don't think it has anything to do with this savepoint.)", "neutral_closed_b")
	cutscene:text("* (It's just...[wait:4] dead.[wait:4] There's no power in it.)", "pout")
	cutscene:wait(0.25)
	cutscene:text("* (Maybe with your SOUL,[wait:2] we can reanimate it?)", "neutral_opened_b")
	cutscene:text("* (We don't have much of a choice anyway.)", "neutral_closed_b")
	cutscene:text("* (Unless you want to suffer some real consequences for dying.)", "annoyed_b")
	cutscene:wait(0.2)
	cutscene:setSpeaker(nil)
	cutscene:text("* (Your soul shined its power on the SAVEPOINT!)", {skip=false})

	Assets.playSound("boost")
    hero:flash()
    Game.world:getEvent(1):flash()
    local x, y = hero:getPosition()
    local bx, by = x-hero.width, y-hero.height
    local soul = Sprite("effects/soulshine", bx, by)
    soul:play(1/30, false, function() soul:remove() end)
    soul:setOrigin(0.25, 0.25)
    soul:setScale(2, 2)
    soul:setLayer(10000)
    Game.world:addChild(soul)

    cutscene:wait(function()
    	return soul.parent == nil
    end)
    cutscene:wait(0.2)

    local sx, sy = Game.world:getEvent(1):getPosition()
    sx = sx + Game.world:getEvent(1).width
    sy = sy + Game.world:getEvent(1).height
    local slayer = Game.world:getEvent(1):getLayer()
    Game.world:getEvent(1):remove()
    local sp = Game.world:addChild(Savepoint(sx, sy, {text="* The devasted darkness looms above you.[wait:4] You are filled with a strange power."}))
    sp:setLayer(slayer)

    for i=1,3 do
	    local sp_a = AfterImage(sp.sprite, 1)
	    sp_a:setScaleOrigin(0.5, 0.37)
	    print(0.2+(((i-1)*2)/10))
	    sp_a:setGraphics({
	    	grow = 0.2+((3-i)/10),
	    	fade = 0.05,
	    	fade_to = 0,
	    	fade_callback = function(self) self:remove() end
	    })
	    Game.world:addChild(sp_a)
	end

    Assets.playSound("sparkle_glock")
    Assets.playSound("save", 1, 2)
    Assets.playSound("revival", 1, 2)

    cutscene:wait(3)

    cutscene:text("* Oh,[wait:2] that worked.", "neutral_closed", "hero")
    cutscene:text("* Did it?[wait:4] I can't see the rock anymore.", "nervous_side", "susie")
    cutscene:text("* Uh,[wait:2] yeah,[wait:2] that's how it was supposed to be.", "neutral_opened_b", "hero")
    cutscene:text("* That's weird but if you say so.", "nervous", "susie")
    cutscene:text("* So does that mean we can continue?", "smile", "susie")
    cutscene:text("* Yep.", "happy", "hero")
    cutscene:text("* Great.", "closed_grin", "susie")

    cutscene:wait(cutscene:attachFollowers())
    cutscene:look(hero, "down")
    cutscene:attachCamera()

    Game:setFlag("depths_savepoint_custcene_seen", true)
end