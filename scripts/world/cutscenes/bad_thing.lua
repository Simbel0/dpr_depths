return function(cutscene)
	local player = Game.world.player
	local follow1 = Game.world.followers[1]

	cutscene:look(player, "left")
	cutscene:look(follow1, "left")

	cutscene:detachCamera()
	cutscene:detachFollowers()

	cutscene:text("* Waiiiiit!!", nil, "starry")
	local starry = cutscene:spawnNPC("starry", -20, player.y)

	cutscene:panTo(follow1.x-70, Game.world.camera.y)

	cutscene:wait(cutscene:slideTo(starry, follow1.x-100, starry.y))

	cutscene:text("* What's up?", "nervous", "susie")
	cutscene:text("* I...[wait:3] I know how I can help!", "neutral", "starry")
	cutscene:text("* You need to be careful around here!", "neutral", "starry")
	cutscene:text("* I'm not sure why but everything here is...", "neutral", "starry")
	cutscene:text("* Wrong.", "neutral", "starry")

	cutscene:wait(0.5)

	cutscene:text("* Wrong...[wait:3] How?", "sus_nervous", "susie")
	cutscene:text("* Wrong like that!!", "neutral", "starry")

	cutscene:look(player, "right")
	cutscene:look(follow1, "right")

	local lump = cutscene:spawnNPC("dark_lump", player.x+250, player.y)
	lump:addFX(OutlineFX({57/255, 28/255, 53/255}))

	cutscene:wait(cutscene:panTo(player.x+120, player.y, 3))
	cutscene:wait(0.5)

	cutscene:text("* ...", "surprise", "susie")
	cutscene:text("* What even is this...?", "shocked", "hero")
	cutscene:text("* It looks...[wait:3] goopy?[wait:3] But also not at the same time?", "sus_nervous", "susie")

	Assets.playSound("generate", 0.9, 0.7)

	cutscene:wait(cutscene:setAnimation(lump, "generate"))

	cutscene:wait(0.5)

	Assets.playSound("bigcut")
	local tongue = Sprite("enemies/dark_lump/tongue", 30, 0)
	lump:addChild(tongue)
	tongue:setOrigin(1, 0)

	local done = false
	tongue:play(nil, false, function() done = true end)

	cutscene:wait(function() return done end)

	player.actor.offsets["attacked_surprised_1"] = {0, -3}
	player:setSprite("attacked_surprised_1")
	player:shake(10)
	Assets.playSound("damage")
	Assets.playSound("damage", 1, 0.8)

	follow1:setSprite("shock")
	follow1:shake()

	local rect = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
	rect:setParallax(0)
	rect:setColor(COLORS.red)
	rect.layer = WORLD_LAYERS["top"]
	Game.world:addChild(rect)
	--Game.world.timer:tween(1, rect, {color={0, 0, 0}})

	cutscene:during(function()
		if rect == nil then return false end

		if rect.color[1] > 0 then
			rect.color[1] = rect.color[1] - DT*1.5
		end
	end)

	local rectConnect = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
	rectConnect:setColor(0, 0, 0)
	rectConnect.layer = rect.layer+999
	rectConnect:setParallax(0)

	local textConnect = Text("Losing connection!")
	textConnect:setScale(2)
	local tWidth = Assets.getFont("main"):getWidth("Losing connection!")*2
	local tHeight = Assets.getFont("main"):getHeight("Losing connection!")*2
	textConnect.x = (SCREEN_WIDTH/2)-tWidth/2
	textConnect.y = (SCREEN_HEIGHT/2)-tHeight
	textConnect.layer = rectConnect.layer+1
	textConnect:setParallax(0)

	local orig_x = textConnect.x
	local orig_y = textConnect.y

	local function switchAlpha(a)
		rectConnect.alpha = a
		textConnect.alpha = a

		textConnect.x = orig_x + Utils.random(-100, 100)
		textConnect.y = orig_y + Utils.random(-100, 100)
	end

	switchAlpha(0)

	Game.world:addChild(rectConnect)
	Game.world:addChild(textConnect)

	local static = Sprite("static", 0, 0)
	static:setLayer(rectConnect:getLayer())
	static.alpha = 0
	static:setParallax(0)
	Game.world:addChild(static)
	static:play(1/20)

	player:setLayer(rect:getLayer()+10)
	lump:setLayer(rect:getLayer()+9)

	cutscene:wait(1)

	player:setAnimation({"attacked_surprised", 1/20, true})
	player:shake(1, 1, 0, 1/20)

	local alarm = Assets.playSound("alarm", 2, 1.2)
	alarm:setLooping(true)

	local d = Assets.playSound("destroyed", 1, 0.8)
	d:setLooping(true)
	local every = Game.world.timer:everyInstant(0.5, function()
		Assets.playSound("damage")
		Assets.playSound("damage", 1, 0.8)
		rect:setColor(COLORS.red)

		Game.world.camera:shake(15, 14.5)

		for i=1,7 do
			Kristal.funnytitle()
		end

		if Utils.random()<0.7 then
			switchAlpha(1)
			Game.world.timer:after(0.1, function()
				switchAlpha(0)
			end)
		elseif Utils.random()<0.7 then
			static.alpha = 1
			Game.world.timer:after(0.2, function()
				static.alpha = 0
			end)
		end
	end)

	cutscene:wait(5)

	Game.world.timer:cancel(every)
	d:stop()
	alarm:stop()

	rect:remove()
	rectConnect:remove()
	textConnect:remove()
	static:remove()

	Assets.stopAndPlaySound("damage", 2, nil, true)

	follow1:setSprite("battle/attack_6")
	local x, y = tongue:getRelativePos(0, 0, Game.world)
	local dmg_sprite = Sprite(Game.party[2]:getAttackSprite(), x, y)
	dmg_sprite.layer = tongue:getLayer()+1
	dmg_sprite:setScale(2, 2)
	dmg_sprite:play(1/15, false, function(s) s:remove() end)
	Game.world:addChild(dmg_sprite)

	player:stopShake()
	player:setSprite("fell")

	player:setPhysics({
		speed = 10,
		friction = 0.5,
		direction = math.pi
	})
	player.y = player.y + 20

	local done2 = false
	tongue:setAnimation({"enemies/dark_lump/tongue", 1/10, false, frames={"6-1"}, callback=function(s) done2 = true; s:remove() end})

	cutscene:wait(function()
		return done2
	end)

	cutscene:wait(1)

	player:shake()
	Assets.playSound("wing")

	cutscene:wait(1)

	cutscene:text("* You think you can get up,[wait:2] Hero?", "sus_nervous", "susie")

	cutscene:wait(1)

	player:shake()
	Assets.playSound("wing")

	player:setAnimation("battle/attack")
	Assets.playSound(Game.party[1]:getAttackSound() or "laz_c", 1, Game.party[1]:getAttackPitch() or 1)

	cutscene:wait(1)

	cutscene:startEncounter("dark_lump", nil, {{"dark_lump", lump}})
	lump:remove()
	player:resetSprite()
	follow1:resetSprite()

	cutscene:look(player, "right")
	cutscene:look(follow1, "right")

	cutscene:panTo(starry.x, Game.world.camera.y)

	cutscene:wait(1)

	cutscene:text("* ...", "nervous_side", "susie")
	cutscene:text("* Those things... seem really dangerous.", "nervous", "susie")
	cutscene:text("* You think?", "really", "hero")

	cutscene:look(player, "left")
	cutscene:look(follow1, "left")

	cutscene:text("* I'm sorry. I should have told you earlier.", "neutral", "starry")
	cutscene:text("* No, it's fine. It's not like I got too hurt.", "neutral_closed_b", "hero")
	cutscene:text("* All ended well in the end.", "happy", "hero")

	cutscene:text("* I'm not too sure about that but if Hero says so...", "sus_nervous", "susie")

	cutscene:wait(0.5)

	cutscene:text("* Say, can I come with you?", "neutral", "starry")
	cutscene:text("* This place can honestly be a bit scary...", "neutral", "starry")
	cutscene:text("* And I can help in battle!", "neutral", "starry")
	cutscene:text("* I can restore your HPs to a certain point in time!", "neutral", "starry")
	cutscene:text("* Just ask me when you want to SAVE your stats and when to LOAD them.", "neutral", "starry")

	cutscene:text("* That does sound useful. Thanks, Starry.", "happy", "hero")

	Assets.playSound("charjoined")
	cutscene:text("* (Starry joined the party!)")

	Game:setFlag("depths_starry_in_party", true)

	starry:convertToFollower(nil, true)

	cutscene:attachCamera()
	cutscene:wait(cutscene:attachFollowers())
end