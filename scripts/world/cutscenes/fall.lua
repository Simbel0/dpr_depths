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
	end
}