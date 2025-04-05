return {
	prestart = function(cutscene)
		if Game:getFlag("depths_stalac_assault_intro_done") then
			cutscene:endCutscene()
			return
		end
		Game.world.camera:shake(5, 0, 0.1)
		Assets.playSound("rumble")

		cutscene:wait(function()
			return Game.world.camera.shake_x == 0
		end)

		cutscene:wait(0.5)

		cutscene:text("* ...You're sure there's nothing that's gonna kill us?", "shocked", "hero")
		cutscene:text("* I think??", "shock_nervous", "susie")
	end,
	start = function(cutscene)
		Game.world.music:stop()
		Game.world.camera:shake(5, 0, 0.1)
		Assets.playSound("rumble", 2, 0.8)

		cutscene:wait(function()
			return Game.world.camera.shake_x == 0
		end)

		local susie = cutscene:getCharacter("susie")
		local hero = cutscene:getCharacter("hero")

		local stalacs = {}
		local function createCutsceneStalac(x, y, gravity)
			local stalac = Sprite("bullets/stalac", x, y-SCREEN_HEIGHT+10)
			stalac.dest_y = y
			stalac:setOrigin(0.5, 1)
			Game.world:addChild(stalac)
			Assets.playSound("ui_cancel")
			stalac:setLayer(susie.layer+1)
			stalac:setPhysics({
				gravity = gravity or 0.3,
			})
			table.insert(stalacs, stalac)
			return stalac
		end

		if not Game:getFlag("depths_stalac_assault_intro_done") then

			first_sta = createCutsceneStalac(susie.x, susie.y)

			cutscene:wait(function()
				return first_sta.y >= susie.y-100
			end)
			Assets.playSound("sussurprise")
			susie:setSprite("shock_right")
			local wait = cutscene:slideTo(susie, susie.x-50, susie.y, nil, "outCubic")
			cutscene:look(hero, "left")

			cutscene:wait(function()
				return first_sta.y >= first_sta.dest_y
			end)

			Utils.removeFromTable(stalacs, first_sta)
			first_sta:remove()
			Assets.playSound("shakerbreaker")

			cutscene:wait(wait)
			cutscene:wait(2)

			cutscene:text("* Oh no.", "shocked", "hero")

			Game.world.camera:shake(5, 0, 0.1)
			Assets.playSound("rumble", 1, 0.5)
			Assets.playSound("rumble", 1, 1.1)

			cutscene:wait(function()
				return Game.world.camera.shake_x == 0
			end)
		end

		for i=1,10 do
			createCutsceneStalac(Utils.random(1900, 2400), Utils.random(770, 880), Utils.random(0.2, 0.5))
			cutscene:wait(0.1)
		end
		cutscene:during(function()
			for i=#stalacs,1, -1 do
				local s = stalacs[i]
				if s.y >= s.dest_y then
					s:remove()
					Assets.playSound("shakerbreaker")
					table.remove(stalacs, i)
				end
			end

			if #stalacs == 0 then return false end
		end)

		cutscene:wait(function()
			return #stalacs == 0
		end)

		susie:setSprite("walk")
		cutscene:attachFollowers()
		cutscene:text("* RUN!", "bangs/nervous_annoyed", "susie")
		
		Game:setFlag("depths_stalac_assault_intro_done", true)
		Game:saveQuick()
		Game:setFlag("depths_stalac_assault", true)

		Game.world.music:play("creepychase")
		Game.world:setBattle(true)
	end,
	ending = function(cutscene)
		local stalacs = {}
		local function createCutsceneStalac(x, y, gravity)
			local stalac = Sprite("bullets/stalac", x, y-SCREEN_HEIGHT-10)
			stalac.dest_y = y
			stalac:setScale(2)
			stalac:setOrigin(0.5, 1)
			Game.world:addChild(stalac)
			Assets.playSound("ui_cancel")
			stalac:setLayer(Game.world.player.layer+1)
			stalac:setPhysics({
				gravity = gravity or 0.3,
			})
			table.insert(stalacs, stalac)
			return stalac
		end

		Game.world:setBattle(false)
		Game.world.timer:after(1, function()
			for i,bullet in ipairs(Game.world.bullets) do
				bullet:remove()
			end
		end)
		cutscene:detachFollowers()
		cutscene:detachCamera()
		Game.world.camera.keep_in_bounds = false
		cutscene:panTo(1000, 310)

		local text = Text("FILE [UNKNOWN] SAVED")
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

		local player = Game.world.player
		local follow1 = Game.world.followers[1]

		local walk1 = cutscene:walkTo(player, 1035, 290)
		local walk2 = cutscene:walkTo(follow1, 1035, 340)

		cutscene:wait(function()
			return walk1() and walk2()
		end)

		cutscene:wait(0.5)

		cutscene:text("* Damn, it's a dead end!", "teeth", "susie")
		cutscene:walkTo(follow1, follow1.x-30, follow1.y, 0.1)
		cutscene:look(player, "left")
		cutscene:panTo(960, 310, 0.5)
		cutscene:text("* Quick, let's go back befo--", "teeth", "susie")

		createCutsceneStalac(820, 230)
		createCutsceneStalac(820, 230+30)
		createCutsceneStalac(820, 230+60)
		createCutsceneStalac(820, 230+90)
		createCutsceneStalac(820, 230+120)

		local sprites = {}
		cutscene:during(function()
			for i=#stalacs,1, -1 do
				local s = stalacs[i]
				if s.y >= s.dest_y then
					s:remove()
					Assets.playSound("shakerbreaker")
					local sp = Sprite("bullets/stalac_debris", s.x, s.dest_y)
					sp.layer = s.layer
					sp:setScale(2)
					sp:setOrigin(0.5)
					Game.world:addChild(sp)
					table.insert(sprites, sp)
					table.remove(stalacs, i)
				end
			end

			if #stalacs == 0 then return false end
		end)

		cutscene:wait(function()
			return #stalacs == 0
		end)
		cutscene:wait(0.5)

		cutscene:text("* We're trapped!", "bangs/nervous_annoyed", "susie")

		cutscene:walkTo(follow1, player.x-80, player.y, 0.5, "right")

		cutscene:text("* "..GeneralUtils:getLeader().name..",[wait:0.1] what do we do??", "shy_b", "susie")
		cutscene:text("* Uh...", "shocked", "hero")

		Game.world.music:fade(0, 1)

		Assets.playSound("ui_cancel")
		local ellipses = {}
		for i=1,7 do
			for j=1,7 do
				local ell = Ellipse(875+30*(i-1), 250+17*(j-1), 15, 7.5)
				ell.layer = player.layer-0.1
				ell.alpha = 0
				ell:setGraphics({
					fade_to = 0.5,
					fade = 0.1
				})
				Game.world:addChild(ell)
				table.insert(ellipses, ell)
				cutscene:wait()
			end
		end
		cutscene:wait(0.5)

		cutscene:text("* ...", "sus_nervous", "susie")
		cutscene:text("* We're done for, aren't we?", "nervous", "susie")

		cutscene:text("* Looks like it.", "pout", "hero")

		cutscene:wait(1)

		cutscene:wait(cutscene:walkTo(follow1, 960, 310))
		cutscene:look(follow1, "up")
		follow1:setSprite("point_up_1")
		follow1:shake()
		Assets.playSound("wing")

		cutscene:text("* COME FIGHT ME YOU DAMN ROCKS!!", "teeth", "susie")

		Game.fader:fadeOut({color={1, 1, 1}, speed=5})
		local sound = Assets.playSound("cymbal")

		cutscene:text("* IMPALE ME IF YOU CAN!!", "teeth_b", "susie", {wait=false})

		cutscene:wait(function()
			return not sound:isPlaying()
		end)
		cutscene:wait(0.3)
		for i,v in ipairs(ellipses) do
			v:remove()
		end
		for i,v in ipairs(sprites) do
			v:remove()
		end
		Game.world.music:play("creepychase", 1, 1)
		Game.world.camera:setPosition(1000, 310)
		follow1:setSprite("walk")

		local text = Text("FILE [UNKNOWN] LOADED")
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

		player:setPosition(player.x-640, 310)
		cutscene:alignFollowers()
		cutscene:attachFollowersImmediate()

		cutscene:closeText()

		Game.fader.alpha = 0

		local starry = Game.world:spawnNPC("starry", 960, 20)

		cutscene:wait(cutscene:walkToSpeed(player, 820, player.y, player.walk_speed+5))

		cutscene:detachFollowers()
		cutscene:detachCamera()

		walk1 = cutscene:walkTo(player, 1035, 290)
		walk2 = cutscene:walkTo(follow1, 1035, 340)

		cutscene:wait(function()
			return walk1() and walk2()
		end)

		cutscene:wait(0.5)

		cutscene:text("* Damn, it's a dead end!", "teeth", "susie")
		cutscene:walkTo(follow1, follow1.x-30, follow1.y, 0.1)
		cutscene:look(player, "left")
		cutscene:panTo(960, 310, 0.5)
		cutscene:text("* Qui--", "teeth", "susie")

		cutscene:look(player, "up")
		cutscene:look(follow1, "up")
		cutscene:slideTo(starry, 960, 100, 0.7)
		cutscene:panTo(960, 260)
		
		cutscene:text("* Hey![wait:2] You there!")

		cutscene:text("* Huh??", "surprise", "susie")

		cutscene:text("* Jump!![wait:2] There's no other way!")

		cutscene:text("* Who are you??[wait:2] Why should we believe you???", "sus_nervous", "susie")

		cutscene:look(player, "left")
		cutscene:look(follow1, "left")

		stalacs = {}

		createCutsceneStalac(820, 230)
		createCutsceneStalac(820, 230+30)
		createCutsceneStalac(820, 230+60)
		createCutsceneStalac(820, 230+90)
		createCutsceneStalac(820, 230+120)

		sprites = {}
		cutscene:during(function()
			for i=#stalacs,1, -1 do
				local s = stalacs[i]
				if s.y >= s.dest_y then
					s:remove()
					Assets.playSound("shakerbreaker")
					local sp = Sprite("bullets/stalac_debris", s.x, s.dest_y)
					sp.layer = s.layer
					sp:setScale(2)
					sp:setOrigin(0.5)
					Game.world:addChild(sp)
					table.insert(sprites, sp)
					table.remove(stalacs, i)
				end
			end

			if #stalacs == 0 then return false end
		end)

		cutscene:wait(function()
			return #stalacs == 0
		end)
		cutscene:wait(0.5)

		cutscene:text("* That's a convincing argument if you ask me.", "neutral_closed_b", "hero")
		cutscene:text("* Alright, we're going up!!", "teeth_b", "susie")

		walk1 = cutscene:walkTo(player, 1020, 260, 0.5)
		walk2 = cutscene:walkTo(follow1, 920, 260, 0.5)

		cutscene:wait(function()
			return walk1() and walk2()
		end)

		Assets.playSound("wing")
		--player:setSprite("")
		follow1:setSprite("kneel")
		player:shake()
		follow1:shake()

		cutscene:wait(0.5)

		cutscene:slideTo(starry, 960, 0, 1)

		Game.world.camera.keep_in_bounds = true
		cutscene:panTo(960, 0, 0.4)

		Assets.playSound("jump")
		walk1 = cutscene:jumpTo(player, 1035, 105, 10, 1)
		walk2 = cutscene:jumpTo(follow1, 895, 105, 10, 1, "fall_1", "landed_1")

		cutscene:wait(function()
			return walk1() and walk2()
		end)
		cutscene:wait(0.5)
		Assets.playSound("wing")
		player:setSprite("walk")
		follow1:setSprite("walk")
		cutscene:look(player, "up")
		cutscene:look(follow1, "up")
		player:shake()
		follow1:shake()

		cutscene:text("* Alright, let's go!", "nervous", "susie")

		cutscene:walkTo(player, player.x, 0, 0.5)
		cutscene:walkTo(follow1, follow1.x, 0, 0.5)
	end
}